function Mask = computemask(data,dilatesz)

minsz = 1e4; 
bgval = 0;
Mask = zeros(size(data));
id = find(data==bgval);

if ~isempty(id)
    Mask(id)=1;
    %Mask = imerode(Mask,strel3d(dilatesz));
    [~,~,Mask] = removesmallcc(Mask,minsz); % remove mask components smaller than 10k pixels
    
    if sum(Mask(:))>0
        Mask = imdilate(Mask,strel3d(dilatesz));
    end
end




end