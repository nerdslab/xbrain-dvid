## Information about the test cubes

Each cube is 200 images of 200x200 pixels.

Every image is 40KB and the stack is 8MB.

Each cube also come in a .nrrd, .tif, and .npy file format.

The idea of the three difference crops was to get the 
top left corner of the slices, the centers of the slices,
and the bottom right hand corner for 
variability of the data.

The individual .tif files have the naming conventions:

`test_cubeX_0YYY.tif`

where X if the cube number and Y is the sequence number.


------------------------------------------------------------

test_cube1
- Image sequence from origional data: 1500-1699
- Started crop at pixel: (130, 376)
- Upper left corner


test_cube2
- Image sequence from origional data: 3000-3199
- Started crop at pixel: (180, 726)
- Center of image stack



test_cube3
- Image sequence from origional data: 5000-5199
- Started crop at pixel: (276, 1078)
- Bottom right corner
