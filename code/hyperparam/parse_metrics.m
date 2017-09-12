baseDir1 = '/Users/evadyer/Documents/xbrain-hyperpresults/ec2_2015November09_02h02m26s498ms';
f1 = dir([baseDir1, filesep, '*.mat']);

baseDir2 = '/Users/evadyer/Documents/xbrain-hyperpresults/bc1_2015November08_19h12m51s242ms';
f2 = dir([baseDir2, filesep, '*.mat']);

baseDir3 = '/Users/evadyer/Documents/xbrain-hyperpresults/ilastik3';
f3 = dir([baseDir1, filesep, '*.mat']);

metrics = [];
for i = 1:length(f1)
    load([baseDir1, filesep, f1(i).name])
    metrics(end+1).segErrNMap = segErrNMap;
    metrics(end).segErrTMap = segErrTMap;
    metrics(end).CellMetrics_CentroidErr = CellMetrics.CentroidErr;
    metrics(end).CellMetrics_TPR_FPR = [CellMetrics.TPR, CellMetrics.FPR];
    metrics(end).CellMetrics_MR = [CellMetrics.MR];
    metrics(end).name = fileName;
end

for i = 1:length(f2)
    load([baseDir2, filesep, f2(i).name])
    metrics(end+1).segErrNMap = segErrNMap;
    metrics(end).segErrTMap = segErrTMap;
    metrics(end).CellMetrics_CentroidErr = CellMetrics.CentroidErr;
    metrics(end).CellMetrics_TPR_FPR = [CellMetrics.TPR, CellMetrics.FPR];
    metrics(end).CellMetrics_MR = [CellMetrics.MR];
    
    metrics(end).name = fileName;
end

for i = 1:length(f3)
    load([baseDir3, filesep, f3(i).name])
    metrics(end+1).segErrNMap = segErrNMap;
    metrics(end).segErrTMap = segErrTMap;
    metrics(end).CellMetrics_CentroidErr = CellMetrics.CentroidErr;
    metrics(end).CellMetrics_TPR_FPR = [CellMetrics.TPR, CellMetrics.FPR];
    metrics(end).CellMetrics_MR = [CellMetrics.MR];
    
    metrics(end).name = fileName;
end

save('metrics_xbrain_run1_2_Nov92015','metrics')
%% Ilastik RFR

baseDir = '/Users/graywr1/xbrain_hyperparam_rfr/ilastik';
f = dir([baseDir, filesep, '*err*.mat']);

metrics = [];
for i = 1:length(f)
    load([baseDir, filesep, f(i).name])
    metrics(end+1).segErrNMap = segErrNMap;
    metrics(end).segErrTMap = segErrTMap;
    metrics(end).CellMetrics_CentroidErr = CellMetrics.CentroidErr;
    metrics(end).CellMetrics_TPR_FPR = [CellMetrics.TPR, CellMetrics.FPR];
    metrics(end).CellMetrics_MR = [CellMetrics.MR];
    metrics(end).name = fileName;
end

save([baseDir, filesep, 'metrics_xbrain_ilastik_rfr_11242015.mat'],'metrics')

%% GMM RFR

baseDir = '/Users/graywr1/xbrain_hyperparam_rfr/gmm';
f = dir([baseDir, filesep, '*err*.mat']);

metrics = [];
for i = 1:length(f)
    load([baseDir, filesep, f(i).name])
    metrics(end+1).segErrNMap = segErrNMap;
    metrics(end).segErrTMap = segErrTMap;
    metrics(end).CellMetrics_CentroidErr = CellMetrics.CentroidErr;
    metrics(end).CellMetrics_TPR_FPR = [CellMetrics.TPR, CellMetrics.FPR];
    metrics(end).CellMetrics_MR = [CellMetrics.MR];
    metrics(end).name = fileName;
end

save([baseDir, filesep, 'metrics_xbrain_gmm_rfr_11242015.mat'],'metrics')
