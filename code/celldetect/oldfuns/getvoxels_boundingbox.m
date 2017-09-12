function X = getvoxels_boundingbox(S,Centroid,box_radius)

        stacksz = size(S);

        %tmp = ceil(Centroid);
        closestvox = Centroid;
        vdim1 = max(1,closestvox(1)-box_radius):min(closestvox(1)+box_radius,stacksz(1));
        vdim2 = max(1,closestvox(2)-box_radius):min(closestvox(2)+box_radius,stacksz(2));
        vdim3 = max(1,closestvox(3)-box_radius):min(closestvox(3)+box_radius,stacksz(3));
        
        test_voxels = S(vdim1,vdim2,vdim3);
        crop_loc(1) = closestvox(1) - max(1,closestvox(1)-box_radius);
        crop_loc(2) = closestvox(2) - max(1,closestvox(2)-box_radius);
        crop_loc(3) = closestvox(3)- max(1,closestvox(3)-box_radius);
        
        X = zeropad_centerpt(test_voxels,box_radius,crop_loc + 1,[box_radius+1,box_radius+1,box_radius+1]);  
end
