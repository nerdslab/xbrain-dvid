function [MapOut] = removebordercc(Map,padX,padY,padZ)
nhoodsz = 18;
% pass in Map with each component labeled with a different integer

tmp = zeros(size(Map));
tmp(1:padY,:,:)=1;
tmp(end-padY+1:end,:,:)=1;
tmp(:,1:padX,:)=1;
tmp(:,end-padX+1:end,:)=1;
tmp(:,:,1:padZ)=1;
tmp(:,:,end-padZ+1:end)=1;

whichborder = find(tmp);

ccid = unique(Map); 
for i=1:length(ccid)-1
    whichcc = find(Map==ccid(i+1)); 
    tmp = setdiff(whichcc,whichborder);
    pixdiff = length(whichcc)-length(tmp);
    
    if pixdiff>0
        Map(whichcc)=0;
    end
end





CC = bwconncomp(Map~=0,nhoodsz);

MapOut = Map;
for i=1:CC.NumObjects
    if length(setdiff(whichborder,CC.PixelIdxList{i}))==length(whichborder)
        
        Maptmp = zeros(size(Map)); 
        Maptmp(CC.PixelIdxList{i}) = Map(CC.PixelIdxList{i});
        
        tmp = unique(Map(CC.PixelIdxList{i})); tmp(tmp==0)=[];
        numobjects = length(tmp);
        
        if numobjects>1
            for j = 1:numobjects
                CC2 = bwconncomp(Maptmp==tmp(j),nhoodsz);
                if length(setdiff(whichborder,CC2.PixelIdxList{1}))==length(whichborder)
                    MapOut(CC2.PixelIdxList{1})=0;
                end
            end
        else
            Mapout(CC.PixelIdxList{i})=0;
        end
                
    end
end


end % end main function

