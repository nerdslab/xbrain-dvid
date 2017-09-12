function thresholdprob(probData,mapData,pthresh,minsize,flag)
% thresholds probability map, removes artifacts by anistropic median
% filtering in 3D (enforce continuity across slices)

if nargin<5
    flag=0;
end

offset = 4;
nhoodsz = 6;

load(probData)
im = cube.data;

% if entire region is masked, return!
if sum(im(:))==0
    cube.setCutout(zeros(size(im)));
    save(mapData,'cube')
    return
end

% reverse probabilities (for ilastik)
if flag==1
    im = 1-im;
end

% test to see if slice is bad (set flag if so)
im2 = medfilt3(im>pthresh,[2,2,5]);
CC = bwconncomp(im2,nhoodsz); % thresholding posterior probabilities
Map = zeros(size(im));

if CC.NumObjects>0
    numvox = zeros(CC.NumObjects,1);
    for i=1:CC.NumObjects
        numvox(i) = length(CC.PixelIdxList{i});
    end
    idx = find(numvox>minsize);
    for i=1:length(idx)
        Map(CC.PixelIdxList{idx(i)}) = offset+i; 
    end
end

cube.setCutout(Map);
save(mapData,'cube')

end