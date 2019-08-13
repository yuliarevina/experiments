% analysis all subjects

% nSubs = 37 %for 25-45
nSubs = 23 %for 20-60

% ntrialseachcond = 1440; % nsubs x how many conds each one had (either 30 or 40, check the list)
ntrialseachcond = 900; % nsubs x how many conds each one had (either 30 or 40, check the list)
% ntrialseachcond = 200; % nsubs x how many conds each one had (either 30 or 40, check the list)
results = [];

% subs = [11 12 14:22 24 26 27 29 30 33:36]; %good red fix subs
% subs = [10 13 23 25 28 31 32 37]; %bad red fix subs
% subs = [2:38]; %all good subs for 25-45
subs = [38:43,45:55,58,60:64]; %all good subs for 20-60
% subs = [39:43]; % subs with high SF


%% for 25 - 45
for i = subs
    if i == 38
        filename = sprintf('Results381.mat'); %381 for 25-45 or 382 for 20-60
    else
        filename = sprintf('Results%d.mat',i);
    end
    load(filename)
    if i == (subs(1))
        results = eval(sprintf('results%d',i));
    end
end

for i = subs(2:end)
    if i == 38
        results = results + eval(sprintf('results%d1',i)); %%d1 for 25-45, or %d2 for 20-60
    else
        results = results + eval(sprintf('results%d',i));
    end
end

%% for 20 - 60
for i = subs
    if i == 38
        filename = sprintf('Results382.mat'); %381 for 25-45 or 382 for 20-60
    else
        filename = sprintf('Results%d.mat',i);
    end
    load(filename)
    if i == (subs(1))
        results = eval(sprintf('results%d2',i));
    end
end

for i = subs(2:end)
    if i == 38
        results = results + eval(sprintf('results%d2',i)); %%d1 for 25-45, or %d2 for 20-60
    else
        results = results + eval(sprintf('results%d',i));
    end
end

%% old analysis
%extract RTs

% 7th column of the matrix (also 6th but we can just use either so let's do
% 7th for now. 5th and 6th for subs 1 - 9 thou

RT_col = 7;

% all RTs histogram

RT = [];

% all_RT = subjectdata(:,RT_col);
% 
% figure; hist(all_RT);


for i = subs
    % RTs by condition
    subjectdata = eval(sprintf('subjectdata%d',i));
    
    if i < 10
        RT_col = 6;
    else
        RT_col = 7;
    end
    RT_tmp = [];
    
    for cond_counter = 1:5
        tmp3 = find((subjectdata(:,1) == cond_counter))'; %condition 1
        RT_tmp(:,cond_counter) = subjectdata(tmp3,RT_col);
    end
    
    RT = [RT; RT_tmp]; %concatenate
end
figure; subplot(2,3, 1); hist(RT(:,1)); xlabel ('Intact');  axis([0 50 0 8000])
subplot(2,3, 2); hist(RT(:,2)); xlabel ('BS'); axis([0 50 0 8000])
subplot(2,3, 3); hist(RT(:,3)); xlabel ('Occluded'); axis([0 50 0 8000])
subplot(2,3, 4); hist(RT(:,4)); xlabel ('Del Sharp'); axis([0 50 0 8000])
subplot(2,3, 5); hist(RT(:,5)); xlabel ('Del Fuzzy'); axis([0 50 0 8000])

median_intact = median(RT(:,1));
median_BS = median(RT(:,2));
median_Occ = median(RT(:,3));
median_Deleted_Sharp = median(RT(:,4));
median_Deleted_Fuzzy = median(RT(:,5));

figure; subplot(2,3, 1); boxplot(RT(:,1)); xlabel ('Intact'); axis([0 2 0 1.5])
subplot(2,3, 2); boxplot(RT(:,2)); xlabel ('BS');  axis([0 2 0 1.5])
subplot(2,3, 3); boxplot(RT(:,3));xlabel ('Occluded'); axis([0 2 0 1.5])
subplot(2,3, 4); boxplot(RT(:,4)); xlabel ('Del Sharp'); axis([0 2 0 1.5])
subplot(2,3, 5); boxplot(RT(:,5)); xlabel ('Del Fuzzy'); axis([0 2 0 1.5])


figure; boxplot(RT(:,1:5),'Notch','on', 'MedianStyle', 'line'); 
set(gca, 'XTickLabel', ({'Intact', 'BS', 'Occluded', 'Del Sharp', 'Del Fuzzy'})); 
axis([0 6 0 1.4]);
ylabel('RT (secs)')
% subplot(2,3, 2); boxplot(RT(:,2)); xlabel ('BS');  axis([0 2 0 1.5])
% subplot(2,3, 3); boxplot(RT(:,3));xlabel ('Occluded'); axis([0 2 0 1.5])
% subplot(2,3, 4); boxplot(RT(:,4)); xlabel ('Del Sharp'); axis([0 2 0 1.5])
% subplot(2,3, 5); boxplot(RT(:,5)); xlabel ('Del Fuzzy'); axis([0 2 0 1.5])



disp('Intact vs BS')
[p,h,stats] = ranksum(RT(:,1),RT(:,2)) %independent samples

disp('Intact vs Occ')
[p,h,stats] = ranksum(RT(:,1),RT(:,3)) %independent samples

disp('Intact vs Del Sh')
[p,h,stats] = ranksum(RT(:,1),RT(:,4)) %independent samples

disp('Intact vs Del Fuzz')
[p,h,stats] = ranksum(RT(:,1),RT(:,5)) %independent samples

disp('BS vs Occ')
[p,h,stats] = ranksum(RT(:,2),RT(:,3)) %independent samples

disp('BS vs Del Sh')
[p,h,stats] = ranksum(RT(:,2),RT(:,4)) %independent samples

disp('BS vs Del Fuzz')
[p,h,stats] = ranksum(RT(:,2),RT(:,5)) %independent samples

disp('Occ vs Del Sh')
[p,h,stats] = ranksum(RT(:,3),RT(:,4)) %independent samples

disp('Occ vs Del Fuzz')
[p,h,stats] = ranksum(RT(:,3),RT(:,5)) %independent samples

disp('Del Sh vs Del Fuzz')
[p,h,stats] = ranksum(RT(:,4),RT(:,5)) %independent samples



% compare medians for RT for each subject (a bit neater to plot than everyy
% single data point for every single subject

figure; bx = boxplot(RT_medians(:,1:5),'Notch','on', 'MedianStyle', 'line'); 
set(gca, 'XTickLabel', ({'Intact', 'BS', 'Occluded', 'Del Sharp', 'Del Fuzzy'})); 
axis([0 6 0 1.0]);
ylabel('RT (secs)')
ax = gca;
h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

hold on
individdata = {RT_medians(:,1), RT_medians(:,2), RT_medians(:,3), RT_medians(:,4), RT_medians(:,5)};
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',3);
for i = subs
    plot(RT_medians(i,1:5))
end


median_of_medians_intact = median(RT_medians(:,1));
median_of_medians_BS = median(RT_medians(:,2));
median_of_medians_Occ = median(RT_medians(:,3));
median_of_medians_Deleted_Sharp = median(RT_medians(:,4));
median_of_medians_Deleted_Fuzzy = median(RT_medians(:,5));



figure; subplot(2,3, 1); hist(RT_medians(:,1)); xlabel ('Intact');  axis([0 1 0 40])
subplot(2,3, 2); hist(RT_medians(:,2)); xlabel ('BS'); axis([0 1 0 40])
subplot(2,3, 3); hist(RT_medians(:,3)); xlabel ('Occluded'); axis([0 1 0 40])
subplot(2,3, 4); hist(RT_medians(:,4)); xlabel ('Del Sharp'); axis([0 1 0 40])
subplot(2,3, 5); hist(RT_medians(:,5)); xlabel ('Del Fuzzy'); axis([0 1 0 40])

disp('Intact vs BS')
[p,h,stats] = signrank(RT_medians(:,1),RT_medians(:,2)) %paired samples

disp('Intact vs Occ')
[p,h,stats] = signrank(RT_medians(:,1),RT_medians(:,3)) %paired samples

disp('Intact vs Del Sh')
[p,h,stats] = signrank(RT_medians(:,1),RT_medians(:,4)) %paired samples

disp('Intact vs Del Fuzz')
[p,h,stats] = signrank(RT_medians(:,1),RT_medians(:,5)) %paired samples

disp('BS vs Occ')
[p,h,stats] = signrank(RT_medians(:,2),RT_medians(:,3)) %paired samples

disp('BS vs Del Sh')
[p,h,stats] = signrank(RT_medians(:,2),RT_medians(:,4)) %paired samples

disp('BS vs Del Fuzz')
[p,h,stats] = signrank(RT_medians(:,2),RT_medians(:,5)) %paired samples

disp('Occ vs Del Sh')
[p,h,stats] = signrank(RT_medians(:,3),RT_medians(:,4)) %paired samples

disp('Occ vs Del Fuzz')
[p,h,stats] = signrank(RT_medians(:,3),RT_medians(:,5)) %paired samples

disp('Del Sh vs Del Fuzz')
[p,h,stats] = signrank(RT_medians(:,4),RT_medians(:,5)) %paired samples



%% RTs

%analyse for all subjects except those excluded from all analyses for BS
%size and RedFix performance

excludedsubs = [1, 44, 56, 57, 59];
allsubs = [1:64];
goodsubs = setdiff(allsubs,excludedsubs);

% mean_RT_good = mean(mean_RT(goodsubs,:), 1)

individdataRT = {mean_RT(goodsubs,1), mean_RT(goodsubs,2), mean_RT(goodsubs,3), mean_RT(goodsubs,4), mean_RT(goodsubs,5)}

figure; hist(mean_RT(goodsubs, :))

figure; bar(mean(mean_RT(goodsubs,:),1), 'y')
hold on
stderror = std(mean_RT(goodsubs,:)) / sqrt( length( goodsubs ))
errorbar(mean(mean_RT(goodsubs, :),1),stderror, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 3)


plotspreadhandles = plotSpread(individdataRT,'distributionMarkers', 'o', 'distributionColors', 'r','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',2);

set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
% set(gca, 'fontsize',10);
set(gca, 'TickDir', 'out')
ylabel('Mean Reaction Time (s)')
axis ([0 6 0.0 1.5])

disp('Intact vs BS')
[H,P,~,STATS] = ttest(individdataRT{1}, individdataRT{2})
%for bayes
raweffect = mean(individdataRT{1} - individdataRT{2})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('Intact vs Occ')
[H,P,~,STATS] = ttest(individdataRT{1}, individdataRT{3})
%for bayes
raweffect = mean(individdataRT{1} - individdataRT{3})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelSh')
[H,P,~,STATS] = ttest(individdataRT{1}, individdataRT{4})
%for bayes
raweffect = mean(individdataRT{1} - individdataRT{4})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelFuzz')
[H,P,~,STATS] = ttest(individdataRT{1}, individdataRT{5})
%for bayes
raweffect = mean(individdataRT{1} - individdataRT{5})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs Occ')
[H,P,~,STATS] = ttest(individdataRT{2}, individdataRT{3})
%for bayes
raweffect = mean(individdataRT{2} - individdataRT{3})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelSh')
[H,P,~,STATS] = ttest(individdataRT{2}, individdataRT{4})
%for bayes
raweffect = mean(individdataRT{2} - individdataRT{4})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelFuzz')
[H,P,~,STATS] = ttest(individdataRT{2}, individdataRT{5})
%for bayes
raweffect = mean(individdataRT{2} - individdataRT{5})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelSh')
[H,P,~,STATS] = ttest(individdataRT{3}, individdataRT{4})
%for bayes
raweffect = mean(individdataRT{3} - individdataRT{4})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelFuzz')
[H,P,~,STATS] = ttest(individdataRT{3}, individdataRT{5})
%for bayes
raweffect = mean(individdataRT{3} - individdataRT{5})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSh vs DelFuzz')
[H,P,~,STATS] = ttest(individdataRT{4}, individdataRT{5})
%for bayes
raweffect = mean(individdataRT{4} - individdataRT{5})
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%% figure
figure; plot(1:5, results(1:5,1,1), 'ro-') %intact
hold on;
plot(1:5, results(1:5,1,2), 'bs-') %BS
plot(1:5, results(1:5,1,3), 'go-') %occl
plot(1:5, results(1:5,1,4), 'kx-') %del sharp
plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 ntrialseachcond+0.5])
[leg] = legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Northwest');
ax = findobj(gcf,'type','axes'); %Retrieve the axes to be copied
hold off;


