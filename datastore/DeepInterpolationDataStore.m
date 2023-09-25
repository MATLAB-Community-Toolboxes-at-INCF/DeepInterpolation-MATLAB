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
        autoResize = false;
        frameCount double
        dsSetCount double
        setsAvailable double
        currentSet double
        setFramesStartIndex double
        currentFrameIndex double        
        allSetFrameStartIndices double
    end

    methods % begin methods section
        function myds = DeepInterpolationDataStore(inArg, doAutoResize)
            assert(isfile(inArg));
            if nargin == 2
                myds.autoResize = logical(doAutoResize);
            end
            myds.fileName = inArg;
            fileInfo = imfinfo(myds.fileName);
            assert(strcmp(fileInfo(1).Format,'tif'), "Must be tiff format");
            if ~myds.autoResize
                assert((fileInfo(1).Width == 512) && (fileInfo(1).Height == 512),...
                    "Stack must be 512x512xN");
            end
            assert(numel(fileInfo) > 62, "Not enough frames in stack for DeepInterpolation");
            myds.frameCount = numel(fileInfo);
            myds.dsSetCount = myds.frameCount - 62;
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
            if myds.autoResize
                rawRefFrame = imresize(rawRefFrame,[512 512]);
            end
            refFrame = single(rawRefFrame);
            flankingFrames = single(ones(512,512,60));%this is fixed due to the network
            framecount = 1;
            for leftFrame = 0:29
                rawThisFrame = imread(myds.fileName,myds.setFramesStartIndex+leftFrame);
                if myds.autoResize
                    rawThisFrame = imresize(rawThisFrame,[512 512]);
                end
                thisFrame = single(rawThisFrame);
                flankingFrames(:,:,framecount) = thisFrame;
                framecount = framecount + 1;
            end
            %frame Start+30 and Start+32 are left out / Start+31 is centerframe
            for rightFrame = 33:62
                rawThisFrame = imread(myds.fileName,myds.setFramesStartIndex+rightFrame);
                if myds.autoResize
                    rawThisFrame = imresize(rawThisFrame,[512 512]);
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
                myds.currentFrameIndex = myds.setFramesStartIndex + 31;
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
            myds.currentFrameIndex = myds.setFramesStartIndex + 31;
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