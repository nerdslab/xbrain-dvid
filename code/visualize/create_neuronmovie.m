function create_neuronmovie(X,filename,movtype)

figure;

if nargin<3
    movtype='fullcube';
end

viewsz = 30;
stepsz = 5;
framerate = 3;

colorz = loadcolorz;

writerObj = VideoWriter(filename,'MPEG-4');
writerObj.FrameRate = framerate;
open(writerObj);


%%%%%% full cube movie
if strcmp(movtype,'fullcube')==1
    for i=1:(100-viewsz)/stepsz
        X2 = zeros(300,300,100);
        X2(:,:,1:(i-1)*stepsz+1 + viewsz-1)= ...
        medfilt3(X(:,:,1:(i-1)*stepsz+1 + viewsz-1) ==1);

        figure(gcf); visualize3d(X==2,colorz.burgundy,0.4); hold on;
        visualize3d(X2,colorz.ice,0.4);
        frame = getframe;
        writeVideo(writerObj,frame);
    end
    
   
%%%%%% display neurons one-by-one movie    
elseif strcmp(movtype,'onebyone')==1
    CC = bwconncomp(X==1,6);
    Num = CC.NumObjects;
    X2 = zeros(300,300,100);
    
    figure(gcf); visualize3d(X==2,colorz.burgundy,0.4); hold on;
    for i=1:Num 
        X2(CC.PixelIdxList{i}) = 1;
        visualize3d(X2==1,colorz.ice,0.4); hold on;
        frame = getframe;
        writeVideo(writerObj,frame);
    end     
end

close(writerObj);

end