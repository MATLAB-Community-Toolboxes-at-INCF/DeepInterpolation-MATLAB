function deepIntInference(deepIntOpts, iFrame)
%DEEPINTINFERENCE - denoise all frames in data or demo one frame
%
% Example function that shows a possible workflow for denoising tiff image stacks
% with a DeepInterpolation Network in MATLAB.
%
% Please also see the github repository of the original python-version of
% DeepInterpolation for info: https://github.com/AllenInstitute/deepinterpolation
%
% Dr. Thomas Künzel, The MathWorks, 2023
% tkuenzel@mathworks.com

if nargin < 2
    iFrame = [];
end

tempLoad = load(fullfile(deepIntOpts.networkPath, deepIntOpts.networkName));
diNet = tempLoad.output;
imageStack = tiffreadVolume(fullfile(deepIntOpts.dataPath,deepIntOpts.dataName));
dataDimensions = size(imageStack);

if ~all(dataDimensions(1:2) == [512 512])
    imageStack = imresize3(imageStack, [512 512 dataDimensions(3)]);
end

newFilename = "denoised_" + deepIntOpts.dataName + "";
outFullFileName = fullfile(deepIntOpts.dataPath, newFilename);

if ~isempty(iFrame)%denoise one frame and show (for debug)
    frames = imageStack(:,:,iFrame-29:iFrame+30);
    diFrame = predict(diNet, frames);
    figure()
    tiledlayout("flow")
    nexttile
    imshow(imageStack(:,:,iFrame),[])
    title("raw")
    nexttile
    imshow(diFrame, [])
    title("denoised")
else%denoise all data
    diImageStack = imageStack;
    framelist = 31:(dataDimensions(3)-30);
    for frameindex = 1:numel(framelist)
        thisframe = framelist(frameindex);
        diImageStack(:,:,thisframe) = predict(diNet,imageStack(:,:,thisframe-30:thisframe+29));
    end    
    imwrite(diImageStack(:,:,1), outFullFileName,"tif");
    for iframe = 2:dataDimensions(3)
        imwrite(diImageStack(:,:,iframe), outFullFileName,"tif","WriteMode","append");
    end
end
end