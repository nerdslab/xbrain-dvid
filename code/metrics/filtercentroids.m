% filter centroids (remove cells on boundary)
function removeid = filtercentroids(Centroids, bsz, xrange, yrange, zrange)


if nargin==2
    xmin = 1350; xmax = 1650;
    ymin = 1850; ymax = 2150;
    zmin = 395; zmax = 495;
else
    xmin = xrange(1);
    xmax = xrange(2);
    ymin = yrange(1);
    ymax = yrange(2);
    zmin = zrange(1);
    zmax = zrange(2);
end

idx = [find(Centroids(:,1)<(xmin+bsz)); find(Centroids(:,1)>(xmax-bsz))];
idy = [find(Centroids(:,2)<(ymin+bsz)); find(Centroids(:,2)>(ymax-bsz))];
idz = [find(Centroids(:,3)<(zmin+bsz)); find(Centroids(:,3)>(zmax-bsz))];

removeid = unique([idx; idy; idz]);

end



