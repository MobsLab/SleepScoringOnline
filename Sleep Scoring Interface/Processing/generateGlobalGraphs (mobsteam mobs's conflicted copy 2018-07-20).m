folders=ls;
dirParent=pwd;
folders=strsplit(folders(1:end-1), ' ');
globalConfMatrix=zeros(3);
close all
figure;
subplot(2,1,1);
hold on
for i=1:length(folders)
    results=readResultsTable(fullfile(dirParent,folders{i},'/PostProcessing/results.csv'));
    subplot(2,2,1);
    hold on
    plot(results{:,'CohenKappa'},results{:,'BalancedAccuracy'},'Marker','o','LineStyle','none','LineWidth',2);
    subplot(2,2,2);
    hold on
    plot(results{:,'Sensitivity'}/100,results{:,'PrecisionP'}/100,'Marker','o','LineStyle','none','LineWidth',2);
    for j=1:length(results{:,'ConfMat'})
        globalConfMatrix=globalConfMatrix+eval(char(results{j,'ConfMat'}));
    end
end
subplot(2,2,1);
legend(folders,'Location','southeast');
xlim([0 1]);
ylim([0 1]);
xlabel("Cohen's Kappa");
ylabel('Balanced accuracy');
set(gca,'FontSize',30)
subplot(2,2,2);
legend(folders,'Location','southeast');
xlim([0 1]);
ylim([0 1]);
xlabel("Recall");
ylabel('Precision');
set(gca,'FontSize',30)
subplot(2,2,3)
globalConfMatrix=globalConfMatrix./sum(globalConfMatrix,2);
h=heatmap({ strcat('Wake'), strcat('REM'),strcat('NREM')},{strcat('Wake'), strcat('REM'), strcat('NREM')},globalConfMatrix);
h.XLabel=strcat('Online');
h.YLabel=strcat('Offline');
h.Title='Confusion matrix';
h.ColorbarVisible='off';
set(gca,'FontSize',30)
balancedAccuracy=sum(diag(globalConfMatrix))/3;

