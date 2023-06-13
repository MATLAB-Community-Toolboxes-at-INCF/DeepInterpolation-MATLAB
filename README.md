# DeepInterpolation with MATLAB
DeepInterpolation with MATLAB is a MATLAB implementation of the DeepInterpolation general-purpose algorithm used to denoise data by removing independent noise. 
For the implementation, we have used the ideas of the [deepinterpolation Python library](https://github.com/AllenInstitute/deepinterpolation) that can be found on GitHub, under the Allen Institute Software License.

This repository is currently meant to provide live scripts to illustrate the training and inference pipelines. 
Note that training does not require ground truth. 

The associated bioRxiv publication can be accessed [here](https://www.biorxiv.org/content/10.1101/2020.10.15.341602v1).

# Example live scripts
We advise users to first try one of the tiny inference example workflows that are found in the example directory. The corresponding live scripts can be opened by clicking either 
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_inference.mlx) for electrical-physiology data from a Neuropixels probe;
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx) for 2-photon optical-physiology data.

The complete live script can be run by clicking the 'Run' button on top of the live editor. As a deep-interpolation folder, you select the directory in which the folders 'examples', 'network_layers', and 'sample_data' are found. It could be well possible you need to install a support package using the Add-on Explorer. This should be easy by clicking the link in the corresponding error message.

It is also possible to run it section by section by clicking the 'Run section' button. Make sure you wait until the current section is finished before you run the next section. The script is still running when you see the loading symbol being active on the left top of the script. Any errors will be marked by a red exclamation mark at the same location.

Some numbers can be adapted manually using sliders (channel number in the ephys example, firstslice in the ophys example).

# Example training

To try out training your own DeepInterpolation network, we recommend to start with: 
* [tiny_ephys_training.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_training.mlx) for ephys data from a Neuropixels probe
* [ophys_training_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/ophys_training_inference.mlx) for 2-photon ophys data 

# Example Inference

To try out inference with your own DeepInterpolation network, we recommend to start with:
* [tiny_ephys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ephys_inference.mlx) for ephys data from a Neuropixels probe
* [tiny_ophys_inference.mlx](https://github.com/INCF/DeepInterpolation-MATLAB/blob/main/examples/tiny_ophys_inference.mlx) for 2-photon ophys data  

Raw pre-trained models are available as separate h5 files on Dropbox.

Some key-recording parameters considering the Neuropixel DeepInterpolation network: Neuropixels Phase 3a probes
* 374 simultaneous recording sites across 3.84 mm, 10 reference channels;
* Four-column checkerboard site layout with 20 µm spacing between rows;
* 30 kHz sampling rate;
* 500x hardware gain setting;
* 500 Hz high pass filter in hardware, 150 Hz high-pass filter applied offline;
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


NB for Linux users: If a Live Script demo finishes its run without any output or error, please consider running the corresponding *.m file for debugging the error. If the error is related to a bug in DeepInterpolation-MATLAB and you have a solution, please submit a pull request, else please raise an issue stating the error message along with OS and MATLAB version details.


