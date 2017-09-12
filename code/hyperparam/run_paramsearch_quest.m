
%% set params
addpaths_quest

% load groundtruth
xstart = 1350; ystart = 1850; zstart = 390;
load('Anno-V0-A1.mat')
load('ReconMap-V0-A1.mat')
C0 = Centroids_ed0 + repmat([xstart,ystart,zstart]',1,size(Centroids_ed0,2));

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

% manually labeled cutout
%xrange = [1350,1650];
%yrange = [1850,2150];
%zrange = [395,495];

% full data
% xrange = [610,2010];
% yrange = [1,2560];
% zrange = [390,2014];

% cajal3d
% outfilename = 'testdata';
% downloadocpdata(outfilename,xrange,yrange,zrange)
% infilename = 'imgdata_gt'; outfilename = 'testprob';

%% download cutout
cajal3d

% xrange = [1350,1650];
% yrange = [1850,2150];
% zrange = [395,495];

xrange = [1300,1700];
yrange = [1800,2200];
zrange = [390,500];

% run2
%BallSz{1} = '18 12 22';
%BallSz{2} = '20 12 22';
%BallSz{3} = '16 12 22';

%run3
%BallSz{1} = '18 12 30';
%BallSz{2} = '20 12 30';
%BallSz{3} = '16 12 30';

% run 5
%BallSz{1} = '18 12 28';
%BallSz{2} = '20 12 28';
%BallSz{3} = '16 12 28';

% run 6
BallSz{1} = '20 12 30';
%BallSz{2} = '20 12 30';
%BallSz{3} = '20 12 30';

outfilename = 'CubeCutout-test';
inData = 'CubeCutout-test';
pData = 'testpdata';
    
downloadocpdata(outfilename,xrange,yrange,zrange)

%% run threshold map module
probx = 0.7;
Errsegmap = zeros(2,length(probx));
%parpool(2)
for i=1:length(probx)
    
    probData = ['testprobdata-pt-',num2str(probx(i)*100)];
    mapData = ['testmapdata-pt-',num2str(probx(i)*100)];
    nmapData = ['testnmapdata-pt-',num2str(probx(i)*100)]; 
    vmapData = ['testvmapdata-pt-',num2str(probx(i)*100)];
    
    gmmposterior(inData,probData,pData,numfreq,minunmasked,maskdilatesz,numcomp,numselect)
   
    thresholdprob(probData,mapData,probx(i),minsize)
      
    % run vessel removal module
    removevessels(mapData,pData,nmapData,vmapData,minsize,vesseldilatesz)
    
    tmp = load(nmapData);
    NMap = tmp.cube.data(51:end-50,51:end-50,6:end-5);
    Errsegmap(:,i) = compute_segmentmetrics(Nmap0, NMap);

    parfor j=1:length(BallSz)
        centroidOut = ['outputcentroids-pt-',num2str(probx(i)*100),'ball-',BallSz{j}];
        paintOut = ['outputpaint-pt',num2str(probx(i)*100),'ball-',BallSz{j}];
        % run cell finding code
        greedyspherefinder(nmapData,centroidOut,paintOut,minsize,...
        BallSz{j},presid,kmax)
    
        tmp = load(centroidOut);
        id1 = find((tmp.Centroids(1,:)>=1350).*(tmp.Centroids(1,:)<=1650));
        id2 = find((tmp.Centroids(2,:)>=1850).*(tmp.Centroids(2,:)<=2150));
        id3 = find((tmp.Centroids(3,:)>=395).*(tmp.Centroids(3,:)<=495));

        whichid = intersect(id3,intersect(id1,id2));
        C1 = tmp.Centroids(:,whichid);
        CellMetrics{i,j} = compute_centroidmetrics(C0,C1,3,10,[300,300,100],5);
    end
    save Results-10-18-7 Errsegmap CellMetrics

end

    

