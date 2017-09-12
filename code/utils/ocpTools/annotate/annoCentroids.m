%[zz, n] = relabel_id(cutout(1).data);
 
% Create empty RAMON Objects - faster than the naive way
function annoCells(Centroids,cellradius)

imageToken = 'dyer15';
serverLocation = 'braingraph1.cs.jhu.edu';
resolution = 0;

oo = OCP();
oo.setServerLocation(serverLocation);
oo.setImageToken(imageToken);
oo.setAnnoToken('cmo7eva');
oo.setDefaultResolution(0);
 
% q = OCPQuery;
% q.setType(eOCPQueryType.annoDense);
% 
% q.setXRange(xrange);
% q.setYRange(yrange);
% q.setZRange(zrange);
% 
% segCuboid = oo.query(q);
 
 
%% Upload Data - assumes OCP class has been setup, above


n = size(Centroids,2);
seg = RAMONSegment();
seg.setAuthor('evadyer');
seg_cell = cell(n,1);

for ii = 1:n
    s = seg.clone();
    seg_cell{ii} = s;
end
 
% Batch write RAMON Objects
oo.setBatchSize(100);

ids = oo.createAnnotation(seg_cell);
labelOut = zeros(size(M)); 
for ii = 1:n
    cellmap = zeros(size(M2));
     cellmap(Centroids(2,ii)-cellradius:Centroids(2,ii)+cellradius,...
         Centroids(2,ii)-cellradius:Centroids(2,ii)+cellradius,...
        Centroids(3,ii)-cellradius:Centroids(3,ii)+cellradius) = scell;
    pixs = find(cellmap);
    labelOut(pixs) = ids(ii);
end

labelOut = cropborder(labelOut,21,20);
 
paint = RAMONVolume();
paint.setCutout(labelOut);
paint.setDataType(eRAMONDataType.anno32);
paint.setResolution(0);
paint.setXyzOffset(cutout(1).xyzOffset);
oo.createAnnotation(paint);
 
