# DeepInterpolation with MATLAB
## A MATLAB implementation of the DeepInterpolation principle

### About DeepInterpolation
DeepInterpolation with MATLAB is a MATLAB implementation of the DeepInterpolation general-purpose algorithm used to denoise data by removing independent noise.
For the implementation, the ideas of the [deepinterpolation Python library](https://github.com/AllenInstitute/deepinterpolation) are used.

This repository is currently meant to provide live scripts to illustrate the training and inference pipelines.
Note that training does not require ground truth.

The associated bioRxiv publication can be accessed [here](https://www.biorxiv.org/content/10.1101/2020.10.15.341602v1).

### Getting started
Users are advised to first try one of the tiny inference example workflows that are found in the example directory. The corresponding live scripts can be opened by clicking either
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_inference.mlx) for electrical-physiology data from a Neuropixels probe;
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx) for 2-photon optical-physiology data.

#### Requirements
* Deep Learning Toolbox Converter for TensorFlow Models support package;

### Example training

To try out training your own DeepInterpolation network, it is recommended to start with:
* [tiny_ephys_training.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_training.mlx) for ephys data from a Neuropixels probe.
* [ophys_training_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/ophys_training_inference.mlx) for 2-photon ophys data.

|Training example  | Training dataset|  (pre-)trained model|
|---|---|---|
|Tiny ephys| ephys_tiny_continuous.dat2 (available in project folder)  | 2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5 (available in project folder)|
| Ophys  | ophys_experiment_496908818.h5  (available on [AWS](http://allen-brain-observatory.s3.amazonaws.com/visual-coding-2p/ophys_movies/ophys_experiment_501254258.h5))  | 2021_07_31_09_49_38_095550_unet_1024_search_mean_squared_error_pre_30_post_30_feat_32_power_1_depth_4_unet_True-0125-0.5732.h5  (available in project folder) |

### Example inference
To try out inference with your own DeepInterpolation network, we recommend to start with:
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_inference.mlx) for ephys data from a Neuropixels probe.
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx) for 2-photon ophys data.

| Example| Pre-trained Model|  Sample Data  |
|---| --- |---|
| Tiny ephys  | 2020_02_29_15_28_unet_single_ephys_1024_mean_squared_error-1050.h5 (available in project folder) | ephys_tiny_continuous.dat2 files (available in project folder)|
| Ophys | 2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5 (available on [Dropbox](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0)) | ophys_tiny_761605196.tif (available in project folder)  |


### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of adding issues or submitting pull requests.
