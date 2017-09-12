### To run xbrain-python:
W. Gray Roncal - 05.16.2016

To run the xbrain processing string, we currently have three steps:  uploading, ilastik,  cell finder/upload.  As we continue to mature the code, this will further simplify.

First install ndparse and dependencies here:  `https://github.com/neurodata/ndparse`
We assume that datasets, projects, and tokens have already been created.  Channels can be created with ndio.  To do this, please follow the instructions here:  `http://docs.neurodata.io/ndstore/`

This is still an alpha version of the python string and so feedback is especially welcome.


#### Format and upload data

Please see the iPython notebook here:  `code/xbrain-python/xbrain_dyer16_data.ipynb`.  We normalize all of the data as a single block.


#### Run ilastik

~~~
# TODO:  Because of a current limitation with ilastik, we run this in a local python terminal and save results as numpy arrays, later reloading into an ipython notebook

from time import time
t = time()
import ndparse as ndp
import numpy as np
import ndio.remote.neurodata as neurodata

nd = neurodata()
pad = 20
input_data = nd.get_cutout('dyer16','image',20-pad,992+pad,20-pad,708+pad,20-pad,280+pad,resolution=0)
classifier = '/graywr1/xbrain_vessel_seg_v5.ilp'
classifier = '/Users/graywr1/dyer16_ilastik_v1.ilp'
probs_retrain = ndp.algorithms.run_ilastik_pixel(input_data, classifier,threads=4, ram=4000)
# ndp.plot(input_data, probs_retrain[:,:,:,2], slice = 60,alpha=0.5)
# ndp.plot(input_data, probs_retrain[:,:,:,1], slice = 60,alpha=0.5)

cellprobs = ndp.utils.choose_channel_4d_3d(probs_retrain, 2)
vesselprobs = ndp.utils.choose_channel_4d_3d(probs_retrain, 1)

data = {}
data['cellprobs'] = cellprobs
data['vesselprobs'] = vesselprobs
np.savez('ilastik_out', data)
~~~

#### Run cell finder and upload

Please see the iPython notebook here:  `code/xbrain-python/xbrain_dyer16_cellfinder.ipynb`.  We normalize all of the data as a single block.
