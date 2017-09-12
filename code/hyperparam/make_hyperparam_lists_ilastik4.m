%make_hyperparameter list files

pthresh = [0.45:0.05:0.7];

ballsz_init = [18];
ballsz_small = [12, 14, 16];
ballsz_large = [24, 28, 32];

presid = 0.5;
bgfg_mode = 1; %gmm = 0; ilastik = 1


pthresh_file = 'pthresh_file5.list';
ballsz_init_file = 'ballsz_init_file5.list';
ballsz_small_file = 'ballsz_small_file5.list';
ballsz_large_file = 'ballsz_large_file5.list';
presid_file = 'presid_file5.list';
bgfg_mode_file = 'bgfg_mode_file5.list';
fname = 'filenames5.list';
c = 0;
for i = 1:length(pthresh)
    for j = 1:length(ballsz_init)
        for k = 1:length(ballsz_small)
            for m = 1:length(ballsz_large)
                for n = 1:length(presid)
                    for o = 1:length(bgfg_mode)
                        c = c + 1;
                        allVars(c,:) = [pthresh(i), ballsz_init(j), ballsz_small(k), ballsz_large(m), presid(n), bgfg_mode(o)];
                    end
                end
            end
        end
    end
end


for i = 1:size(allVars,2)
fid = fopen(pthresh_file,'wb');

fprintf(fid,'%f\n',allVars(:,1));

fid = fopen(ballsz_init_file,'wb');
fprintf(fid,'%f\n',allVars(:,2));
fid = fopen(ballsz_small_file,'wb');
fprintf(fid,'%f\n',allVars(:,3));
fid = fopen(ballsz_large_file,'wb');
fprintf(fid,'%f\n',allVars(:,4));
fid = fopen(presid_file,'wb');
fprintf(fid,'%f\n',allVars(:,5));
fid = fopen(bgfg_mode_file,'wb');
fprintf(fid,'%f\n',allVars(:,6));

end

fid = fopen(fname,'wb')

for i = 1:length(allVars)
    fprintf(fid,'xbrain_paramset_%s_%s_%s_%s_%s_%s\n',num2str(allVars(i,1)),num2str(allVars(i,2)),num2str(allVars(i,3)),num2str(allVars(i,4)),num2str(allVars(i,5)),num2str(allVars(i,6)));
end
    fclose('all')