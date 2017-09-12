% script to download data + annotations
% xrange = [1, 2560];
% yrange = [1, 2560];
% zrange = [390, 2014];
% boundaries of reconstructed cells (within Centroids)
% xmin = 658;
% xmax = 1929;
% ymin = 24;
% ymax = 2476;
% zmin = 414;
% zmax = 1950;

load cellsize_rfr1
load centroids_rfr1
%load finalresults-cell2vesseldist

% add offset and flip back to (x,y,z) coordinates
C2 = C1(:,1:3)+repmat([1,610,390],size(C1,1),1);
C3(:,1) = C2(:,2); 
C3(:,2) = C2(:,1); 
C3(:,3) = C2(:,3);

clear C1 C2

[id,dis] = knnsearch(Centroids(:,1:3),C3);
fullmatch = length(id)-length(unique(id));

if fullmatch==0
    display('Perfect match')
else
    error('Centroids do not match!')
end

C0 = Centroids(id,1:3);

id1 = find(cellsz==17);
id2 = find(cellsz==21);
id3 = find(cellsz==29);
L = length(C0)-(length(id1)+length(id2)+length(id3))

dist2 = nndist(id,:);

% figure;
% subplot(2,2,1); hist(d2,100); 
% subplot(2,2,2); hist(d2(id1,:),100); 
% subplot(2,2,3); hist(d2(id2,:),100);
% subplot(2,2,4); hist(d2(id3,:),100)

% cell sizes
% (13-17) = 30.8%
% (19-23) = 42.4%
% (25-29) = 26.8%

%%

cajal3d
oo = OCP();
oo.setServerLocation('http://openconnecto.me/');
oo.setImageToken('S1_proj4');
oo.setAnnoToken('xbrain_rfr1');
oo.setAnnoChannel('vessel_seg'); % changes the annotation channel to download

xstart = 610; 
xstop = 2010;
ystart = 1; 
ystop = 2481;
zstart = 390+20; 
zstop = 2010;
resolution = 0;

qv = OCPQuery;
qv.setType(eOCPQueryType.annoDense);
% clear vessel_id

stepsz = 100; Nsteps = floor((zstop-zstart)/stepsz);
count=1; numvox = 0;
vessel_id = cell(Nsteps,stepsz);
nndist = 1e5*ones(size(Centroids,1),1);
for i=1:Nsteps
    qv.setCutoutArgs([xstart,xstop],[ystart,ystop],[zstart + (i-1)*stepsz ,zstart + i*stepsz],1);
    qv.setResolution(resolution);
    vesselanno = oo.query(qv);
    
    for j=1:stepsz
        %tmp = imrotate(vesselanno.data(:,:,j),-8,'crop'); %% why was this
        %rotated before?!?!?
        tmp = vesselanno.data(:,:,j);
        sz = size(tmp);
        [r1,r2,r3] = ind2sub(sz,find(tmp));
        tmp = [r2,r1,r3] + repmat(vesselanno.xyzOffset-1,length(r1),1);
        
        if ~isempty(tmp)
            [~,tmp2] = knnsearch(tmp,Centroids(:,1:3),'k',1);
            nndist = min(tmp2,nndist);
        end
        numvox = numvox + length(tmp);
    end
    display(['Iterations remaining = ', int2str(Nsteps-i)])
    
end

    

