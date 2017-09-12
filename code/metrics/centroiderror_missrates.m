function [dvec,TP,FP,M,Matches] = centroiderror_missrates(C0,C1,thresh)
% need 3 x N matrices to compare

D = pdist2(C1',C0');
[vals,sortid] = sort(min(D),'ascend'); 

L = length(find(vals<=thresh));
D2 = pdist2(C1',C0(:,sortid)');

Matches = zeros(2,L);
dvec = zeros(L,1);
for i=1:L    
    idcol = i;
    [valtmp,idrow] = min(D2(:,i));
    
    if valtmp<=thresh
        Matches(:,i) = [idrow;idcol];
        dvec(i) = valtmp;
    end
    
    D2(idrow,:)=thresh+100;
    D2(:,idcol)=thresh+100;
end

idd = dvec>thresh;
Matches(:,idd)=[];

numcorrect = sum(sum(Matches)~=0);
numgt = size(C0,2);
numrecov = size(C1,2);

TP = numcorrect/numrecov;
FP = 1 - TP;
M = (numgt - numcorrect)/numgt;


end % end main function