# DeepInterpolation-MATLAB
DeepInterpolation-MATLAB is a MATLAB implementation of the DeepInterpolation general-purpose algorithm used to denoise data by removing independent noise. Importantly training does NOT require ground truth. This repository is currently meant to provide livescripts to illustrate the training and inference pipelines. 

The associated bioRxiv publication can be accessed from here: https://www.biorxiv.org/content/10.1101/2020.10.15.341602v1

# Principle of DeepInterpolation
![principle](https://user-images.githubusercontent.com/83267915/203020071-53836bfe-5303-4587-ad1c-87595af08689.png)

Figure 1 - Schematic introducing the principles of DeepInterpolation. A. An interpolation model is trained to predict a noisy block from other blocks with independent noise. The loss is the difference between the predicted data and a new noisy block. B. The interpolation model is used to create a noiseless version of the input data. (Lecoq et al., 2020)

# Example training

To try out training your own DeepInterpolation network, we recommend to start with this file: [tiny_ephys_training.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/livescripts/examples/tiny_ephys_training.mlx)

# Example Inference

To try out training your own DeepInterpolation network, we recommend to start with:
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/livescripts/examples/tiny_ephys_inference.mlx) for ephys data from a Neuropixels probe
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/livescripts/examples/tiny_ophys_inference.mlx) for 2-photon ophys data  

Raw pre-trained models are available as separate h5 file on Dropbox.

Neuropixel DeepInterpolation network:

Key recording parameters:

Neuropixels Phase 3a probes
* 374 simultaneous recording sites across 3.84 mm, 10 reference channels
* Four-column checkerboard site layout with 20 µm spacing between rows
* 30 kHz sampling rate
* 500x hardware gain setting
* 500 Hz high pass filter in hardware, 150 Hz high-pass filter applied offline.
* Pre-processing: Median subtraction was applied to individual probes to remove signals that were common across all recording sites. Each probe recording was mean-centered and normalized with a single pair of value for all nodes on the probe.
* Docker hub id : 245412653747/deep_interpolation:allen_neuropixel
* Dropxbox link : https://www.dropbox.com/sh/tm3epzil44ybalq/AACyKxfvvA2T_Lq_rnpHnhFma?dl=0

Two-photon Ai93 excitatory line DeepInterpolation network:

Key recording parameters:

* 30Hz sampling rate, 400x400 μm2 field of view, 512x512 pixels.
* 0.8 NA objective.
* 910 nm excitation wavelength.
* Gcamp6f calcium indicator.
* Ai93 reporter line expressed in excitatory neurons.
* Docker hub id : 245412653747/deep_interpolation:allen_400um_512pix_30hz_ai93
* Dropbox link : https://www.dropbox.com/sh/vwxf1uq2j60uj9o/AAC9BQI1bdfmAL3OFO0lmVb1a?dl=0
* Training data : https://github.com/AllenInstitute/deepinterpolation/blob/master/examples/paper_generation_code/json_data/2019-09-05-train-very-large-single-plane-Ai93-norm.json


NB for Linux users: If a Live Script demo finishes its run without any output or error, please consider running the corresponding *.m file for debugging the error. If the error is related to a bug in DeepInterpolation-MATLAB and you have a solution please submit a pull request, else please raise an issue stating the error message along with OS and MATLAB version details.


