function segmentvessels_python(probFile, outFile, ptr, dilatesz, minsize)
% Input
% inProbMap = name of input file 
% (masked vessel probability channel from ilastik stored as RAMON Volume)
% outVMap = name of output file
% ptr = threshold to apply to vessel prob. map
% dilatesz = size to dilate to fill in holes
% minsize = minimum size of connected comp in final vessel segmentation

% inProbMap = 'Ilastikpixel_1.output_filename_format-029.h5'
% hh = h5read(inProbMap,'/exported_data');
 
ptr = single(ptr);
dilatesz = single(dilatesz);
minsize = single(minsize);
smallsz = 100; % clean up garbage (cc's < smallsz)

if isstr(probFile)
    load(probFile)
    Vmap = data; % known
else
    Vmap = single(probFile);
end

Vmap2 = (Vmap>ptr);
 
[~,~,Vmap2] = removesmallcc(Vmap2,smallsz);
Vmap2 = imdilate(Vmap2,strel3d(dilatesz));
[~,~,data] = removesmallcc(Vmap2,minsize);

save(outFile, 'data')
%return Vmap