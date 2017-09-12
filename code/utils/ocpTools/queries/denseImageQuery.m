function imCuboid = denseImageQuery(oo,xrange,yrange,zrange,resolution)

% Dense Image Query
q2 = OCPQuery;
q2.setType(eOCPQueryType.imageDense);
q2.setXRange(xrange);
q2.setYRange(yrange);
q2.setZRange(zrange);
q2.setResolution(resolution);
imCuboid = oo.query(q2);

end