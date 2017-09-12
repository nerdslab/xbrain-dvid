function R2 = visualizecentroids(Centroids,stacksz,ballsz)

%stacksz = int(stacksz);

if nargin<3
    ballsz = 5;
end

ReconMap = zeros(stacksz);

for i=1:size(Centroids,2)
    ReconMap(Centroids(1,i),Centroids(2,i),Centroids(3,i))= 1;
end

R2 = imdilate(ReconMap,strel3d(ballsz));
figure; visualize3d(R2~=0,'g',0.4)

end