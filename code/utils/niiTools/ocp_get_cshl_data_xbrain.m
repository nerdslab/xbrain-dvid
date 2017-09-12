function img = ocp_get_cshl_data_xbrain(serverLocation, token, resolution, outputDir, xArgs, yArgs, zArgs, description)

% INPUTS:
% serverLocation:  OCP server location, containing the data
% token:  Pointer to dataset
% resolution:  desired resolution for dataset analysis
% outputDir:  local location to do processing/analysis
% xArgs: x extent to retrieve
% yArgs: y extent to retrieve
% zArgs: z extent to retrieve

% OUTPUTS:
% NIFTI File for Truthing in ITK Snap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COPYRIGHT NOTICE
% (c) 2014 The Johns Hopkins University / Applied Physics Laboratory
% All Rights Reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get Data

% Setup OCP
oo = OCP();
oo.setServerLocation(serverLocation);
oo.setImageToken(token);

% Build query
q = OCPQuery();
q.setType(eOCPQueryType.imageDense);
q.setCutoutArgs(xArgs,yArgs,zArgs,resolution);

% Cutout Data
img = oo.query(q);

%% Check Data
% Data can be visualized using the following command
% image(img)

%% Save png
dirname = fullfile(outputDir, sprintf('%s_x%d-%d_y%d-%d_z%d-%d_r%d',...
    token,xArgs(1),xArgs(2),yArgs(1),yArgs(2),zArgs(1),zArgs(2),resolution));
mkdir(dirname);
save(fullfile(dirname,'query.mat'),'q');
for ii = 1:size(img.data,3)
    filename = fullfile(dirname, sprintf('%s_x%d-%d_y%d-%d_z%d-%d_r%d.png',...
        token,xArgs(1),xArgs(2),yArgs(1),yArgs(2),zArgs(1),zArgs(1)+ ii - 1,resolution));
    
%    imwrite(squeeze(img.data(:,:,ii)), filename)
end

%% Save nii
filename = fullfile(dirname, sprintf('%s_x%d-%d_y%d-%d_z%d-%d_r%d.nii',...
    token,xArgs(1),xArgs(2),yArgs(1),yArgs(2),zArgs(1),zArgs(1)+ ii - 1,resolution));
nii = make_nii(img.data(:,:,:), [0.00065 0.00065 0.00065], [0 0 0], 2, description);
save_nii(nii, filename);