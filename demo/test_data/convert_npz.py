"""
convert_npz.py
"""

import numpy as np 
import scipy.io as sio
import h5py
from PIL import Image
from skimage import io

file = "test_cube3/test_cube3_full.tif"

#file = sio.loadmat("V3_imgdata_gt.tif")
im = io.imread(file)
print im.shape
imarray = np.array(im)
np.save("test_cube3/test_cube3_full.npy", imarray)

"""
arrays = {}
f = h5py.File('V3_imgdata_gt.mat')
for k, v in f.items():
    arrays[k] = np.array(v)
np.save("V3_imgdata_gt.npy", arrays)
"""

"""
keys = file.keys()
#manifest = open('manifest', 'a')
for i in keys:
	np.save(i, file[i])
	#manifest.write(i + '.npy\n')

#manifest.close()
"""
