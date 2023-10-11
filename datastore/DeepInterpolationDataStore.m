classdef DeepInterpolationDataStore < matlab.io.Datastore & ...
                                      matlab.io.datastore.Subsettable & ...
                                      matlab.io.datastore.Shuffleable
    %DEEPINTERPOLATIONDATASTORE - custom datastore for DeepInterpolation-MATLAB
    %
    % This custom datastore provides 60 flanking frames [512x512x60] and the center
    % frame [512x512] upon one read.
    %
    % dids = DeepInterpolationDataStore(pathToTiffFile, true);
    %
    % Input must be full path to a grayscale, single channel tiff stack of >62 frames
    % in order to work (this is according to the function of the DeepInterpolation
    % network).
    %
    % If the image frame dimensions differ from the network input size of 512x512,
    % the second input argument (false/true) controls whether the frames will be
    % automatically resized to 512x512 before they are returned.
    %
    % Dr. Thomas Künzel, The MathWorks, 2023
    % tkuenzel@mathworks.com

    properties
        fileName string
        doAutoResize logical
        numberOfFlankingFrames int32
        outputFrameSize int32
        frameCount double
        dsSetCount double
        setsAvailable double
        currentSet double
        setFramesStartIndex double
        currentFrameIndex double
        allSetFrameStartIndices double
    end

    methods % begin methods section
        function myds = DeepInterpolationDataStore(filePath, options)
            arguments
                filePath
                options = struct();
            end
            if isfield(options, 'doAutoResize')
                myds.doAutoResize = logical(options.doAutoResize);
            else % default
                myds.doAutoResize = false;
            end
            if isfield(options, 'numberOfFlankingFrames')
                assert(options.numberOfFlankingFrames > 0)
                assert(rem(options.numberOfFlankingFrames, 2) == 0, "Number of flanking frames should be even.")
                myds.numberOfFlankingFrames = options.numberOfFlankingFrames;
            else % default
                myds.numberOfFlankingFrames = 60;
            end
            if isfield(options, 'outputFrameSize')
                if not (myds.doAutoResize)
                    warning('Specified an output frame size, but auto-resize is turned off.')
                end
                outputFrameSize = options.outputFrameSize;
                if not (isnumeric(outputFrameSize) && isequal(size(outputFrameSize), [1, 2]) && all(outputFrameSize >= 0))
                    error('outputFrameSize should be an array with dimension 1x2 and non-negative values.');
                end
                myds.outputFrameSize = outputFrameSize;
            else % default
                myds.outputFrameSize = [512, 512];
            end
            assert(isfile(filePath));
            myds.fileName = filePath;
            fileInfo = imfinfo(myds.fileName);
            assert(strcmp(fileInfo(1).Format,'tif'), "Must be tiff format");
            if ~myds.doAutoResize
                assert((fileInfo(1).Width == myds.outputFrameSize(1)) ...
                    && (fileInfo(1).Height == myds.outputFrameSize(2)),...
                    "Actual frame size is not equal to specified outputFrameSize");
            end
            framePerSetCount = myds.numberOfFlankingFrames + 3;
            assert(numel(fileInfo) >= framePerSetCount, "Not enough frames in stack for DeepInterpolation");
            myds.frameCount = numel(fileInfo);
            myds.dsSetCount = myds.frameCount - framePerSetCount + 1;
            myds.allSetFrameStartIndices = 1:myds.dsSetCount;
            reset(myds);
        end

        function tf = hasdata(myds)
            % Return true if more data is available.
            tf = myds.setsAvailable > 0;
        end

        function [data,info] = read(myds)
            % Read data and information about the extracted data.
            assert(hasdata(myds), "No more data to read");
            rawRefFrame = imread(myds.fileName,myds.currentFrameIndex);
            if myds.doAutoResize
                rawRefFrame = imresize(rawRefFrame,myds.outputFrameSize);
            end
            refFrame = single(rawRefFrame);
            flankingFrames = single( ...
                ones(myds.outputFrameSize(1), ...
                myds.outputFrameSize(2), ...
                myds.numberOfFlankingFrames) ...
                );
            framecount = 1;
            for leftFrame = 0:(myds.numberOfFlankingFrames/2) - 1
                rawThisFrame = imread(myds.fileName,myds.setFramesStartIndex+leftFrame);
                if myds.doAutoResize
                    rawThisFrame = imresize(rawThisFrame,myds.outputFrameSize);
                end
                thisFrame = single(rawThisFrame);
                flankingFrames(:,:,framecount) = thisFrame;
                framecount = framecount + 1;
            end
            %frame myds.numberOfFlankingFrames + 1 is center frame. One
            %frame before and one after is left out.
            startRightFrame = myds.numberOfFlankingFrames/2 + 3;
            for rightFrame = startRightFrame:startRightFrame + myds.numberOfFlankingFrames/2 - 1
                rawThisFrame = imread(myds.fileName,myds.setFramesStartIndex+rightFrame);
                if myds.doAutoResize
                    rawThisFrame = imresize(rawThisFrame,myds.outputFrameSize);
                end
                thisFrame = single(rawThisFrame);
                flankingFrames(:,:,framecount) = thisFrame;
                framecount = framecount + 1;
            end
            data = {flankingFrames, refFrame};
            info = "set=" + num2str(myds.currentSet) + "/centerframe=" + num2str(myds.currentFrameIndex);
            myds.currentSet = myds.currentSet + 1;
            myds.setsAvailable = myds.setsAvailable - 1;
            if myds.setsAvailable > 0
                myds.setFramesStartIndex = myds.allSetFrameStartIndices(myds.currentSet);
                myds.currentFrameIndex = myds.setFramesStartIndex + myds.numberOfFlankingFrames/2 + 1;
            else
                myds.setFramesStartIndex = nan;
                myds.currentFrameIndex = nan;
            end
        end

        function reset(myds)
            % Reset to the start of the data.
            myds.setsAvailable = myds.dsSetCount;
            myds.currentSet = 1;
            myds.setFramesStartIndex = myds.allSetFrameStartIndices(myds.currentSet);
            myds.currentFrameIndex = myds.setFramesStartIndex + myds.numberOfFlankingFrames/2 + 1;
        end%

        function shmyds = shuffle(myds)
            % shmyds = shuffle(myds) shuffles the sets
            % Create a copy of datastore
            shmyds = copy(myds);

            % Shuffle files and corresponding labels
            numObservations = shmyds.dsSetCount;
            idx = randperm(numObservations);
            shmyds.allSetFrameStartIndices = myds.allSetFrameStartIndices(idx);
            reset(shmyds);
        end
    end

    methods (Hidden = true)
        function frac = progress(myds)
            % Determine percentage of data read from datastore
            if hasdata(myds)
                frac = (myds.currentSet-1) / myds.dsSetCount;
            else
                frac = 1;
            end
        end
    end

    methods (Access = protected)
        function subds = subsetByReadIndices(myds, indices)
            subds = copy(myds);
            subds.dsSetCount = numel(indices);
            subds.allSetFrameStartIndices = myds.allSetFrameStartIndices(indices);
            reset(subds);
        end

        function n = maxpartitions(myds)
            n = myds.dsSetCount;
        end
    end

end