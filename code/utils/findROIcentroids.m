function [Cout,ID] = findROIcentroids(Centroids,xyzOffset,dsz,windowsz)

if nargin<4
    windowsz=0;
end

coord = [xyzOffset; xyzOffset + [dsz(2),dsz(1),dsz(3)] ];

xid = find((Centroids(:,1)<=coord(2,1)-windowsz).*(Centroids(:,1)>=coord(1,1)+windowsz));
yid = find((Centroids(:,2)<=coord(2,2)-windowsz).*(Centroids(:,2)>=coord(1,2)+windowsz));
zid = find((Centroids(:,3)<=coord(2,3)-windowsz).*(Centroids(:,3)>=coord(1,3)+windowsz));

ID = intersect(zid,intersect(xid,yid));
Cout = Centroids(ID,1:3);


end