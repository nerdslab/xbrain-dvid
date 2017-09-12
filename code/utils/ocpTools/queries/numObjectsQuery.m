function [Num,CellDensity,whichid] = numObjectsQuery(oo,xrange,yrange,zrange,resolution,nummasked,isores)
% isores = [x_resolution,y_resolution,z_resolution] 

if nargin<7
    isores = 0.00065*ones(3,1);
end

% Query Number of Objects
q1 = OCPQuery;
q1.setType(eOCPQueryType.RAMONIdList);
q1.setXRange(xrange);
q1.setYRange(yrange);
q1.setZRange(zrange);
q1.setResolution(resolution);
whichid = oo.query(q1);
Num = length(whichid);

numvox = prod([length(xrange(1):xrange(2)),...
    length(yrange(1):yrange(2)), length(zrange(1):zrange(2))]);

Vol = (numvox - nummasked)*(prod(isores));

CellDensity = Num/Vol;

end