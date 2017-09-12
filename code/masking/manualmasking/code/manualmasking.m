function manualmasking(imageToken,serverLocation,zrange,stepsz,filename,resolution)
% zrange is (2 x 1) with start and final image to mask

cajal3d % start OCPMatlab
% filename = [imageToken, '_maskimg_']; % save images w/ this filename
% filename = 'CM07_proj1_maskimg_'; % save images w/ this filename

close all

if nargin<6
    resolution = 2; % read in downsampled images to compute mask
end

if resolution == 2
    % full x and y range for downsampled images
    xrange = [0,640]; 
    yrange = [0,640];
end

if resolution == 0
    % full x and y range for downsampled images
    xrange = [0,2560]; 
    yrange = [0,2560];
end

% x,y range at native resolution
x0range =[0,2560];
y0range =[0,2560];

whichz = zrange(1):stepsz:zrange(2);
whichrem = rem((zrange(2)-zrange(1)),stepsz);

if isempty(whichz)
    error('Must specify proper range for images!')
end

if whichrem~=0
    whichz = [whichz,zrange(2)-1];
end

[ cutout ] = read_api(serverLocation, imageToken, resolution, xrange, yrange, [whichz(1),whichz(1)+1]);
Maskold = roipoly(cutout(1).data);

% compute masks at stepsz intervals over zrange
for i=1:length(whichz)-1  
    [ cutout ] = read_api(serverLocation, imageToken, resolution, ...
        xrange, yrange, [whichz(i+1),whichz(i+1)+1]);
    Masknew = roipoly(cutout(1).data);
    
    Mask3(:,:,1) = Maskold; 
    Mask3(:,:,2) = Masknew;
    BWq = interpmask(Mask3,linspace(1,2,stepsz),'spline');
    
    if (whichrem~=0)&&(i==(length(whichz)-1))
        lastj = whichrem-1;
    else
        lastj=stepsz-1;
    end
    
    for j=0:lastj
        [ cutout ] = read_api(serverLocation, imageToken, 0, x0range, y0range, [whichz(i)+j,whichz(i)+1+j]);
        
        if resolution==2
            MaskIM = cutout(1).data.*imresize(uint8(BWq(:,:,j+1)),4);
        elseif resolution==0
            MaskIM = cutout(1).data.*uint8(BWq(:,:,j+1));
        end
        
        saveimages(MaskIM,whichz(i)+j,filename) % save masked images
    end
    
    Maskold = Masknew;
end % end for loop

end % end main function 


