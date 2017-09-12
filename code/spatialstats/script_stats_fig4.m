
load('centroids_rfr1.mat') % in /xbrain/results
load('traindata-celldetect-V1.mat') % /xbrain/data/groundtruth/V1

id1 = find((Centroids(:,4)<0.9).*(Centroids(:,4)>=0.7));
id2 = find((Centroids(:,4)<0.7).*(Centroids(:,4)>=0.5));
%id3 = find((Centroids(:,4)<0.5).*(Centroids(:,4)>=0.3));

%[xx,yy,zz] =meshgrid(1350:20:1649,1850:20:2149,395:20:494);
%trainbox = [xx(:), yy(:), zz(:)];

xmin = 1350; xmax = 1650; 
ymin = 1850; ymax = 2150;
zmin = 395; zmax = 495;

sz = 3; x0 = [];
[xx1,yy1,zz1] =meshgrid(xmin-sz:xmin+sz,ymin-sz:ymin+sz,zmin-sz:zmin+sz);
x0 = [xx1(:), yy1(:), zz1(:)];

[xx1,yy1,zz1] =meshgrid(xmax-sz:xmax+sz,ymin-sz:ymin+sz,zmin-sz:zmin+sz);
x0 = [x0; [xx1(:), yy1(:), zz1(:)]];

[xx1,yy1,zz1] =meshgrid(xmin-sz:xmin+sz,ymax-sz:ymax+sz,zmin-sz:zmin+sz);
x0 = [x0; [xx1(:), yy1(:), zz1(:)]];

[xx1,yy1,zz1] =meshgrid(xmax-sz:xmax+sz,ymax-sz:ymax+sz,zmin-sz:zmin+sz);
x0 = [x0; [xx1(:), yy1(:), zz1(:)]];

[xx1,yy1,zz1] =meshgrid(xmin-sz:xmin+sz,ymax-sz:ymax+sz,zmax-sz:zmax+sz);
x0 = [x0; [xx1(:), yy1(:), zz1(:)]];

[xx1,yy1,zz1] =meshgrid(xmax-sz:xmax+sz,ymax-sz:ymax+sz,zmax-sz:zmax+sz);
x0 = [x0; [xx1(:), yy1(:), zz1(:)]];

clear C1
C1(:,1) = Centroids_gt(1,:)+xmin; 
C1(:,2) = Centroids_gt(2,:)+ymin; 
C1(:,3) = Centroids_gt(3,:)+zmin;

%%

figure;
plot3(Centroids(id1,1),Centroids(id1,2),Centroids(id1,3),'mo','MarkerSize',2)
hold on;

plot3(Centroids(id2,1),Centroids(id2,2),Centroids(id2,3),'bo','MarkerSize',2)
hold on;

%plot3(x0(:,1),x0(:,2),x0(:,3),'k+','MarkerSize',10)
%hold on;

figure;
idx = find((Centroids(:,4)>0.7).*(Centroids(:,4)<=0.9));
plot3(Centroids(idx,1),Centroids(idx,2),Centroids(idx,3),'.','Color', [51, 102, 153]./255)
idx2 = find((Centroids(:,4)>0.7).*(Centroids(:,4)<=0.5));

%%
figure;
idx = find((Centroids(:,4)>=0.5));
plot3(Centroids(idx,1),Centroids(idx,2),Centroids(idx,3),'.','Color',[51, 102, 153]./255)

hold on;

plot3(C1(:,1),C1(:,2),C1(:,3),'x','Color',[204, 51, 0]./255,'MarkerSize',6)
hold on;

%%

% 
% trainbox2 = [xx2(:), yy2(:), zz2(:)];
% 
% idd1 = find(trainbox2(:,1)>=trainbox(:,1));
% idd2 = find(trainbox2(:,2)>=trainbox(:,2));
% idd3 = find(trainbox2(:,3)>=trainbox(:,3));
% t2 = [trainbox2(idd1,1), trainbox2(idd2,2), trainbox2(idd3,3)];
% 
% plot3(t2(:,1),t2(:,2),t2(:,3),'k.')


% plot3(trainbox(:,1),trainbox(:,2),trainbox(:,3),'k.')
% 
% plot3(Centroids(id3,1),Centroids(id3,2),Centroids(id3,3),'k.')
% hold on;
% 
