[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=INCF/DeepInterpolation-MATLAB&file=README.mlx)
# DeepInterpolation with MATLAB
A MATLAB implementation of the DeepInterpolation principle
### About DeepInterpolation
DeepInterpolation is a general-purpose algorithm used to denoise data by removing independent noise. The Allen Institute developed the principle and created a [reference implementation in Python](https://github.com/AllenInstitute/deepinterpolation).
The principle of DeepInterpolation has been [published](https://www.nature.com/articles/s41592-021-01285-2) in the Nature Methods journal, with applications to systems neuroscience data.

### Getting started
Get started with one of the example inference workflows. You can individually view (:eyes:) or run (:arrow_forward:) these examples on MATLAB Online:

| Nickname| Trained Model|  Sample data  | View | Run
| --- | --- | --- | --- | --- |
| "Ephys" (electrophysiology) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5)  | [sample data](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](examples/tiny_ephys_inference.mlx) | :arrow_forward:
| "Ophys" (optical physiology) | [model](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0)  (Dropbox, 120 MB) | [sample data](sample_data/ophys_tiny_761605196.tif)   | [:eyes:](examples/tiny_ophys_inference.mlx) | :arrow_forward:


#### Requirements
* [Deep Learning Toolbox Converter for TensorFlow Models](https://nl.mathworks.com/matlabcentral/fileexchange/64649-deep-learning-toolbox-converter-for-tensorflow-models) support package.

### Going Further

#### Training examples
Try out training your own DeepInterpolation network. You can individually view (:eyes:) or run (:arrow_forward:) these examples on MATLAB Online:

| Nickname  | Model |  Dataset | View | Run
|---|---|---|---|---|
| "Ephys" (electrophysiology) | [model](sample_data/2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5) | [dataset](sample_data/ephys_tiny_continuous.dat2) | [:eyes:](examples/tiny_ephys_training.mlx) | :arrow_forward: |
| "Ophys" (optical physiology) | [model](sample_data/2021_07_31_09_49_38_095550_unet_1024_search_mean_squared_error_pre_30_post_30_feat_32_power_1_depth_4_unet_True-0125-0.5732.h5) | [dataset](http://allen-brain-observatory.s3.amazonaws.com/visual-coding-2p/ophys_movies/ophys_experiment_496908818.h5) (AWS, 55.6 GB) | [:eyes:](examples/ophys_training_inference.mlx) | :arrow_forward: |


### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of adding issues or submitting pull requests.