colorpoints(1) = 'r';
colorpoints(2) = 'b';
colorpoints(3) = 'g';
colorpoints(4) = 'k';
colorpoints(5) = 'c';

markershape(1) = 's';
markershape(2) = 'd';
markershape(3) = 'o';
markershape(4) = 'x';
markershape(5) = '*';

%% psignifit stuff
psignifitdata = zeros(5,3,5);
psignifitdata(1,1,:) = 0.25;
psignifitdata(2,1,:) = 0.30;
psignifitdata(3,1,:) = 0.35;
psignifitdata(4,1,:) = 0.40;
psignifitdata(5,1,:) = 0.45;

psignifitdata(:,2,1) = results(:,:,1)/ntrialseachcond;
psignifitdata(:,2,2) = results(:,:,2)/ntrialseachcond;
psignifitdata(:,2,3) = results(:,:,3)/ntrialseachcond;
psignifitdata(:,2,4) = results(:,:,4)/ntrialseachcond;
psignifitdata(:,2,5) = results(:,:,5)/ntrialseachcond;
psignifitdata(:,3,:) = ntrialseachcond;

figure;
psychometricfig = gcf;
% ax = findobj(gcf,'type','axes'); %Retrieve the axes to be copied


% legh = legend(ax);
% copyobj([legh,ax],psychometricfig);

axes1 = axes('Parent',psychometricfig);
box(axes1,'on');
hold(axes1,'on');

for condition = 1:5
%     plotpd(psignifitdata(:,:,condition), 'Color', colorpoints(condition), 'MarkerSize',20)  % plots the points
%     plot(psignifitdata(:,:,condition), 'Color', colorpoints(condition), 'MarkerSize',20)  % plots the points
    
    plot(psignifitdata(:,1,1)', psignifitdata(:,2,condition), 'LineStyle', 'None', 'Color', colorpoints(condition), 'Marker', markershape(condition), 'MarkerSize', 10) %intact
%     legend('1', '2')
    hold on
end

legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Southeast');

for condition = 1:5
    plotpd(psignifitdata(:,:,condition), 'LineStyle', 'None', 'Color', colorpoints(condition), 'Marker', markershape(condition), 'MarkerFaceColor', 'None','MarkerSize', 5)  % plots the points
    shape = 'cumulative Gaussian';   % what curve you want to fit
    prefs = batch('shape', shape, 'n_intervals', 1, 'runs', 2000);
    % n intervals corresponds to the space between the choices I think, runs is
    % how many bootstrap fittings you want to do
    
    outputPrefs = batch('write_pa', 'pa', 'write_th', 'th','write_st','st', 'write_sl', 'sl');
    % outputPrefs = batch('params', 'pa');
    % this just chooses what you want out of it - I wanted thresholds and
    % errors
    
    h2(condition,:) = psignifit(psignifitdata(:,:,condition), [prefs outputPrefs]);
    % h2 = pfit(data, [prefs]);
    % h2 = pfit(data, 'shape', shape, 'n_intervals', 1, 2000)
    % this will output it and work out the curve
    plot1(condition) = plotpf(shape, pa.est, 'Color', colorpoints(condition), 'Parent', axes1);
%     plot1(4) = plotpf(shape, pa.est, 'Color', colorpoints(condition), 'Parent', axes1);
    % plotpf(shape, h2.params.est)
    % Plot the fit to the original data
    
    [s, t] = findslope(shape, pa.est);
end

plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')

% plot1 = gcf;
% set(plot1(1),'DisplayName','Intact','Marker','o','Color',[1 0 0]);
% set(plot1(2),'DisplayName','BS','Marker','square','Color',[0 0 1]);
% set(plot1(3),'DisplayName','Occl','Marker','o','Color',[0 1 0]);
% set(plot1(4),'DisplayName','Del Sharp','Marker','x','Color',[0 0 0]);
% set(plot1(5),'DisplayName','Del Fuzz','Marker','x','Color',[0 1 1]);

% Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'Location','northwest');
% legend



% newfig= figure;
% legh = legend(ax);
% % psychometricfig = gcf;
% copyobj([legh,ax],newfig);

hold off;

%% palamedes analysis

disp ('Palamedes...')
%Stimulus intensities
% StimLevels = [0.25 0.30 0.35 0.40 0.45]; 
StimLevels = [0.20 0.30 0.40 0.50 0.60]; 
figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condition = 1:5 %conditions
    
     switch condition
        case 1
            disp('Intact')
        case 2
            disp('Blindspot')
        case 3
            disp('Occluded')
        case 4
            disp('Deleted Sharp')
        case 5
            disp('Deleted Fuzzy')
    end
    
    %Number of positive responses (e.g., 'yes' or 'correct' at each of the
    %   entries of 'StimLevels'
    NumPos = [results(1,:,condition) results(2,:,condition) results(3,:,condition) results(4,:,condition) results(5,:,condition)];
    
    %Number of trials at each entry of 'StimLevels'
    OutOfNum = [ntrialseachcond ntrialseachcond ntrialseachcond ntrialseachcond ntrialseachcond];
    
    
    
    %Use the Logistic function
    PF = @PAL_Logistic;
    %@PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull,
    %PAL_Quick, PAL_logQuick,
    %PAL_CumulativeNormal, PAL_HyperbolicSecant
    
    %Threshold and Slope are free parameters, guess and lapse rate are fixed
    paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
    
    %Parameter grid defining parameter space through which to perform a
    %brute-force search for values to be used as initial guesses in iterative
    %parameter search.
%     searchGrid.alpha = 0.25:.001:.45; %PSE
    searchGrid.alpha = 0.20:.001:.60; %PSE
    searchGrid.beta = logspace(0,1,101); %slope
    searchGrid.gamma = 0.02;  %scalar here (since fixed) but may be vector %guess rate (lower asymptote)
    searchGrid.lambda = 0.02;  %ditto % lapse rate, finger error, upper asympt
    
    %Perform fit
    disp('Fitting function.....');
    [paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels,NumPos, ...
        OutOfNum,searchGrid,paramsFree,PF);
    
    disp('done:')
    message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
    disp(message);
    message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
    disp(message);
    
    %Create simple plot
    ProportionCorrectObserved=NumPos./OutOfNum;
    StimLevelsFineGrain=[min(StimLevels-0.05):max(StimLevels+0.05)./1000:max(StimLevels+0.05)];
    ProportionCorrectModel(condition,:) = PF(paramsValues,StimLevelsFineGrain);
    
%     disp('Goodness of Fit')
%     B = 1000;
%     [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF,'searchGrid', searchGrid);
%   
%     disp(sprintf('Dev: %6.4f',Dev))
%     disp(sprintf('pDev: %6.4f',pDev))
%     disp(sprintf('N converged: %6.4f',sum(converged==1)))
%     disp('--') %empty line
    
    
    plot(StimLevels,ProportionCorrectObserved,'LineStyle', 'None','Color', colorpoints(condition),'Marker',markershape(condition),'MarkerFaceColor', 'None','markersize',10);  
end

legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Southeast');

for condition = 1:5
     plot(StimLevelsFineGrain,ProportionCorrectModel(condition,:),'-','color',colorpoints(condition),'linewidth',2);
end



set(gca, 'fontsize',14);
% set(gca, 'Xtick',StimLevels);
set(gca, 'Xtick',[0.20 0.30 0.40 0.50 0.60]);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - cycles per deg SF');
ylabel('Proportion "Comparison More Stripes"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')
plot([0.489 0.489], [0 1], 'LineStyle', '--')


%% all results, stats

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

% 25-45 or 20-60 analysis?
analysis_group = 25; %25 or 20

if analysis_group == 25
    allsubs = [1:38]; %all good subs for 25-45
elseif analysis_group == 20
    allsubs = [38:64]; %all good subs for 20-60
end

% 
% % %outliers (all bad subs for both 25-45 and 20-60) *old analysis prior to
% % 18/07/2019
% subjectsIntactOutliers = [1, 3, 13, 44, 47, 56, 57, 59];
% subjectsBSOutliers = [1, 3, 19, 26, 29, 32, 36, 41, 44, 48, 50, 56, 57, 59];
% subjectsOccOutliers = [1, 8, 12, 13, 17, 19, 20, 22, 27, 29, 32, 36, 37, 38, 40, 44, 45, 48, 50, 52, 56, 57, 59, 64];
% subjectsDelShOutliers = [1, 16, 19, 20, 26, 27, 29, 32, 37, 38, 40, 41, 42, 44, 45, 46, 48, 56, 57, 59, 64];
% subjectsDelFuzzOutliers = [1, 18, 19, 20, 27, 29, 31, 32, 37, 38, 40, 44, 45, 50, 53, 56, 57, 59, 64];


% %outliers (all bad subs for both 25-45 and 20-60) *new analysis after
% 18/07/2019, when spotted mistake with sub48 & mistake in IntactOutlier
% (was removing 3 instead of 4
subjectsIntactOutliers = [1, 4, 13, 44, 47, 56, 57, 59];
subjectsBSOutliers = [1, 3, 19, 26, 29, 32, 36, 41, 44, 48, 50, 56, 57, 59];
subjectsOccOutliers = [1, 8, 12, 13, 17, 19, 20, 22, 27, 29, 32, 36, 37, 38, 40, 44, 45, 48, 50, 52, 56, 57, 59, 64];
subjectsDelShOutliers = [1, 16, 19, 20, 26, 27, 29, 32, 37, 38, 40, 41, 42, 44, 45, 46, 56, 57, 59, 64];
subjectsDelFuzzOutliers = [1, 18, 19, 20, 27, 29, 31, 32, 37, 38, 40, 44, 45, 48, 50, 53, 56, 57, 59, 64];


if removeoutliers %overwrite the sublists
    
    
    if analysis_group == 20
        
        % everything
        subjectsIntact20_60 = [allsubs];
        subjectsBS20_60 = [allsubs];
        subjectsOcc20_60 = [allsubs];
        subjectsDelSh20_60 = [allsubs];
        subjectsDelFuzz20_60 = [allsubs];
        
        
        subjectsIntact20_60 = setdiff(subjectsIntact20_60, subjectsIntactOutliers);
        subjectsBS20_60 = setdiff(subjectsBS20_60,subjectsBSOutliers);
        subjectsOcc20_60 = setdiff(subjectsOcc20_60, subjectsOccOutliers);
        subjectsDelSh20_60 = setdiff(subjectsDelSh20_60,subjectsDelShOutliers);
        subjectsDelFuzz20_60 = setdiff(subjectsDelFuzz20_60, subjectsDelFuzzOutliers);
    else
        
        
        % everything
        subjectsIntact = [allsubs];
        subjectsBS = [allsubs];
        subjectsOcc = [allsubs];
        subjectsDelSh = [allsubs];
        subjectsDelFuzz = [allsubs];
        
        subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
        subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
        subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
        subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
        subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
        
    end
end


if analysis_group == 20
    %means for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    meanIntactPSE20_60 = nanmean(Data_20_60.PSE.Intact);
    meanBSPSE20_60 = nanmean(Data_20_60.PSE.BS);
    meanOccludedPSE20_60 = nanmean(Data_20_60.PSE.Occluded);
    meanDelShPSE20_60 = nanmean(Data_20_60.PSE.DeletedSharp);
    meanDelFuzPSE20_60 = nanmean(Data_20_60.PSE.DeletedFuzzy);
else
    %means for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    meanIntactPSE25_45 = nanmean(Data_25_45.PSE.Intact);
    meanBSPSE25_45 = nanmean(Data_25_45.PSE.BS);
    meanOccludedPSE25_45 = nanmean(Data_25_45.PSE.Occluded);
    meanDelShPSE25_45 = nanmean(Data_25_45.PSE.DeletedSharp);
    meanDelFuzPSE25_45 = nanmean(Data_25_45.PSE.DeletedFuzzy);
end

if analysis_group == 20
    %means for good subs only
    meanIntactPSE20_60_good = nanmean(Data_20_60.PSE.Intact(subjectsIntact20_60-37));
    meanBSPSE20_60_good = nanmean(Data_20_60.PSE.BS(subjectsBS20_60-37));
    meanOccludedPSE20_60_good = nanmean(Data_20_60.PSE.Occluded(subjectsOcc20_60-37));
    meanDelShPSE20_60_good = nanmean(Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37));
    meanDelFuzPSE20_60_good = nanmean(Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37));
