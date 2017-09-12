function M = centroids2spheremap(Centroids,cellradius,stacksz,labels)

N = size(Centroids,2);
if nargin<4
    labels = 1:N;
end

% dilate image again with new centroids
M0 = zeros(stacksz);
for i=1:N
    M0(max(Centroids(2,i),1),max(Centroids(1,i),1),max(Centroids(3,i),1)) = labels(i);
end
se=strel3d(cellradius);
M = imdilate(M0,se);

end