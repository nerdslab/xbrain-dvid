function [Results,PixList,Centroids] = computedensitystats(X,Vmap,maxdist)
% isores = each voxel equals 0.65 microns (distance in microns)
% kvals = compute distance to kNN for these values of k 
% && same k for degree distribution 
isores = .65; 
kvals = 1:20; 

% compute distance to NNs (as function of k)
CC = bwconncomp(X~=0,6);
PixList = cell(CC.NumObjects,1);
for i=1:CC.NumObjects
    PixList{i} = (CC.PixelIdxList{i});
end

stacksz = size(X);
[distknn,Centroids] = distance2nn(PixList,stacksz,kvals);

Num = size(Centroids,2);
distdegree = zeros(length(kvals),length(maxdist));
for i=1:length(maxdist)
    [distdegree(:,i)] = degreedist(Centroids,kvals,maxdist(i))';
end

% compute distance from each centroid to nearest vessel 
idd = find(Vmap);
[Vloc(1,:),Vloc(2,:),Vloc(3,:)] = ind2sub(stacksz,idd);

dist2vessel = zeros(Num,1);
for i=1:Num
    dist2vessel(i) = min(sqrt(sum((repmat(Centroids(:,i),1,size(Vloc,2)) - Vloc).^2)))*isores;
end

% determine which cells are on border
notborder = zeros(Num,1);
idx = whichborder(stacksz);
for i=1:Num
    if length(setdiff(PixList{i},idx))==length(PixList{i})
        notborder(i) = 1;
    end
end

% calc area of connected components
cellarea = zeros(Num,1);
cradius = zeros(Num,1);
for i=1:Num
    cellarea(i) = length(PixList{i})*isores;
    cradius(i) = (cellarea(i)*(3/(2*pi))).^(1/3);
end

notborder = find(notborder);

Results.dist2vessel = dist2vessel;
Results.distknn = distknn';
Results.distdegree = distdegree;
Results.PixList = PixList;
Results.notborder = notborder;
Results.cellarea = cellarea;

end