else
    %means for good subs only
    meanIntactPSE25_45_good = nanmean(Data_25_45.PSE.Intact(subjectsIntact));
    meanBSPSE25_45_good = nanmean(Data_25_45.PSE.BS(subjectsBS));
    meanOccludedPSE25_45_good = nanmean(Data_25_45.PSE.Occluded(subjectsOcc));
    meanDelShPSE25_45_good = nanmean(Data_25_45.PSE.DeletedSharp(subjectsDelSh));
    meanDelFuzPSE25_45_good = nanmean(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz));
end

if analysis_group == 20
    %medians for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    medianIntactPSE20_60 = nanmedian(Data_20_60.PSE.Intact);
    medianBSPSE20_60 = nanmedian(Data_20_60.PSE.BS);
    medianOccludedPSE20_60 = nanmedian(Data_20_60.PSE.Occluded);
    medianDelShPSE20_60 = nanmedian(Data_20_60.PSE.DeletedSharp);
    medianDelFuzPSE20_60 = nanmedian(Data_20_60.PSE.DeletedFuzzy);
else
    %medians for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    medianIntactPSE25_45 = nanmedian(Data_25_45.PSE.Intact);
    medianBSPSE25_45 = nanmedian(Data_25_45.PSE.BS);
    medianOccludedPSE25_45 = nanmedian(Data_25_45.PSE.Occluded);
    medianDelShPSE25_45 = nanmedian(Data_25_45.PSE.DeletedSharp);
    medianDelFuzPSE25_45 = nanmedian(Data_25_45.PSE.DeletedFuzzy);
end

if analysis_group == 20
    %medians for good subs only
    medianIntactPSE20_60_good = nanmedian(Data_20_60.PSE.Intact(subjectsIntact20_60-37));
    medianBSPSE20_60_good = nanmedian(Data_20_60.PSE.BS(subjectsBS20_60-37));
    medianOccludedPSE20_60_good = nanmedian(Data_20_60.PSE.Occluded(subjectsOcc20_60-37));
    medianDelShPSE20_60_good = nanmedian(Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37));
    medianDelFuzPSE20_60_good = nanmedian(Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37));
else
    %medians for good subs only
    medianIntactPSE25_45_good = nanmedian(Data_25_45.PSE.Intact(subjectsIntact));
    medianBSPSE25_45_good = nanmedian(Data_25_45.PSE.BS(subjectsBS));
    medianOccludedPSE25_45_good = nanmedian(Data_25_45.PSE.Occluded(subjectsOcc));
    medianDelShPSE25_45_good = nanmedian(Data_25_45.PSE.DeletedSharp(subjectsDelSh));
    medianDelFuzPSE25_45_good = nanmedian(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz));
end

%% 25-45
Alldatatoplot25_45 = [];
individdata25_45= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot25_45 = [Data_25_45.PSE.Intact(subjectsIntact); Data_25_45.PSE.BS(subjectsBS); Data_25_45.PSE.Occluded(subjectsOcc); Data_25_45.PSE.DeletedSharp(subjectsDelSh); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];

individdata25_45 = {Data_25_45.PSE.Intact(subjectsIntact); Data_25_45.PSE.BS(subjectsBS); Data_25_45.PSE.Occluded(subjectsOcc); Data_25_45.PSE.DeletedSharp(subjectsDelSh); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)};


%% 20-60
Alldatatoplot20_60 = [];
individdata20_60 =[];
%group data for boxplot 0.20 - 0.60
% -37 cos we are using subs 38-64 but the vector is row 1 to row 27
Alldatatoplot20_60 = [Data_20_60.PSE.Intact(subjectsIntact20_60-37); Data_20_60.PSE.BS(subjectsBS20_60-37); Data_20_60.PSE.Occluded(subjectsOcc20_60-37); Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37)];
groups = [ones(1,length(subjectsIntact20_60))';2*ones(1,length(subjectsBS20_60))'; 3*ones(1,length(subjectsOcc20_60))'; 4*ones(1,length(subjectsDelSh20_60))';5*ones(1,length(subjectsDelFuzz20_60))'];

individdata20_60 = {Data_20_60.PSE.Intact(subjectsIntact20_60-37); Data_20_60.PSE.BS(subjectsBS20_60-37); Data_20_60.PSE.Occluded(subjectsOcc20_60-37); Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37)};

% 
% %group data for boxplot
% Alldatatoplot = [Intact(subjectsIntact,1); BS(subjectsBS,1); Occluded(subjectsOcc,1); DeletedSharp(subjectsDelSh,1); DeletedFuzzy(subjectsDelFuzz,1)];
% groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];

% individdata = {Intact(subjectsIntact,1), BS(subjectsBS,1), Occluded(subjectsOcc,1), DeletedSharp(subjectsDelSh,1), DeletedFuzzy(subjectsDelFuzz,1)};

%% combined for all subs

Alldatatoplot_combined = [Data_25_45.PSE.Intact(subjectsIntact); Data_20_60.PSE.Intact(subjectsIntact20_60-37); Data_25_45.PSE.BS(subjectsBS); Data_20_60.PSE.BS(subjectsBS20_60-37); ...
    Data_25_45.PSE.Occluded(subjectsOcc); Data_20_60.PSE.Occluded(subjectsOcc20_60-37); Data_25_45.PSE.DeletedSharp(subjectsDelSh);Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); ...
    Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz); Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37)];

groups = [ones(1,length(subjectsIntact)+length(subjectsIntact20_60))';2*ones(1,length(subjectsBS)+length(subjectsBS20_60))';...
    3*ones(1,length(subjectsOcc)+length(subjectsOcc20_60))'; 4*ones(1,length(subjectsDelSh)+length(subjectsDelSh20_60))';...
    5*ones(1,length(subjectsDelFuzz)+length(subjectsDelFuzz20_60))'];

individdata_combined = {[Data_25_45.PSE.Intact(subjectsIntact); Data_20_60.PSE.Intact(subjectsIntact20_60-37)]; [Data_25_45.PSE.BS(subjectsBS); Data_20_60.PSE.BS(subjectsBS20_60-37)]; ...
    [Data_25_45.PSE.Occluded(subjectsOcc); Data_20_60.PSE.Occluded(subjectsOcc20_60-37)]; [Data_25_45.PSE.DeletedSharp(subjectsDelSh);Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37)]; ...
    [Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz); Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37)]};
%% make boxplot for PSEs

% 0.25 - 0.45
figure; bx = boxplot(Alldatatoplot25_45,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
plot([0 6],[0.3 0.3], 'g--')
plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata25_45,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE for 0.25 - 0.45 group')
axis([0 6 0.25 0.9])
set(gcf, 'Position', [200, 200, 1600, 900])


%% make boxplot for PSEs

%0.20 - 0.60
figure; bx = boxplot(Alldatatoplot20_60,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
plot([0 6],[0.3 0.3], 'g--')
plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata20_60,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE for 0.20 - 0.60 group')
axis([0 6 0.25 0.9])
set(gcf, 'Position', [200, 200, 1600, 900])


%% make boxplot for PSEs

%combined
figure; bx = boxplot(Alldatatoplot_combined,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
plot([0 6],[0.3 0.3], 'g--')
plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata_combined,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE for both groups')
axis([0 6 0.25 0.9])
set(gcf, 'Position', [200, 200, 1600, 900])

%% significant diffs for PSEs medians for 0.25 - 0.45

disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_25_45.PSE.Intact(subjectsIntact,1),Data_25_45.PSE.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsBS),1),Data_25_45.PSE.BS(intersect(subjectsIntact,subjectsBS),1), 'method','approximate') %paired samples
[H,P,~,STATS] = ttest(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsBS),1),Data_25_45.PSE.BS(intersect(subjectsIntact,subjectsBS),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsBS),1)) - mean(Data_25_45.PSE.BS(intersect(subjectsIntact,subjectsBS),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30
       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_25_45.PSE.Intact(subjectsIntact,1),Data_25_45.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsOcc),1),Data_25_45.PSE.Occluded(intersect(subjectsIntact,subjectsOcc),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsOcc),1),Data_25_45.PSE.Occluded(intersect(subjectsIntact,subjectsOcc),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsOcc),1)) - mean(Data_25_45.PSE.Occluded(intersect(subjectsIntact,subjectsOcc),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.PSE.Intact(subjectsIntact,1),Data_25_45.PSE.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelSh),1))  -  mean(Data_25_45.PSE.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.PSE.Intact(subjectsIntact,1),Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelFuzz),1)) - mean(Data_25_45.PSE.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_25_45.PSE.BS(subjectsBS,1),Data_25_45.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsOcc),1),Data_25_45.PSE.Occluded(intersect(subjectsBS,subjectsOcc),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsOcc),1),Data_25_45.PSE.Occluded(intersect(subjectsBS,subjectsOcc),1))
%for bayes
raweffect = mean(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsOcc),1)) - mean(Data_25_45.PSE.Occluded(intersect(subjectsBS,subjectsOcc),1))
%for bayes
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.PSE.BS(subjectsBS,1),Data_25_45.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelSh),1)) - mean(Data_25_45.PSE.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.PSE.BS(subjectsBS,1),Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelFuzz),1)) - mean(Data_25_45.PSE.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.PSE.Occluded(subjectsOcc,1),Data_25_45.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelSh),1),Data_25_45.PSE.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelSh),1)) - mean(Data_25_45.PSE.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.PSE.Occluded(subjectsOcc,1),Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1)) - mean(Data_25_45.PSE.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.PSE.DeletedSharp(subjectsDelSh,1),Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_25_45.PSE.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.PSE.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),Data_25_45.PSE.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.PSE.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1)) - mean(Data_25_45.PSE.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%% significant diffs for PSEs medians for 0.20 - 0.60

disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1),Data_20_60.PSE.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1),'method','approximate') %paired samples
[H,P,~,STATS] = ttest(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1),Data_20_60.PSE.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))- mean(Data_20_60.PSE.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),Data_20_60.PSE.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),Data_20_60.PSE.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))- mean(Data_20_60.PSE.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.PSE.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.PSE.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),Data_20_60.PSE.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),Data_20_60.PSE.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))- mean(Data_20_60.PSE.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.PSE.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.PSE.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),Data_20_60.PSE.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.PSE.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.PSE.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.DeletedSharp(subjectsDelSh,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_20_60.PSE.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_20_60.PSE.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.PSE.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.PSE.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.PSE.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



%% significant diffs for PSEs medians for combined groups

%  data structures are getting a bit complicated, extract data first and then perform stats, for better readability

Intact_for_IntvsBS = [Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsBS)); Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37))];
BS_for_IntvsBS = [Data_25_45.PSE.BS(intersect(subjectsIntact,subjectsBS)); Data_20_60.PSE.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37))];

Intact_for_IntvsOcc = [Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsOcc)); Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37))];
Occ_for_IntvsOcc = [Data_25_45.PSE.Occluded(intersect(subjectsIntact,subjectsOcc)); Data_20_60.PSE.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37))];

Intact_for_IntvsDelSh = [Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelSh)); Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37))];
DelSh_forIntvsDelSh = [Data_25_45.PSE.DeletedSharp(intersect(subjectsIntact,subjectsDelSh)); Data_20_60.PSE.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37))];

Intact_for_IntvsDelFuzz = [Data_25_45.PSE.Intact(intersect(subjectsIntact,subjectsDelFuzz)); Data_20_60.PSE.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_IntvsDelFuzz = [Data_25_45.PSE.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz)); Data_20_60.PSE.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37))];

BS_for_BSvsOcc = [Data_25_45.PSE.BS(intersect(subjectsBS,subjectsOcc)); Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37))];
Occ_for_BSvsOcc = [Data_25_45.PSE.Occluded(intersect(subjectsBS,subjectsOcc)); Data_20_60.PSE.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37))];

BS_for_BSvsDelSh = [Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelSh)); Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37))];
DelSh_for_BSvsDelSh = [Data_25_45.PSE.DeletedSharp(intersect(subjectsBS,subjectsDelSh)); Data_20_60.PSE.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37))];

