function varargout = CreateNiftiWithMetaData_splitcubes(xrange, yrange, zrange, imageToken, nsplits, overlap)
%splits region of interest into smaller cubes for manual annotation (ground
%truthing purposes. Doesn't split the zaxis
%OVERLAP: amount of overlap (actually the amount of overlap is twice this
%number, because it sets how much one cube will spill into the neighbor's
%region
%NSPLITS: number of
% EXAMPLE: CreateNiftiWithMetaData_splitcubes([1200,1600],[1000,1400],[700,800],'dyer15',1,10)

addpath('./../../../ocpMatlab')   
addpath('./../../../neuronID/io/')   

%
%xrange = [1200,1600];
%yrange = [1000,1400];
%zrange = [700,800];

%% make the splits
%clear Xrange Yrange Zrange
%nsplits = 1;
xwidth = xrange(2)-xrange(1)+1;
ywidth = xrange(2)-xrange(1)+1;
%overlap = 10;
count = 0;
%
for i = 1:nsplits+1
    for j = 1:nsplits+1
        count = count+1;
        Xrange{count} = [max(xrange(1), xrange(1) + floor(xwidth/(nsplits+1))*(i-1) - overlap), min(xrange(2), xrange(1) + floor(xwidth/(nsplits+1))*(i) + overlap)];
        Yrange{count} = [max(yrange(1), yrange(1) + floor(ywidth/(nsplits+1))*(j-1) - overlap), min(yrange(2), yrange(1) + floor(ywidth/(nsplits+1))*(j) + overlap)];
        Zrange{count} = zrange;
    end
end

%% create script and "protocol" for downloading data from OCP, converting to NIFTI files (with metadata), sending to bobby (via Box)
cajal3d

% parameters (this is the metadata we want to keep track of)
%imageToken = 'dyer15';
resolution = 0;

serverLocation = 'openconnecto.me'; %this one wasn't working today
%serverLocation = 'braingraph1.cs.jhu.edu';

%choose output directory
outputDir = './splitted_cubes';

for i=1:length(Xrange)
    i
%put all the metadata together in a string
descrip= sprintf('IT_%s_X_%d-%d_Y_%d-%d_Z_%d-%d_R_%d_SL_%s',imageToken,Xrange{i}(1),Xrange{i}(2),Yrange{i}(1),Yrange{i}(2),Zrange{i}(1),Zrange{i}(2),resolution,serverLocation);

%doit
img = ocp_get_cshl_data_xbrain(serverLocation, imageToken, resolution, outputDir, Xrange{i}, Yrange{i}, Zrange{i}, descrip);
end