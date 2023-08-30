function net = fmriDenoiserNetwork(modelPath, pretrainedNetwork)
%fmriDenoiserNetwork - generate MATLAB Version of the DeepInterpolation fMRI-Denoiser

lgraph = layerGraph();

tempLayers = [
    image3dInputLayer([7 7 7 5],"Name","image3dinput",'Normalization','none');
    convolution3dLayer([3 3 3],8,"Name","conv3d","Padding","same","Weights",mywini(1),"Bias",mybini(1));
    reluLayer("Name","relu1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    maxPooling3dLayer([3 3 3],"Name","pool1","Padding","same")
    convolution3dLayer([3 3 3],16,"Name","conv3d_1","Padding","same","Weights",mywini(2),"Bias",mybini(2))
    reluLayer("Name","relu2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    maxPooling3dLayer([3 3 3],"Name","pool2","Padding","same")
    convolution3dLayer([3 3 3],32,"Name","conv3d_2","Padding","same","Weights",mywini(3),"Bias",mybini(3))
    reluLayer("Name","relu3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","conc_up_1")
    convolution3dLayer([3 3 3],16,"Name","conv3d_3","Padding","same","Weights",mywini(4),"Bias",mybini(4))
    reluLayer("Name","relu4")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","conc_up_2")
    convolution3dLayer([3 3 3],8,"Name","conv3d_4","Padding","same","Weights",mywini(5),"Bias",mybini(5))
    reluLayer("Name","relu5")
    convolution3dLayer([1 1 1],1,"Name","conv3d_5","Padding","same","Weights",mywini(6),"Bias",mybini(6))
    regressionLayer("Name","out_r")];
lgraph = addLayers(lgraph,tempLayers);

clear tempLayers;

lgraph = connectLayers(lgraph,"relu1","pool1");
lgraph = connectLayers(lgraph,"relu1","conc_up_2/in2");
lgraph = connectLayers(lgraph,"relu2","pool2");
lgraph = connectLayers(lgraph,"relu2","conc_up_1/in2");
lgraph = connectLayers(lgraph,"relu3","conc_up_1/in1");
lgraph = connectLayers(lgraph,"relu4","conc_up_2/in1");

net = assembleNetwork(lgraph);
save(modelPath,"net")

function w = mywini(ilayer)
lwlnames = {'conv3d','conv3d_1','conv3d_2','conv3d_3','conv3d_4','conv3d_5'}; %layers_with_learnables
lname = lwlnames{ilayer};
thisweights = h5read(pretrainedNetwork,strcat('/model_weights/',lname,'/',lname,'/kernel:0'));
w = permute(thisweights,[5,4,3,2,1]);
end

function b = mybini(ilayer)
lwlnames = {'conv3d','conv3d_1','conv3d_2','conv3d_3','conv3d_4','conv3d_5'}; %layers_with_learnables
lwldims = [8 16 32 16 8 1];
lname = lwlnames{ilayer};
b = h5read(pretrainedNetwork,strcat('/model_weights/',lname,'/',lname,'/bias:0'));
b = reshape(b,[1 1 1 lwldims(ilayer)]);
end

end