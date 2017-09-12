%%%%%%%%%%%%%%%%%%%%%%
% OMP_ProbMap.m = function to detect cells and return their centroids
%%%
% Input
%%%
% Prob = Nr x Nc x Nz matrix which contains the probability of each voxel being a cell body. (i.e., the (r,c,z) position of Prob contains the probability that the (r,c,z) voxel of an image cube lies within a cell body.)
% ptr = threshold between (0,1) to apply to probability map (only consider voxels for which Prob(r,c,z) > ptr)
% presid = stopping criterion is a value between (0,1) (minimum normalized correlation between template and probability map) (Example = 0.47)
% startsz = initial size of spherical template (to use in sweep)
% dilatesz = size to increase mask around each detected cell (zero out sphere of radius startsz+dilatesz around each centroid)
% kmax = maximum number of cells (alternative stopping criterion)
%%%
% Output
%%%
% Centroids = D x 4 matrix, where D = number of detected cells. 
%             The (x,y,z) coordinate of each cell are contained in columns 1-3. 
%             The fourth column contains the correlation (ptest) between the template 
%             and probability map and thus represents our "confidence" in the estimate. 
%             The algorithm terminates when ptest<=presid.
% Nmap = Nr x Nc x Nz matrix containing labeled detected cells (1,...,D)
%%%%%%%%%%%%%%%%%%%%%%

function [Centroids,Nmap] = OMP_ProbMap(Prob,ptr,presid,startsz,dilatesz,kmax)

% threshold probability map
Prob = Prob.*(Prob>ptr);

% create dictionary of spherical templates
box_radius = ceil(max(startsz)/2) + 1;
Dict = create_synth_dict(startsz,box_radius);
Ddilate = create_synth_dict(startsz+dilatesz,box_radius);
Lbox = round(length(Dict)^(1/3));

Nmap = zeros(size(Prob));
newid = 1;
newtest = Prob;
Centroids = [];

% run greedy search step for at most kmax steps (# cells <= kmax)
for ktot = 1:kmax
    tic,
    val = zeros(size(Dict,2),1);
    id = zeros(size(Dict,2),1);
    
    for j = 1:size(Dict,2)
       convout = convn_fft(newtest,reshape(Dict(:,j),Lbox,Lbox,Lbox));
       [val(j),id(j)] = max(convout(:)); % positive coefficients only
    end
    
    % find position in image with max correlation
    [~,which_atom] = max(val); 
    which_loc = id(which_atom); 
  
    X2 = compute3dvec(Dict(:,which_atom),which_loc,Lbox,size(newtest));
    xid = find(X2); 

    X3 = compute3dvec(Ddilate,which_loc,Lbox,size(newtest));
    
    newid = newid+1; % bug - increment newid twice!
    newtest = newtest.*(X3==0);
    ptest = val./sum(Dict);
    
    if ptest<presid
        return
    end
    Nmap(xid) = newid;
    newid = newid+1;

    [rr,cc,zz] = ind2sub(size(newtest),which_loc);
    newC = [cc, rr, zz];

    Centroids = [Centroids; [newC,ptest]];

    display(['Iter remaining = ', int2str(kmax-ktot), ...
         ' Correlation = ', num2str(ptest,3)])

end

end





