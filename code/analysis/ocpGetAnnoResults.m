% Simple example of retrieving data on OCP server

oo = OCP;
oo.setImageToken('S1_proj4');
oo.setAnnoToken('S1_proj_test1');

xRange = [610,2010];
yRange = [1,2560];
zRange = [390,2014];
resolution = 2;

xRange = ceil(xRange/2^resolution);
yRange = ceil(yRange/2^resolution);

q = OCPQuery;
q.setType(eOCPQueryType.annoDense);
q.setCutoutArgs(xRange,yRange,zRange,resolution);
q.validate
anno = oo.query(q);

q.setType(eOCPQueryType.imageDense);
im = oo.query(q);
h = image(im); h.associate(anno);

%Type 'M' in the viewer to create a movie
