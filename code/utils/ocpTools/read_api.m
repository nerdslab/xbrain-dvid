function [ cutout ] = read_api(serverLocation, imageToken, resolution, xrange, yrange, zrange)
%READ_API Query OpenConnectome API on Grayscale channel
%
% Helper function to query from the OpenConnectome API for the CLARITY
% project. NOTE: Will specifically request from the grayscale channel!
% remove that line if unnecessary for other uses.
%
% serverLocation: string indicating location of server
% imageToken: string indicating image token
% resolution: resolution of cutout
% xrange: 1x2 array of the cutout range in x dimension
% yrange: 1x2 array of the cutout range in y dimension
% yrange: 1x2 array of the cutout range in z dimension
%
% read_api(serverLocation, imageToken, resolution)
% read_api(serverLocation, imageToken, resolution, zrange)
% read_api(serverLocation, imageToken, resolution, xrange, yrange, zrange)

% validate inputs
narginchk(3,6);

% initialize API objects
ocp = OCP();
q = OCPQuery;
q.setType(eOCPQueryType.imageDense);

% set server location and token
ocp.setServerLocation(serverLocation);
ocp.setImageToken(imageToken);

% if ranges not specified, use default
if nargin==3
    ranges = ocp.imageInfo.DATASET.IMAGE_SIZE(resolution);
    xrange = [0, ranges(1)];
    yrange = [0, ranges(2)];
    zrange = ocp.imageInfo.DATASET.SLICERANGE;
elseif nargin==4 %option exists to request a single full image. 
    zrange = xrange; %@Chris, what's the proper way to do this? Thanks!
    ranges = ocp.imageInfo.DATASET.IMAGE_SIZE(resolution);
    xrange = [0, ranges(1)];
    yrange = [0, ranges(2)];
elseif nargin==6
else
    error('Invalid number of input arguments (must be either 3, 4 or 6)!');
end

% specify the image cube to download
q.setXRange(xrange);
q.setYRange(yrange);
q.setZRange(zrange);

% specify resolution
q.setResolution(resolution);
 
% specify channel (grayscale)
chan = {'Grayscale'};
q.setChannels(chan);

% query API if validation is passed
[ pf, msg ] = q.validate();
if  pf
    cutout = ocp.query(q);
else
    disp(msg);
    error('API validation failed');
end

end
