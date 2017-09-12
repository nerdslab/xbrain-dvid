function xbrain_hyperparams(pthresh, ballsz_start,ballsz_small, ballsz_large,presid, bgfg, fileName, errFile, paintFile, inData, pData, probData, mapData, nmapData, vmapData, centroidOut, outfilename)
       

%% Setup
ballsz = [ballsz_start, ballsz_small, ballsz_large];

% load groundtruth
load('Anno-V0-A1.mat')
load('ReconMap-V0-A1.mat')

% Map true centroids to true space
xstart = 1350; ystart = 1850; zstart = 395;
xstop = 1650; ystop = 2150; zstop = 495;

pad = [50, 50, 5];

C0 = Centroids_ed0 + repmat([xstart,ystart,zstart]',1,size(Centroids_ed0,2));

opts = setopts_findcellcentroid([]);
numfreq = opts.numfreq;
minunmasked = opts.minunmasked;
maskdilatesz = opts.maskdilatesz;
numcomp = opts.numcomp;
vesseldilatesz = opts.vesseldilatesz;
kmax = opts.kmax;
numselect = opts.numselect;
minsize = opts.minsize;

localFlag = 0;
if localFlag
inData = 'CubeCutout-test';
pData = 'testpdata';
probData = 'testprobdata';
mapData = 'testmapdata';
nmapData = 'testnmapdata';
vmapData = 'testvmapdata';
centroidOut = 'outputcentroids';
outfilename = 'outfilename';
end

%% download cutout
xrange = [xstart-pad(1),xstop+pad(1)];
yrange = [ystart-pad(2),ystop+pad(2)];
zrange = [zstart-pad(3),zstop+pad(3)];

downloadocpdata(inData,xrange,yrange,zrange) %TODO - this should be inData!!

%% run threshold map module

gmmposterior(inData,probData,pData,numfreq,minunmasked,maskdilatesz,numcomp,numselect)

if bgfg == 1
    disp('running ilastik')
    %error('ilastik not yet implemented')
    probData = '/share0/xbrain-celldetect/ilastikTestCube2.mat';
    
    % reverse probabilities for ilastik output - only done once in setup
    %load(probData)
    %cube3 = 1- cube.data;   
    %cube.setCutout(cube3);
    %save(probData,'cube')
end

thresholdprob(probData,mapData,pthresh,minsize)

% run vessel removal module
removevessels(mapData,pData,nmapData,vmapData,minsize,vesseldilatesz)

% segmentation error for NMap
tmp = load(nmapData);
NMap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
segErrNMap = compute_segmentmetrics(Nmap0, NMap);

% segmentation error for Total Map (Vmap + Nmap)
tmp = load(vmapData)
VMap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
TMap = zeros(size(VMap));
TMap(find(VMap))=1; TMap(find(NMap))=1;

TMap0 = zeros(size(VMap));
TMap0(find(VMap))=1; TMap0(find(NMap))=1;
segErrTMap = compute_segmentmetrics(TMap0, TMap);

% run cell finding code
greedyspherefinder(nmapData,centroidOut,paintFile,minsize,...
    ballsz,presid,kmax, pad(1), pad(2), pad(3))

tmp = load(centroidOut);
id1 = find((tmp.Centroids(1,:)>=xstart).*(tmp.Centroids(1,:)<=xstop));
id2 = find((tmp.Centroids(2,:)>=ystart).*(tmp.Centroids(2,:)<=ystop));
id3 = find((tmp.Centroids(3,:)>=zstart).*(tmp.Centroids(3,:)<=zstop));

whichid = intersect(id3,intersect(id1,id2));
C1 = tmp.Centroids(:,whichid);
CellMetrics = compute_centroidmetrics(C0,C1,10,[300,300,100],5); 

save(errFile, 'CellMetrics','segErrNMap','segErrTMap','fileName')