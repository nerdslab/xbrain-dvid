function Centroids = celldetect2centroids(foldername,maxnum)

if ~isempty(foldername)
    cd(foldername)
end

if nargin<2
    maxnum = 10;
end

f = dir('*.mat');
Num = length(f);

CentroidsAll =[];

for i=1:min(Num,maxnum)
    
    load(f(i).name)
    CentroidsAll = [CentroidsAll; Centroids];
end

Centroids = CentroidsAll;

