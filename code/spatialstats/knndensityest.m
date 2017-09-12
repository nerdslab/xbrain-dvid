function [pout,pts,volvox,dvec,numvox] = knndensityest(Centroids,k,ptr)
% <Input>
% Centroids is N x 3 matrix
% <Output>
% dvec = density of each voxel (# cells / cubic mm)

if nargin<3
    ptr=1e-4;
end

pixres = 0.65;
wsz = 50;
numsteps = 200;

if size(Centroids,2)~=3
    error('Must be 3D!')
end

mindim = min(Centroids(:,1:3))-wsz;
maxdim = max(Centroids(:,1:3))+wsz;
stacksz = maxdim-mindim;

stepsz = ceil(max(stacksz)./numsteps);
[x0,y0,z0] = meshgrid(mindim(1)-wsz:stepsz:maxdim(1)+wsz,...
                      mindim(2)-wsz:stepsz:maxdim(2)+wsz,...
                      mindim(3)-wsz:stepsz:maxdim(3)+wsz);
probx = computeprob([x0(:),y0(:),z0(:)],Centroids,k);
pts = [x0(:),y0(:),z0(:)];
newsz = size(x0);

probx = permute(probx,[2,1,3]);
pout = reshape(probx,newsz(1),newsz(2),newsz(3));

volvox = (stepsz*pixres)^3; % volume of a voxel
p2 = (pout*size(Centroids,1))/volvox; % # of cells/ voxel 

for i=1:size(p2,3)
    Mask(:,:,i) = imfill((p2(:,:,i)>ptr),'holes');
end

idd = find(Mask);
numvox = length(idd);
dvec = p2(idd)*10^9;

end % end main function

function p1=computeprob(X1,xt,k1)

 xsz2 = size(xt,2);
 xsz1 = size(X1,1);
 [~,sd]= knnsearch( xt, X1, 'K',k1);
 %d1= Getdist( xt,X1 );
 %[sd1, sdInd1] = sort(d1);
 rhoX1=sd(:,end);
 p1 = k1./ (xsz1*rhoX1.^xsz2);
 p1= p1/sum(p1);
  
end


