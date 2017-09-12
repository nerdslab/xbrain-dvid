function X = zeropad_centerpt(test_voxels,box_radius,start_loc,end_loc)

X = zeros(box_radius*2 + 1, box_radius*2 + 1, box_radius*2 + 1);
L1 = start_loc(1); L2 = size(test_voxels,1)-start_loc(1)-1;
xidx = end_loc(1)-L1+1:end_loc(1)+L2+1;        

L1 = start_loc(2); L2 = size(test_voxels,2)-start_loc(2)-1;
yidx = end_loc(2)-L1+1:end_loc(2)+L2+1;
        
L1 = start_loc(3); L2 = size(test_voxels,3)-start_loc(3)-1;
zidx = end_loc(3)-L1+1:end_loc(3)+L2+1;
        
X(xidx,yidx,zidx) = test_voxels;

end