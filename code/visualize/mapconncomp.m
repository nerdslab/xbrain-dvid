function Map = mapconncomp(R,whichcomp,stacksz)

Map = zeros(stacksz);
N = length(whichcomp);

for i=1:N
    Map(R.PixelIdxList{whichcomp(i)}) = 1;
end

end