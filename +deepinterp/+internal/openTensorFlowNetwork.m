function net = openTensorFlowNetwork(tensorFlowZipFile, namespaceName)
% OPENTENSORFLOWNETWORK - open a TensorFlow network zip file
%
% NET = OPENTENSORFLOWNETWORK(TENSORFLOWZIPFILE, NAMESPACENAME)
%
% Open a network from a saved TensorFlow network zip file.
%
% The ZIP file should have a directory with subdirectories "assets",
% "variables" and files "keras_metadata.pb" and "saved_model.pb".
%
% NAMESPACENAME is the namespace to be used to import the network.
%
% The namespace is created in the directory:
%  [DEEP_INTERPOLATION_ROOT filesep 'preTrainedModels' filesep 'TensorFlowNetworks']
%
%

tfnet_path = fullfile(deepinterp.toolboxpath,'pretrainedModels','TensorFlowNetworks');

output_files = unzip(tensorFlowZipFile,tfnet_path);
modelFolder = fileparts(output_files{1});
net_namespace = namespaceName;
currDir = pwd;

did_it_fail = false;

try,
   cd(tfnet_path);
   net = importNetworkFromTensorFlow(modelFolder,Namespace=namespaceName);
catch,
   did_it_fail = true;
end;

cd(currDir);

if did_it_fail,
    error(lasterr);
end;