BS_for_BSvsDelFuzz = [Data_25_45.PSE.BS(intersect(subjectsBS,subjectsDelFuzz)); Data_20_60.PSE.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_BSvsDelFuzz = [Data_25_45.PSE.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz)); Data_20_60.PSE.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37))];

Occ_for_OccvsDelSh = [Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelSh)); Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37))];
DelSh_OccvsDelSh = [Data_25_45.PSE.DeletedSharp(intersect(subjectsOcc,subjectsDelSh)); Data_20_60.PSE.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37))];

Occ_for_OccvsDelFuzz = [Data_25_45.PSE.Occluded(intersect(subjectsOcc,subjectsDelFuzz)); Data_20_60.PSE.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_OccvsDelFuzz = [Data_25_45.PSE.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz)); Data_20_60.PSE.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37))];

DelSh_for_DelShvsDelFuzz = [Data_25_45.PSE.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz)); Data_20_60.PSE.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_DelShvsDelFuzz = [Data_25_45.PSE.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz)); Data_20_60.PSE.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37))];


disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Intact_for_IntvsBS, BS_for_IntvsBS) %paired samples
       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Intact_for_IntvsOcc, Occ_for_IntvsOcc) 

disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Intact_for_IntvsDelSh, DelSh_forIntvsDelSh)

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Intact_for_IntvsDelFuzz, DelFuzz_for_IntvsDelFuzz)

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(BS_for_BSvsOcc,Occ_for_BSvsOcc) 

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(BS_for_BSvsDelSh, DelSh_for_BSvsDelSh) 

disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(BS_for_BSvsDelFuzz, DelFuzz_for_BSvsDelFuzz) 

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Occ_for_OccvsDelSh, DelSh_OccvsDelSh) 

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Occ_for_OccvsDelFuzz, DelFuzz_for_OccvsDelFuzz) 

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.DeletedSharp(subjectsDelSh,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(DelSh_for_DelShvsDelFuzz, DelFuzz_for_DelShvsDelFuzz) 


%% BS sizes, perceived cpd vs actual cpd in gap conditions


removeoutliers = 1;

% % %outliers
% subjectsIntactOutliers = [];
% subjectsBSOutliers = [19 26];
% subjectsOccOutliers = [1 6 17 19 20 27];
% subjectsDelShOutliers = [1 6 9 19 20 27];
% % subjectsDelFuzzOutliers = [1 19 20 27];
% % 
% % everything 
% subjectsIntact = [1:nSubs];
% subjectsBS = [1:nSubs];
% subjectsOcc = [1:nSubs];
% subjectsDelSh = [1:nSubs];
% subjectsDelFuzz = [1:nSubs];
% 
% if removeoutliers %overwrite the sublists
%     subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
%     subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
%     subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
%     subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
%     subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
% end


%% old calculatations, now have PTE already saved as a variable in the struct
% BS size
BS_Size(:,1);

Barlength = BS_Size(:,1) + 10; %in deg, 10 deg of visible bar outside BS

NcyclesControl = Barlength * 0.3; %control was always 0.3 cpd

Perceived_cpd_BS = BS(subjectsBS,1);

Perceived_cpd_Occ = Occluded(subjectsOcc,1);

Perceived_cpd_DelSh = DeletedSharp(subjectsDelSh,1);

Perceived_cpd_DelFuzz = DeletedFuzzy(subjectsDelFuzz,1);

cpd_veridical = NcyclesControl/10; %10 deg of visible bar

%% BIAS for 0.25-0.45 group
bias_BS =  Data_25_45.PSE.BS(subjectsBS) - Data_25_45.PTE(subjectsBS);
bias_Occ = Data_25_45.PSE.Occluded(subjectsOcc) - Data_25_45.PTE(subjectsOcc);
bias_DelSh =  Data_25_45.PSE.DeletedSharp(subjectsDelSh) - Data_25_45.PTE(subjectsDelSh);
bias_DelFuzz = Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz) - Data_25_45.PTE(subjectsDelFuzz);


medianbias_BS = median(bias_BS)
medianbias_Occ = median(bias_Occ)
medianbias_DelSh = median(bias_DelSh)
medianbias_DelFuzz = median(bias_DelFuzz)


disp('BS')
% [P,H,STATS] = ranksum(Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS))
[P,H,STATS] = signrank(Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS))
[H,P,~,STATS] = ttest(Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS))
%for bayes
raweffect = mean(bias_BS)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30
[H,P,~,STATS] = ttest(bias_BS)

disp('Occluded')
% [P,H,STATS] = ranksum(Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc))
[P,H,STATS] = signrank(Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc))
[H,P,~,STATS] = ttest(Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc))
%for bayes
raweffect = mean(bias_Occ)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('DelSharp')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh))
[P,H,STATS] = signrank(Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh))
[H,P,~,STATS] = ttest(Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh))
%for bayes
raweffect = mean(bias_DelSh)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('DelFuzzy')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz))
[P,H,STATS] = signrank(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz))
[H,P,~,STATS] = ttest(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz))
%for bayes
raweffect = mean(bias_DelFuzz)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30




% figure; plot([1 2], [Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS)])
% axis([0.5 2.5 0.2 1])
% ylabel('CPD')
% % xlabel('VVIQ')
% set(gca,'XTickLabel', {'', 'Perceived cpd BS','', 'cpd veridical',''}) 
% 
% figure; plot([1 2], [Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc)])
% axis([0.5 2.5 0.2 1])
% ylabel('CPD')
% % xlabel('VVIQ')
% set(gca,'XTickLabel', {'','Perceived cpd Occ', '','cpd veridical'}) 
% 
% figure; plot([1 2], [Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh)])
% axis([0.5 2.5 0.2 1])
% ylabel('CPD')
% % xlabel('VVIQ')
% set(gca,'XTickLabel', {'','Perceived cpd DelSh','', 'cpd veridical'}) 
% 
% figure; plot([1 2], [Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz)])
% axis([0.5 2.5 0.2 1])
% ylabel('CPD')
% % xlabel('VVIQ')
% set(gca,'XTickLabel', {'','Perceived cpd DelFuzz', '','cpd veridical'}) 


% boxplot figures

for i = 1:4
    switch i
        case 1
            X = [Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS)];
            Label = {'PSE BS', 'PTE BS'};
        case 2
            X = [Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc)];
            Label = {'PSE Occ', 'PTE Occ'};
        case 3
            X = [Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh)];
            Label = {'PSE DelSh', 'PTE DelSh'};
        case 4
            X = [Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz)];
            Label = {'PSE DelFuzz', 'PTE DelFuzz'};
    end
        
        
    figure; bx = boxplot(X,'Notch','off', 'MedianStyle', 'line');
    ax = gca;
    
    h = get(bx(5,:),{'XData','YData'});
    for k=1:size(h,1)
        patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
        patch(h{k,1},h{k,2},'y');
    end
    ax.Children = ax.Children([end 1:end-1]);
    
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % set(lines,'linewidth',1, 'Color', 'r');
    set(lines,'linewidth',3)
    
    % h = findobj(gca,'Tag','Box');
    % for j=1:length(h)
    %    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
    % end
    % boxplot(Alldatatoplot,groups,'Notch','on')
    
    % patch(get(h,'XData'),get(h,'YData'),'r')
    % patch(groups,Alldatatoplot,'r')
    % patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
    hold on
    plot([0 3],[0.3 0.3], 'g--')
%     plot([0 3],[0.489 0.489], 'g--')
    plotspreadhandles = plotSpread(X,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
    set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);
    
    
    plot([1 2], X)
    
    
    % set(findall(3,'type','line','color','k'),'markerSize',16)
    set(gca, 'fontsize',16);
    set(gca,'XTickLabel', Label)
    set(gca, 'TickDir', 'out')
    ylabel('PSE')
    axis([0.7 2.3 0.25 0.9])
    set(gcf, 'Position', [200, 200, 900, 900])
    
end

%% BIAS for 0.20-0.60 group
bias_BS =  Data_20_60.PSE.BS(subjectsBS20_60-37) - Data_20_60.PTE(subjectsBS20_60-37);
bias_Occ = Data_20_60.PSE.Occluded(subjectsOcc20_60-37) - Data_20_60.PTE(subjectsOcc20_60-37);
bias_DelSh =  Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37) - Data_20_60.PTE(subjectsDelSh20_60-37);
bias_DelFuzz = Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37) - Data_20_60.PTE(subjectsDelFuzz20_60-37);


medianbias_BS = median(bias_BS)
medianbias_Occ = median(bias_Occ)
medianbias_DelSh = median(bias_DelSh)
medianbias_DelFuzz = median(bias_DelFuzz)


disp('BS')
% [P,H,STATS] = ranksum(Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS))
[P,H,STATS] = signrank(Data_20_60.PSE.BS(subjectsBS20_60-37), Data_20_60.PTE(subjectsBS20_60-37))
[H,P,~,STATS] = ttest(Data_20_60.PSE.BS(subjectsBS20_60-37), Data_20_60.PTE(subjectsBS20_60-37))
%for bayes
raweffect = mean(bias_BS)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occluded')
% [P,H,STATS] = ranksum(Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc))
[P,H,STATS] = signrank(Data_20_60.PSE.Occluded(subjectsOcc20_60-37), Data_20_60.PTE(subjectsOcc20_60-37))
[H,P,~,STATS] = ttest(Data_20_60.PSE.Occluded(subjectsOcc20_60-37), Data_20_60.PTE(subjectsOcc20_60-37))
%for bayes
raweffect = mean(bias_Occ)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSharp')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh))
[P,H,STATS] = signrank(Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37), Data_20_60.PTE(subjectsDelSh20_60-37), 'method', 'approximate')
[H,P,~,STATS] = ttest(Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37), Data_20_60.PTE(subjectsDelSh20_60-37))
%for bayes
raweffect = mean(bias_DelSh)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('DelFuzzy')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz))
[P,H,STATS] = signrank(Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37), Data_20_60.PTE(subjectsDelFuzz20_60-37))
[H,P,~,STATS] = ttest(Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37), Data_20_60.PTE(subjectsDelFuzz20_60-37))
%for bayes
raweffect = mean(bias_DelFuzz)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



% boxplot figures

for i = 1:4
    switch i
        case 1
            X = [Data_20_60.PSE.BS(subjectsBS20_60-37), Data_20_60.PTE(subjectsBS20_60-37)];
            Label = {'PSE BS', 'PTE BS'};
        case 2
            X = [Data_20_60.PSE.Occluded(subjectsOcc20_60-37), Data_20_60.PTE(subjectsOcc20_60-37)];
            Label = {'PSE Occ', 'PTE Occ'};
        case 3
            X = [Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37), Data_20_60.PTE(subjectsDelSh20_60-37)];
            Label = {'PSE DelSh', 'PTE DelSh'};
        case 4
            X = [Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37), Data_20_60.PTE(subjectsDelFuzz20_60-37)];
            Label = {'PSE DelFuzz', 'PTE DelFuzz'};
    end
        
        
    figure; bx = boxplot(X,'Notch','off', 'MedianStyle', 'line');
    ax = gca;
    
    h = get(bx(5,:),{'XData','YData'});
    for k=1:size(h,1)
        patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
        patch(h{k,1},h{k,2},'y');
    end
    ax.Children = ax.Children([end 1:end-1]);
    
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % set(lines,'linewidth',1, 'Color', 'r');
    set(lines,'linewidth',3)
    
    % h = findobj(gca,'Tag','Box');
    % for j=1:length(h)
    %    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
    % end
    % boxplot(Alldatatoplot,groups,'Notch','on')
    
    % patch(get(h,'XData'),get(h,'YData'),'r')
    % patch(groups,Alldatatoplot,'r')
    % patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
    hold on
    plot([0 3],[0.3 0.3], 'g--')
    plotspreadhandles = plotSpread(X,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
    set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);
    
    
    plot([1 2], X)
    
    
    % set(findall(3,'type','line','color','k'),'markerSize',16)
    set(gca, 'fontsize',16);
    set(gca,'XTickLabel', Label)
    set(gca, 'TickDir', 'out')
    ylabel('PSE')
    axis([0.7 2.3 0.25 0.9])
    set(gcf, 'Position', [200, 200, 900, 900])
    
end

