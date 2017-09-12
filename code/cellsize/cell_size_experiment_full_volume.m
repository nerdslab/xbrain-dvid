% Cell size experiment
% W. Gray Roncal and Eva Dyer
% xbrain forever

cajal3d
% params

%bsz = 13:2:31; 
bsz = 13:1:31; 
ptr = 0.3;
N = max(bsz)+2;
padsz = (N-1)/2 + 1;
L = length(bsz);
filtsz = 0;

xstart = 610;
ystart = 1; 
zstart = 390;
resolution = 0;

pData = h5read('~/repos/xbrain/results/cell_prob_rfr1_full.hdf5');
load('centroids_rfr1.mat') % download centroids for entire cube 
pData = permute(pData,[3,2,1]);

%% estimate cell sizes
xyz = [xstart, ystart, zstart];
C0 = findROIcentroids(Centroids,xyz,[size(pData,2),size(pData,1),size(pData,3)],padsz); % find centroids in same coordinates as current cube 

C1 = C0 - repmat(xyz,size(C0,1),1);
Nc = size(C1,1);

C1 = [C1(:,2),C1(:,1),C1(:,3)];


%% estimate cell sizes
tic, [outPaint,cellsz] = estimate_cellsize(pData,C1,bsz,ptr); toc

paint = sum(outPaint,4);

%% visualize 
% figure(1),
% colorz = 'rgb';
% for i=1:3
%     visualize3d(outPaint(:,:,:,i),colorz(i),'0.5'), hold on
% end

% figure(2),
% for i=1:size(paint,3) 
%     imagesc(-(paint(:,:,i)~=0)*100 + double(IM(:,:,i))), 
%     pause, 
% end

