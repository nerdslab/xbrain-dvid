# Downloading Image Data and Annotated Volumes #

This repo contains manually annotated (training and test) volumes of X-ray microtomography data. Currently, we have these volumes saved in matfiles, however we plan to include other formats in a future release. Further details about the data collection and methods use to annotate these volumes can be found in our [manuscript](http://arxiv.org/pdf/1604.03629).

If you use any of the data products contained in this repository, please cite the following manuscript:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography." [arXiv:1604.03629](http://arxiv.org/pdf/1604.03629) (2016).__

If you have any questions, please contact Eva Dyer at edyer{at}northwestern{dot}edu. 

***
## What's available ##

* __xbrain/data/groundtruth__
  - To access any of our ground truth datasets, you need to first download this [file](https://dl.dropboxusercontent.com/u/1260288/Data/Xbrain-GroundTruth-Data/validation.zip). Due to its size, it is not contained in this repo.
  - This folder contains Matlab arrays (MAT) with X-ray image data and/or manual annotations, as well as .nii files (ITK Snap) which contain the raw annotations of different volumes.
  - To start, go to the groundtruth folder (/xbrain/data/groundtruth) and check out V1.
  - V0, V1, V2, V3 are all different (non-overlapping) subvolumes we labeled within an unsectioned cubic mm volume of mouse cortex. 
  - V1 is the largest annotated volume (300 x 300 x 100) and currently the only volume that we have full (dense) reconstructions of cells and vessels. V0 is a smaller cube in the middle of V1 for which we have two annotations from different annotators (A1 and A2).
  - V2 can be used as a small test set for cell detection algorithms (full cell bodies, some vessels).
  - V3 was the final held out test set that we used to evaluate xbrain (only cell centroids, not full cell bodies).
  - To download the annotations from all training volumes, go to CombinedMats folder and download 'AllGroundTruthVolumes.mat'
* __xbrain/data/getdata__
  - Python notebooks for data downloads using ndio (github.com/neurodata/ndio).
* __xbrain/data/validation__
  - To access any of our validation datasets, you need to first download this [file](https://dl.dropboxusercontent.com/u/1260288/Data/Xbrain-GroundTruth-Data/validation.zip). Due to its size, it is not contained in this repo.
  - Test arrays for validating matlab routines. This folder contains mat files, ilp files (ilastik classifier format after training), and outputs of our algorithms on test datasets.
 
***
## Examples

### Python Example - Download image data, annotations, and/or cell/vessel probability maps
__(0) Install neurodata's API, [ndio](http://www.github.com/neurodata/ndio).__
```
pip install ndio
```
__(1) Download and run this [ipython notebook](http://github.com/neurodata/xbrain/blob/master/code/xbrain-python/xbrain_getdata.ipynb)__ to fetch the:
* final results of our vessel segmentation and cell detection methods running at scale (cellseg, vesselseg)
* probability maps produced from our trained ilastik classifier (cellprob, vesselprob)

### Matlab Example - Training and test data to evaluate cell detection algorithms
__(0) Download the ground truth data__
* Download the ground truth data [here](https://dl.dropboxusercontent.com/u/1260288/Data/Xbrain-GroundTruth-Data/groundtruth.zip).
* Upack the zip file and add it to your Matlab path 

__(1) Load the raw image data and location of all cells in the ground truth volume V1__
```matlab
load('/data/groundtruth/V1/traindata-celldetect-V1')
```
This mat file contains the following: 
* IM contains the raw data from the image volume V1 (300x300x100 pixels)
* Centroids_gt is a 3x321 matrix containing the (x,y,z) centroid of all __manually labeled__ cell bodies in V1 (in global coordinates). This list of centroids was manually curated to ensure accuracy. 
* Centroids_xb is a 3x302 matrix containing the (x,y,z) centroid of all __detected__ cell bodies in V1 (in global coordinates) using xbrain's cell detection method.

__(2) Load the test set (raw data + ground truth centroids) (V3)__
```matlab
load('/data/groundtruth/V3/traindata-celldetect-V3.mat')
```
This mat file contains the following:
* IM3 contains the raw data from the image volume V2 (200x200x200 pixels). 
* Centroids_gt3 is a 3x291 matrix containing the (x,y,z) centroid of all __manually labeled__ cell bodies in V1 (in global coordinates). This set of labels has not been manually curated to ensure accuracy. We simply load the annotated nii files for this volume (located in /data/groundtruth/V3) and simply find connected components in the annotated volume.

### Matlab Example - Download image data using CAJAL (Matlab API)
  - [Install CAJAL](http://github.com/neurodata/CAJAL) (NeuroData's Matlab API)
  - Download and save this [m file](https://github.com/neurodata/xbrain/blob/master/data/getdata/MatlabAPI/ocpGetData.m)
  - To download all of the (4x) downsampled image data into Matlab, use this command: `Img = ocpGetData();`
