% script to compile results over manually labeled cube
% make sure /private/tmp is in path
XRange = [1350,1650];
YRange = [1850,2150];
ZRange = [395,495];
filenm = 'test_jul_14_2';

%%
% compute threshmap
threshmap_fullcube('S1_proj4',XRange,YRange,ZRange,[],filenm);

load([filenm, '_x_',int2str(XRange(1)),'-',int2str(XRange(2)),'_y_', ...
                    int2str(YRange(1)),'-',int2str(YRange(2)),'_z_', ...
                    int2str(ZRange(1)),'-',int2str(ZRange(2))]);
%%
% find cell centroids using greedy synthesis
Results = findcellcentroids(Map,IM,[],filenm);
ReconMap = Results{1,1}.ReconMap;
Centroids = Results{1,1}.Centroids;

%%
% compute sphere map for manual segmentation
[Nmap,Vmap] = cleanuplabels([]); % eva7.nii
[Recon0,Centroids0,ReconMap0] = greedycelldetection(Nmap,IM,[]);

%%
% compute centroid errors
[dvec,TPR,FPR,MR] = centroiderror_missrates(Centroids0,Centroids,10);

%%
% density estimation
[prob0,pts0] = knndensityest(ReconMap0,[300,300,100],'full',5);
[probx,ptsx] = knndensityest(ReconMap,[300,300,100],'full',5);

distpq =KLDiv(probx(:),prob0(:)); % measure difference between densities

DensityStats.distpq = distpq;
DensityStats.MR = MR;
DensityStats.TPR = TPR;
DensityStats.FPR = FPR;
DensityStats.CentroidErr = [min(dvec), mean(dvec), max(dvec)];



% figure; 
% for i=1:100; 
%     subplot(1,2,1); imagesc(prob0(:,:,i) + ...
%         padarray((ReconMap0(:,:,i)~=0)*1e-7,[1,1])); axis square; 
%     subplot(1,2,2); imagesc(probx(:,:,i)+ ...
%         padarray((ReconMap(:,:,i)~=0)*1e-7,[1,1])); axis square; 
%     pause, 
% end

