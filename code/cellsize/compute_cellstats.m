function compute_cellstats(C0,numslices)

% C0 (N x 5) matrix = (x,y,z,corrval,size)


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
zstart = 390; 
zstop = 2010;
resolution = 0;

qv = OCPQuery;
qv.setType(eOCPQueryType.annoDense);
Nsteps = floor((zstop-zstart)/numslices);
nndist = 1e5*ones(size(Centroids,1),1);
for i=1:Nsteps
    qv.setCutoutArgs([xstart,xstop],[ystart,ystop],[zstart + (i-1)*numslices ,zstart + i*numslices],1);
    qv.setResolution(resolution);
    tic, vesselanno = oo.query(qv); toc
    
    for j=1:numslices

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

% nndist
% numvox
[~,tmp2] = knnsearch(C0(:,1:3),C0(:,1:3),'k',2);
Results.CellCentroid = C0(:,1:3);
Results.CellDist = tmp2(:,2);
Results.CellSize = C0(:,5);
Results.VesselDist = nndist;
Results.CellCorr = C0(:,4);


[pout,pts,volvox,dvec,numvox] = knndensityest(C0(:,1:3),10,1e-5,50);












end