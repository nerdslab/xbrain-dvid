% Upload Image Script for 16bit xraydata - uploaded as 8bit data for now
% W. Gray Roncal

oo = OCP();
oo.setServerLocation('braingraph1.cs.jhu.edu');
oo.setImageToken('dyer15');

imChunk = 8;
zOffset = 41;

q = OCPQuery;

%Data Directory
f = dir('*.tif');
nChunk = ceil(length(f)/imChunk);

for jj = 1:nChunk
    clear im %do this!
    jj
    s1 = imChunk * (jj-1) + 1;
    s2 = min(imChunk * (jj), length(f));
    
    c = 1;
    for ii = s1:s2
        
        im(:,:,c) = im2uint8(imread(f(ii).name));
        c = c + 1;
    end
    
    % convert to uint8 data
    %im = im2uint8(im);
    
    X = RAMONVolume; X.setCutout(im);
    X.setResolution(0);
    X.setXyzOffset([0,0,zOffset+s1-1]);
    
    % Put chunks
    oo.uploadImageData(X) 
    

end

