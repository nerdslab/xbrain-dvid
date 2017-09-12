%%%%%%%%%%%%
% Script to run the gmm-segmentation + cell finder on x-ray data (neurodata)
% Example usage:
% xrange = [1350,1650]; yrange = [1850,2150]; zrange = [395,495]; 
% startballsz = 18; dilatesz = 8; kmax = 500; presid = 0.47;
% Results = runxbrain_gmm(xrange,yrange,zrange,presid,startballsz,dilatesz,kmax);
%%%%%%%%%%%%
%%%
% Input
%%%
% xrange = [xstart, xstop] of cutout in x-ray volume (imageToken = S1_proj4)
% yrange = [ystart, ystop] of cutout in x-ray volume (imageToken = S1_proj4)
% zrange = [zstart, zstop] of cutout in x-ray volume (imageToken = S1_proj4)
% presid = fraction of energy that must match sphere (scalar from 0 to 1)
% dilatesz = dilate mask around each detected cell (to remove in each step of greedy search)
% kmax = maximum number of cells in cube (alternative stopping criterion to using presid)
%%%
% Output
%%%
% Results = struct with results for all steps of processing + final outputs
%   Results.Centroids = D x 4 matrix with x,y,z position and sphere-correlation val
%              for all D detected cells
%   Results.Paint = Nr x Nc x Nz volume with all detected cell bodies
%   labeled from (1,...,D), where image volume is the same size 
%   [Nc = xstop-xstart, Nr = ystop-ystart, Nz = zstop-zstart]
%%%%%%%%%%%%

function Results = runxbrain_gmm(xrange,yrange,zrange,presid,startballsz,dilatesz,kmax,displayopt)
% startballsz = size of spherical template
% presid = 
% dilatesz = dilate mask around each detected cell
% kmax = maximum number of cells in volume

% Example location of training volume (V1)
% xrange = [1350,1650]; yrange = [1850,2150]; zrange = [395,495];

if nargin<8
    displayopt=1;
end

if nargin<7
    displayopt=1;
    kmax = 1000;
end

if nargin<6
    dilatesz = 8;
    displayopt=1;
    kmax = 1000;
end

if nargin<5
    startballsz = 18;
    dilatesz = 8;
    displayopt=1;
    kmax = 1000;
end

if nargin<4
    presid = 0.7;
    startballsz = 18;
    dilatesz = 8;
    displayopt=1;
    kmax = 1000;
end

% Set default parameters
opts = setopts_findcellcentroid([]);
numcomp = opts.numcomp;
numselect = opts.numselect;

%% download cutout
cajal3d

cube = read_api('http://www.openconnecto.me','S1_proj4',0,xrange,yrange,zrange);
Results.IM0 = cube.data;
save CubeCutout-test cube
clear IM0

%% run gmm module
inData = 'CubeCutout-test';
probData = 'testprobdata'; 

gmmposterior(inData,probData,numcomp,numselect);

IM = cube.data;
Results.IM = IM;

load('testprobdata'); 
Results.Prob = cube.data;
clear cube

%% run cell detection module
centroidFile = 'outputcentroids'; 
paintFile = 'outputpaint';
OMP_ProbMap_deploy(probData,presid,startballsz,dilatesz, kmax, paintFile, centroidFile)

load('outputcentroids')
Results.Centroids = Centroids;
clear Centroids

load('outputpaint')
Results.Paint = cube.data;
clear cube

if displayopt==1
    figure; 
    for i=1:size(Results.IM,3)
        imagesc(im2double(Results.IM(:,:,i))-(Results.Paint(:,:,i)~=0)*0.8), 
        title(['Click any button to proceed to next image. (Slice # ', int2str(zrange(1)+i-1),')'])
        pause, 
    end
end


end



