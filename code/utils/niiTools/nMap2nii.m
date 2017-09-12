function nMap2nii(M, newfilename, singlecolor)
%creates a segmentation file (.hdr or .img) from 3D matrix M:
%M - 3D matrix
%newfilename - name of the segmentation file to be created (should be
%original file plus something)
%singlecolor: 1 for single color, 0 to preserve the different numbers in M

if singlecolor
   M=double(M>0);
else
    M=double(M);
end

nii = make_nii(double(M), [0.00065 0.00065 0.00065], [0 0 0]);
save_nii(nii, newfilename);

end