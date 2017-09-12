load([pwd, '/data/ilastik_vesselprob_V1.mat'])

Vmap = segmentvessels_mat(ProbV,0.98,8,1000);

% uncomment next line to visualize in 3D
%figure; visualize3d(Vmap,'g',0.4)