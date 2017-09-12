function combine_orthogonal_probs(inVol1, dimOrder1, inVol2, dimOrder2, inVol3, dimOrder3, probChannel, threshold, xpad, ypad, zpad, cubeVol, outVol, outProb)
% This function needs to be generalized, but will work for now
% input ilastik volumes
% output a single mat volume ready for downstream processing

%For now, assumes only one dataset and that all files are packaged the same
h = h5info(inVol1);
 
data = h5read(inVol1, ['/', h.Datasets.Name]);
im1 = squeeze(data(probChannel,:,:,:,:,:));
dimOrder1 = str2num(dimOrder1);
idx1 = find(dimOrder1 == 1);
idx2 = find(dimOrder1 == 2);
idx3 = find(dimOrder1 == 3);
im1 = permute(im1, [idx1, idx2, idx3]);

data = h5read(inVol2, ['/', h.Datasets.Name]);
im2 = squeeze(data(probChannel,:,:,:,:,:));
dimOrder2 = str2num(dimOrder2);
idx1 = find(dimOrder2 == 1);
idx2 = find(dimOrder2 == 2);
idx3 = find(dimOrder2 == 3);
im2 = permute(im2, [idx1, idx2, idx3]);

data = h5read(inVol3, ['/', h.Datasets.Name]);
im3 = squeeze(data(probChannel,:,:,:,:,:));
dimOrder3 = str2num(dimOrder3);
idx1 = find(dimOrder3 == 1);
idx2 = find(dimOrder3 == 2);
idx3 = find(dimOrder3 == 3);
im3 = permute(im3, [idx1, idx2, idx3]);

im = max(max(im1,im2),im3);

load(cubeVol)
%cube = RAMONVolume;
cube.setCutout(im(xpad+1:end-xpad,ypad+1:end-ypad,zpad+1:end-zpad));
cube.setXyzOffset([cube.xyzOffset(1)+xpad,cube.xyzOffset(2)+ypad,cube.xyzOffset(3)+zpad])
save(outProb,'cube')

im = im > threshold;

cube.setCutout(im(xpad+1:end-xpad,ypad+1:end-ypad,zpad+1:end-zpad));
save(outVol,'cube')

