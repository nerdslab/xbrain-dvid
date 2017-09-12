% V0 coordinates
windowsz=0;

szstats = zeros(3,5);
numdetect = zeros(5,1);
for i=0:3
    coord = getcoord_testvol(i);
    xyzOffset = [coord(1),coord(3),coord(5)];
    cubesz = [coord(2)-coord(1),coord(4)-coord(3),coord(6)-coord(5)];
    [Cout,ID] = findROIcentroids(C0,xyzOffset,cubesz,windowsz);                     
    szstats(:,i+1) = 4*pi*(([mean(cellsz(ID)), median(cellsz(ID)), std(cellsz(ID))]./2).^2);
    numdetect(i+1) = length(ID);
end

szstats(:,5) = 4*pi*(([mean(cellsz), median(cellsz), std(cellsz)]./2).^2);
numdetect(5) = length(Centroids);


