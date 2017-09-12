load('testmapdata-pt-82.mat')
ProbMap = cube.data;
load('testvmapdata-pt-82.mat')
VMap = cube.data;
load('testnmapdata-pt-82.mat')
NMap = cube.data;
load('testpdata.mat')
load('testprobdata.mat')
paintout = 'outputpaint-pt82.mat';
load(paintout)
PaintMap = cube.data;

% load centroids
centroidout = 'outputcentroids-pt-82.mat';
tmp = load(centroidout);

xstart = 1350; ystart = 1850; zstart = 390;
load('Anno-V0-A1.mat')
load('ReconMap-V0-A1.mat')

C0 = Centroids_ed0 + repmat([xstart,ystart,zstart]',1,size(Centroids_ed0,2));
tmp = load(centroidout);
id1 = find((tmp.Centroids(1,:)>=1350).*(tmp.Centroids(1,:)<=1650));
id2 = find((tmp.Centroids(2,:)>=1850).*(tmp.Centroids(2,:)<=2150));
id3 = find((tmp.Centroids(3,:)>=395).*(tmp.Centroids(3,:)<=495));
whichid = intersect(id3,intersect(id1,id2));
C1 = tmp.Centroids(:,whichid);

CellMetrics = compute_centroidmetrics(C0,C1,3,10,[300,300,100],5);


xid = 51:size(NMap,1)-50;
yid = 51:size(NMap,2)-50;
zid = 6:size(NMap,3)-5;

for i=1:15; 
    figure(1); subplot(5,3,i); imagesc((PaintMap(yid:xid,5+i)~=0)+ Nmap0(yid:xid,5+i)*2 +Vmap0(:,:,i)*(-2),[-2,3]); axis off; axis square;
    figure(2); subplot(5,3,i); imagesc(IM(yid,xid,5+i),[min(min(IM(:,:,i))),max(max(IM(:,:,i)))]); axis off; axis square;
end


