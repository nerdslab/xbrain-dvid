% Simple example of retrieving data on OCP server
function vMap = ocpGetVessels(xRange,yRange,zRange,resolution)

oo = OCP;
oo.setImageToken('S1_proj4');
oo.setAnnoToken('xbrain_rfr1');

if nargin<1
    % coordinates for entire working volume
    xRange = [610,2010]; 
    yRange = [1,2000];
    zRange = [390,2014];
    resolution = 2; % subsample the data in (x,y) by a factor of 4
end   

%oo.setAnnoToken('S1_proj_test1');
oo.setAnnoChannel('vessel_seg');

xRange = ceil(xRange/2^resolution);
yRange = ceil(yRange/2^resolution);

q = OCPQuery;
q.setType(eOCPQueryType.annoDense);
q.setCutoutArgs(xRange,yRange,zRange,resolution);
q.validate
anno = oo.query(q);

vMap = anno.data;

end

% q.setType(eOCPQueryType.imageDense);
% im = oo.query(q);
% h = image(im); h.associate(anno);
% 
% %Type 'M' in the viewer to create a movie


