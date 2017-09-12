% Hyperparameter search for vessel segmentation 

% load ground truth A0-V0 (cells + vessels)
load('Anno-V0-A0.mat')
Vmap0(:,:,1:15)=[]; 
Vmap0 = imdilate(Vmap0,strel3d(1));
bsz = 20; % size of padding in each dimension       

inPMap = 'final-ilastik-probmap-vessel.mat';
outVMap = 'out-vesselmap';

ptrvec = 0.6:.01:0.99;
dilatevec = 1:6;
minsize = 4000;

F1 = zeros(length(ptrvec),length(dilatevec));
for i=1:length(ptrvec)
    for j=1:length(dilatevec)
        segmentvessels(inPMap,outVMap,ptrvec(i),dilatevec(j),minsize)
        load(outVMap)
        Vmap = cube.data;
        Vmap2 = Vmap(bsz+1:end-bsz,bsz+1:end-bsz,bsz+1:end-bsz); Vmap = Vmap2;
        
        % compute segmentation error
        [TP,FP,FN] = compute_segmentmetrics(Vmap0, Vmap);
        F1(i,j) = f1score(TP,FP,FN,2);
        display(['F1 score = ', num2str(F1(i,j),2)])
    end
    length(ptrvec)-i
end

[~,id] = max(F1(:));
[r1,r2] = ind2sub(size(F1),id);

ptr_opt = ptrvec(r1);
dilate_opt = dilatevec(r2);

display(['Selected threshold: ' num2str(ptr_opt,2)])
display(['Selected dilate size: ' num2str(dilate_opt,2)])

segmentvessels(inPMap,outVMap,ptrvec(r1),dilatevec(r2),minsize)
load(outVMap); Vmap = cube.data;
Vmap2 = Vmap(bsz+1:end-bsz,bsz+1:end-bsz,bsz+1:end-bsz); 
Vmap = Vmap2;

save(outVMap,'F1','cube','Vmap0')

%%%%% for final segmentation results 

% Selected threshold: 0.68
% Selected dilate size: 3
% max(F1) = 0.7907

