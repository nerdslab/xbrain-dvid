[X, meta] = nrrdread('proj4_x1851-2150_y1351-1650_z395-495_r0_cube1_anno_eva2.nrrd');

%figure; visualize3d(X~=0,'r',0.4);
%subplot(1,2,1); visualize3d(X==1,'r',0.4); 
%subplot(1,2,2); visualize3d(X==2,'r',0.4)
% CC= bwconncomp(X);
% Num = CC.NumObjects;

colorz = loadcolorz;

% burgundy and ice
figure; 
visualize3d(X==1,colorz.ice,0.6)
visualize3d(X==2,colorz.burgundy,0.6);

X2 = zeros(300,300,100); 
X2(:,:,1:20)= (X(:,:,1:20)==1); 

figure; 
visualize3d(X2,ice,0.4); hold on;
visualize3d(imdilate(X2,sel),'c',0.4);
visualize3d(X==2, burgundy,0.4);

%%%%%%%%%%%%%%%%%%%
% Create Movie
%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%




%sel = strel3d(1);
%nmap = imdilate(imerode(X==1,sel),sel);
%vmap = imdilate(imerode(X==2,sel),sel);

nmap = (X==1);
vmap = (X==2);
figure; 
visualize3d(vmap,burgundy,0.4); hold on;
visualize3d(nmap,ice,0.4); hold off;




