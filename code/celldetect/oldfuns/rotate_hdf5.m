function rotate_hdf5(inVol, outVol, dataset, dimOrder)

im = h5read(inVol, dataset); %requires leading '/' for dataset

dimOrder = str2num(dimOrder);

im = permute(im,[dimOrder(1), dimOrder(2), dimOrder(3)]);

try
h5create(outVol,dataset,[size(im,1), size(im,2), size(im,3)])
catch
    disp('dataset already exists')
end

h5write(outVol, dataset, im)