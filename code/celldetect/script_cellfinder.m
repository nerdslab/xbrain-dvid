% script to run cell finder (on test data)
% Input = Prob (cell probability map for V1)

load('data/testdata_2BM/ilastik_probs_V1/test_cube_probs_rfr.mat')
Prob = cube.data;

ptr = 0.2; % threshold Prob > ptr
% best operating point found in V1
presid = 0.47; startsz = 18; dilatesz = 8;
kmax = 10; % find first 10 cells only

[Centroids,Nmap] = OMP_ProbMap(Prob,ptr,presid,startsz,dilatesz,kmax);