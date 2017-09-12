function [MapOut] = removebordercc(Map,padX,padY,padZ)

if nargin<2
    padX = 1;
    padY = 1;
    padZ = 1;
end

tmp = zeros(size(Map));
tmp(1:padY,:,:)=1;
tmp(end-padY+1:end,:,:)=1;
tmp(:,1:padX,:)=1;
tmp(:,end-padX+1:end,:)=1;
tmp(:,:,1:padZ)=1;
tmp(:,:,end-padZ+1:end)=1;

whichborder = find(tmp);

MapOut = Map;
ccid = unique(Map); 
for i=1:length(ccid)-1
    whichcc = find(MapOut==ccid(i+1)); 
    tmp = setdiff(whichcc,whichborder);
    pixdiff = length(whichcc)-length(tmp);
    
    if pixdiff>0
        MapOut(whichcc)=0;
    end
end




end % end main function

