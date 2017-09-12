function [outPaint,cellsz] = estimate_cellsize(pData,Centroids,bsz,ptr,method)
% Input >>
% pData = probability map
% bsz = diamater of balls to sweep over
% Centroids (Nc x 3) are in (x,y,z) notation (row,col,slice) 
% N = maximum box size (for computing correlation)
% 


if isempty(Centroids)
    outPaint=0;
    cellsz=0;
    return
end

filtsz= 0;
if filtsz>0
    pData = medfilt3(pData,[filtsz,filtsz,filtsz]);
end
    
pData = pData.*(pData>ptr); % threshold prob map

if nargin<5
    method = 'x';
end

% compute balls of fixed diameter
L = length(bsz);
N = max(bsz)+2;
padsz = (N-1)/2 + 5;

ball_mask = zeros(N,N,N,L); 
for i=1:L
        [~,b] = strel3d_v2(bsz(i)); 
        Lb = length(b);
        offset = (N-Lb)/2;
        ball_mask(offset+1:offset+Lb ,offset+1:offset+Lb, offset+1:offset+Lb,i) = b;
end

Nc = size(Centroids,1);

if strcmp(method,'full')
    out = cell(L,1);
    for i=1:L
        tmp = ball_mask(:,:,:,i); 
        out{i} = convn_fft(pData,ball_mask(:,:,:,i));  
    end

    for i=1:Nc
        for j=1:length(out)
            tmp = out{j};
            corrval(i,j) = tmp(Centroids(i,2), Centroids(i,1), Centroids(i,3));
        end
    end
    
else
    padProb = padarray(pData,[padsz,padsz,padsz]);
    for i=1:Nc
        if mod(i,100) == 0
            fprintf('now processing %d of %d...\n', i, Nc)
        end
        
        tmpdata = padProb(Centroids(i,2) - (N-1)/2 + padsz: Centroids(i,2)+ (N-1)/2 + padsz, ...
                      Centroids(i,1) - (N-1)/2 + padsz: Centroids(i,1)+ (N-1)/2 + padsz,...
                      Centroids(i,3) - (N-1)/2 + padsz: Centroids(i,3)+ (N-1)/2 + padsz);
        for j=1:L
            tmp = tmpdata.*ball_mask(:,:,:,j);
            corrval(i,j) = sum(tmp(:));
        end
        %display(['Iterations remaining = ' int2str(Nc-i)])
    end
    
end

d2 = diff([corrval(:,1), corrval]')';
[~,id] = max(d2');
id = max(1,id-1);
cellsz = bsz(id);


% split paint into three channels

clear pData
if 0
numchan=3;
paint = uint16([size(pData)+2*padsz,numchan]);
for i=1:Nc
    
    chanid = ceil(id(i)/(numchan+1));
    tmp=paint(Centroids(i,2)-(N-1)/2 + padsz: Centroids(i,2)+(N-1)/2 + padsz,...
          Centroids(i,1)-(N-1)/2 + padsz: Centroids(i,1)+(N-1)/2 + padsz,...
          Centroids(i,3)-(N-1)/2 + padsz: Centroids(i,3)+(N-1)/2 + padsz, chanid);
      
    paint(Centroids(i,2)-(N-1)/2 + padsz: Centroids(i,2)+(N-1)/2 + padsz,...
          Centroids(i,1)-(N-1)/2 + padsz: Centroids(i,1)+(N-1)/2 + padsz,...
          Centroids(i,3)-(N-1)/2 + padsz: Centroids(i,3)+(N-1)/2 + padsz, chanid) = tmp + ball_mask(:,:,:,id(i))*i;
end

outPaint = paint(padsz+1:end-padsz, padsz+1:end-padsz, padsz+1:end-padsz, :);

end

if ~exist('outPaint')
    outPaint = [];
end

