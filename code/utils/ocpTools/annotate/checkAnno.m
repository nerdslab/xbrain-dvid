
% annotation query
segCuboid = denseAnnoQuery(xrange,yrange,zrange,resolution);

% image query
imCuboid = denseImageQuery(xrange,yrange,zrange,resolution);

% Compute Cell Density in Volume (IDs)
[Num,CellDensity] = numObjectsQuery(oo,xrange,yrange,zrange,resolution);

% RAMON Dense Query -- a specific object
% q3 = OCPQuery;
% q3.setType(eOCPQueryType.RAMONDense);
% q3.setResolution(resolution);
% q3.setId(idsAll(30))
% qID = oo.query(q3);

% Overlay Image and Annotation
h = image(imCuboid);
h.associate(segCuboid)

