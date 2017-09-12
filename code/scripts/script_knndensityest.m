
opts = setopts_findcellcentroid([]);
numfreq = opts.numfreq;
minunmasked = opts.minunmasked;
maskdilatesz = opts.maskdilatesz;
numcomp = opts.numcomp;
pthresh = opts.pthresh;
vesseldilatesz = opts.vesseldilatesz;
ballsz = opts.ballsz;
dilatesz = opts.dilatesz;
presid = opts.presid;
kmax = opts.kmax;
numselect = opts.numselect;
minsize = opts.minsize;

xrange = [1350,1650];
yrange = [1850,2150];
zrange = [395,495];

% full data
% xrange = [610,2010];
% yrange = [1,2560];
% zrange = [390,2014];

% cajal3d
% outfilename = 'testdata';
% downloadocpdata(outfilename,xrange,yrange,zrange)
% infilename = 'imgdata_gt'; outfilename = 'testprob';

cajal3d
outfilename = 'testdata';
downloadocpdata(outfilename,xrange,yrange,zrange)

infilename = 'testdata'; probfilename = 'testprob'; pdatafilename = 'processeddata';
gmmposterior(infilename,probfilename,pdatafilename,numfreq,minunmasked,maskdilatesz,numcomp,numselect)

probfilename = 'testprob'; outfilename = 'testmap';
thresholdprob(probfilename,outfilename,pthresh,minsize)

mapfilename = 'testmap'; nmapfilename = 'testnmap'; vmapfilename = 'testvmap';
removevessels(mapfilename,pdatafilename,nmapfilename,vmapfilename,minsize,vesseldilatesz)

centroidfilename = 'outputcentroids'; paintfilename = 'outputpaint';
% make sure to make ballsz a string
greedyspherefinder(nmapfilename,centroidfilename,paintfilename,minsize,ballsz,dilatesz,presid,kmax)







