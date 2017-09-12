% generate figure - show need for sphere finding alg!

load('reconmap_gt.mat');
IM = cube.data;
coord_im = cube.xyzOffset;
coord_pmap = cube.xyzOffset;

slicenum=30;
im = IM(:,:,slicenum);
im = im2double(im);

%%%% image data - before and after thresholding
figure;
subplot(3,3,1);
imagesc(-im);
axis square, axis off
title('Reconstructed image slice')

subplot(3,3,2);
bg = (im>= mean(im(:)));
id = find(bg);
im2 = im; im2(id) = mean(im(:));
imagesc(-im2);
axis square, axis off
title('Mean thresholded slice')

load('Anno-V1-A1.mat')
subplot(3,3,3);
imagesc(Nmap0(:,:,slicenum) + Vmap0(:,:,slicenum)*2);
axis square, axis off
title('Ground truth labels')


%%%% cells - before and after thresholding
load('ilastik_cellprob_V1.mat')
subplot(3,3,4);
imagesc(ProbN(21:end-20,21:end-20,5+slicenum))
axis square, axis off
title('Cell probability map');

subplot(3,3,5);
imagesc(ProbN(21:end-20,21:end-20,5+slicenum).*(ProbN(21:end-20,21:end-20,5+slicenum)>mean(mean(ProbN(:,:,slicenum)))))
axis square, axis off
title('Thresholded probability map');

subplot(3,3,6);
imagesc(ReconMap(:,:,slicenum)*3)
axis square, axis off
title('Output of cell finder');


%%%% vessels - before and after thresholding
load('ilastik_vesselprob_V1.mat')
subplot(3,3,7);
imagesc(ProbV(21:end-20,21:end-20,5+slicenum))
axis square, axis off
title('Vessel probability map');

subplot(3,3,8);
imagesc(ProbV(21:end-20,21:end-20,5+slicenum).*(ProbV(21:end-20,21:end-20,5+slicenum)>mean(mean(ProbV(:,:,slicenum)))))
axis square, axis off
title('Thresholded probability map');

subplot(3,3,9);
load('testdata-vesselseg-V1.mat')
imagesc(Vmap(21:end-20,21:end-20,5+slicenum))
axis square, axis off
title('Output of vessel segmentation');

