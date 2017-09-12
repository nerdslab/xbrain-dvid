% example volumes

% manually labeled cutout (V0)
% xrange = [1350,1650];
% yrange = [1850,2150];
% zrange = [395,495];

% dataset dimensions
% xrange = [610,2010];
% yrange = [1,2560];
% zrange = [390,2014];


%% set params

%(expose parameters here for loni modules -- otherwise all info contained
% in opts struct)
opts = setopts_findcellcentroid([]);
numfreq = opts.numfreq;
minunmasked = opts.minunmasked;
maskdilatesz = opts.maskdilatesz;
numcomp = opts.numcomp;
pthresh = opts.pthresh;
vesseldilatesz = opts.vesseldilatesz;
ballsz = opts.ballsz;
dilatesz = opts.dilatesz;
presid = opts.presid;
kmax = opts.kmax;
numselect = opts.numselect;
minsize = opts.minsize;
padX = opts.padX;
padY = opts.padY;
padZ = opts.padZ;
maxsize = opts.maxsize;

%% download cutout
cajal3d

xrange = [1300,1700];
yrange = [1800,2200];
zrange = [390,550];

% bad cube
%xrange = [1150,1550];
%yrange = [1000,1400];
%zrange = [600,700];

imgData = 'CubeCutout-test';
downloadocpdata(imgData,xrange,yrange,zrange)

%% run normalization module
%pData = 'testpdata';
%normalizedata(imgData,pData,numfreq,minunmasked,maskdilatesz)

%% run gmm module
%inData = 'CubeCutoutImage_1.outputFile-16.mat'; 

probData = 'testprobdata'; 
gmmposterior(imgData,probData,numcomp,numselect)

%load('testprobdata'); Prob = cube.data;

%% run threshold map module
mapData = 'testmapdata';
thresholdprob(probData,mapData,pthresh,minsize)

%load('testmapdata'); Map = cube.data;

%% run vessel removal module
nmapData = 'testnmapdata'; vmapData = 'testvmapdata';
removevessels(mapData,nmapData,vmapData,minsize,vesseldilatesz)

%load('testnmapdata'); NMap = cube.data; load('testvmapdata'); VMap = cube.data;

%% run cell detection module
centroidOut = 'outputcentroids'; paintOut = 'outputpaint';
greedyspherefinder(nmapData,centroidOut,paintOut,minsize,ballsz,0.8)

%load('outputcentroids')
%load('outputpaint'); Paint = cube.data;

