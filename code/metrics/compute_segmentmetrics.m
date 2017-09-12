function [TP,FP,FN] = compute_segmentmetrics(Map0, Map1)
% Err = [1-true pos, 1 - true neg] = [False pos, Miss rate]
%Rmap0 = ground truth
%Rmap1 = recovered segmentation

M = Map0-Map1;
FP = sum(M(:)==-1);
TP = sum(Map1(:)~=0) - FP;
FN = sum(M(:)==1);

end