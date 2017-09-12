function xbrain_hyperparams_ed(pthresh, ballsz_start,ballsz_small, ballsz_large,presid, bgfg, fileName, errFile, paintOut, inData, pData, probData, mapData, nmapData, vmapData, centroidOut, outfilename)
       

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
    paintOut = 'outputpaint';
end

%% download cutout
xrange = [xstart-pad(1),xstop+pad(1)];
yrange = [ystart-pad(2),ystop+pad(2)];
zrange = [zstart-pad(3),zstop+pad(3)];

downloadocpdata(inData,xrange,yrange,zrange) %TODO - this should be inData!!

%% run threshold map module

normalizedata(inData,pData,numfreq,minunmasked,maskdilatesz) % output is pData (normalized IM)

if bgfg == 0
    gmmposterior(pData,probData,numcomp,numselect)
end

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
Nmap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
segErrNMap = compute_segmentmetrics(Nmap0, Nmap);

% segmentation error for Total Map (Vmap + Nmap)
tmp = load(vmapData);
Vmap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here
Tmap = zeros(size(Vmap));
tmpid = find(Vmap); Tmap(tmpid)=1; 
tmpid = find(Nmap); Tmap(tmpid)=1;

Tmap0 = zeros(size(Vmap0));
Tmap0(find(Vmap0))=1; Tmap0(find(Nmap0))=1;
segErrTMap = compute_segmentmetrics(Tmap0, Tmap);

% run cell finding code
greedyspherefinder(nmapData,centroidOut,paintOut,minsize,...
    ballsz,presid,kmax, pad(1), pad(2), pad(3))

% crop centroids (remove small region around zstart and zstop)
cropsz = 20;
tmp = load(centroidOut);
C1 = cropcentroids(tmp.Centroids,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
C02 = cropcentroids(C0,xstart+cropsz,xstop-cropsz,ystart+cropsz,ystop-cropsz,zstart+cropsz,zstop-cropsz);
CellMetrics = compute_centroidmetrics(C02,C1,10,[300,300,100],5); 

% cropped output
%tmp = load(painOut);
%ReconMap = tmp.cube.data(1+pad(1):end-pad(1),1+pad(2):end-pad(2),1+pad(3):end-pad(3)); %padding happens here

save(errFile, 'CellMetrics','segErrNMap','segErrTMap','fileName')