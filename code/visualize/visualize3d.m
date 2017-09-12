function visualize3d(v,colors,alphaval)

if nargin==2
    alphaval = 1;
end

% visualize the volume
p = patch( isosurface(v,0) );                 % create isosurface patch
isonormals(v, p)                              % compute and set normals
set(p, 'FaceColor',colors, 'EdgeColor','none')   % set surface props
daspect([1 1 1])                              % axes aspect ratio
view(3), axis vis3d tight, box on, grid on    % set axes props
camproj perspective                           % use perspective projection
camlight, lighting phong, alpha(alphaval)           % enable light, set transparency
%axis off