function [probx,pts] = knndensityest(Map,stacksz,sampmethod,k)

numsteps=20;

if nargin<3
    sampmethod = 'full';
end

% check to see if binary map or centroids were passed in
if min(size(Map))==3
    Centroids = Map;
    
    if nargin<4
        k = ceil(sqrt(length(Centroids)));
    end

else
    % find connected components
    R = bwconncomp(Map>0);
    RP = regionprops(R,'Centroid');
    N = length(RP);
   
    % compute centroids
    Centroids = zeros(3,N);
    for i=1:N
        Centroids(:,i) = RP(i).Centroid;
    end
    
    if nargin<4
        k = ceil(sqrt(N));
    end
end

% compute discrete pmf
if strcmp(sampmethod,'sparse')
    probx = computeprob(Centroids',Centroids',k);  
    pts = Centroids;
elseif strcmp(sampmethod,'full')
    [x0,y0,z0] = meshgrid(linspace(1,stacksz(2),numsteps),...
        linspace(1,stacksz(1),numsteps),linspace(1,stacksz(3),numsteps));
    prob0 = computeprob(Centroids',[x0(:),y0(:),z0(:)],k);
    pts = [x0(:),y0(:),z0(:)];
    
    [xf,yf,zf] = meshgrid(1:stacksz(2),1:stacksz(1),1:stacksz(3));
    probx = interp3(x0,y0,z0,reshape(prob0,size(x0)),xf,yf,zf);
    %probx = permute(probx,[2,1,3]);
    
elseif strcmp(sampmethod,'perturb')
    numpts = 20; vari = 20;
    tmp = repmat(Centroids,1,numpts);
    pts =  tmp + vari*randn(size(tmp));
    probx = computeprob(Centroids',pts',k);
else
    error('Must specify sampling method!')
end

probx = probx./sum(probx(:)); % normalize pmf
   
end % end main function

function p1=computeprob(X1,xt,k1)
xsz1 = size(xt,2);
x1sz = size(X1,1);
d1= Getdist( xt,X1 );
[sd1, ~] = sort(d1);
rhoX1=sd1(k1,:);
p1 = k1./ (x1sz*rhoX1.^xsz1);
end

function dMat=Getdist(X,Y)
dszX=size(X,1);
dszY=size(Y,1);
VY=ones(dszY,1);
VX=ones(1,dszX);
dMat=VY*sum(X'.^2)-2*Y*X'+sum(Y.^2,2)*VX;
end
 




