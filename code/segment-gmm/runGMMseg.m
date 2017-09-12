addpath('~/Documents/repos/xbrain/data/testdata_32ID/S4_subblock')
viz = 1; % show images

%% LOAD IMAGE DATA from tif stack
for i=860:999, 
    IM(:,:,i-859) = imread(['data_00',int2str(i),'.tiff.tif']); 
end
count = 141; 
for i=1000:1139, 
    IM(:,:,count) = imread(['data_0',int2str(i),'.tiff.tif']); 
    count=count+1; 
end

IM = im2double(IM);

if viz==1
    figure;
    for i=1:size(IM,3)
        imagesc(IM(:,:,i)), pause,
    end
end

%% RUN GMM Segmentation 

numcomp = 2; 
numsamp = 2e5; 
numfreq = 5; 

ProbMap = gmmposterior_im(IM,numcomp,numsamp,numfreq);

if viz==1
    figure;
    for i=1:size(IM,3)
        subplot(1,2,1); imagesc(IM(:,:,i)), title(['Original image # ',int2str(i)])
        subplot(1,2,2); imagesc(ProbMap(:,:,i)), title(['Probability map # ',int2str(i)])
        pause,
    end
end


%% 



