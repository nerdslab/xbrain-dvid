function metadata = getTheMetaData(descrip)
%Extracts metadata information from NIFTI filename.
%
%Example:
%filename='dyer15_x1200-1600_y1000-1400_z700-899_r0.nii'
%getTheMetaData(filename)

idx.US=strfind(descrip,'_');

metadata.imageToken = descrip(1:idx.US(1)-1);
aux = descrip(idx.US(1)+2:idx.US(2)-1); idx_aux = strfind(aux,'-'); 
metadata.xrange = [str2double(aux(1:idx_aux-1)),str2double(aux(idx_aux+1:end))];

aux = descrip(idx.US(2)+2:idx.US(3)-1); idx_aux = strfind(aux,'-');
metadata.yrange = [str2double(aux(1:idx_aux-1)),str2double(aux(idx_aux+1:end))];

aux = descrip(idx.US(3)+2:idx.US(4)-1); idx_aux = strfind(aux,'-');
metadata.zrange = [str2double(aux(1:idx_aux-1)),str2double(aux(idx_aux+1:end))];

metadata.resolution = str2num(descrip(idx.US(4)+2));
if strcmp(descrip(idx.US(4)+3),'.')
    metadata.annotationfile = 'no';
else
    metadata.annotationfile = 'yes';
end