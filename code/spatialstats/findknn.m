function [whichnn, dists] = findknn(X,Y,k)

 tmp = pdist2(X,Y,'euclidean', 'Smallest',max(k)+1);
 [val,id] = sort(tmp,'ascend');
 dists = val(2:end);
 whichnn = id(2:end);    
    
end