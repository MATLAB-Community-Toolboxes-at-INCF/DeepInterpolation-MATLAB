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
* For running
  [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx),
  please download the model used for inference from [Dropbox](https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC0sZWahCJFBRARoYsw8Nnra/2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5?dl=0).

### Example training

To try out training your own DeepInterpolation network, it is recommended to start with: 
* [tiny_ephys_training.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_training.mlx) for ephys data from a Neuropixels probe
* [ophys_training_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/ophys_training_inference.mlx) for 2-photon ophys data 

### Example inference
Raw pre-trained models are available as separate h5 files on Dropbox.

Some key-recording parameters considering the Neuropixel DeepInterpolation network: Neuropixels Phase 3a probes
* 374 simultaneous recording sites across 3.84 mm, 10 reference channels;
* Four-column checkerboard site layout with 20 µm spacing between rows;
* 30 kHz sampling rate;
* 500x hardware gain setting;
* 500 Hz high-pass filter in hardware, 150 Hz high-pass filter applied offline;
* Pre-processing: Median subtraction was applied to individual probes to remove signals that were common across all recording sites. Each probe recording was mean-centered and normalized with a single pair of values for all nodes on the probe.
* Docker hub id: 245412653747/deep_interpolation:allen_neuropixel;
* Dropbox link: https://www.dropbox.com/sh/tm3epzil44ybalq/AACyKxfvvA2T_Lq_rnpHnhFma?dl=0

The two-photon Ai93 excitatory line DeepInterpolation network probes 
* 30Hz sampling rate, 400x400 μm2 field of view, 512x512 pixels;
* 0.8 NA objective;
* 910 nm excitation wavelength;
* Gcamp6f calcium indicator;
* Ai93 reporter line expressed in excitatory neurons;
* Docker hub id: 245412653747/deep_interpolation:allen_400um_512pix_30hz_ai93
* Dropbox link: https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC9BQI1bdfmAL3OFO0lmVb1a?dl=0
* Training data: https://github.com/AllenInstitute/deepinterpolation/blob/master/examples/paper_generation_code/json_data/2019-09-05-train-very-large-single-plane-Ai93-norm.json

### Support
DeepInterpolation with MATLAB is a public repository. Contributions can be made in the form of adding issues or submitting pull requests.
