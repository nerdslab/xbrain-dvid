%% Start here
f1 = []; p = []; r = []; f2 = [];
% Load probs
load('CellFinderProbs_centroidFile_testcube4.mat')

% Map true centroids to true space
xstart = 1200; ystart = 1650; zstart = 1126;
xstop = 1400; ystop = 1850; zstop = 1326;
cropsz = 10;


% Load truth and crop it
load('Anno-V3-A0A3.mat')
% temp = load_nii('proj4_x1200-1400_y1650-1850_z1126-1326_r0_testvol_v3_anno_eva1_will1_eva2_will2_eva3.nii');
% truth = temp.img;
% 
% 
% bw = bwconncomp(truth);
% rp = regionprops(bw,'Centroid');
% 
% clear centroid_truth
% for i = 1:length(rp)
%     centroid_truth(:,i) =round(rp(i).Centroid);
% end
%C0 = centroid_truth + repmat([xstart,ystart,zstart]',1,size(centroid_truth,2));
C0 = centroid_truth;
C02 = cropcentroids(C0,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz); %TODO


f1_max = 0;
thresh = 10;

% load centroid file

c = 1;
clear FP TP FN

sweep = 0.47

for i = sweep
    idx = find(Centroids(:,4) > i);
    Ct = Centroids(idx,1:3)';
    Ct = cropcentroids(Ct,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
    
    try
        [TPid,FPid,FNid] = centroiderror_missrates_pr(C02,Ct,thresh);
        
        FP(c) = length(FPid);
        TP(c) = length(TPid);
        FN(c) = length(FNid);
        c = c +1;
        
    catch
        %  disp('skipping this iteration')
    end
end

[f1(end+1), p(end+1), r(end+1)] = f1score(TP,FP,FN);
[f2(end+1), ~, ~] = f1score(TP,FP,FN,2);

f1
p
r
f2