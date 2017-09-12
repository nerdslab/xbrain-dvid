function visualizedensityfn(probx,vals)

colorz = loadcolorz;
normpx = probx*(1/max(probx(:)));

cid{1} = 'b';
cid{2} = 'c';
cid{3} = 'g';
cid{4} = 'y';
cid{5} = colorz.orange;
cid{6} = 'r';

    
figure; 
for i=1:min(length(vals)-1,6)
    visualize3d((normpx>=vals(i)).*(normpx<vals(i+1)),cid{i},0.1); 
    hold on;
end

end