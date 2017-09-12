%% Start here

load('ReconMap-V0-A1.mat')
% Map true centroids to true space
xstart = 1350; ystart = 1850; zstart = 395;
xstop = 1750; ystop = 2150; zstop = 495;
cropsz = 10;
crop2 = 0;
C0 = Centroids_ed0 + repmat([xstart,ystart,zstart]',1,size(Centroids_ed0,2));
C02 = cropcentroids(C0,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+15+cropsz,zstop-cropsz); %TODO

f = dir('centroid*.mat');

f1_max = 0;
thresh = 10;
clear legendLabel
for k = 1:length(f)
    %k
    load(f(k).name)
    
    t = strrep(f(k).name,'_','-');
    legendLabel{k} = strrep(t,'.mat','');
    
    c = 1;
    clear FP TP FN
    
    sweep = 0.4:0.01:1;
    for i = sweep
        idx = find(Centroids(:,4) > i);
        Ct = Centroids(idx,1:3)';
        Ct = cropcentroids(Ct,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+15+cropsz,zstop-cropsz);
        
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
     
[f1, p, r] = f1score(TP,FP,FN);
test_f1 = max(f1);
 
    if test_f1 > f1_max
        f1_max = test_f1; % new best
        f1idx = find(f1 == test_f1);
        opPt.thresh = sweep(f1idx);
        opPt.paramsetting = legendLabel{k};
        opPt.f1 = f1_max;
        idx = find(Centroids(:,4) > opPt.thresh);
        Ct = Centroids(idx,1:3)';
        Ct = cropcentroids(Ct,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+15+cropsz,zstop-cropsz);
 
        [opPt.TPid,opPt.FPid,opPt.FNid] = centroiderror_missrates_pr(C02,Ct,thresh);
        
        TP = length(opPt.TPid);
        FP = length(opPt.FPid);
        FN = length(opPt.FNid);
        
        opPt.precision = TP/(TP+FP);
        opPt.recall = TP/(TP+FN);
        opPt.f1check = (2*opPt.precision*opPt.recall)/(opPt.precision+opPt.recall);
        opPt.Centroid_Detection = Ct';
        opPt.Centroid_Truth = C02';
        opPt.nTruthPts = length(C02);
        opPt
    end
    figure(100), hold on, grid on, plot(r,p,'-s')%plot(FPR, TPR)%
    
    %legend(legendLabel)
    figure(101), hold on, grid on, plot(f1,'-*')%plot(FPR, TPR)%
    drawnow
end

figure(100), legend(legendLabel)
title('Precision Recall Curve')
xlabel('Recall')
ylabel('Precision')
figure(101), legend(legendLabel)
title('F1 Score')
xlabel('threshold')
idx = get(gca,'XTick');
idx(idx == 0) = 1;

idxTick = sweep(idx);
set(gca,'XTick',idx)
set(gca,'XTickLabel',idxTick)
ylabel('score')

%% Vis

D = opPt.Centroid_Detection;
T = opPt.Centroid_Truth;
TPc = D(opPt.TPid,:);
FPc = D(opPt.FPid,:);
FNc = T(opPt.FNid,:);

bounds = [TPc; FPc; FNc];

b = [min(bounds(:,1)), max(bounds(:,1)), min(bounds(:,2)), max(bounds(:,2)), min(bounds(:,3)), max(bounds(:,3))];

TPc = TPc - repmat([b(1),b(3), b(5)]-[5,5,5],[length(TPc),1]);
FPc = FPc - repmat([b(1),b(3), b(5)]-[5,5,5],[length(FPc),1]);
FNc = FNc - repmat([b(1),b(3), b(5)]-[5,5,5],[length(FNc),1]);

TPm = zeros(b(2)-b(1)+10, b(4)-b(3)+10, b(6)-b(5)+10);
FPm = zeros(b(2)-b(1)+10, b(4)-b(3)+10, b(6)-b(5)+10);
FNm = zeros(b(2)-b(1)+10, b(4)-b(3)+10, b(6)-b(5)+10);

for i = 1:length(TPc)
TPm(TPc(i,1), TPc(i,2), TPc(i,3)) = 1;
end

for i = 1:length(FPc)
FPm(FPc(i,1), FPc(i,2), FPc(i,3)) = 1;
end

for i = 1:length(FNc)
FNm(FNc(i,1), FNc(i,2), FNc(i,3)) = 1;
end
TPm = imdilate(TPm, strel('ball',18,18,0))-18>0;
FPm = imdilate(FPm, strel('ball',18,18,0))-18>0;
FNm = imdilate(FNm, strel('ball',18,18,0))-18>0;

%%

figure(102), hold on, visualize3d(TPm,[0,1,0]), 
visualize3d(FPm,[0,0,1])
visualize3d(FNm,[1,0,0])

%% 12-2

load('paint_12_2')
load('Anno-V0-A1.mat')
load('centroid_12_2')
thresh = 0.4:0.025:1;
i = thresh(12); % from analysis

idx = find(Centroids(:,4) > i);

xstart = 1350; ystart = 1850; zstart = 395;
xstop = 1750; ystop = 2150; zstop = 495;
cropsz = 20;
Ct = Centroids(idx,1:3)';
Ct = cropcentroids(Ct,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);

rp = regionprops(cube.data, 'PixelIdxList');

mask = zeros(size(cube.data));
for i = 1:length(idx)
    mask(rp(idx(i)).PixelIdxList) = i;
end
load('~/CubeCutout_1.outputFile-1.mat')
padX = 20; padY = 20; padZ = 20;
cube.setCutout(cube.data(1+padX:end-padX, 1+padY:end-padY, 1+padZ:end-padZ));
M = RAMONVolume; M.setCutout(mask);
h = image(cube); h.associate(M)

%% 
% crop centroids (remove small region around zstart and zstop)
% cropsz = 20;
% %tmp = load(centroidOut);
% %C1 = cropcentroids(tmp.Centroids,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
% %C02 = cropcentroids(C0,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
% %CellMetrics = compute_centroidmetrics(C02,C1,10,[300,300,100],5);
% %load('Anno-V0-A1.mat')
% load('ReconMap-V0-A1.mat')
% 
% % Map true centroids to true space
% xstart = 1350; ystart = 1850; zstart = 395;
% xstop = 1750; ystop = 2150; zstop = 495;
% 
% cropsz = 20;
% 
% C0 = Centroids_ed0 + repmat([xstart,ystart,zstart]',1,size(Centroids_ed0,2));
% 
% 
% sb_size_all = 20;%12; %[12,14,16,18, 20];
% d_size_all = 2;% [2, 4, 6, 8, 10]
% 
% sb_size = 20;
% d_size = 2;
% 
% probFile = '~/applymask_1.outProbcube-TRAINING.mat';
% OMP_ProbMap_deploy(probFile, 0.4, sb_size, d_size, 500, 'temp.mat', 'ctemp.mat')
