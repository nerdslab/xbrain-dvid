
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

outfilename = 'CubeCutout-test';
downloadocpdata(outfilename,xrange,yrange,zrange)

%% run gmm module
%inData = 'CubeCutoutImage_1.outputFile-16.mat'; 
inData = 'CubeCutout-test';
probData = 'testprobdata'; pData = 'testpdata';
gmmposterior(inData,probData,pData,numfreq,minunmasked,maskdilatesz,numcomp,numselect)

%load('testpdata');
%load('testprobdata'); 
%Prob = cube.data;

%% run threshold map module
probx = [0.68:0.02:0.9];
Errsegmap = zeros(1,length(probx));

parpool(8)
for i=1:length(probx)
    probData = 'testprobdata'; 
    mapData = ['testmapdata-pt-',num2str(probx(i)*100)];
    nmapData = ['testnmapdata-pt-',num2str(probx(i)*100)]; 
    vmapData = ['testvmapdata-pt-',num2str(probx(i)*100)];
    centroidOut = ['outputcentroids-pt-',num2str(probx(i)*100)];
    paintOut = ['outputpaint-pt',num2str(probx(i)*100)];
    
    thresholdprob(probData,mapData,probx(i),minsize)
    
    %tmp=load(mapData);
    %TMap = tmp.cube.data(51:end-50,51:end-50,6:end-5);
    %Errmap1(i) = compute_segmentmetrics((Nmap0+Vmap0)~=0, TMap);
    
    % run vessel removal module
    removevessels(mapData,pData,nmapData,vmapData,minsize,vesseldilatesz)
    
    tmp = load(nmapData);
    NMap = tmp.cube.data(51:end-50,51:end-50,6:end-5);
    Errsegmap(:,i) = compute_segmentmetrics(Nmap0, NMap);

    % run cell finding code
    greedyspherefinder(nmapData,centroidOut,paintOut,minsize,...
     ballsz,presid,kmax)
 
    tmp = load(centroidout);
    id1 = find((tmp.Centroids(1,:)>=1350).*(tmp.Centroids(1,:)<=1650));
    id2 = find((tmp.Centroids(2,:)>=1850).*(tmp.Centroids(2,:)<=2150));
    id3 = find((tmp.Centroids(3,:)>=395).*(tmp.Centroids(3,:)<=495));

    whichid = intersect(id3,intersect(id1,id2));
    C1 = tmp.Centroids(:,whichid);
 
    CellMetrics{i} = compute_centroidmetrics(C0,C1,3,10,[300,300,100],5);

end

save Results-10-18-1 Errsegmap CellMetrics
    

