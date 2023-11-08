[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=gettingStarted.mlx)
[![View Deep-Interpolation-MATLAB on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/134991-deepinterpolation-matlab)
# DeepInterpolation with MATLAB
A MATLAB implementation of the DeepInterpolation principle
### About DeepInterpolation
DeepInterpolation is a general-purpose algorithm used to denoise data by removing independent noise. The Allen Institute developed the principle and created a [reference implementation in Python](https://github.com/AllenInstitute/deepinterpolation).
The principle of DeepInterpolation has been [published](https://www.nature.com/articles/s41592-021-01285-2) in the Nature Methods journal, with applications to systems neuroscience data.

### Getting started
Get oriented and get started using [MATLAB Online](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=gettingStarted.mlx). This will orient you to several live script examples available to guide new users.

You can also try one of the example inference workflows. You can individually view (:eyes:) or run (:arrow_forward:) these examples on MATLAB Online:

| Nickname| Trained Model|  Sample data  | View | Run
| --- | --- | --- | --- | --- |
| "Ephys" (electrophysiology) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5)  | [sample data](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ephys_inference.mlx&embed=web)
| "Ophys" (optical physiology) | [model](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0)  (Dropbox, 120 MB) | [sample data](sample_data/ophys_tiny_761605196.tif)   | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ophys_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_ophys_inference.mlx)
| "fMRI" (functional magnetic resonance imaging) | [model](sample_data/2020_08_28_00_25_fmri_unet_denoiser_mean_absolute_error_2020_08_28_00_25_model.h5) | [sample_data](https://openneuro.org/crn/datasets/ds001246/snapshots/1.2.1/files/sub-01:ses-perceptionTest01:func:sub-01_ses-perceptionTest01_task-perception_run-01_bold.nii.gz) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_fMRI_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_fMRI_inference.mlx)
| "Custom datastore" Read from a custom datastore | [model](sample_data/pretrainedNetwork.mat) | [sample_data](sample_data/ophys_tiny_761605196.tif) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Fcustomdatastore_example.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/customdatastore_example.mlx)


#### Requirements
* [Deep Learning Toolbox Converter for TensorFlow Models](https://nl.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models) support package.

### Going Further

#### Training examples
Try out training your own DeepInterpolation network. You can individually view (:eyes:) or run (:arrow_forward:) these examples on MATLAB Online:

| Nickname  | Model |  Dataset | View | Run
|---|---|---|---|---|
| "Ephys" (electrophysiology) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5) | [dataset](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ephys_training.mlx&embed=web) |
| "Ophys" (optical physiology) | [model](sample_data/2021_07_31_09_49_38_095550_unet_1024_search_mean_squared_error_pre_30_post_30_feat_32_power_1_depth_4_unet_True-0125-0.5732.h5) | [dataset](http://allen-brain-observatory.s3.amazonaws.com/visual-coding-2p/ophys_movies/ophys_experiment_496908818.h5) (AWS, 55.6 GB) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Fophys_training_inference.mlx&embed=web) | (\*) |

<sub>(\*) This data-intensive example is recommended for use on a local machine, not for MATLAB online.</sub>


### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of adding issues or submitting pull requests.
