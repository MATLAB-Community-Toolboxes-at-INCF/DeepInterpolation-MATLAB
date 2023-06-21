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
* [ophys_training_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/ophys_training_inference.mlx) for 2-photon ophys data. Training dataset needs to be downloaded manually and stored in the sample_data folder and is available for download on [AWS](http://allen-brain-observatory.s3.amazonaws.com/visual-coding-2p/ophys_movies/ophys_experiment_501254258.h5) (51.8 GB)

### Example inference
To try out inference with your own DeepInterpolation network, we recommend to start with:
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_inference.mlx) for ephys data from a Neuropixels probe.
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx) for 2-photon ophys data. The trained network needs to be downloaded manually and stored in the sample_data folder. It is available for download on [Dropbox](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0).


### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of adding issues or submitting pull requests.
