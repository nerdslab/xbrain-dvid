function xbrain_hyperparams_ed_test(pthresh, ballsz_start,ballsz_small, ballsz_large,presid, bgfg, fileName, errFile, paintOut, inData, pData, probData, mapData, nmapData, vmapData, centroidOut, outfilename)
       

%% Setup
ballsz = [ballsz_start, ballsz_small, ballsz_large];

% load groundtruth
load('Anno-V0-A1.mat')
load('ReconMap-V0-A1.mat')

% Map true centroids to true space
xstart = 1400; ystart = 1400; zstart = 895;
xstop = 1700; ystop = 1700; zstop = 995;

pad = [30,30,30];

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

% run cell finding code
greedyspherefinder(nmapData,centroidOut,paintOut,minsize,...
    ballsz,presid,kmax, pad(1), pad(2), pad(3))


end %%%%% end of function
 