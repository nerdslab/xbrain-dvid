function uploadCellBodies(uploadServer, uploadToken, uploadChannel, RAMONData)
% Updated for new cajal September 2015 (v.1.8.0)

%% Cutout Data
% Load query
load(RAMONData);

% Set for upload
oo = OCP();
oo.setServerLocation(uploadServer);
oo.setAnnoToken(uploadToken);
oo.setAnnoChannel(uploadChannel);

% re-run connected components
rp = regionprops(cube.data,'PixelIdxList','Area');

nObj = sum([rp.Area]>0);
fprintf('Number Cell Bodies detected: %d\n',nObj);


%% Upload RAMON objects as voxel lists with preserve write option
fprintf('Creating Cell Objects...');
cells = cell(nObj,1);
ccc = 1;
for ii = 1:length(rp)
    
    if rp(ii).Area > 0
        s = RAMONSegment();
        s.setClass(eRAMONSegmentClass.soma);
        s.setResolution(cube.resolution);
        s.setXyzOffset(cube.xyzOffset);
        s.setDataType(eRAMONChannelDataType.uint32); %just in case
        s.setChannelType(eRAMONChannelType.annotation);
        s.setChannel(uploadChannel);
        [r,c,z] = ind2sub(size(cube.data),rp(ii).PixelIdxList);
        voxel_list = cat(2,c,r,z);
        
        s.setVoxelList(cube.local2Global(voxel_list));
        
        
        % Approximate absolute centroid
        centroid = cube.local2Global(round(mean(voxel_list,1)));
        
        %metadata - for convenience
        s.addDynamicMetadata('centroid', centroid);
        
        cells{ccc} = s;
        ccc = ccc + 1;
    end
    
end
fprintf('done.\n');
%%
if nObj ~= 0
    fprintf('Uploading %d cells\n\n',length(cells));
    
    ids = oo.createAnnotation(cells,eOCPConflictOption.preserve);
    
    for ii = 1:nObj
    %    id = oo.createAnnotation(cells{ii});%TODO,eOCPConflictOption.preserve);
        fprintf('Uploaded cell id: %d\n',ids(ii));
    end
    
    fprintf('Uploaded %d cells\n\n',nObj);
else
    fprintf('No Cells Detected\n');
end

