%%% V1
out = load_nii('V1samples_withincellandbackground_slices_25_50_75_10sampperslice.nii');
Seg = out.img;

out = load_nii('proj4_x1351-1650_y1851-2150_z395-495_r0_cube1');
IM = out.img;
y1 = cell2bgSNR(IM + abs(min(IM(:))),Seg);
v1_snr = [mean(y1),std(y1)];


%%% V2
out = load_nii('V2samples_withincellandbackground_slices_25_51_75_10sampperslice.nii');
Seg = out.img;

out = load_nii('S1_proj4_x1450-1650_y1450-1650_z895-994_r0.nii');
IM = out.img;
y2 = cell2bgSNR(IM + abs(min(IM(:))),Seg);
v2_snr = [mean(y2),std(y2)];


%%% V3
out = load_nii('V3_samples_30perslice_every25slices_cellwbg.nii');
Seg = out.img;

out = load_nii('proj4_x1200-1400_y1650-1850_z1126-1326_r0_testvol_v3_img.nii');
IM = out.img;
y3 = cell2bgSNR(IM + abs(min(IM(:))),Seg);
v3_snr = [mean(y3),std(y3)];

%%% Combined
yy = [y1; y2; y3];
tot_snr = [mean(yy),std(yy)];



