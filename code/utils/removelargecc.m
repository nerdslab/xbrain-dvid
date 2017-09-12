function [idx,CC,X] = removelargecc(X,maxsize)
% idx = returns indices of components that are LARGER than minsize
% Xout = new labeled 3d map with connected components (like bwlabeln) 

[numvox,CC] = computearea_conncomp(X);
idx = find((numvox>maxsize));

for i=1:length(idx)
    X(CC.PixelIdxList{idx(i)})=0;
end

end