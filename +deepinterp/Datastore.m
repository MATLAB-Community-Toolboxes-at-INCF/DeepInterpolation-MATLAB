classdef Datastore < matlab.io.Datastore & ...
                                      matlab.io.datastore.Subsettable & ...
                                      matlab.io.datastore.Shuffleable
    % DATASTORE - custom datastore for DeepInterpolation-MATLAB
    %
    % This custom datastore provides flanking frames and the center frame 
    % upon one read.
    %
    % dids = deepinterp.Datastore(pathToTiffFile, options);
    %
    % Input must be full path to a grayscale, single channel tiff stack of 
    % >'flankingFrames + 2' frames in order to work (this is according to
    % the function of the DeepInterpolation network).
    %
    % If the image frame dimensions differ from the network input size
    % the doAutoResize option controls whether the frames will be
    % automatically resized to outputFrameSize before they are returned.
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
        datasetType string
        NwbDatasetPath string
    end

    methods % begin methods section
        function myds = DeepInterpolationDataStore(filePath, options)
            arguments
                filePath
                options = struct();
            end
            assert(isfile(filePath));
            myds.fileName = filePath;
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
            if isfield(options, 'datasetType')
                if ~ismember(options.datasetType, {'nwb', 'tiff'})
                    error('The dataset type is either "nwb" or "tiff".');
                end
                myds.datasetType = options.datasetType;
            else
                myds.datasetType = 'tiff';
            end
            if strcmp(myds.datasetType, 'nwb')
                if ~isfield(options, 'NwbDatasetPath')
                    myds.NwbDatasetPath = '/acquisition/motion_corrected_stack/data';
                else
                    myds.NwbDatasetPath = options.NwbDatasetPath;
                end
                try
                    h5info(myds.fileName, myds.NwbDatasetPath);
                catch ME
                    error('Cannot read the selected path from the nwb file: %s', ME.message);
                end
            end
            dimensions = getFileFrameDimensions(myds);
            if ~myds.doAutoResize
                assert((dimensions.Width == myds.outputFrameSize(1)) ...
                    && (dimensions.Height == myds.outputFrameSize(2)),...
                    "Actual frame size is not equal to specified outputFrameSize");
            end
            framePerSetCount = myds.numberOfFlankingFrames + 3;
            assert(getNumberOfFrames(myds) >= framePerSetCount, "Not enough frames in stack for DeepInterpolation");
            myds.frameCount = getNumberOfFrames(myds);
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
            refFrame = getSingleFrame(myds, myds.currentFrameIndex);
            flankingFrames = single( ...
                ones(myds.outputFrameSize(1), ...
                myds.outputFrameSize(2), ...
                myds.numberOfFlankingFrames) ...
                );
            framecount = 1;
            for leftFrame = 0:(myds.numberOfFlankingFrames/2) - 1
                thisFrame = getSingleFrame(myds, myds.setFramesStartIndex+leftFrame);
                flankingFrames(:,:,framecount) = thisFrame;
                framecount = framecount + 1;
            end
            %frame myds.numberOfFlankingFrames + 1 is center frame. One
            %frame before and one after is left out.
            startRightFrame = myds.numberOfFlankingFrames/2 + 3;
            for rightFrame = startRightFrame:startRightFrame + myds.numberOfFlankingFrames/2 - 1
                thisFrame = getSingleFrame(myds, myds.setFramesStartIndex+rightFrame);
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

        function rawFrame = readFrameFromTiff(myds, index)
            rawFrame = imread(myds.fileName, index);
        end

        function rawFrame = readFrameFromNwb(myds, index)
            dimensions = getNwbFrameDimensions(myds);
            index = double(index);
            rawFrame = h5read(myds.fileName, myds.NwbDatasetPath, [1, 1, index], [dimensions.Width, dimensions.Height, 1]);
        end

        function frame = getSingleFrame(myds, index)
            if strcmp(myds.datasetType, 'tiff')
                rawFrame = readFrameFromTiff(myds, index);
            elseif strcmp(myds.datasetType, 'nwb')
                rawFrame = readFrameFromNwb(myds, index);
            else
               error('Unsupported dataset type.');
            end
            if myds.doAutoResize
                rawFrame = imresize(rawFrame, myds.outputFrameSize);
            end
            frame = single(rawFrame);
        end

        function dimensions = getTiffFrameDimensions(myds)
            fileInfo = imfinfo(myds.fileName);
            dimensions.Width = fileInfo(1).Width;
            dimensions.Height = fileInfo(1).Height;
        end

        function dimensions = getNwbFrameDimensions(myds)
            datasetInfo = h5info(myds.fileName, myds.NwbDatasetPath);
            datasetSize = datasetInfo.Dataspace.Size;
            dimensions.Width = datasetSize(1);
            dimensions.Height = datasetSize(2);
        end

        function dimensions = getFileFrameDimensions(myds)
            if strcmp(myds.datasetType, 'tiff')
                dimensions = getTiffFrameDimensions(myds);
            elseif strcmp(myds.datasetType, 'nwb')
                dimensions = getNwbFrameDimensions(myds);
            else
               error('Unsupported dataset type.');
            end
        end

        function numFrames = getTiffNumberOfFrames(myds)
            fileInfo = imfinfo(myds.fileName);
            numFrames = numel(fileInfo);
        end

        function numFrames = getNwbNumberOfFrames(myds)
            datasetInfo = h5info(myds.fileName, myds.NwbDatasetPath);
            numFrames = datasetInfo.Dataspace.Size(3);
        end

        function numFrames = getNumberOfFrames(myds)
            if strcmp(myds.datasetType, 'tiff')
                numFrames = getTiffNumberOfFrames(myds);
            elseif strcmp(myds.datasetType, 'nwb')
                numFrames = getNwbNumberOfFrames(myds);
            else
               error('Unsupported dataset type.');
            end
        end

    end

end
