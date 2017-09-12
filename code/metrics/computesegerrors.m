
thr = [0.5:0.1:1];
tmp11 = 0; tmp12 = 0;
tmp21 = 0; tmp22 = 0;
count1 = 1; count2 = 1;
fp_nmap = zeros(5,2);
miss_nmap = zeros(5,2);

%%%%% compute segmentation error for Nmap
for i=1:length(metrics)
    SegErrNmap(:,i) = metrics(i).segErrNMap;
end
whichid2 = find(diff(SegErrNmap(2,:)));

count = 1;
for i=1:2:length(whichid2)
    NmapFP(count,1) = SegErrNmap(1,whichid2(i)-1);
    NmapMR(count,1) = SegErrNmap(2,whichid2(i)-1);
    count = count+1;
    
end

count = 1;
for i=2:2:length(whichid2)
    NmapFP(count,2) = SegErrNmap(1,whichid2(i)-1);
    NmapMR(count,2) = SegErrNmap(2,whichid2(i)-1);
    count = count+1;
end

figure; plot([0.5:0.1:1],(NmapMR+NmapFP)/2)
title('Segmentation Error (Neuron Map)')
legend('iLastik', 'GMM')
 

%%%%%%%%% 
for i=1:length(metrics)
    tmp = metrics(i).CellMetrics_TPR_FPR;
    CellFP(i) = tmp(2);
    CellMR(i) = metrics(i).CellMetrics_MR;
end

whichid2 = find(diff(SegErrNmap(2,:)));

count = 1;
for i=1:2:length(whichid2)
    NmapFP(count,1) = SegErrNmap(1,whichid2(i)-1);
    NmapMR(count,1) = SegErrNmap(2,whichid2(i)-1);
    count = count+1;
    
end

count = 1;
for i=2:2:length(whichid2)
    NmapFP(count,2) = SegErrNmap(1,whichid2(i)-1);
    NmapMR(count,2) = SegErrNmap(2,whichid2(i)-1);
    count = count+1;
end


metrics.CellMetrics_TPR_FPR






