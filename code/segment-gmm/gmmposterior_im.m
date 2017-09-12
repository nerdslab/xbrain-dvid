function ProbMap = gmmposterior_im(IM,numcomp,numselect,numfreq)
%%%%%
% Input
% IM = (N1 x N2 x N3) cube of image data
% numcomp = number of components used in GMM (# classes for segmentation)
% numselect = number of voxels to select to train GMM (e.g. 50,000)
% numfreq = number of frequency components to kill in pre-processing
%%%%%
% Output
% IMout = output probability cube (cell prob. class)

preprocess=1; % preprocess the data
maskdilatesz = 20;

%% Step 0. load input data from ocp (Ramon Volume)
data = im2double(IM);

%% Step 1. compute mask
dilatesz = 10; % varthr = 1e-5;
Mask = computemask_gmm(data,dilatesz);
whichmasked = find(Mask==1);

% more than 40% of image slice must be unmasked to solve for gmm
numunmasked = round(0.4*numel(Mask(:,:,1))); 

%% Step 2. preprocess data (optional)
if preprocess==1   
    if nargin<4
        [dataN,~] = preprocessdata(data,Mask);
    else
         [dataN,~] = preprocessdata(data,Mask,numfreq);
    end
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
    
    % only fit gmm on data points < mean (remove those > mean)
    meanim = mean(dataN(notmasked));
    notmasked = setdiff(notmasked, find(dataN>meanim));
    L = length(notmasked);
    
    newd = dataN(notmasked);
    newd2 = newd+sign(min(newd))*min(newd);
    newd2 = newd2./max(newd2);
    
    if (L > numunmasked)&&(var(newd2)>1e-4)
        ns= min(numselect,L);
        Ns = min(ns,L); 
        % if last argument == 1 (gmm over voxels), if == 'patches', patch-based gmm
        [Probx,whichcell] = fitgmm(dataN(:),notmasked,Ns,numcomp); 
        im(notmasked) = Probx(:,whichcell);
    end
    display(['Iterations remaining = ', int2str(size(dataN,3)-i)])
end % end loop over slices

%remove borders
if sum(Mask(:))>0
    borderz = maskborder(Mask,maskdilatesz);
    im(find(borderz == -1))=0;
end

ProbMap = im;

end % end main function







