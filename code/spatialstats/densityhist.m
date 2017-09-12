function [probx,pts] = densityhist(Map,numsteps)

%numsteps=50;
stacksz = size(Map);

% find connected components
R = bwconncomp(Map>0);
RP = regionprops(R,'Centroid');
N = length(RP);

% compute centroids
Centroids = zeros(3,N);
for i=1:N
    Centroids(:,i) = RP(i).Centroid;
end


probx = interp3(x0,y0,z0,reshape(prob0,size(x0)),xf,yf,zf);
    
probx = probx./sum(probx(:)); % normalize pmf
   
end

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
 




