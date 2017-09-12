function annoCells(M,oo,xyzOffset)
% M is a volume of labeled pixels 
% (each set of labels with same number correspond to a cell body)
% oo = OCP object (defined by the fields commented above)
% xyzOffset = cutout(1).xyzOffset (from query of image cutout)

n = length(unique(M));

% create RAMON Segment
seg = RAMONSegment();
seg.setAuthor('evadyer');

seg_cell = cell(n,1);
for ii = 1:n
    s = seg.clone();
    %s.addDynamicMetadata('centroid',Centroids(:,ii))
    seg_cell{ii} = s;
end
 
% Batch write RAMON Objects
oo.setBatchSize(100);
ids = oo.createAnnotation(seg_cell);

display('Finished creating annotation IDs!')

labelOut = zeros(size(M)); 
for ii = 1:n
    pixs = find(M==ii);
    labelOut(pixs) = ids(ii);
end

% create paint annotation
paint = RAMONVolume();

if ~isempty(paint)
    paint.setAuthor('evadyer');
    paint.setCutout(labelOut);
    paint.setDataType(eRAMONDataType.anno32);
    paint.setResolution(oo.defaultResolution);
    paint.setXyzOffset(xyzOffset);
    oo.createAnnotation(paint);
end
% create segments (soma) with centroids (KV pair)


end
 
