function [segErrNMap, segErrTMap, CellMetrics ] = compute_errmetrics(nmapData,vmapData,centroidOut,Nmap0,Vmap0,C0,cropsz,pad,xstart,xstop,ystart,ystop,zstart,zstop)

knn = 5;
septhresh = 10;
stacksz = size(Nmap0);

% segmentation error for NMap
tmp = load(nmapData);
Nmap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
segErrNMap = compute_segmentmetrics(Nmap0, Nmap);

% segmentation error fo r Total Map (Vmap + Nmap)
tmp = load(vmapData);
Vmap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
Tmap = zeros(size(Vmap));
tmpid = find(Vmap); Tmap(tmpid)=1; 
tmpid = find(Nmap); Tmap(tmpid)=1;

Tmap0 = zeros(size(Vmap0));
Tmap0(find(Vmap0))=1; Tmap0(find(Nmap0))=1;
segErrTMap = compute_segmentmetrics(Tmap0, Tmap);

% crop centroids (remove small region around zstart and zstop)

tmp = load(centroidOut);
C1 = cropcentroids(tmp.Centroids,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
C02 = cropcentroids(C0,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
CellMetrics = compute_centroidmetrics(C02,C1,septhresh,stacksz,knn); 

end
