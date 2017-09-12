function Pout = filtergmm(ProbMap,ptr)
dilatesz = 3;
mincompsz = 500;

Pout = imerode(ProbMap.*(ProbMap>ptr),strel3d(dilatesz));
[~,~,Pout] = removesmallcc(Pout,mincompsz);
Pout =  imdilate(Pout,strel3d(dilatesz));

end