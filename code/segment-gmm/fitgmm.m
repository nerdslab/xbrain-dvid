function [Probx,whichcell] = fitgmm(IM,notmasked,numselect,numcomp,method)

if nargin<5
    method = '0';
end

if strcmp(method,'patches')
    IM2 = padarray(IM,[1,1,1]);
    impatch = zeros(27,length(notmasked));
    
    for j=1:length(notmasked); 
        [rr,cc,zz] = ind2sub(size(IM),notmasked(j)); 
        impatch(:,j) = reshape(IM2(rr:rr+2,cc:cc+2,zz:zz+2),27,1); 
    end
    
    % remove rows and columns that are constant
    remrows = find(sum(diff(impatch'))==0);
    remcols = find(sum(diff(impatch))==0);
    
    % training dataset
    traind = impatch; 
    traind(remrows,:)=[]; 
    traind(:,remcols)=[];
    tmp = randperm(size(traind,2));
    sid = tmp(1:size(traind,2)-numselect);
    traind(:,sid)=[];
      
    % test data
    testd = impatch; 
    testd(remrows,:)=[];
    
    % fit mixture
    gm = fitgmdist(traind',numcomp);
    Probx = posterior(gm,testd');
    [~,whichcell] = min(mean(gm.mu,2));
else
    tmpid = randperm(length(notmasked));
    whichtrain = notmasked(tmpid(1:numselect));
    gm = fitgmdist(IM(whichtrain),numcomp);
    Probx = posterior(gm,IM(notmasked)); 
    [~,whichcell] = min(gm.mu);
end

end % end subfunction