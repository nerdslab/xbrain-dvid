function [numvox,CC] = computearea_conncomp(X)

if ~iscell(X)
    CC = bwconncomp(X,6);
    N = CC.NumObjects;

    numvox = zeros(N,1);
    for i=1:N
        numvox(i) = length(CC.PixelIdxList{i});
    end

else
    numvox = zeros(length(X),1);

    for i=1:length(X)
        numvox(i) = length(X{i});
    end
    
    CC=0;
    
end

end % end function