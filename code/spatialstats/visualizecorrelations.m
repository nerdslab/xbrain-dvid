function corr = visualizecorrelations(Results)

data{1} = Results.dist2vessel;
data{2} = Results.cellarea;
data{3} = Results.distknn(:,1);
data{4} = Results.distknn(:,5);

featnames{1} = 'dist2vessel';
featnames{2} = 'cellarea';
featnames{3} = 'distnn';
featnames{4} = 'dist5nn';

corr = eye(4,4);
for i=1:4
    for j = 1:i
        corr(i,j) = (data{i}./norm(data{i}))'*(data{j}./norm(data{j}));
    end
end

corr = 0.5*(corr + corr');

figure(1);
for i=1:4
    for j=1:i
        ind = (i-1)*4 + j;
        subplot(4,4,ind);
        plot(data{i},data{j},'.','MarkerSize',12); axis tight;
        title([featnames{i}, ' vs. ', featnames{j}, ' (Corr = ' num2str(corr(i,j),2), ')'])
    end
end

figure(2)
boxplot((Results.distknn))

figure(3)
data1 = trimmean(Results.distknn,20);
data2 = Results.distdegree;
plot(data1,data2,'-^','LineWidth',3,'MarkerSize',10)

% vol_sphere = (4/3)*pi*r^3;

end