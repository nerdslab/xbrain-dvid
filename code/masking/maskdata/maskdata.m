function maskdata(inData,inProb, outProb, outMask, maskdilatesz,padX, padY, padZ)
% Input = 
% imData (string with name of input file - image data)
% imMask (string with name of output file - binary mask)
% maskdilatesz = 50 (amount to dilate mask to crop boundary effects)

%% Step 0. load input data from ocp (Ramon Volume)
load(inData)
data = im2double(cube.data);
data = data(1+padX:end-padX,1+padY:end-padY,1+padZ:end-padZ); % need to account for padding

load(inProb)
Prob = im2double(cube.data);

%% Step 1. compute mask
dilatesz = 10; % varthr = 1e-5;
Mask = computemask(data,dilatesz);

if (sum(Mask(:))>0)&&(maskdilatesz>0)
    
    if nargin<3
        maskdilatesz = 50;
    end
    
    borderz = maskborder(Mask,maskdilatesz);
    Mask(find(borderz == -1)) = 1;
end

xyz = cube.xyzOffset;

Prob = Prob.*(Mask<=0);
cube.setCutout(Prob);
%cube.setXyzOffset([xyz(1)+padX,xyz(2)+padY,xyz(3)+padZ]);
save(outProb,'cube')

cube.setCutout(Mask);
save(outMask,'cube')

end % end main function


