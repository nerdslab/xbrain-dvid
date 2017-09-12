function nMap2hdr_both(M_img, M_seg, seg_singlecolor, xrange,yrange,zrange,imageToken,appendName)
%creates an .hdr (and .img) for an image and a segmentation/annotation file (.hdr or .img) from two 3D matrix M_img and M_seg:

%seg_singlecolor: 1 for single color, 0 to preserve the different numbers in M

if seg_singlecolor
   M_seg=double(M_seg>0);
else
    M_seg=double(M_seg);
end

newfilename_img = gen_niifilename(xrange,yrange,zrange,imageToken,['img_' appendName]);
newfilename_seg = gen_niifilename(xrange,yrange,zrange,imageToken,['anno_' appendName]);

nii = make_nii(M_img, [0.00065 0.00065 0.00065], [0 0 0]);
save_nii(nii, newfilename_img);
delete([newfilename_img '.mat'])
%delete([newfilename_img '.img'])   %doesn't work if .img is deleted

nii = make_nii(M_seg, [0.00065 0.00065 0.00065], [0 0 0]);
save_nii(nii, newfilename_seg);
delete([newfilename_seg '.mat'])
%delete([newfilename_seg '.img']) %doesn't work if .img is deleted

end