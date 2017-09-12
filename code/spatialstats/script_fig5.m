% script_fig5
% creates top panel of Figure 5

load('finalresults-cell2vesseldist.mat')
load('centroids_rfr1.mat')

dist_vessel = nndist; clear nndist
out = knnsearch(Centroids(:,1:3),Centroids(:,1:3),'K',2);
nncell = out(:,2)';
dist_cell = sqrt(sum(((Centroids(:,1:3)-Centroids(nncell,1:3))').^2))';

% compute cell density (nn approach)
k=5; % dvec = cell density estimates over volume
[pout,pts,volvox,dvec,numvox] = knndensityest(Centroids(:,1:3),k);

%%
figure;
subplot(131);
hist(dvec,linspace(0,6e5))
axis tight
title('Distribution of cell density over volume')
xlabel('cell density (x 10^5 cells/cubic mm)')
ylabel('counts')

subplot(132);
hist(dist_cell*0.65,linspace(0,140,100))
axis tight
title('Distances from cell centers to closest cell center')
xlabel('cubic microns')
ylabel('neurons')


subplot(133);
hist(dist_vessel*0.65,linspace(0,140,100))
axis tight
title('Distances from cell centers to closest vessel voxel')
xlabel('cubic microns')
ylabel('neurons')

sample_stats.celldensity_mean = mean(dvec);
sample_stats.celldensity_var = var(dvec);

sample_stats.ccdist_mean = mean(dist_cell);
sample_stats.ccdist_var = var(dist_cell);

sample_stats.cvdist_mean = mean(dist_vessel);
sample_stats.cvdist_var = var(dist_vessel);

sample_stats.totstats = [mean(dvec),var(dvec),mean(dist_cell), var(dist_cell), mean(dist_vessel),var(dist_vessel)];


%%
% visualize density
figure; 
for i=1:size(pout,3); 
    imagesc(log(pout(:,:,i)),[min(log(pout(:))),max(log(pout(:)))]), 
    pause, 
end



