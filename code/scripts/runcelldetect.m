function Results = runcelldetect(xrange,yrange,zrange,pthresh,ballsz,presid)
% pthresh = 0:0.05:1;
% ballsz = '20 16 25'; % starting ball, smallest ball, largest ball
% presid = fraction of energy that must match sphere (0 to 1)

% xrange = [1350,1650]; yrange = [1850,2150]; zrange = [395,495];
% [910,1210],[1000,1300],[1000 1300] = cool vessel big connected comp
%% set params

% these are the fixed parameters
opts = setopts_findcellcentroid([]);
numfreq = opts.numfreq;
minunmasked = opts.minunmasked;
maskdilatesz = opts.maskdilatesz;
numcomp = opts.numcomp;
vesseldilatesz = opts.vesseldilatesz;
kmax = opts.kmax;
numselect = opts.numselect;
minsize = opts.minsize;

%pthresh = opts.pthresh;
%ballsz = opts.ballsz;

%% download cutout
cajal3d

cube = read_api('http://www.openconnecto.me','S1_proj4',0,xrange,yrange,zrange);
Results.IM0 = cube.data;
save CubeCutout-test cube
clear IM0

%% run gmm module
%inData = 'CubeCutoutImage_1.outputFile-16.mat'; 
inData = 'CubeCutout-test';
probData = 'testprobdata'; pData = 'testpdata';
gmmposterior(inData,probData,pData,numfreq,minunmasked,maskdilatesz,numcomp,numselect)

load('testpdata');
Results.IM = IM;
clear IM

load('testprobdata'); 
Results.Prob = cube.data;
clear cube

%% run threshold map module
probData = 'testprobdata'; mapData = 'testmapdata';
thresholdprob(probData,mapData,pthresh,minsize)

load('testmapdata')
Results.Map = cube.data;
clear cube

%% run vessel removal module
mapData = 'testmapdata'; nmapData = 'testnmapdata'; vmapData = 'testvmapdata';
removevessels(mapData,pData,nmapData,vmapData,minsize,vesseldilatesz)

load('testnmapdata')
Results.NMap = cube.data;
clear cube

load('testvmapdata')
Results.VMap = cube.data;
clear cube

%% run cell detection module
centroidOut = 'outputcentroids'; paintOut = 'outputpaint';
greedyspherefinder(nmapData,centroidOut,paintOut,minsize,ballsz,presid,kmax)

load('outputcentroids')
Results.Centroids = Centroids;
clear Centroids

load('outputpaint')
Results.Paint = cube.data;
clear cube

end



