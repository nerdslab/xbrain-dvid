function segCuboid = denseAnnoQuery(oo,xrange,yrange,zrange,resolution)

% Dense Annotation Query
q1 = OCPQuery;
q1.setType(eOCPQueryType.annoDense);
q1.setXRange(xrange);
q1.setYRange(yrange);
q1.setZRange(zrange);
q1.setResolution(resolution);
segCuboid = oo.query(q1);

end