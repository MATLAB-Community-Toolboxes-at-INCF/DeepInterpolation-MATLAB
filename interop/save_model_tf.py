#The following snippet is executed in Python 3.9 with TensorFlow 2.10. Currently, the import functionality in MATLAB support upto TF 2.10.
#The command to install TensorFlow 2.10 is:
#pip install tensorflow==2.10

import tensorflow as tf
model = tf.keras.models.load_model('2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450.h5')
model.save('TF_2019_09_11_23_32_unet_single_1024_mean_absolute_error_Ai93-0450', save_format='tf')

