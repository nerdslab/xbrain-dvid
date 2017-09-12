function C = writeoverlabels(A)

C = zeros(size(A,1),1);
for i=1:size(A,2)
    idC = find(C);
    idA = find(A(:,i));
    idX = intersect(idA,idC);
    C = C + A(:,i);
    if ~isempty(idX)
        C(idX)=A(idX,i);        
    end
end