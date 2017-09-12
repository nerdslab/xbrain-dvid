function gmmposterior(imData,probData,numcomp,numselect)

% input is pData
% output is probData
preprocess=1; % preprocess the data
maskdilatesz = 20;

%% Step 0. load input data from ocp (Ramon Volume)
load(imData)
data = im2double(cube.data);

%% Step 1. compute mask
dilatesz = 10; % varthr = 1e-5;
Mask = computemask_gmm(data,dilatesz);
whichmasked = find(Mask==1);

% more than 40% of image slice must be unmasked to solve for gmm
numunmasked = round(0.4*numel(Mask(:,:,1))); 

%% Step 2. preprocess data (optional)
if preprocess==1
    [dataN,~] = preprocessdata(data,Mask);
    dataN = dataN;
else
    dataN = data;
end

clear data
warning off
im = zeros(size(dataN));
for i=1:size(dataN,3)
    tmp = zeros(size(dataN)); 
    tmp(:,:,i) = 1;
    id0 = find(tmp);
    notmasked = setdiff(id0,whichmasked);
    
    % only fit gmm on data points > mean
    meanim = mean(dataN(notmasked));
    notmasked = setdiff(notmasked, find(dataN>meanim));
    L = length(notmasked);
    
    if (L > numunmasked)&&(var(dataN(notmasked))>1e-4)
        ns= min(numselect,L);
        Ns = min(ns,L); 
        % if last argument == 1 (gmm over voxels), if == 'patches', patch-based gmm
        [Probx,whichcell] = fitgmm(dataN(:),notmasked,Ns,numcomp); 
        im(notmasked) = Probx(:,whichcell);
    end
end % end loop over slices

%remove borders
if sum(Mask(:))>0
    borderz = maskborder(Mask,maskdilatesz);
    im(find(borderz == -1))=0;
end

cube.setCutout(im);
save(probData,'cube')

end % end main function







