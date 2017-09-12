function combineCentroids(outFile, varargin)

csvOut = [];

for i = 1:length(varargin)
    load(varargin{i})
    csvOut = vertcat(csvOut, Centroids);
end

Centroids = csvOut;

save(outFile, 'Centroids')