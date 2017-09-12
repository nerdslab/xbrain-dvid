# xbrain (code)

This is the main repository for code to _analyze and quantify neuroanatomy in X-ray microtomography images_. You can find further details about how we apply these methods to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography." arXiv preprint, [arXiv:1604.03629](https://arxiv.org/abs/1604.03629) (2016).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at edyer{at}northwestern{dot}edu.
***

### Getting started... ###

#### Install NeuroData Matlab API (Cajal) ####
In order to run the following example, you must install NeuroData's Matlab API (CAJAL). You can do this by downloading or cloning the [CAJAL](http://www.github.com/neurodata/CAJAL) github repo. If you have your own dataset to test, you can skip this step but note that much of the code assumes that you have CAJAL installed and in your path.

#### Run xbrain on training volume (V1) ####
(Step 1) To begin, make sure you add all necessary directories to your current path in Matlab. To run our cell detection algorithm on raw image data (located in NeuroData), you need the following directories.
~~~matlab
addpath('/xbrain/code/segment-gmm')
addpath('/xbrain/code/celldetect')
addpath('/xbrain/code/utils')
~~~

(Step 2) Next, run the cell detection method on x-ray image data located in NeuroData (imageToken='S1proj4') using the following commands.
~~~matlab
xrange = [1350,1650]; yrange = [1850,2150]; zrange = [395,495]; 
startballsz = 18; dilatesz = 8; kmax = 500; presid = 0.7;
Results = runxbrain_gmm(xrange,yrange,zrange,presid,startballsz,dilatesz,kmax);
~~~
The parameters that we supply in the example above have been optimized over this training volume (V1) using methods in hyperparam module (/xbrain/code/hyperparam).
***

### What's here... ###
* __analysis__: matlab scripts for retrieving results from OCP.
* __celldetect__: matlab code for cell detection.
* __cellsize__: matlab code for estimating the size of detected cells.
* __hyperparam__: matlab code for running hyper-parameter sweeps to optimize celldetect and vessel-segment modules.
* __masking__: matlab code for semi-supervised masking of data volumes.
* __metrics__: matlab code for computing centroid-based and pixel-wise precision and recall.
* __segment-gmm__: matlab code for segmenting foreground (cells and vessels) from the background using a gaussian mixture model.
* __segment-vessels__: matlab code for computing vessel segmentation (from ilastik output).
* __scripts__: matlab scripts for running different segmentation and analysis modules.
* __spatialstats__: code to compute density and other spatial statistics.
* __utils__: extra helper functions needed in multiple modules.
* __visualize__: matlab and python code to visualize data + pull down a obj representation of annotations (for 3D visualization with Blender).
