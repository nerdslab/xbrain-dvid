function C = cropcentroids(Centroids,xstart,xstop,ystart,ystop,zstart,zstop)

id1 = find((Centroids(1,:)>=xstart).*(Centroids(1,:)<=xstop));
id2 = find((Centroids(2,:)>=ystart).*(Centroids(2,:)<=ystop));
id3 = find((Centroids(3,:)>=zstart).*(Centroids(3,:)<=zstop));

whichid = intersect(id3,intersect(id1,id2));
C = Centroids(:,whichid);

end
