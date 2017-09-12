function [idx,CC,X] = removesmallcc(X,minsize)
% idx = returns indices of components that are SMALLER than minsize
% Xout = new labeled 3d map with connected components (like bwlabeln) 

[numvox,CC] = computearea_conncomp(X);
idx = find((numvox<minsize));

for i=1:length(idx)
    X(CC.PixelIdxList{idx(i)})=0;
end

end