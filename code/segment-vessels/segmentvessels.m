function segmentvessels(inProbMap,outVMap,ptr,dilatesz,minsize)
% Input
% inProbMap = name of input file 
% (masked vessel probability channel from ilastik stored as RAMON Volume)
% outVMap = name of output file
% ptr = threshold to apply to vessel prob. map
% dilatesz = size to dilate to fill in holes
% minsize = minimum size of connected comp in final vessel segmentation

% inProbMap = 'Ilastikpixel_1.output_filename_format-029.h5'
% hh = h5read(inProbMap,'/exported_data');

smallsz = 100; % clean up garbage (cc's < smallsz)

load(inProbMap)
Vmap = cube.data;

Vmap2 = (Vmap>ptr);

[~,~,Vmap2] = removesmallcc(Vmap2,smallsz);
Vmap2 = imdilate(Vmap2,strel3d(dilatesz));
[~,~,Vmap] = removesmallcc(Vmap2,minsize);

cube.setCutout(uint32(Vmap>0));
save(outVMap,'cube','-v7.3')

end