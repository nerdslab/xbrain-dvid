% Cell size experiment
% W. Gray Roncal and Eva Dyer
% xbrain forever

ball_mask = false(49,49,49,20);
ball_mask_proto = zeros(49,49,49);
ball_mask_proto(25,25,25) = 1;
dist_mtx = bwdist(ball_mask_proto);
c = 1;
for i = 6:1:24
    ball_mask(:,:,:,c) = dist_mtx < i;
    c = c + 1;
end

% load in a matrix of probabilities
load('xbrain_feb20_train_probmask_cube.mat')

% load in a matrix of cell centroids - need to generalize this
load('results/train_cube_hyperparams/centroid_18_8.mat')
xstart = 1350; ystart = 1850; zstart = 410;
xstop = 1650; ystop = 2150; zstop = 495;

Centroids = Centroids(Centroids(:,4) > 0.5,1:3); % we might want to limit to those > 0.47 or whatever cutoff
C0 = Centroids - repmat([xstart,ystart,zstart],size(Centroids,1),1);
C0(C0(:,3) > 85,:) = [];

% add padding everywhere of 25
padProbs = zeros(size(cube,1)+50,size(cube,2)+50,size(cube,3)+50);
padProbs(25:end-25-1,25:end-25-1,25:end-25-1) = cube.data;
C0 = C0+repmat(25,size(C0));

clear cell_support
for i = 1:size(C0,1)  % for each centroid
    
    % for each template slice, drop down 49,49,49 window
        cell_block = padProbs(C0(i,2)-24:C0(i,2)+24,C0(i,1)-24:C0(i,1)+24,C0(i,3)-24:C0(i,3)+24);
    for j = 1:size(ball_mask,4)
        cell_support(i,j) = mean(cell_block(ball_mask(:,:,:,j)>0));
        % get a score
    end
    % get a derivative score
    cell_diff(i,:) = diff(cell_support(i,:));
end




% load in a matrix of images for comparison