function [IM,Mask] = preprocessdata(data,Mask,numfreq)

% Preprocess Data to remove radial artifacts
% for 400x400 cube, numfreq ~= 5
% set all masked pixels to equal -200

bgval = -200;
n1 = size(data,1);

if nargin<3
    wthr = 0.0267;
    numfreq = ceil(wthr*n1);
end

% for new dataset, numfreq = 5;

% remove low frequency dct components (in 2D)
N = size(data,3);

IM = zeros(size(data));
for i=1:N
    im = data(:,:,i);
    out = dct2(im);
    out(:,2:numfreq)=0; % dont remove the mean
    out(2:numfreq,:)=0; % dont remove the mean
    out = idct2(out);
    
    if sum(Mask(:))>0
        idd_unmask = find(Mask(:,:,i)~=1); % find unmasked pixels
        
        % subtract mean without masked pixels
        mean_noidd = mean(im(idd_unmask));
        out = out - mean_noidd;
        
        idd_mask = find(Mask(:,:,i)==1);
        out(idd_mask) = bgval;
    else
       out = out - mean(out(:)); 
    end
    
         
    IM(:,:,i) = out; 
end
    
end




