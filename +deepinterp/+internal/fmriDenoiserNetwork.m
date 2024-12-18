function net = fmriDenoiserNetwork(preN)
%FMRIDENOISERNETWORK - MATLAB Version of the DeepInterpolation fMRI-Denoiser

resize = true;

lgraph = layerGraph();
poolsize = [2 2 2];
poolargs={"Stride",poolsize}; 
convargs={"Padding","same"};
resizeLayers1 = [
    resize3dLayer("Scale",2,"Name","up1");
    functionLayer(@zeropad,"Name","pad1",Formattable=true,Acceleratable=true)];
resizeLayers2 = [
    resize3dLayer("Scale",2,"Name","up2")
    functionLayer(@zeropad,"Name","pad2",Formattable=true,Acceleratable=true)];
cc1="pad1"; cc2="pad2";

if ~resize
    poolargs={"Padding","same"};
    resizeLayers1=[]; resizeLayers2=[];
    cc1="relu3"; cc2="relu4";    
end

tempLayers = [
    image3dInputLayer([7 7 7 5],"Name","image3dinput","Normalization","none")
    convolution3dLayer([3 3 3],8,"Name","conv1",convargs{:},"Weights",mywini(1,preN),"Bias",mybini(1,preN))
    reluLayer("Name","relu1")
    maxPooling3dLayer(poolsize,"Name","pool1",poolargs{:})
    convolution3dLayer([3 3 3],16,"Name","conv2",convargs{:},"Weights",mywini(2,preN),"Bias",mybini(2,preN))
    reluLayer("Name","relu2")
    maxPooling3dLayer(poolsize,"Name","pool2",poolargs{:})
    convolution3dLayer([3 3 3],32,"Name","conv3",convargs{:},"Weights",mywini(3,preN),"Bias",mybini(3,preN))
    reluLayer("Name","relu3")
    resizeLayers1];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","conc_up_1")
    convolution3dLayer([3 3 3],16,"Name","conv4",convargs{:},"Weights",mywini(4,preN),"Bias",mybini(4,preN))
    reluLayer("Name","relu4")
    resizeLayers2];
lgraph = addLayers(lgraph,tempLayers);
lgraph = connectLayers(lgraph,cc1,"conc_up_1/in1");
lgraph = connectLayers(lgraph,"relu2","conc_up_1/in2");

tempLayers = [
    depthConcatenationLayer(2,"Name","conc_up_2")
    convolution3dLayer([3 3 3],8,"Name","conv5",convargs{:},"Weights",mywini(5,preN),"Bias",mybini(5,preN))
    reluLayer("Name","relu5")
    convolution3dLayer([1 1 1],1,"Name","out",convargs{:},"Weights",mywini(6,preN),"Bias",mybini(6,preN))
    regressionLayer("Name","out_r")];
lgraph = addLayers(lgraph,tempLayers);
lgraph = connectLayers(lgraph,cc2,"conc_up_2/in1");
lgraph = connectLayers(lgraph,"relu1","conc_up_2/in2");

clear tempLayers;

net = assembleNetwork(lgraph);
end


%% Local Functions

function w = mywini(ilayer, preN)
lwlnames = {'conv3d','conv3d_1','conv3d_2','conv3d_3','conv3d_4','conv3d_5'}; %layers_with_learnables
lname = lwlnames{ilayer};
thisweights = h5read(preN,strcat('/model_weights/',lname,'/',lname,'/kernel:0'));
w = permute(thisweights,[5,4,3,2,1]);
end

function b = mybini(ilayer, preN)
lwlnames = {'conv3d','conv3d_1','conv3d_2','conv3d_3','conv3d_4','conv3d_5'}; %layers_with_learnables
lwldims = [8 16 32 16 8 1];
lname = lwlnames{ilayer};
b = h5read(preN,strcat('/model_weights/',lname,'/',lname,'/bias:0'));
b = reshape(b,[1 1 1 lwldims(ilayer)]);
end

function out = zeropad(in)
m = extractdata(in);
n = padarray(m,[1 1 1],0,"post");
out = dlarray(n);
end