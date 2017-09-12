function [TP,FP,FN] = centroiderror_missrates_pr(C0,C1,thresh)
% need 3 x N matrices to compare
 
TP = [];
FN = [];
 
% compute distance matrix
D = pdist2(C1',C0');
 
for i = 1:size(C0,2)
    % for each truth point, find nearest point
    idx = find(D(:,i) == min(D(:,i)));
    idx = idx(1); %break tie
    
    % if less than or equal to thresh, add to TP array, remove row from further consideration
    if D(idx,i) <= thresh
        TP = [TP, idx];
        D(idx,:) = 999;
        % if greater than thresh, add to FN array
    else
        FN = [FN, idx];
    end
end
 
% to get FP = total rows - TP
FP = 1:size(D,1);
FP = setdiff(FP,TP);

end