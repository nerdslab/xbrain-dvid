% Compute the distance between each cell and its K nearest neighbor
%%%%%%%%%%
% Input
% PixList = index list of connected components
% stacksz = size of image cube
% k = number of neighbors
%%%%%%%%%%
function [kdist,Centroids] = distance2nn(PixList,stacksz,k)

isores = .65; % each voxel equals 0.65 microns
N = length(PixList);
Num = length(k);

% compute centroids
Centroids = zeros(3,N);
for i=1:N
    tmp = zeros(stacksz);
    tmp(PixList{i}) = 1;
    CC = bwconncomp(tmp);
    RP = regionprops(CC,'Centroid');
    Centroids([2,1,3],i) = RP.Centroid;
    
end

kdist = zeros(Num,N);
for i=1:N  
    [~, dists] = findknn(Centroids(:,i)',Centroids',k);
    
    for j=1:length(k)
        kdist(j,i) = dists(k(j))*isores;
    end
end

   
end