%% BIAS for combined
bias_BS =  [Data_20_60.PSE.BS(subjectsBS20_60-37); Data_25_45.PSE.BS(subjectsBS)] - [Data_20_60.PTE(subjectsBS20_60-37); Data_25_45.PTE(subjectsBS)];
bias_Occ = [Data_20_60.PSE.Occluded(subjectsOcc20_60-37);Data_25_45.PSE.Occluded(subjectsOcc)] - [Data_20_60.PTE(subjectsOcc20_60-37);Data_25_45.PTE(subjectsOcc)];
bias_DelSh =  [Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_25_45.PSE.DeletedSharp(subjectsDelSh)] - [Data_20_60.PTE(subjectsDelSh20_60-37);Data_25_45.PTE(subjectsDelSh)];
bias_DelFuzz = [Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)] - [Data_20_60.PTE(subjectsDelFuzz20_60-37);Data_25_45.PTE(subjectsDelFuzz)];


medianbias_BS = median(bias_BS)
medianbias_Occ = median(bias_Occ)
medianbias_DelSh = median(bias_DelSh)
medianbias_DelFuzz = median(bias_DelFuzz)


disp('BS')
% [P,H,STATS] = ranksum(Data_25_45.PSE.BS(subjectsBS), Data_25_45.PTE(subjectsBS))
[P,H,STATS] = signrank([Data_20_60.PSE.BS(subjectsBS20_60-37); Data_25_45.PSE.BS(subjectsBS)] , [Data_20_60.PTE(subjectsBS20_60-37); Data_25_45.PTE(subjectsBS)])
disp('Occluded')
% [P,H,STATS] = ranksum(Data_25_45.PSE.Occluded(subjectsOcc), Data_25_45.PTE(subjectsOcc))
[P,H,STATS] = signrank([Data_20_60.PSE.Occluded(subjectsOcc20_60-37);Data_25_45.PSE.Occluded(subjectsOcc)] , [Data_20_60.PTE(subjectsOcc20_60-37);Data_25_45.PTE(subjectsOcc)])
disp('DelSharp')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedSharp(subjectsDelSh), Data_25_45.PTE(subjectsDelSh))
[P,H,STATS] = signrank([Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_25_45.PSE.DeletedSharp(subjectsDelSh)] , [Data_20_60.PTE(subjectsDelSh20_60-37);Data_25_45.PTE(subjectsDelSh)])
disp('DelFuzzy')
% [P,H,STATS] = ranksum(Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz), Data_25_45.PTE(subjectsDelFuzz))
[P,H,STATS] = signrank([Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)] , [Data_20_60.PTE(subjectsDelFuzz20_60-37);Data_25_45.PTE(subjectsDelFuzz)])



% boxplot figures

for i = 1:4
    switch i
        case 1
            X = [[Data_20_60.PSE.BS(subjectsBS20_60-37); Data_25_45.PSE.BS(subjectsBS)] , [Data_20_60.PTE(subjectsBS20_60-37); Data_25_45.PTE(subjectsBS)]];
            Label = {'PSE BS', 'PTE BS'};
        case 2
            X = [[Data_20_60.PSE.Occluded(subjectsOcc20_60-37);Data_25_45.PSE.Occluded(subjectsOcc)] , [Data_20_60.PTE(subjectsOcc20_60-37);Data_25_45.PTE(subjectsOcc)]];
            Label = {'PSE Occ', 'PTE Occ'};
        case 3
            X = [[Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_25_45.PSE.DeletedSharp(subjectsDelSh)] , [Data_20_60.PTE(subjectsDelSh20_60-37);Data_25_45.PTE(subjectsDelSh)]];
            Label = {'PSE DelSh', 'PTE DelSh'};
        case 4
            X = [[Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)] , [Data_20_60.PTE(subjectsDelFuzz20_60-37);Data_25_45.PTE(subjectsDelFuzz)]];
            Label = {'PSE DelFuzz', 'PTE DelFuzz'};
    end
        
        
    figure; bx = boxplot(X,'Notch','off', 'MedianStyle', 'line');
    ax = gca;
    
    h = get(bx(5,:),{'XData','YData'});
    for k=1:size(h,1)
        patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
        patch(h{k,1},h{k,2},'y');
    end
    ax.Children = ax.Children([end 1:end-1]);
    
    lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
    % set(lines,'linewidth',1, 'Color', 'r');
    set(lines,'linewidth',3)
    
    % h = findobj(gca,'Tag','Box');
    % for j=1:length(h)
    %    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
    % end
    % boxplot(Alldatatoplot,groups,'Notch','on')
    
    % patch(get(h,'XData'),get(h,'YData'),'r')
    % patch(groups,Alldatatoplot,'r')
    % patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
    hold on
    plot([0 3],[0.3 0.3], 'g--')
    plotspreadhandles = plotSpread(X,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
    set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);
    
    
    plot([1 2], X)
    
    
    % set(findall(3,'type','line','color','k'),'markerSize',16)
    set(gca, 'fontsize',16);
    set(gca,'XTickLabel', Label)
    set(gca, 'TickDir', 'out')
    ylabel('PSE')
    axis([0.7 2.3 0.25 0.9])
    set(gcf, 'Position', [200, 200, 900, 900])
    
end

%%
%%%%%%%%%%%%%%%%%%%%%%
% SLOPE
%%%%%%%%%%%%%%%%%%%%%%

removeoutliers = 1;

% 25-45 or 20-60 analysis?
analysis_group = 20; %25 or 20

if analysis_group == 25
    allsubs = [1:38]; %all good subs for 25-45
elseif analysis_group == 20
    allsubs = [38:64]; %all good subs for 20-60
end

% 
% % %outliers (all bad subs for both 25-45 and 20-60) * old analysis prior
% % to fixing sub48 on 18/07/2019
% subjectsIntactOutliers = [1, 4, 13, 44, 47, 56, 57, 59];
% subjectsBSOutliers = [1, 3, 41, 44, 48, 56, 57, 59];
% subjectsOccOutliers = [1, 8, 22, 44, 48, 52, 56, 57, 59, 64];
% subjectsDelShOutliers = [1, 16, 26, 41, 42, 44, 46, 48, 56, 57, 59, 64];
% subjectsDelFuzzOutliers = [1, 18, 20, 31, 44, 53, 56, 57, 59, 64];

% %outliers (all bad subs for both 25-45 and 20-60) *new analysis after
% fixing sub48 *
subjectsIntactOutliers = [1, 4, 13, 44, 47, 56, 57, 59];
subjectsBSOutliers = [1, 3, 41, 44, 48, 56, 57, 59];
subjectsOccOutliers = [1, 8, 22, 44, 48, 52, 56, 57, 59, 64];
subjectsDelShOutliers = [1, 16, 26, 41, 42, 44, 46, 56, 57, 59, 64];
subjectsDelFuzzOutliers = [1, 18, 20, 31, 44, 48, 53, 56, 57, 59, 64];

% 
% % %outliers (all bad subs for both 25-45 and 20-60) *new analysis after
% % fixing sub48 * very stringent, remove any slopes where PSE is not
% % converged and outside range, even if slope value is "good"
% subjectsIntactOutliers = [1, 4, 13, 44, 47, 56, 57, 59];
% subjectsBSOutliers = [1, 3, 19, 26, 29, 32, 36, 41, 44, 48, 50, 56, 57, 59];
% subjectsOccOutliers = [1, 8, 12, 13, 17, 19, 20, 22, 27, 29, 32, 36, 37, 38, 40, 44, 45, 48, 50, 52, 56, 57, 59, 64];
% subjectsDelShOutliers = [1, 16, 19, 20, 26, 27, 29, 32, 37, 38, 40, 41, 42, 44, 45, 46, 56, 57, 59, 64];
% subjectsDelFuzzOutliers = [1, 18, 19, 20, 27, 29, 31, 32, 37, 38, 40, 44, 45, 48, 50, 53, 56, 57, 59, 64];

if removeoutliers %overwrite the sublists
    
    
    if analysis_group == 20
        
        % everything
        subjectsIntact20_60 = [allsubs];
        subjectsBS20_60 = [allsubs];
        subjectsOcc20_60 = [allsubs];
        subjectsDelSh20_60 = [allsubs];
        subjectsDelFuzz20_60 = [allsubs];
        
        subjectsIntact20_60 = setdiff(subjectsIntact20_60, subjectsIntactOutliers);
        subjectsBS20_60 = setdiff(subjectsBS20_60,subjectsBSOutliers);
        subjectsOcc20_60 = setdiff(subjectsOcc20_60, subjectsOccOutliers);
        subjectsDelSh20_60 = setdiff(subjectsDelSh20_60,subjectsDelShOutliers);
        subjectsDelFuzz20_60 = setdiff(subjectsDelFuzz20_60, subjectsDelFuzzOutliers);
    else
        % everything
        subjectsIntact = [allsubs];
        subjectsBS = [allsubs];
        subjectsOcc = [allsubs];
        subjectsDelSh = [allsubs];
        subjectsDelFuzz = [allsubs];
        
        subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
        subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
        subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
        subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
        subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
        
    end
end
% 
% if analysis_group == 20
%     %means for all subs (except bad BS and RedFIX task, which are replaced with
%     %NaNs already
%     meanIntactSlope20_60 = nanmean(Data_20_60.Slope.Intact);
%     meanBSSlope20_60 = nanmean(Data_20_60.Slope.BS);
%     meanOccludedSlope20_60 = nanmean(Data_20_60.Slope.Occluded);
%     meanDelShSlope20_60 = nanmean(Data_20_60.Slope.DeletedSharp);
%     meanDelFuzSlope20_60 = nanmean(Data_20_60.Slope.DeletedFuzzy);    
% else
%     %means for all subs (except bad BS and RedFIX task, which are replaced with
%     %NaNs already
%     meanIntactSlope25_45 = nanmean(Data_25_45.Slope.Intact);
%     meanBSSlope25_45 = nanmean(Data_25_45.Slope.BS);
%     meanOccludedSlope25_45 = nanmean(Data_25_45.Slope.Occluded);
%     meanDelShSlope25_45 = nanmean(Data_25_45.Slope.DeletedSharp);
%     meanDelFuzSlope25_45 = nanmean(Data_25_45.Slope.DeletedFuzzy);
% end
% 
% %medians for all subs (except bad BS and RedFIX task, which are replaced with
% %NaNs already
% medianIntactSlope25_45 = nanmedian(Data_25_45.Slope.Intact);
% medianBSSlope25_45 = nanmedian(Data_25_45.Slope.BS);
% medianOccludedSlope25_45 = nanmedian(Data_25_45.Slope.Occluded);
% medianDelShSlope25_45 = nanmedian(Data_25_45.Slope.DeletedSharp);
% medianDelFuzSlope25_45 = nanmedian(Data_25_45.Slope.DeletedFuzzy);
% 
% 
% %medians for all subs (except bad BS and RedFIX task, which are replaced with
% %NaNs already
% medianIntactSlope20_60 = nanmedian(Data_20_60.Slope.Intact);
% medianBSSlope20_60 = nanmedian(Data_20_60.Slope.BS);
% medianOccludedSlope20_60 = nanmedian(Data_20_60.Slope.Occluded);
% medianDelShSlope20_60 = nanmedian(Data_20_60.Slope.DeletedSharp);
% medianDelFuzSlope20_60 = nanmedian(Data_20_60.Slope.DeletedFuzzy);

if analysis_group == 20
    %means for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    meanIntactSlope20_60 = nanmean(Data_20_60.Slope.Intact);
    meanBSSlope20_60 = nanmean(Data_20_60.Slope.BS);
    meanOccludedSlope20_60 = nanmean(Data_20_60.Slope.Occluded);
    meanDelShSlope20_60 = nanmean(Data_20_60.Slope.DeletedSharp);
    meanDelFuzSlope20_60 = nanmean(Data_20_60.Slope.DeletedFuzzy);
else
    %means for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    meanIntactSlope25_45 = nanmean(Data_25_45.Slope.Intact);
    meanBSSlope25_45 = nanmean(Data_25_45.Slope.BS);
    meanOccludedSlope25_45 = nanmean(Data_25_45.Slope.Occluded);
    meanDelShSlope25_45 = nanmean(Data_25_45.Slope.DeletedSharp);
    meanDelFuzSlope25_45 = nanmean(Data_25_45.Slope.DeletedFuzzy);
end

if analysis_group == 20
    %means for good subs only
    meanIntactSlope20_60_good = nanmean(Data_20_60.Slope.Intact(subjectsIntact20_60-37));
    meanBSSlope20_60_good = nanmean(Data_20_60.Slope.BS(subjectsBS20_60-37));
    meanOccludedSlope20_60_good = nanmean(Data_20_60.Slope.Occluded(subjectsOcc20_60-37));
    meanDelShSlope20_60_good = nanmean(Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37));
    meanDelFuzSlope20_60_good = nanmean(Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37));
else
    %means for good subs only
    meanIntactSlope25_45_good = nanmean(Data_25_45.Slope.Intact(subjectsIntact));
    meanBSSlope25_45_good = nanmean(Data_25_45.Slope.BS(subjectsBS));
    meanOccludedSlope25_45_good = nanmean(Data_25_45.Slope.Occluded(subjectsOcc));
    meanDelShSlope25_45_good = nanmean(Data_25_45.Slope.DeletedSharp(subjectsDelSh));
    meanDelFuzSlope25_45_good = nanmean(Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz));
end

if analysis_group == 20
    %medians for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    medianIntactSlope20_60 = nanmedian(Data_20_60.Slope.Intact);
    medianBSSlope20_60 = nanmedian(Data_20_60.Slope.BS);
    medianOccludedSlope20_60 = nanmedian(Data_20_60.Slope.Occluded);
    medianDelShSlope20_60 = nanmedian(Data_20_60.Slope.DeletedSharp);
    medianDelFuzSlope20_60 = nanmedian(Data_20_60.Slope.DeletedFuzzy);
else
    %medians for all subs (except bad BS and RedFIX task, which are replaced with
    %NaNs already
    medianIntactSlope25_45 = nanmedian(Data_25_45.Slope.Intact);
    medianBSSlope25_45 = nanmedian(Data_25_45.Slope.BS);
    medianOccludedSlope25_45 = nanmedian(Data_25_45.Slope.Occluded);
    medianDelShSlope25_45 = nanmedian(Data_25_45.Slope.DeletedSharp);
    medianDelFuzSlope25_45 = nanmedian(Data_25_45.Slope.DeletedFuzzy);
end

if analysis_group == 20
    %medians for good subs only
    medianIntactSlope20_60_good = nanmedian(Data_20_60.Slope.Intact(subjectsIntact20_60-37));
    medianBSSlope20_60_good = nanmedian(Data_20_60.Slope.BS(subjectsBS20_60-37));
    medianOccludedSlope20_60_good = nanmedian(Data_20_60.Slope.Occluded(subjectsOcc20_60-37));
    medianDelShSlope20_60_good = nanmedian(Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37));
    medianDelFuzSlope20_60_good = nanmedian(Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37));
