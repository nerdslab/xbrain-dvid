% setup 
cajal3d 

% set parameters
imageToken = 'dyer15';
serverLocation = 'braingraph1.cs.jhu.edu';
resolution = 0;

% define OCP object
oo = OCP();
oo.setServerLocation(serverLocation);
oo.setImageToken(imageToken);