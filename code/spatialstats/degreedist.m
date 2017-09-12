%%%%%%%%%% Degree Distribution 
% Compute fraction P(k) of nodes in the network having k cnx to other nodes
%%%%%%%%%%
% Input  =  { Centroids (centroid of each cell), 
%             maxdist in microns (max distance between cells to consider them connected) }
% Output =  {out = degree distribution as a function of k, D = distance matrix }   
function [out,D] = degreedist(Centroids,kvec,maxdist)

isores= 0.65;
D = pdist2(Centroids',Centroids');
N = length(D);

% create binary affinity matrix by considering all cells within maxdist from one
% another to be connected
W = (D*isores).*((D*isores)<maxdist);

% compute degree distribution
dx = sum((tril(W)-eye(N))~=0);
N = length(dx);
out = zeros(length(kvec),1);

for i= 1:length(kvec)
    out(i) = sum(dx>=kvec(i))./N;
end

end
