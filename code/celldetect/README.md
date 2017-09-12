# xbrain (code/celldetect)

This repository contains methods for _detecting cells in X-ray microtomography images_. You can find further details about how we apply the methods in this repo to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography." arXiv preprint, [arXiv:1604.03629](https://arxiv.org/abs/1604.03629) (2016).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at edyer{at}northwestern{dot}edu.
***

### Celldetect Module ###
The main aim of this module is to infer the position (and eventually size) of all cells in a 3D volume of image data. We assume that we already have computed a "probability map" which encodes the probability that each voxel corresponds to a cell body. 

Before starting, you must first include the following folders in your path in Matlab:  
* /xbrain/code/utils
* /xbrain/code/celldetect

### Example - run cell finding algorithm
To begin, run the script ___script_cellfinder.m___. This script will run the main cell finding routine ___OMP_ProbMap.m___ on the test data in the celldetect folder. The output includes two variables: (1) _Centroids_, a 10x4 matrix with the position (x,y,z) first 10 detected cells centroids (columns 1-3) and the correlation value between all detected cells and theinput probability map (column 4). (2) _Nmap_, a 200x200x100 matrix with all of the detected cells labeled with a unique ID (and the remaining volume labeled w/ zeros).

To find more cells in the volume, set kmax to a larger number. The variable _kmax_ controls the maximum number of iterations of the algorithms (and constrains the maximum number of detected cells). 

To find the top 100 cells, call the greedy sphere finder method again (this will take a few minutes).
```matlab
kmax = 100; 
[Centroids,Nmap] = OMP_ProbMap(Prob,ptr,presid,startsz,dilatesz,kmax);
```

### Visualize 
__(1) Visualize the detected cells overlaid on probabilities__
  ```matlab
figure; 
for i=1:size(Prob,3) 
    imagesc(Prob(:,:,i)-(Nmap(:,:,i)~=0)), 
    pause, 
end
  ```
  
##### What's included in the celldetect module #####
* __OMP_ProbMap.m__: This is the main function used for cell detection, as it implements our greedy sphere finding approach described in [Dyer et al. 2016](https://arxiv.org/abs/1604.03629). This algorithm takes a 3D probability map (the same size as the image data) as its input and returns the centroids and confidence value (between 0-1) of all detected cell bodies.
* __cellfinder_nd.m__: This is the function we use to implement our greedy sphere finder algorithm for datasets in NeuroData and push the resulting annotations back to the NeuroData server.
* __compute3dvec.m__: This function places an input 3D template (vec) at a fixed position (which_loc) in a bounding box of width = Lbox*2 + 1. 
* __convn_fft.m__: This computes a n-dimensional convolution in the Fourier domain (uses fft rather than spatial convolution to reduce complexity).
* __create_synth_dict.m__: This function creates a collection of spherical templates of different sizes. The output is a dictionary of template vectors, of size (Lbox^3 x length(radii)), where Lbox = box_radius*2 +1 and radii is an input to the function which contains a vector of different sphere sizes.
***
