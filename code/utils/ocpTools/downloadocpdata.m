function downloadocpdata(outfilename,xrange,yrange,zrange)

serverLocation = 'openconnecto.me';
imageToken = 'S1_proj4';
resolution = 0;
 
%% Step 1. Query cutout
%cajal3d
cube = read_api(serverLocation, imageToken, resolution,xrange,yrange,zrange); 
save(outfilename,'cube')


end