%%%%%%%%%%%%%%%%%%%%%%
function cellfinder_nd(probFile,presid,startballsz,dilatesz, kmax, paintFile, centroidFile, server, token, channel, doUpload)

load(probFile) % assume stored in cube
Prob = cube.data;

% create sphere template inside of bounding box
box_radius = ceil(max(startballsz)/2) + 1;
Dict = create_synth_dict(startballsz,box_radius);
Lbox = round(length(Dict)^(1/3));

Nmap = zeros(size(Prob));
newid = 1;
newtest = single(Prob); % extra precision isn't important here
Centroids = [];
Confidence = [];
for ktot = 1:kmax
    
    val = zeros(size(Dict,2),1);
    id = zeros(size(Dict,2),1);
    
    for j = 1:size(Dict,2)
       convout = convn_fft(newtest,reshape(Dict(:,j),Lbox,Lbox,Lbox));
       [val(j),id(j)] = max(convout(:)); % positive coefficients only
    end
    
    % find position in image with max correlation
    if val == 0 % corner case
        break
    end
    [~,which_atom] = max(val); 
    which_loc = id(which_atom); 
  
    X2 = compute3dvec(Dict(:,which_atom),which_loc,Lbox,size(newtest));
    xid = find(X2); 
    newtest = newtest.*(imdilate(X2,strel3d(dilatesz))<=0);
    ptest = val./sum(Dict);
    
    if ptest<presid
        break%return
    end
    
    % fixing bug - don't set this value until after 
    Nmap(xid) = newid;
    newid = newid+1;

    [rr,cc,zz] = ind2sub(size(newtest),which_loc);
    
    if ~isempty(cube.xyzOffset)
        newC = cube.xyzOffset + [cc, rr, zz] - [1, 1, 1]; %TODO
    else
        newC = [cc, rr, zz];
    end

    Centroids = [Centroids; [newC,ptest]]; 
    display(['Iter remaining = ', int2str(kmax-ktot), ...
             ' Correlation = ', num2str(ptest,3)])
         
end

cube.setCutout(Nmap)
%% Need to integrate upload code so that things all happen in parallel
% this isn't the only way to do this, but probably the simplest

if doUpload

% Load data
labels = Nmap;
rp = regionprops(labels,'PixelIdxList','Area');

% get rid of edge objects
edgeLabels = [unique(labels(:,:,1)); unique(labels(:,:,end)); unique(labels(:,1,:)); ...
              unique(labels(:,end,:)); unique(labels(1,:,:)); unique(labels(end,:,:))];

edgeLabels = unique(edgeLabels);
edgeLabels(edgeLabels == 0) = [];

for i = 1:length(edgeLabels)
    if rp(edgeLabels(i)).Area > 0 
        labels(rp(edgeLabels(i)).PixelIdxList) = 0;
    end
end

% get data from DB for mask - should only be possible to have duplicates inload('../../data/groundtruth/Anno-V0-A0.mat')
% the edges

oo = OCP();

oo.setServerLocation(server);
oo.setAnnoToken(token);
oo.setAnnoChannel(channel);

% compute bounds for boundary issue cropping
im_size = oo.annoInfo.DATASET.IMAGE_SIZE(0)
im_offset = oo.annoInfo.DATASET.OFFSET(cube.resolution)

xstop = cube.xyzOffset(1)+size(cube,2)-1;
ystop = cube.xyzOffset(2)+size(cube,1)-1;
zstop = cube.xyzOffset(3)+size(cube,3)-1;

%cube.setCutout(cube.data(1:(xstop-cube.xyzOffset(1)+1), ...
%                           1:(xstop-cube.xyzOffset(2)+1), ...
%                           1:(xstop-cube.xyzOffset(3)+1)));

q = OCPQuery;
q.setType(eOCPQueryType.annoDense);
q.setResolution(cube.resolution);
q.setCutoutArgs([cube.xyzOffset(1), xstop], ...
                [cube.xyzOffset(2), ystop], ...
                [cube.xyzOffset(3), zstop], ...
                cube.resolution);
q
existingAnno = oo.query(q);

existingAnno

exist_label = unique(labels(existingAnno.data > 0));
exist_label(exist_label == 0) = [];

if ~isempty(exist_label)
    disp('removing labels that already exist in DB')
    length(exist_label)
    
for i = 1:length(exist_label)
    if rp(exist_label(i)).Area > 0 
        labels(rp(exist_label(i)).PixelIdxList) = 0;
    end
end

end

% now write back up!
cube.setCutout(labels);


% The way to do this is to assume that we have already cropped off the
% ilastik volume, and so we want to get back the same sized volume as the
% one we are about to upload.  In practice, this is stored in the
% probability cube and therefore Nmap output
rp = regionprops(labels, 'PixelIdxList','Area');
nObj = sum([rp.Area]>0);
fprintf('Number Cell Bodies detected: %d\n',nObj);

% Upload RAMON objects as voxel lists with preserve write option
fprintf('Creating Cell Objects...');
cells = cell(nObj,1);
ccc = 1;
size(Centroids)
size(rp)

for ii = 1:length(rp)
    
    if rp(ii).Area > 0
        s = RAMONSegment();
        s.setClass(eRAMONSegmentClass.soma);
        s.setResolution(cube.resolution);
        s.setXyzOffset(cube.xyzOffset);
        s.setDataType(eRAMONChannelDataType.uint32); %just in case
        s.setChannelType(eRAMONChannelType.annotation);
        s.setChannel(channel);
        [r,c,z] = ind2sub(size(cube.data),rp(ii).PixelIdxList);
        voxel_list = cat(2,c,r,z);
        
        s.setVoxelList(cube.local2Global(voxel_list));
        
        % Approximate absolute centroid
        
        %metadata - for convenience
        s.addDynamicMetadata('centroid', Centroids(ii,:));
        
        cells{ccc} = s;
        ccc = ccc + 1;
    end
    
end
fprintf('done.\n');
%
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
end
%%
save(centroidFile,'Centroids')
sprintf(paintFile)
save(paintFile,'cube','-v7.3')
