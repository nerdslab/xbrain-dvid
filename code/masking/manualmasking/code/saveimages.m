function saveimages(IM,startimg,filenm)

N = size(IM,3);
for i=1:N    
    currim = IM(:,:,i);
    imnum = startimg+i-1;
    if (imnum>99)&&(imnum<1000)
        totfilenm = [filenm, '0', int2str(imnum),'.tif'];
    elseif (imnum<100)
        totfilenm = [filenm, '00', int2str(imnum),'.tif'];
    elseif (imnum>=1000)
        totfilenm = [filenm, int2str(imnum),'.tif'];
    end
    
    if isa(IM,'double')
        currim2 = currim + sign(min(currim(:))).*min(currim(:));
        currim2 = currim2./max(currim2(:));
        currim = im2uint8(currim2);
    end    
    imwrite(currim,totfilenm,'tif')
end

end
