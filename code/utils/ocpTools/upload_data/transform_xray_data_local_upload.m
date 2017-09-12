% Upload Image Script for 16bit xraydata - uploaded as 8bit data for now
% W. Gray Roncal

zOffset = 41;

%Data Directory
f = dir('*.tif');

!mkdir output

for jj = 1:length(f)
    jj
    if jj < 10
    pre = '000';
    elseif jj < 100
        pre = '00';
    elseif jj < 1000
        pre = '0';
    else 
        pre = '';
    end
    
    clear im
    im = im2uint8(imread(f(jj).name));
    
    imwrite(im, ['output', filesep, 'xbrain_dyer15_slice', pre, num2str(jj),'.tif']);
    
end
