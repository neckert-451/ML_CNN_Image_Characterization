# Machine Learning CNN Image Characterization Project
Repository for all the files and code related to the project I completed in the Materials Science Engineering Department/Nuclear Engineering Department during Fall 2019.

Project description: create an image recognition machine learning algorithm to identify cracks and inclusions in irradiated samples of 316 stainless steel. The images were collected and supplied by the Nuclear Engineering and Radiological Sciences (NERS) department and the image processing, data scrubbing, and AI algorithm was performed by Noel Eckert while in the Materials Science and Engineering (MSE) department. All work was performed at the University of Michigan.

This repo includes all the source code (written in MatLab) and the images used to training, testing, and validating the CNN algorithm.

File inforamtion:
* RESIZING_IMAGES_V.m: resizes the images and crops out the scale bar (these are SEM images).
* RESIZING_IMAGES_V2_32x32.m: resizes images to 32x32 pixels.
* VALIDATION_64x64.m: CNN algorithm with validation (only handles images with dimensions 64x64).
* VALIDATION_TRACKING_TEST.m: CNN algorithm with output that graphically tracks training and testing accuricies and entropies.
* randomsplittingof225files.m: test code to ensure that images are randomly assigned to training, testing, and validation classes.
