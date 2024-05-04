[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=gettingStarted.mlx)
[![View Deep-Interpolation-MATLAB on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/134991-deepinterpolation-matlab)
# DeepInterpolation with MATLAB
A MATLAB implementation of the DeepInterpolation principle
### About DeepInterpolation
DeepInterpolation is a [published](https://pubmed.ncbi.nlm.nih.gov/34650233) general-purpose algorithm created by the [Allen Institute](https://alleninstitute.org/) for removing noise that arrives independently from data frame to data frame. 

DeepInterpolation uses deep learning to predict a data frame from the contents of several preceeding and succeeding frames. The resulting prediction is free of independent noise such as shot noise (imaging) or thermal noise (electrophysiology). If the signal is well predicted by these preeceding and succeeding frames, as in 2-photon imaging and multi-channel recording, then DeepInterpolation does an excellent job of increasing signal-to-noise ratio. In systems neuroscience, this allows more cells to be characterized with better certainty about their activity. 

### Getting started
Get started with inference examples using smaller datasets. You can individually view :eyes: or run :arrow_forward: each on [MATLAB Online](https://www.mathworks.com/products/matlab-online.html):

| | Inference Example | Trained Model|  Sample data  | View | Run
| ---  | --- | --- | --- | --- | --- |
|⚡|"Ephys" (electrophysiology<sup>1</sup>) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5)  | [sample data](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ephys_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_ephys_inference.mlx)
|🔬|"Ophys" (optical physiology<sup>2</sup>) object demo| [model](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0)  (Dropbox, 120 MB) | [sample data](sample_data/ophys_tiny_761605196.tif)   | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ophys_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/small_ophys_inference.mlx)
|🔬|"Ophys" (optical physiology<sup>2</sup>) detailed demo| [model](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0)  (Dropbox, 120 MB) | [sample data](sample_data/ophys_tiny_761605196.tif)   | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ophys_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_ophys_inference.mlx)
|🧠| fMRI (functional magnetic resonance imaging) | [model](https://www.dropbox.com/sh/ngx5plndmd4jsca/AAAqeFE9Bw6g72Cm9SC4QkMxa/2020_08_28_00_25_fmri_unet_denoiser_mean_absolute_error_2020_08_28_00_25_model.h5) (Dropbox, 407.55 KB)| [sample_data](https://openneuro.org/crn/datasets/ds001246/snapshots/1.2.1/files/sub-01:ses-perceptionTest01:func:sub-01_ses-perceptionTest01_task-perception_run-01_bold.nii.gz) (OpenNeuro)| [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_fMRI_inference.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_fMRI_inference.mlx)

<sup>1</sup> via Neuropixels neural probes
<sup>2</sup> via two-photon (2P) calcium imaging

#### Requirements
* [Deep Learning Toolbox Converter for TensorFlow Models](https://nl.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models) support package.

### Going Further

#### Training examples
Try out training your own DeepInterpolation network. You can individually view (:eyes:) or run (:arrow_forward:) these examples on MATLAB Online:

| Nickname  | Model |  Dataset | View | Run
|---|---|---|---|---|
| "Ephys" (electrophysiology) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5) | [dataset](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Ftiny_ephys_training.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/tiny_ephys_training.mlx)
| "Ophys" (optical physiology) | [model](sample_data/2021_07_31_09_49_38_095550_unet_1024_search_mean_squared_error_pre_30_post_30_feat_32_power_1_depth_4_unet_True-0125-0.5732.h5) | [dataset](http://allen-brain-observatory.s3.amazonaws.com/visual-coding-2p/ophys_movies/ophys_experiment_496908818.h5) (AWS, 55.6 GB) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2F29e7e92d-4639-4178-8e19-739580981e60%2Ffiles%2Fexamples%2Fophys_training_inference.mlx&embed=web) | (\*) |

<sub>(\*) This data-intensive example is recommended for use on a local machine, not for MATLAB online.</sub>

#### Custom Datastore for DeepInterpolation
For large datasets that are too large to load entirely into memory, the custom datastore offers a solution. By initializing the datastore with a dataset's path, users can sequentially access both flanking frames and their respective center frames. This allows for easy training and inference.

For a detailed introduction and a practical workflow, see the customdatastore_example:
| Nickname  | Model |  Dataset | View | Run
|---|---|---|---|---|
| "Custom datastore" Read from a custom datastore | [model](sample_data/pretrainedNetwork.mat) | [sample_data](sample_data/ophys_tiny_761605196.tif) | [:eyes:](https://viewer.mathworks.com/?viewer=live_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F84c22101-bffc-435a-910c-b0c7dcd5b386%2Fbfd58de9-1242-48ba-81bc-dfe9c37fae6b%2Ffiles%2Fexamples%2Fcustomdatastore_example.mlx&embed=web) | [:arrow_forward:](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=examples/customdatastore_example.mlx)

### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of [adding issues](https://github.com/MATLAB-Community-Toolboxes-at-INCF/DeepInterpolation-MATLAB/issues) or submitting pull requests.

### Illustration

The principle behind DeepInterpolation is illustrated in the following figure from [Lecoq et al. 2021]((https://pubmed.ncbi.nlm.nih.gov/34650233)) in _Nature Methods_. 

![Figure 1a from Lecoq et al. 2021](sampleData/Lecoq_et_al_2021_Fig1a.png). 

To predict the frame-of-interest ("predicted frame"), a deep learning network uses data from several preceeding and succeeding video frames. During training, the network is modified so that it produces better and better representations of the predicted frames over several datasets. During inference, the network produces predicted frames that are used in place of the original data. If the signal in the data is well predicted by the information in the preceeding and succeeding frames, then the inferred data contains a reconstruction of the original data where the usual noise that occurs independently on each frame is greatly reduced, because it is not predicted on average. The signal can be inferred with high quality in part because the network can average out the independent noise in the preceeding and succeeding frames to uncover the underlying signal just prior to and just after the signal in the predicted frame. 

### Uses other open source resources

We use [progressbar](https://www.mathworks.com/matlabcentral/fileexchange/6922-progressbar) and mimic some functions from [Brain Observatory Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/90900-brain-observatory-toolbox).

### Other implementations of DeepInterpolation

- [Python](https://github.com/AllenInstitute/deepinterpolation)



