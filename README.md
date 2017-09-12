# xbrain 

This repository contains methods for _analyzing and quantifying neuroanatomy in X-ray microtomography images_. You can find further details about how we apply the methods in this repo to analyze mm-scale brain volumes in the following paper:

__Dyer, Eva L., et al. "Quantifying mesoscale neuroanatomy using X-ray microtomography." arXiv preprint, [arXiv:1604.03629](https://arxiv.org/abs/1604.03629) (2016).__

If you use any of the code or datasets in this repo, please cite this paper. 
Please direct any questions to Eva Dyer at edyer{at}northwestern{dot}edu.
***

### What's here... ###

* __Code__: MATLAB and Python code for running various segmentation and analysis routines.
* __Data__: Training and test volumes used to optimize and evaluate our methods.
* __Library__: Ilastik classifier files + LONI Pipeline files used to execute our distributed workflow on full data volumes (~100 GB of raw data).
* __Results__: Some results from running xbrain on large datasets.
