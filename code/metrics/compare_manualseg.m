%compare manual segmentations
presid = 0.4;
kmax = 5; % max spheres / components
startballsz = '20'; % searching size (ball)
minballsz = '12'; % min sz ball for scale space search ()
maxballsz = '25';  % max sz ball for scale space search ()
mincc = 500; % min size of cc's
sepdist = 10; % distance between cell centroids (vox)
thresh = 5; % centroids > 5 voxes apart cant be matches
knn = 5; % num nn for density estimation

% load eva and hugo's annotations
img = load_nii('proj4_x1925-2074_y1425-1574_z395-495_subset_cube1_hugo_seg_final.hdr');
hfdata = img.img;

img = load_nii('proj4_x1351-1650_y1851-2150_z395-495_r0_cube1_anno_eva7.nii');
eddata = img.img;

Nmap_ed = eddata(75:end-76,75:end-76,:)==1;
Vmap_ed = eddata(75:end-76,75:end-76,:)==2;

Nmap_hf = hfdata==1;
Vmap_hf = hfdata==2;

% find dilation of V1-A2 that minimizes Hamming dist between 
% d(V1-A1 - dilate(V1-A2))
Err = zeros(10,1);
for i =1:10
    Err(i) = compute_segmentmetrics(Nmap_ed,imdilate(Nmap_hf,strel3d(i))); 
end

%% minimum attained when dilating hf by strel3d(3)
Nmap_hf0 = Nmap_hf;
Nmap_hf = imdilate(Nmap_hf0,strel3d(3));

figure; visualize3d(Nmap_ed,'g',0.4); hold on;
visualize3d(Nmap_hf,'b',0.4); 

%% now run greedy sphere finder

[ReconMap_ed0,Centroids_ed0] = greedyspherefinder_local(eddata==1,...
mincc,startballsz,minballsz,maxballsz,presid,kmax);

[ReconMap_ed,Centroids_ed] = greedyspherefinder_local(Nmap_ed,...
    mincc,startballsz,minballsz,maxballsz,presid,kmax);

[ReconMap_hf,Centroids_hf] = greedyspherefinder_local(Nmap_hf,...
    mincc,startballsz,minballsz,maxballsz,presid,kmax);

figure; visualize3d(ReconMap,'g',0.4); hold on;
visualize3d(ReconMap_hf,'b',0.4); 

Results = computeallmetrics(Centroids_ed,Centroids_hf,Nmap_ed,Nmap_hf0,[]);


%% 

clear Map, clear ReconMap_ed, clear Centroids_ed
for i =1:9;
    probData = 'testprobdata'; mapData = 'testmapdata';
    thresholdprob(probData,mapData,0.1*i,mincc); load('testmapdata')
    Map{i} = cube.data; 
    
    [ReconMap_ed2{i},Centroids_ed2{i}] = greedyspherefinder_local(Map{i},...
    mincc,startballsz,minballsz,maxballsz,presid,kmax);

    Results.CellErr{i} = compute_centroidmetrics(Centroids_ed0,...
        Centroids_ed2{i},sepdist,thresh,size(Map0),knn);
i,
end
    
    




