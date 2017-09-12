function visualizeconncomps(PixList,Vmap,ifpause,iferode)

if nargin<3
    ifpause=0;
end

ccolor = loadcolorz;

% plot vessels
figure;
visualize3d(Vmap,ccolor.burgundy,0.4); hold on; 

% plot all cells by color
for i=1:length(PixList)
    tmp = zeros(size(Vmap));
    tmp(PixList{i})=1;
    
    if iferode==1
        visualize3d(imerode(tmp==1,strel3d(2)),rand(3,1),0.4);
    else
        visualize3d(tmp==1,rand(3,1),0.4);
    end
    
    if ifpause==1
        pause,
    end
end

end