else
    %medians for good subs only
    medianIntactSlope25_45_good = nanmedian(Data_25_45.Slope.Intact(subjectsIntact));
    medianBSSlope25_45_good = nanmedian(Data_25_45.Slope.BS(subjectsBS));
    medianOccludedSlope25_45_good = nanmedian(Data_25_45.Slope.Occluded(subjectsOcc));
    medianDelShSlope25_45_good = nanmedian(Data_25_45.Slope.DeletedSharp(subjectsDelSh));
    medianDelFuzSlope25_45_good = nanmedian(Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz));
end


% 
% %means
% meanIntactSlope = mean(Intact(subjectsIntact,2));
% meanBSSlope = mean(BS(subjectsBS,2));
% meanOccludedSlope = mean(Occluded(subjectsOcc,2));
% meanDelShSlope = mean(DeletedSharp(subjectsDelSh,2));
% meanDelFuzSlope = mean(DeletedFuzzy(subjectsDelFuzz,2));
% 
% %medians
% medianIntactSlope = median(Intact(subjectsIntact,2));
% medianBSSlope = median(BS(subjectsBS,2));
% medianOccludedSlope = median(Occluded(subjectsOcc,2));
% medianDelShSlope = median(DeletedSharp(subjectsDelSh,2));
% medianDelFuzSlope = median(DeletedFuzzy(subjectsDelFuzz,2));


%% 25-45
Alldatatoplot25_45 = [];
individdata25_45= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot25_45 = [Data_25_45.Slope.Intact(subjectsIntact); Data_25_45.Slope.BS(subjectsBS); Data_25_45.Slope.Occluded(subjectsOcc); Data_25_45.Slope.DeletedSharp(subjectsDelSh); Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];

individdata25_45 = {Data_25_45.Slope.Intact(subjectsIntact); Data_25_45.Slope.BS(subjectsBS); Data_25_45.Slope.Occluded(subjectsOcc); Data_25_45.Slope.DeletedSharp(subjectsDelSh); Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz)};


%% 20-60
Alldatatoplot20_60 = [];
individdata20_60 =[];
%group data for boxplot 0.20 - 0.60
% -37 cos we are using subs 38-64 but the vector is row 1 to row 27
Alldatatoplot20_60 = [Data_20_60.Slope.Intact(subjectsIntact20_60-37); Data_20_60.Slope.BS(subjectsBS20_60-37); Data_20_60.Slope.Occluded(subjectsOcc20_60-37); Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37); Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37)];
groups = [ones(1,length(subjectsIntact20_60))';2*ones(1,length(subjectsBS20_60))'; 3*ones(1,length(subjectsOcc20_60))'; 4*ones(1,length(subjectsDelSh20_60))';5*ones(1,length(subjectsDelFuzz20_60))'];

individdata20_60 = {Data_20_60.Slope.Intact(subjectsIntact20_60-37); Data_20_60.Slope.BS(subjectsBS20_60-37); Data_20_60.Slope.Occluded(subjectsOcc20_60-37); Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37); Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37)};


%% combined for all subs

Alldatatoplot_combined = [Data_25_45.Slope.Intact(subjectsIntact); Data_20_60.Slope.Intact(subjectsIntact20_60-37); Data_25_45.Slope.BS(subjectsBS); Data_20_60.Slope.BS(subjectsBS20_60-37); ...
    Data_25_45.Slope.Occluded(subjectsOcc); Data_20_60.Slope.Occluded(subjectsOcc20_60-37); Data_25_45.Slope.DeletedSharp(subjectsDelSh);Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37); ...
    Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz); Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37)];

groups = [ones(1,length(subjectsIntact)+length(subjectsIntact20_60))';2*ones(1,length(subjectsBS)+length(subjectsBS20_60))';...
    3*ones(1,length(subjectsOcc)+length(subjectsOcc20_60))'; 4*ones(1,length(subjectsDelSh)+length(subjectsDelSh20_60))';...
    5*ones(1,length(subjectsDelFuzz)+length(subjectsDelFuzz20_60))'];

individdata_combined = {[Data_25_45.Slope.Intact(subjectsIntact); Data_20_60.Slope.Intact(subjectsIntact20_60-37)]; [Data_25_45.Slope.BS(subjectsBS); Data_20_60.Slope.BS(subjectsBS20_60-37)]; ...
    [Data_25_45.Slope.Occluded(subjectsOcc); Data_20_60.Slope.Occluded(subjectsOcc20_60-37)]; [Data_25_45.Slope.DeletedSharp(subjectsDelSh);Data_20_60.Slope.DeletedSharp(subjectsDelSh20_60-37)]; ...
    [Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz); Data_20_60.Slope.DeletedFuzzy(subjectsDelFuzz20_60-37)]};


% 
% %group data for boxplot
% Alldatatoplot = [Intact(subjectsIntact,2); BS(subjectsBS,2); Occluded(subjectsOcc,2); DeletedSharp(subjectsDelSh,2); DeletedFuzzy(subjectsDelFuzz,2)];
% groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];
% 
% individdata = {Intact(subjectsIntact,2), BS(subjectsBS,2), Occluded(subjectsOcc,2), DeletedSharp(subjectsDelSh,2), DeletedFuzzy(subjectsDelFuzz,2)};



%% significant diffs for slopes

%% significant diffs for PSEs medians for 0.25 - 0.45

disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsBS),1),Data_25_45.Slope.BS(intersect(subjectsIntact,subjectsBS),1),'method','approximate') %paired samples
[H,P,~,STATS] = ttest(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsBS),1),Data_25_45.Slope.BS(intersect(subjectsIntact,subjectsBS),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsBS),1)) - mean(Data_25_45.Slope.BS(intersect(subjectsIntact,subjectsBS),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30
       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsOcc),1),Data_25_45.Slope.Occluded(intersect(subjectsIntact,subjectsOcc),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsOcc),1),Data_25_45.Slope.Occluded(intersect(subjectsIntact,subjectsOcc),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsOcc),1)) - mean(Data_25_45.Slope.Occluded(intersect(subjectsIntact,subjectsOcc),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelSh),1))  -  mean(Data_25_45.Slope.DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1),'method','approximate')
[H,P,~,STATS] = ttest(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelFuzz),1)) - mean(Data_25_45.Slope.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsOcc),1),Data_25_45.Slope.Occluded(intersect(subjectsBS,subjectsOcc),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsOcc),1),Data_25_45.Slope.Occluded(intersect(subjectsBS,subjectsOcc),1))
%for bayes
raweffect = mean(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsOcc),1)) - mean(Data_25_45.Slope.Occluded(intersect(subjectsBS,subjectsOcc),1))
%for bayes
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelSh),1)) - mean(Data_25_45.Slope.DeletedSharp(intersect(subjectsBS,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelFuzz),1)) - mean(Data_25_45.Slope.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.Occluded(subjectsOcc,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelSh),1),Data_25_45.Slope.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelSh),1)) - mean(Data_25_45.Slope.DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.Occluded(subjectsOcc,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelFuzz),1)) - mean(Data_25_45.Slope.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.DeletedSharp(subjectsDelSh,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_25_45.Slope.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1),'method','approximate') 
[H,P,~,STATS] = ttest(Data_25_45.Slope.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),Data_25_45.Slope.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1))
%for bayes
raweffect = mean(Data_25_45.Slope.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1)) - mean(Data_25_45.Slope.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%%%%



%% significant diffs for PSEs medians for 0.20 - 0.60

disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1),Data_20_60.Slope.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1)) %paired samples
[H,P,~,STATS] = ttest(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1),Data_20_60.Slope.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))- mean(Data_20_60.Slope.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30
       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),Data_20_60.Slope.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1),Data_20_60.Slope.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))- mean(Data_20_60.Slope.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),'method', 'approximate')
[H,P,~,STATS] = ttest(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.Slope.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.Intact(subjectsIntact,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),'method', 'approximate')
[H,P,~,STATS] = ttest(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.Slope.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),Data_20_60.Slope.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1),Data_20_60.Slope.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))- mean(Data_20_60.Slope.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.Slope.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.BS(subjectsBS,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.Slope.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_25_45.Slope.Occluded(subjectsOcc,1),Data_25_45.Slope.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1),Data_20_60.Slope.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))- mean(Data_20_60.Slope.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.Occluded(subjectsOcc,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.Slope.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_25_45.Slope.DeletedSharp(subjectsDelSh,1),Data_25_45.Slope.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Data_20_60.Slope.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),'method', 'approximate') 
[H,P,~,STATS] = ttest(Data_20_60.Slope.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1),Data_20_60.Slope.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))
%for bayes
raweffect = mean(Data_20_60.Slope.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))- mean(Data_20_60.Slope.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37),1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30
%%%%%%%%%%% 

%% significant diffs for PSEs medians for combined groups

%  data structures are getting a bit complicated, extract data first and then perform stats, for better readability

Intact_for_IntvsBS = [Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsBS)); Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsBS20_60-37))];
BS_for_IntvsBS = [Data_25_45.Slope.BS(intersect(subjectsIntact,subjectsBS)); Data_20_60.Slope.BS(intersect(subjectsIntact20_60-37,subjectsBS20_60-37))];

Intact_for_IntvsOcc = [Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsOcc)); Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37))];
Occ_for_IntvsOcc = [Data_25_45.Slope.Occluded(intersect(subjectsIntact,subjectsOcc)); Data_20_60.Slope.Occluded(intersect(subjectsIntact20_60-37,subjectsOcc20_60-37))];

Intact_for_IntvsDelSh = [Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelSh)); Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37))];
DelSh_forIntvsDelSh = [Data_25_45.Slope.DeletedSharp(intersect(subjectsIntact,subjectsDelSh)); Data_20_60.Slope.DeletedSharp(intersect(subjectsIntact20_60-37,subjectsDelSh20_60-37))];

