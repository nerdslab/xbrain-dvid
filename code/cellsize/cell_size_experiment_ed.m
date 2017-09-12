% Cell size experiment
% W. Gray Roncal and Eva Dyer
% xbrain forever

% params
bsz = 13:2:31; 
ptr = 0.3;
N = max(bsz)+2;
padsz = (N-1)/2 + 1;
L = length(bsz);
filtsz = 0;

xstart = 1000; xstop = 1600;
ystart = 600; ystop = 1300;
zstart = 400; zstop = 800;
resolution = 0;

cajal3d
oo = OCP();
oo.setServerLocation('http://openconnecto.me/');
oo.setImageToken('S1_proj4');
oo.setAnnoToken('xbrain_rfr1');

%% image dense query

q = OCPQuery; 
q.setType(eOCPQueryType.imageDense); 
q.setCutoutArgs([xstart,xstop],[ystart,ystop],[zstart,zstop],1); 
q.setResolution(resolution);
tic, cube = oo.query(q); toc, display('Finished retrieving data')
IM = cube.data;

if sum(IM(:))==0
    return
end

%%% probability channel
oo.setAnnoChannel('cell_prob');
q2 = OCPQuery;
q2.setType(eOCPQueryType.annoDense);
q2.setCutoutArgs([xstart,xstop],[ystart,ystop],[zstart,zstop],1);
q2.setResolution(resolution);
probmap = oo.query(q2);
pData = probmap.data;


%% 
% oo.setAnnoChannel('cell_seg');
% q3 = OCPQuery;
% q3.setType(eOCPQueryType.annoDense);
% q3.setCutoutArgs([xstart,xstop],[ystart,ystop],[zstart,zstop],1);
% q3.setResolution(resolution);
% cellmap = oo.query(q3);
% NMap = cellmap.data; 


%% 

% figure; 
% for i=1:zstop-zstart 
%     subplot(1,3,1); imagesc(IM(:,:,i))
%     subplot(1,3,2); imagesc(pData(:,:,i)); title(int2str(zstart+i-1))
%     subplot(1,3,3); imagesc(NMap(:,:,i)~=0)
%     pause, 
% end


%%
% load and re-center centroids 
load('centroids_rfr1.mat') % download centroids for entire cube 
C0 = findROIcentroids(Centroids,cube.xyzOffset,size(cube),padsz); % find centroids in same coordinates as current cube 
xyz = cube.xyzOffset;
C1 = C0 - repmat(xyz,size(C0,1),1);
Nc = size(C1,1);

%% estimate cell sizes

tic, [outPaint,cellsz] = estimate_cellsize(pData,C1,bsz,ptr); toc
paint = sum(outPaint,4);

%% visualize 
% figure(1),
% colorz = 'rgb';
% for i=1:3
%     visualize3d(outPaint(:,:,:,i),colorz(i),'0.5'), hold on
% end

% figure(2),
% for i=1:size(paint,3) 
%     imagesc(-(paint(:,:,i)~=0)*100 + double(IM(:,:,i))), 
%     pause, 
% end

