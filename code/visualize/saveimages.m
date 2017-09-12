function saveimages(IM,startimg,filenm)

IM = im2uint8(IM);
N = size(IM,3);
for i=1:N    
    currim = IM(:,:,i);
    imwrite(currim,[filenm, int2str(startimg+i-1),'.tif'],'tif')
    i,
end

end