Intact_for_IntvsDelFuzz = [Data_25_45.Slope.Intact(intersect(subjectsIntact,subjectsDelFuzz)); Data_20_60.Slope.Intact(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_IntvsDelFuzz = [Data_25_45.Slope.DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz)); Data_20_60.Slope.DeletedFuzzy(intersect(subjectsIntact20_60-37,subjectsDelFuzz20_60-37))];

BS_for_BSvsOcc = [Data_25_45.Slope.BS(intersect(subjectsBS,subjectsOcc)); Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsOcc20_60-37))];
Occ_for_BSvsOcc = [Data_25_45.Slope.Occluded(intersect(subjectsBS,subjectsOcc)); Data_20_60.Slope.Occluded(intersect(subjectsBS20_60-37,subjectsOcc20_60-37))];

BS_for_BSvsDelSh = [Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelSh)); Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37))];
DelSh_for_BSvsDelSh = [Data_25_45.Slope.DeletedSharp(intersect(subjectsBS,subjectsDelSh)); Data_20_60.Slope.DeletedSharp(intersect(subjectsBS20_60-37,subjectsDelSh20_60-37))];

BS_for_BSvsDelFuzz = [Data_25_45.Slope.BS(intersect(subjectsBS,subjectsDelFuzz)); Data_20_60.Slope.BS(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_BSvsDelFuzz = [Data_25_45.Slope.DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz)); Data_20_60.Slope.DeletedFuzzy(intersect(subjectsBS20_60-37,subjectsDelFuzz20_60-37))];

Occ_for_OccvsDelSh = [Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelSh)); Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37))];
DelSh_OccvsDelSh = [Data_25_45.Slope.DeletedSharp(intersect(subjectsOcc,subjectsDelSh)); Data_20_60.Slope.DeletedSharp(intersect(subjectsOcc20_60-37,subjectsDelSh20_60-37))];

Occ_for_OccvsDelFuzz = [Data_25_45.Slope.Occluded(intersect(subjectsOcc,subjectsDelFuzz)); Data_20_60.Slope.Occluded(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_OccvsDelFuzz = [Data_25_45.Slope.DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz)); Data_20_60.Slope.DeletedFuzzy(intersect(subjectsOcc20_60-37,subjectsDelFuzz20_60-37))];

DelSh_for_DelShvsDelFuzz = [Data_25_45.Slope.DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz)); Data_20_60.Slope.DeletedSharp(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37))];
DelFuzz_for_DelShvsDelFuzz = [Data_25_45.Slope.DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz)); Data_20_60.Slope.DeletedFuzzy(intersect(subjectsDelSh20_60-37,subjectsDelFuzz20_60-37))];


disp('Intact vs BS')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Intact_for_IntvsBS, BS_for_IntvsBS) %paired samples
       
disp('Intact vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Intact_for_IntvsOcc, Occ_for_IntvsOcc) 

disp('Intact vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Intact_for_IntvsDelSh, DelSh_forIntvsDelSh)

disp('Intact vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Intact(subjectsIntact,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Intact_for_IntvsDelFuzz, DelFuzz_for_IntvsDelFuzz)

disp('BS vs Occ')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(BS_for_BSvsOcc,Occ_for_BSvsOcc) 

disp('BS vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(BS_for_BSvsDelSh, DelSh_for_BSvsDelSh) 

disp('BS vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.BS(subjectsBS,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(BS_for_BSvsDelFuzz, DelFuzz_for_BSvsDelFuzz) 

disp('Occ vs DelSh')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Occ_for_OccvsDelSh, DelSh_OccvsDelSh) 

disp('Occ vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.Occluded(subjectsOcc,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Occ_for_OccvsDelFuzz, DelFuzz_for_OccvsDelFuzz) 

disp('DelSh vs DelFuzz')
% [p,h,stats] = ranksum(Data_20_60.PSE.DeletedSharp(subjectsDelSh,1),Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(DelSh_for_DelShvsDelFuzz, DelFuzz_for_DelShvsDelFuzz) 


% % disp('Intact vs BS')
% % [p,h,stats] = ranksum(Intact(subjectsIntact,2),BS(subjectsBS,2))
% % [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),2),BS(intersect(subjectsIntact,subjectsBS),2))
% %        
% % disp('Intact vs Occ')
% % [p,h,stats] = ranksum(Intact(subjectsIntact,2),Occluded(subjectsOcc,2)) 
% % [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsOcc),2),Occluded(intersect(subjectsIntact,subjectsOcc),2)) 
% % 
% % disp('Intact vs DelSh')
% % [p,h,stats] = ranksum(Intact(subjectsIntact,2),DeletedSharp(subjectsDelSh,2))
% % [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelSh),2),DeletedSharp(intersect(subjectsIntact,subjectsDelSh),2))
% % 
% % disp('Intact vs DelFuzz')
% % [p,h,stats] = ranksum(Intact(subjectsIntact,2),DeletedFuzzy(subjectsDelFuzz,2))
% % [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),2))
% % 
% % disp('BS vs Occ')
% % [p,h,stats] = ranksum(BS(subjectsBS,2),Occluded(subjectsOcc,2)) 
% % [p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsOcc),2),Occluded(intersect(subjectsBS,subjectsOcc),2)) 
% % 
% % disp('BS vs DelSh')
% % [p,h,stats] = ranksum(BS(subjectsBS,2),DeletedSharp(subjectsDelSh,2)) 
% % [p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelSh),2),DeletedSharp(intersect(subjectsBS,subjectsDelSh),2))
% % 
% % disp('BS vs DelFuzz')
% % [p,h,stats] = ranksum(BS(subjectsBS,2),DeletedFuzzy(subjectsDelFuzz,2))
% % [p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),2)) 
% % 
% % disp('Occ vs DelSh')
% % [p,h,stats] = ranksum(Occluded(subjectsOcc,2),DeletedSharp(subjectsDelSh,2)) 
% % [p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelSh),2),DeletedSharp(intersect(subjectsOcc,subjectsDelSh),2)) 
% % 
% % disp('Occ vs DelFuzz')
% % [p,h,stats] = ranksum(Occluded(subjectsOcc,2),DeletedFuzzy(subjectsDelFuzz,2)) 
% % [p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),2)) 
% % 
% % disp('DelSh vs DelFuzz')
% % [p,h,stats] = ranksum(DeletedSharp(subjectsDelSh,2),DeletedFuzzy(subjectsDelFuzz,2)) 
% % [p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),2)) 



