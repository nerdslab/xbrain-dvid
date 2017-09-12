erodesz = 5; % size of structuring element to erode then dilate
numclust = 3; % number of clusters to split cell types into
minsz = 500; % minimum number of voxels for conn comps (set rest to zero)

%% Load nii file (with segmentation)
Gt = load_nii('proj4_x1351-1650_y1851-2150_z395-495_r0_cube1_anno_eva8.nii');

% neuron and vessel segmentation
Nmap = (Gt.img==1);
Vmap = (Gt.img==2);

%% 
% Compute following metrics:
% (1) distance between each neuron and its kth NN
% (2) degree distribution
% (3) distance from centroid of cell to closest vessel
% (4) 

maxdist=10;
Results = computedensitystats(Nmap,Vmap,maxdist);

corr = visualizecorrelations(Results);


%%








%% this part isnt working.

% cluster cells based upon their size
labels = kmeans(numvox_nb,numclust);
[val,id] = sort(labels);

vec = zeros(Num,1);
vec(val==3)=max(numvox_nb(val==3));
vec(val==2)=max(numvox_nb(val==2));
vec(val==1)=max(numvox_nb(val==1));

figure; plot(numvox_nb(id)); hold on; plot(vec)

figure;
for j=1:2
for i=1:100
    currid = id(100*(j-1)+i);
    figure(j)
    subplot(10,10,i); 
    tmp = zeros(size(Nmap));
    tmp(PixList_nb{currid})=1;
    
    if currid>length(PixList_nb)
        break
    end
    
    if labels(currid)==1
        visualize3d(tmp,'b',0.4)
    elseif labels(currid)==2
        visualize3d(tmp,'g',0.4)
    else
        visualize3d(tmp,'r',0.4)
    end
end
end