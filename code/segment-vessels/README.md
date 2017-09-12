# segment-vessels

This repo contains code to _segment blood vessels in X-ray microtomography images_. You can find further details about how we apply these methods to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography." arXiv preprint, [arXiv:1604.03629](https://arxiv.org/abs/1604.03629) (2016).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at edyer{at}northwestern{dot}edu.
***

### To get started... ###
(1) While in the __/xbrain/code/segment-vessels__ folder, run the following script:
```matlab
script_segmentvessels
```
(2) To visualize the output in 3D: 
```matlab
figure; visualize3d(Vmap,'g',0.4)
```

### What's here... ###
* __script_segmentvessels.m__: matlab script which uses the test ilastik probability channel (from volume V1) and produces a segmentation of the vessels (using the function __segmentvessels_mat.m__).
* __segmentvessels_mat.m__: matlab function which takes a probability map (from ilastik or another classifier) as its input and produces a binary image as its output with segmented vessels.
* __data__: folder with test input (ilastik) and its output when you use the parameters, ptr = 0.98, dilatesz = 8, and minsize = 1000 (as specified in the script).
* __data/ilastik_vesselprob_V1.mat__: matfile with 340x340x125 vessel probability map (output of ilastik).
* __data/testout.mat__: test output mat file of size 340x340x125 (binary map with vessels labeled as 1's and 0's otherwise).


