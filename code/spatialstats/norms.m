function [Xn,nmz] = norms(X)

% normalize the columns of X
nmz = sqrt(sum(X.^2));
Xn = X./repmat(nmz,size(X,1),1);


end