%% make boxplot for slopes 0.25 - 0.45
figure; bx = boxplot(Alldatatoplot25_45,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
% plot([0 6],[0.3 0.3], 'g--')
plotspreadhandles = plotSpread(individdata25_45,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope for 0.25 - 0.45 group')
axis([0 6 -5 90])
set(gcf, 'Position', [200, 200, 1600, 900])


%% make boxplot for slopes 0.20 - 0.60
figure; bx = boxplot(Alldatatoplot20_60,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
% plot([0 6],[0.3 0.3], 'g--')
plotspreadhandles = plotSpread(individdata20_60,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope for 0.20 - 0.60 group')
axis([0 6 155 250])
axis([0 6 -5 90])
set(gcf, 'Position', [200, 200, 1600, 900])

%% make boxplot for slopes 0.20 - 0.60
figure; bx = boxplot(Alldatatoplot_combined,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
   patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
   patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),'y');
% end
% boxplot(Alldatatoplot,groups,'Notch','on')

% patch(get(h,'XData'),get(h,'YData'),'r')
% patch(groups,Alldatatoplot,'r')
% patch(get(h,'XData'),get(h,'YData'),color(length(h)),'FaceAlpha',.5)
hold on
% plot([0 6],[0.3 0.3], 'g--')
plotspreadhandles = plotSpread(individdata_combined,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope for 0.20 - 0.60 group')
axis([0 6 -5 90])
set(gcf, 'Position', [200, 200, 1600, 900])



%% VVIQ PSE

% % 
% % % %outliers
% % subjectsIntactOutliers = [];
% % subjectsBSOutliers = [19 26];
% % subjectsOccOutliers = [1 6 17 19 20 27];
% % subjectsDelShOutliers = [1 6 9 19 20 27];
% % subjectsDelFuzzOutliers = [1 19 20 27];
% 
% % or keep everything 
% subjectsIntact = [1:27];
% subjectsBS = [1:27];
% subjectsOcc = [1:27];
% subjectsDelSh = [1:27];
% subjectsDelFuzz = [1:27];




removeoutliers = 1;

%%% 25-45 or 20-60 analysis?
analysis_group = 20; %25 or 20

if analysis_group == 25
    allsubs = [1:38]; %all good subs for 25-45
elseif analysis_group == 20
    allsubs = [38:64]; %all good subs for 20-60
end

% %outliers (all bad subs for both 25-45 and 20-60)
subjectsIntactOutliers = [1, 3, 13, 44, 47, 56, 57, 59];
subjectsBSOutliers = [1, 3, 19, 26, 29, 32, 36, 41, 44, 48, 50, 56, 57, 59];
subjectsOccOutliers = [1, 8, 12, 13, 17, 19, 20, 22, 27, 29, 32, 36, 37, 38, 40, 44, 45, 48, 50, 52, 56, 57, 59, 64];
subjectsDelShOutliers = [1, 16, 19, 20, 26, 27, 29, 32, 37, 38, 40, 41, 42, 44, 45, 46, 48, 56, 57, 59, 64];
subjectsDelFuzzOutliers = [1, 18, 19, 20, 27, 29, 31, 32, 37, 38, 40, 44, 45, 50, 53, 56, 57, 59, 64];


if removeoutliers %overwrite the sublists
    
    
   if analysis_group == 20
        
        % everything
        subjectsIntact20_60 = [allsubs];
        subjectsBS20_60 = [allsubs];
        subjectsOcc20_60 = [allsubs];
        subjectsDelSh20_60 = [allsubs];
        subjectsDelFuzz20_60 = [allsubs];
        
        
        subjectsIntact20_60 = setdiff(subjectsIntact20_60, subjectsIntactOutliers);
        subjectsBS20_60 = setdiff(subjectsBS20_60,subjectsBSOutliers);
        subjectsOcc20_60 = setdiff(subjectsOcc20_60, subjectsOccOutliers);
        subjectsDelSh20_60 = setdiff(subjectsDelSh20_60,subjectsDelShOutliers);
        subjectsDelFuzz20_60 = setdiff(subjectsDelFuzz20_60, subjectsDelFuzzOutliers);
   
   else  
        % everything
        subjectsIntact = [allsubs];
        subjectsBS = [allsubs];
        subjectsOcc = [allsubs];
        subjectsDelSh = [allsubs];
        subjectsDelFuzz = [allsubs];
        
        subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
        subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
        subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
        subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
        subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
   end
    
end


% 
% if removeoutliers %overwrite the sublists
%     subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
%     subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
%     subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
%     subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
%     subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
% end


% calculate bias for all subs
bias_BS =  [Data_20_60.PSE.BS(subjectsBS20_60-37); Data_25_45.PSE.BS(subjectsBS)] - [Data_20_60.PTE(subjectsBS20_60-37); Data_25_45.PTE(subjectsBS)];
VVIQ_BS = VVIQ([subjectsBS20_60, subjectsBS])
bias_Occ = [Data_20_60.PSE.Occluded(subjectsOcc20_60-37);Data_25_45.PSE.Occluded(subjectsOcc)] - [Data_20_60.PTE(subjectsOcc20_60-37);Data_25_45.PTE(subjectsOcc)];
VVIQ_Occ = VVIQ([subjectsOcc20_60, subjectsOcc])
bias_DelSh =  [Data_20_60.PSE.DeletedSharp(subjectsDelSh20_60-37); Data_25_45.PSE.DeletedSharp(subjectsDelSh)] - [Data_20_60.PTE(subjectsDelSh20_60-37);Data_25_45.PTE(subjectsDelSh)];
VVIQ_DelSh = VVIQ([subjectsDelSh20_60, subjectsDelSh])
bias_DelFuzz = [Data_20_60.PSE.DeletedFuzzy(subjectsDelFuzz20_60-37); Data_25_45.PSE.DeletedFuzzy(subjectsDelFuzz)] - [Data_20_60.PTE(subjectsDelFuzz20_60-37);Data_25_45.PTE(subjectsDelFuzz)];
VVIQ_DelFuzz = VVIQ([subjectsDelFuzz20_60, subjectsDelFuzz])
%% VVIQ plot BS
[r p] = corrcoef(VVIQ_BS, bias_BS, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ_BS, bias_BS, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ_BS, bias_BS, 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias BS')
xlabel('Imagery Strength')
axis([1 5 -0.3 0.5])
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

bootstraptimes = 10000;
%try some bootstrap
% for sb_av = 2:3 %for sb and av
%     for x = 1:3 %for condition 1 to 3
%         for c = 1:nSubs, %for each subject
           collboot = bootstrp(bootstraptimes, @(bootr)[corrcoef(bootr,'rows','complete')], [VVIQ_BS, bias_BS]);
            collboot = sort(collboot(:,2));
            collbootZ = fisherztransform(collboot);
            submean = collbootZ(bootstraptimes*.5);
%             testindresults(c) = submean(c,x,sb_av); % pc(:,2) sb, 3 = av
%         end
 
%         testboot = bootstrp(bootstraptimes,@mean,testindresults); %bootstrap the means 5000 times
%         testboot = sort(testboot); %sort this
%         testboot(bootstraptimes*.025); %test at alpha level 0.05. 0.025 because it's two-sided test
        values = {[collbootZ(bootstraptimes*.025) collbootZ(bootstraptimes*.5) collbootZ(bootstraptimes*.975)]}; %save the mean and CI
%         themean(sb_av,x) = testboot(bootstraptimes*.5); %mean
        ci_lo = submean - [collbootZ(bootstraptimes*.025)]; %mean - 2.5th %tile = low CI
        ci_hi = collbootZ(bootstraptimes*.975) - submean; % 97.5th %tile = high CI
%     end %cond1/2
% end %sb/av


%% VVIQ plot occl
[r p] = corrcoef(VVIQ_Occ, bias_Occ, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ_Occ, bias_Occ, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ_Occ, bias_Occ, 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias Occ')
xlabel('Imagery Strength')
axis([1 5 -0.3 0.5])
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ plot delet sharp
[r p] = corrcoef(VVIQ_DelSh, bias_DelSh, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ_DelSh, bias_DelSh, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ_DelSh, bias_DelSh, 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias DelSh')
xlabel('Imagery Strength')
axis([1 5 -0.3 0.5])
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ deleted fuzzy
[r p] = corrcoef(VVIQ_DelFuzz, bias_DelFuzz, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ_DelFuzz, bias_DelFuzz, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ_DelFuzz, bias_DelFuzz, 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias DelFuzz')
xlabel('Imagery Strength')
axis([1 5 -0.3 0.5])
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ slopes
% Get data

removeoutliers = 0;

% % %outliers
% subjectsIntactOutliers = [];
% subjectsBSOutliers = [19 26];
% subjectsOccOutliers = [1 6 17 19 20 27];
% subjectsDelShOutliers = [1 6 9 19 20 27];
% subjectsDelFuzzOutliers = [1 19 20 27];
% 
% % or keep everything 
% subjectsIntact = [1:27];
% subjectsBS = [1:27];
% subjectsOcc = [1:27];
% subjectsDelSh = [1:27];
% subjectsDelFuzz = [1:27];


if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
end


%% VVIQ plot BS
[r p] = corrcoef(VVIQ(subjectsBS), BS(subjectsBS,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsBS), BS(subjectsBS,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsBS), BS(subjectsBS,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Slope')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))


%% VVIQ plot occl
[r p] = corrcoef(VVIQ(subjectsOcc), Occluded(subjectsOcc,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsOcc), Occluded(subjectsOcc,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsOcc), Occluded(subjectsOcc,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Slope')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ plot delet sharp
[r p] = corrcoef(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Slope')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))


%% VVIQ deleted fuzzy
[r p] = corrcoef(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Slope')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% correlation of Slopes



subjectsIntactBS = intersect(subjectsIntact, subjectsBS);
subjectsIntactcOcc = intersect(subjectsIntact,subjectsOcc);
subjectsIntactDelSh = intersect(subjectsIntact, subjectsDelSh);
subjectsIntactDelFuzz = intersect(subjectsIntact,subjectsDelFuzz);

subjectsBSOcc = intersect(subjectsBS, subjectsOcc);
subjectsBSDelSh = intersect(subjectsBS,subjectsDelSh);
subjectsBSDelFuzz = intersect(subjectsBS, subjectsDelFuzz);

subjectsOccDelSh = intersect(subjectsOcc,subjectsDelSh);
subjectsOccDelFuzz = intersect(subjectsOcc, subjectsDelFuzz);

subjectsDelShDelFuzz = intersect(subjectsDelSh,subjectsDelFuzz);




%removed outliers
% IntactSubs = [1:27];
% OccludedSubs = [2:27];
% DeletedSharpSubs = [1:5, 7, 10:27];
% DeletedFuzzySubs = [1:7, 9:27];

[r p] = corrcoef(Intact(subjectsIntactBS,2), BS(subjectsIntactBS,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Intact(subjectsIntactBS,2), BS(subjectsIntactBS,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Intact(subjectsIntactBS,2), BS(subjectsIntactBS,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('BS Slope')
xlabel('Intact slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(Intact(subjectsIntactcOcc,2), Occluded(subjectsIntactcOcc,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Intact(subjectsIntactcOcc,2), Occluded(subjectsIntactcOcc,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Intact(subjectsIntactcOcc,2), Occluded(subjectsIntactcOcc,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Occluded Slope')
xlabel('Intact slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(Intact(subjectsIntactDelSh,2), DeletedSharp(subjectsIntactDelSh,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Intact(subjectsIntactDelSh,2), DeletedSharp(subjectsIntactDelSh,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Intact(subjectsIntactDelSh,2), DeletedSharp(subjectsIntactDelSh,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Sharp Slope')
xlabel('Intact slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(Intact(subjectsIntactDelFuzz,2), DeletedFuzzy(subjectsIntactDelFuzz,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Intact(subjectsIntactDelFuzz,2), DeletedFuzzy(subjectsIntactDelFuzz,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Intact(subjectsIntactDelFuzz,2), DeletedFuzzy(subjectsIntactDelFuzz,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Fuzzy Slope')
xlabel('Intact slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(BS(subjectsBSOcc,2), Occluded(subjectsBSOcc,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS(subjectsBSOcc,2), Occluded(subjectsBSOcc,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(BS(subjectsBSOcc,2), Occluded(subjectsBSOcc,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Occluded Slope')
xlabel('BS slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(BS(subjectsBSDelSh,2), DeletedSharp(subjectsBSDelSh,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS(subjectsBSDelSh,2), DeletedSharp(subjectsBSDelSh,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(BS(subjectsBSDelSh,2), DeletedSharp(subjectsBSDelSh,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Sharp Slope')
xlabel('BS slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(BS(subjectsBSDelFuzz,2), DeletedFuzzy(subjectsBSDelFuzz,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS(subjectsBSDelFuzz,2), DeletedFuzzy(subjectsBSDelFuzz,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(BS(subjectsBSDelFuzz,2), DeletedFuzzy(subjectsBSDelFuzz,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Fuzzy Slope')
xlabel('BS slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))


[r p] = corrcoef(Occluded(subjectsOccDelSh,2), DeletedSharp(subjectsOccDelSh,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Occluded(subjectsOccDelSh,2), DeletedSharp(subjectsOccDelSh,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Occluded(subjectsOccDelSh,2), DeletedSharp(subjectsOccDelSh,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Sharp Slope')
xlabel('Occluded slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))


[r p] = corrcoef(Occluded(subjectsOccDelFuzz,2), DeletedFuzzy(subjectsOccDelFuzz,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Occluded(subjectsOccDelFuzz,2), DeletedFuzzy(subjectsOccDelFuzz,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(Occluded(subjectsOccDelFuzz,2), DeletedFuzzy(subjectsOccDelFuzz,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Fuzzy Slope')
xlabel('Occluded slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

[r p] = corrcoef(DeletedSharp(subjectsDelShDelFuzz,2), DeletedFuzzy(subjectsDelShDelFuzz,2), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(DeletedSharp(subjectsDelShDelFuzz,2), DeletedFuzzy(subjectsDelShDelFuzz,2), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)

figure;scatter(DeletedSharp(subjectsDelShDelFuzz,2), DeletedFuzzy(subjectsDelShDelFuzz,2), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted-Fuzzy Slope')
xlabel('Deleted-Sharp slope')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))



% analysis all subjects
% 
% nSubs = 27
% 
% ntrialseachcond = 1070;
% % results = [];
% 
% for i = 1:nSubs
%     filename = sprintf('Results%d.mat',i);
%     load(filename)
%     if i == 1
%         results = results1;
%     end
% end
% 
% for i = 2:nSubs
%     results = results + eval(sprintf('results%d',i));
% end
% 


%% BS Size vs PSE

removeoutliers =1;

% % %outliers
% subjectsIntactOutliers = [];
% subjectsBSOutliers = [19 26];
% subjectsOccOutliers = [1 6 17 19 20 27];
% subjectsDelShOutliers = [1 6 9 19 20 27];
% subjectsDelFuzzOutliers = [1 19 20 27];
% 
% % everything 
% subjectsIntact = [1:27];
% subjectsBS = [1:27];
% subjectsOcc = [1:27];
% subjectsDelSh = [1:27];
% subjectsDelFuzz = [1:27];

if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
end

% vs BS
disp('BS')
[r p] = corrcoef(BS_Size(subjectsBS,1), BS(subjectsBS,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS_Size(subjectsBS,1), BS(subjectsBS,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(BS_Size(subjectsBS,1), BS(subjectsBS,1),'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('BS PSE')
xlabel('BS Size')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

% vs Occ
disp('Occluded')
[r p] = corrcoef(BS_Size(subjectsOcc,1), Occluded(subjectsOcc,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS_Size(subjectsOcc,1), Occluded(subjectsOcc,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(BS_Size(subjectsOcc,1), Occluded(subjectsOcc,1),'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Occluded PSE')
xlabel('BS Size')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

% vs Deleted Sharp
disp('Deleted Sharp')
[r p] = corrcoef(BS_Size(subjectsDelSh,1), DeletedSharp(subjectsDelSh,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS_Size(subjectsDelSh,1), DeletedSharp(subjectsDelSh,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(BS_Size(subjectsDelSh,1), DeletedSharp(subjectsDelSh,1),'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted Sharp PSE')
xlabel('BS Size')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

% vs Deleted Fuzzy
disp('Deleted Fuzzy')
[r p] = corrcoef(BS_Size(subjectsDelFuzz,1), DeletedFuzzy(subjectsDelFuzz,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(BS_Size(subjectsDelFuzz,1), DeletedFuzzy(subjectsDelFuzz,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(BS_Size(subjectsDelFuzz,1), DeletedFuzzy(subjectsDelFuzz,1),'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Deleted Fuzzy PSE')
xlabel('BS Size')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))






%% ??

figure; plot(Perceived_cpd_BS, cpd_veridical(subjectsBS),'MarkerFaceColor','y', 'MarkerEdgeColor','k')
[r p] = corrcoef(Perceived_cpd_BS, cpd_veridical(subjectsBS), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(Perceived_cpd_BS, cpd_veridical(subjectsBS), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))




%%
% VVIQ vs Bias
disp('BS')
[r p] = corrcoef(VVIQ(subjectsBS,1), bias_BS, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsBS,1), bias_BS, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(VVIQ(subjectsBS,1), bias_BS,'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias BS')
xlabel('VVIQ')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%%
% VVIQ vs Occ
disp('BS')
[r p] = corrcoef(VVIQ(subjectsOcc,1), bias_Occ, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsOcc,1), bias_Occ, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(VVIQ(subjectsOcc,1), bias_Occ,'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias Occ')
xlabel('VVIQ')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%%
% VVIQ vs DelSh
disp('BS')
[r p] = corrcoef(VVIQ(subjectsDelSh,1), bias_DelSh, 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsDelSh,1), bias_DelSh, 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure; scatter(VVIQ(subjectsDelSh,1), bias_DelSh,'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('Bias Del Sh')
xlabel('VVIQ')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

