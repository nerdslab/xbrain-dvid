function opts = setopts_findcellcentroid(opts)

if ~isfield(opts,'maxsize')
    opts.maxsize = 10e3;
end

if ~isfield(opts,'padX')
    opts.padX = 40;
end

if ~isfield(opts,'padY')
    opts.padY = 40;
end

if ~isfield(opts,'padZ')
    opts.padZ = 40;
end

if ~isfield(opts,'isquest')
    opts.isquest = 1;
end

% when segmenting foreground from bg -- number of components for GMM
if ~isfield(opts,'numcomp')
    opts.numcomp = 2;
end

% (only relevant for borders w little data)
if ~isfield(opts,'maskdilatesz')
    opts.maskdilatesz = 40;
end

% min number of unmasked data to train gmm. 
% (only relevant for borders w little data) 
if ~isfield(opts,'minunmasked')
    opts.minunmasked = 0.1;
end

% max number of cell components to use in synthesis 
if ~isfield(opts,'kmax')
    opts.kmax = 20;
end

% percentage of component that must be explained away to use a new atom
if ~isfield(opts,'presid')
    opts.presid = 0.5;
end

% dilation size when munching away cells (in greedy sphere matching alg)
if ~isfield(opts,'dilatesz')
opts.dilatesz = 8;
end

% dilation size for vessels when computing Nmap
if ~isfield(opts,'vesseldilatesz')
    opts.vesseldilatesz = 8;
end

% size of minimum connected component to keep
if ~isfield(opts,'minsz')
    opts.minsize = 500;
end

% neighborhood size for connected comp analysis
if ~isfield(opts,'nhoodsz')
    opts.nhoodsz = 6; % minimum for 3D
end

% threshold for probability in GMM (background from foreground)
if ~isfield(opts,'pthresh')
    opts.pthresh = 0.8;
end

% size of a new chunk for analysis (total size = blksz + overlapsz = 300)
if ~isfield(opts,'blksz')
    opts.blksz = 260;
end

% size of balls used in greedy synthesis step
if ~isfield(opts,'ballsz')
    %opts.ballsz = '16 18 20 22'; (for big run)
    %opts.ballsz = '20 12 25';
    opts.ballsz = '18 12 25';
end

% amount of overlap between chunks
if ~isfield(opts,'overlapsz')
    opts.overlapsz = 40;
end

% erode when computing threshmap
if ~isfield(opts,'erodesz')
    opts.erodesz = 2;
end

% amount of samples to select from each slice - for learning GMM 
if ~isfield(opts,'numselect')
    opts.numselect = 50000;
end

% amount of samples to select from each slice - for learning GMM 
if ~isfield(opts,'numfreq')
    opts.numfreq = 8; % optimized for cubes with length 300
end

end