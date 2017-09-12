% input = C0 = ground truth centroid matrix C0 (3 x N0) 
%         C1 = recovered centroid matrix (3 x N1) 

function CellMetrics = compute_centroidmetrics(C0,C1,thresh,stacksz,knn)

% merge centroids
%[C1] = mergecentroids(C1,sepdist);

if isempty(C1)
    CellMetrics.distpq = NaN;
    CellMetrics.MR = NaN;
    CellMetrics.TPR = NaN;
    CellMetrics.FPR = NaN;
    CellMetrics.CentroidErr = NaN;
    CellMetrics.Matches = NaN;
    return
end


% compute true/false positives and misses
[dvec,TPR,FPR,MR,Matches] = centroiderror_missrates(C0,C1,thresh);

%%
% density estimation
[prob0,~] = nndensity(C0,stacksz,knn);
[probx,~] = nndensity(C1,stacksz,knn);

%[prob0,~] = nndensity(C0,stacksz,round(sqrt(size(C0,2))));
%[probx,~] = nndensity(C1,stacksz,round(sqrt(size(C1,2))));

distpq =KLDiv(probx(:),prob0(:)); % measure difference between densities

CellMetrics.distpq = distpq;
CellMetrics.MR = MR;
CellMetrics.TPR = TPR;
CellMetrics.FPR = FPR;
CellMetrics.CentroidErr = [min(dvec), mean(dvec), max(dvec)];
CellMetrics.Matches = Matches;

end

% function C1 = mergecentroids(C1,sepdist)
% % merge centroids in C1 if within mindist (remove columns of C1)
% Dist = pdist2(C1',C1');
% Tmp = ones(size(Dist)); 
% Tmp = triu(Tmp);
% Dist = Dist + Tmp*(sepdist*2);
% [rr,cc] = find(Dist<sepdist);
% 
% % centroid is average of both centroids within sepdist from each other 
% for i=1:length(cc)    
%     tmp = find(cc(i)==cc);
%     newcentroid = mean(C1(:,[cc(i);rr(tmp)]),2);
%     C1(:,cc(i)) = newcentroid;
%     cc(setdiff(tmp,cc(i)))=[];
% end
%     
% C1(:,rr) = [];
% 
% mergeID = [idlist(rr);idlist(cc)];
% 
% end

function [probx,pts] = nndensity(Centroids,stacksz,k)

numsteps=20;
[x0,y0,z0] = meshgrid(linspace(1,stacksz(2),numsteps),...
    linspace(1,stacksz(1),numsteps),linspace(1,stacksz(3),numsteps));

prob0 = computeprob(Centroids',[x0(:),y0(:),z0(:)],k);
pts = [x0(:),y0(:),z0(:)];
    
[xf,yf,zf] = meshgrid(1:stacksz(2),1:stacksz(1),1:stacksz(3));
probx = interp3(x0,y0,z0,reshape(prob0,size(x0)),xf,yf,zf);
probx = probx./sum(probx(:)); % normalize pmf
   
end % end nn density estimation function

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
 






