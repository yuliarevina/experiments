% analysis all subjects

nSubs = 37
nSubs = 5

ntrialseachcond = 1460; % nsubs x how many conds each one had (either 30 or 40, check the list)
ntrialseachcond = 200; % nsubs x how many conds each one had (either 30 or 40, check the list)
results = [];

% subs = [11 12 14:22 24 26 27 29 30 33:36]; %good red fix subs
% subs = [10 13 23 25 28 31 32 37]; %bad red fix subs
subs = [1:nSubs]; %all subs
subs = [39:43]; % subs with high SF

for i = subs
    filename = sprintf('Results%d.mat',i);
    load(filename)
    if i == (subs(1))
        results = eval(sprintf('results%d',i));
    end
end

for i = subs(2:end)
    results = results + eval(sprintf('results%d',i));
end

%%
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
markershape(2) = 's';
markershape(3) = 'o';
markershape(4) = 'x';
markershape(5) = 'x';

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
StimLevels = [0.25 0.30 0.35 0.40 0.45]; 
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
    searchGrid.alpha = 0.20:.001:.60; %PSE
    searchGrid.beta = logspace(0,1,101); %slope
    searchGrid.gamma = 0.0;  %scalar here (since fixed) but may be vector %guess rate (lower asymptote)
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
    
    disp('Goodness of Fit')
    B = 1000;
    [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF,'searchGrid', searchGrid);
  
    disp(sprintf('Dev: %6.4f',Dev))
    disp(sprintf('pDev: %6.4f',pDev))
    disp(sprintf('N converged: %6.4f',sum(converged==1)))
    disp('--') %empty line
    
    
    plot(StimLevels,ProportionCorrectObserved,'LineStyle', 'None','Color', colorpoints(condition),'Marker',markershape(condition),'MarkerFaceColor', 'None','markersize',10);  
end

legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Southeast');

for condition = 1:5
     plot(StimLevelsFineGrain,ProportionCorrectModel(condition,:),'-','color',colorpoints(condition),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - cycles per deg SF');
ylabel('Proportion "Comparison More Stripes"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')


%% all results, stats

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;


% %outliers
subjectsIntactOutliers = [];
subjectsBSOutliers = [19 26, 29, 32];
subjectsOccOutliers = [1 6 17 19 20 27, 29, 32, 36, 37];
subjectsDelShOutliers = [1 6 9 19 20 27, 29, 32, 37];
subjectsDelFuzzOutliers = [1 19 20 27, 29, 37];

% everything 
subjectsIntact = [subs];
subjectsBS = [subs];
subjectsOcc = [subs];
subjectsDelSh = [subs];
subjectsDelFuzz = [subs];

if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
end

%means
meanIntactPSE = mean(Intact(:,1));
meanBSPSE = mean(BS(:,1));
meanOccludedPSE = mean(Occluded(:,1));
meanDelShPSE = mean(DeletedSharp(:,1));
meanDelFuzPSE = mean(DeletedFuzzy(:,1));

%medians
medianIntactPSE = median(Intact(:,1));
medianBSPSE = median(BS(:,1));
medianOccludedPSE = median(Occluded(:,1));
medianDelShPSE = median(DeletedSharp(:,1));
medianDelFuzPSE = median(DeletedFuzzy(:,1));

%group data for boxplot
Alldatatoplot = [Intact(subjectsIntact,1); BS(subjectsBS,1); Occluded(subjectsOcc,1); DeletedSharp(subjectsDelSh,1); DeletedFuzzy(subjectsDelFuzz,1)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];

individdata = {Intact(subjectsIntact,1), BS(subjectsBS,1), Occluded(subjectsOcc,1), DeletedSharp(subjectsDelSh,1), DeletedFuzzy(subjectsDelFuzz,1)};


%% make boxplot for PSEs
figure; bx = boxplot(Alldatatoplot,groups,'Notch','on', 'MedianStyle', 'line');
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
plot([0 6],[0.491 0.491], 'k--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE')
axis([0 6 0.25 0.7])
set(gcf, 'Position', [200, 200, 1600, 900])

%% significant diffs for PSEs medians

disp('Intact vs BS')
[p,h,stats] = ranksum(Intact(subjectsIntact,1),BS(subjectsBS,1)) %independent samples
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),1),BS(intersect(subjectsIntact,subjectsBS),1)) %paired samples
       
disp('Intact vs Occ')
[p,h,stats] = ranksum(Intact(subjectsIntact,1),Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsOcc),1),Occluded(intersect(subjectsIntact,subjectsOcc),1)) 

disp('Intact vs DelSh')
[p,h,stats] = ranksum(Intact(subjectsIntact,1),DeletedSharp(subjectsDelSh,1))
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelSh),1),DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1))

disp('Intact vs DelFuzz')
[p,h,stats] = ranksum(Intact(subjectsIntact,1),DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1))

disp('BS vs Occ')
[p,h,stats] = ranksum(BS(subjectsBS,1),Occluded(subjectsOcc,1)) 
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsOcc),1),Occluded(intersect(subjectsBS,subjectsOcc),1)) 

disp('BS vs DelSh')
[p,h,stats] = ranksum(BS(subjectsBS,1),DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelSh),1),DeletedSharp(intersect(subjectsBS,subjectsDelSh),1)) 

disp('BS vs DelFuzz')
[p,h,stats] = ranksum(BS(subjectsBS,1),DeletedFuzzy(subjectsDelFuzz,1))
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1)) 

disp('Occ vs DelSh')
[p,h,stats] = ranksum(Occluded(subjectsOcc,1),DeletedSharp(subjectsDelSh,1)) 
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelSh),1),DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1)) 

disp('Occ vs DelFuzz')
[p,h,stats] = ranksum(Occluded(subjectsOcc,1),DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1)) 

disp('DelSh vs DelFuzz')
[p,h,stats] = ranksum(DeletedSharp(subjectsDelSh,1),DeletedFuzzy(subjectsDelFuzz,1)) 
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1)) 


%%
%%%%%%%%%%%%%%%%%%%%%%
% SLOPE
%%%%%%%%%%%%%%%%%%%%%%

removeoutliers = 1;

% % %outliers based on non- convergence
% subjectsIntactOutliers = [];
% subjectsBSOutliers = [19 26];
% subjectsOccOutliers = [1 6 17 19 20 27];
% subjectsDelShOutliers = [1 6 9 19 20 27];
% subjectsDelFuzzOutliers = [1 19 20 27];


% %outliers based on non convergence, remove only slopes higher than median
subjectsIntactOutliers = [];
subjectsBSOutliers = [];
subjectsOccOutliers = [1 6];
subjectsDelShOutliers = [6 9];
subjectsDelFuzzOutliers = [];



% 
% or keep everything 
subjectsIntact = [1:nSubs];
subjectsBS = [1:nSubs];
subjectsOcc = [1:nSubs];
subjectsDelSh = [1:nSubs];
subjectsDelFuzz = [1:nSubs];


if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
end


%means
meanIntactSlope = mean(Intact(subjectsIntact,2));
meanBSSlope = mean(BS(subjectsBS,2));
meanOccludedSlope = mean(Occluded(subjectsOcc,2));
meanDelShSlope = mean(DeletedSharp(subjectsDelSh,2));
meanDelFuzSlope = mean(DeletedFuzzy(subjectsDelFuzz,2));

%medians
medianIntactSlope = median(Intact(subjectsIntact,2));
medianBSSlope = median(BS(subjectsBS,2));
medianOccludedSlope = median(Occluded(subjectsOcc,2));
medianDelShSlope = median(DeletedSharp(subjectsDelSh,2));
medianDelFuzSlope = median(DeletedFuzzy(subjectsDelFuzz,2));


%group data for boxplot
Alldatatoplot = [Intact(subjectsIntact,2); BS(subjectsBS,2); Occluded(subjectsOcc,2); DeletedSharp(subjectsDelSh,2); DeletedFuzzy(subjectsDelFuzz,2)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsBS))'; 3*ones(1,length(subjectsOcc))'; 4*ones(1,length(subjectsDelSh))';5*ones(1,length(subjectsDelFuzz))'];

individdata = {Intact(subjectsIntact,2), BS(subjectsBS,2), Occluded(subjectsOcc,2), DeletedSharp(subjectsDelSh,2), DeletedFuzzy(subjectsDelFuzz,2)};



%% significant diffs for slopes

disp('Intact vs BS')
[p,h,stats] = ranksum(Intact(subjectsIntact,2),BS(subjectsBS,2))
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),2),BS(intersect(subjectsIntact,subjectsBS),2))
       
disp('Intact vs Occ')
[p,h,stats] = ranksum(Intact(subjectsIntact,2),Occluded(subjectsOcc,2)) 
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsOcc),2),Occluded(intersect(subjectsIntact,subjectsOcc),2)) 

disp('Intact vs DelSh')
[p,h,stats] = ranksum(Intact(subjectsIntact,2),DeletedSharp(subjectsDelSh,2))
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelSh),2),DeletedSharp(intersect(subjectsIntact,subjectsDelSh),2))

disp('Intact vs DelFuzz')
[p,h,stats] = ranksum(Intact(subjectsIntact,2),DeletedFuzzy(subjectsDelFuzz,2))
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),2))

disp('BS vs Occ')
[p,h,stats] = ranksum(BS(subjectsBS,2),Occluded(subjectsOcc,2)) 
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsOcc),2),Occluded(intersect(subjectsBS,subjectsOcc),2)) 

disp('BS vs DelSh')
[p,h,stats] = ranksum(BS(subjectsBS,2),DeletedSharp(subjectsDelSh,2)) 
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelSh),2),DeletedSharp(intersect(subjectsBS,subjectsDelSh),2))

disp('BS vs DelFuzz')
[p,h,stats] = ranksum(BS(subjectsBS,2),DeletedFuzzy(subjectsDelFuzz,2))
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),2)) 

disp('Occ vs DelSh')
[p,h,stats] = ranksum(Occluded(subjectsOcc,2),DeletedSharp(subjectsDelSh,2)) 
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelSh),2),DeletedSharp(intersect(subjectsOcc,subjectsDelSh),2)) 

disp('Occ vs DelFuzz')
[p,h,stats] = ranksum(Occluded(subjectsOcc,2),DeletedFuzzy(subjectsDelFuzz,2)) 
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),2)) 

disp('DelSh vs DelFuzz')
[p,h,stats] = ranksum(DeletedSharp(subjectsDelSh,2),DeletedFuzzy(subjectsDelFuzz,2)) 
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),2)) 



%% make boxplot for slopes
figure; bx = boxplot(Alldatatoplot,groups,'Notch','on', 'MedianStyle', 'line');
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
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact', 'Blindspot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope')
% axis([0 6 0.2 0.7])
set(gcf, 'Position', [200, 200, 1600, 900])


%% VVIQ PSE

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
[r p] = corrcoef(VVIQ(subjectsBS), BS(subjectsBS,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsBS), BS(subjectsBS,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsBS), BS(subjectsBS,1), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('PSE')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ plot occl
[r p] = corrcoef(VVIQ(subjectsOcc), Occluded(subjectsOcc,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsOcc), Occluded(subjectsOcc,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsOcc), Occluded(subjectsOcc,1), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('PSE')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ plot delet sharp
[r p] = corrcoef(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsDelSh), DeletedSharp(subjectsDelSh,1), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('PSE')
xlabel('Imagery Strength')
hold on
h = lsline;
set(h, 'LineWidth',3)
title(sprintf('r = %f; p = %f',r(1,2),p(1,2)))

%% VVIQ deleted fuzzy
[r p] = corrcoef(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,1), 'rows','complete') %correlation excluding NaNs
[rspearman pspearman] = corr(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,1), 'rows','complete', 'type', 'Spearman') %correlation excluding NaNs)
figure;scatter(VVIQ(subjectsDelFuzz), DeletedFuzzy(subjectsDelFuzz,1), 'MarkerFaceColor','y', 'MarkerEdgeColor','k')
set(gca, 'TickDir', 'out')
set(gca, 'fontsize',16);
ylabel('PSE')
xlabel('Imagery Strength')
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



%% BS sizes, perceived cpd vs actual cpd in gap conditions


removeoutliers = 1;

% % %outliers
% subjectsIntactOutliers = [];
% subjectsBSOutliers = [19 26];
% subjectsOccOutliers = [1 6 17 19 20 27];
% subjectsDelShOutliers = [1 6 9 19 20 27];
% subjectsDelFuzzOutliers = [1 19 20 27];
% 
% everything 
subjectsIntact = [1:nSubs];
subjectsBS = [1:nSubs];
subjectsOcc = [1:nSubs];
subjectsDelSh = [1:nSubs];
subjectsDelFuzz = [1:nSubs];

if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
end


%%
% BS size
BS_Size(:,1);

Barlength = BS_Size(:,1) + 10; %in deg, 10 deg of visible bar outside BS

NcyclesControl = Barlength * 0.3; %control was always 0.3 cpd

Perceived_cpd_BS = BS(subjectsBS,1);

Perceived_cpd_Occ = Occluded(subjectsOcc,1);

Perceived_cpd_DelSh = DeletedSharp(subjectsDelSh,1);

Perceived_cpd_DelFuzz = DeletedFuzzy(subjectsDelFuzz,1);

cpd_veridical = NcyclesControl/10; %10 deg of visible bar

bias_BS =  Perceived_cpd_BS - cpd_veridical(subjectsBS);
bias_Occ = Perceived_cpd_Occ - cpd_veridical(subjectsOcc);
bias_DelSh =  Perceived_cpd_DelSh - cpd_veridical(subjectsDelSh);
bias_DelFuzz = Perceived_cpd_DelFuzz - cpd_veridical(subjectsDelFuzz);


medianbias_BS = median(bias_BS)
medianbias_Occ = median(bias_Occ)
medianbias_DelSh = median(bias_DelSh)
medianbias_DelFuzz = median(bias_DelFuzz)

%%
disp('BS')
[P,H,STATS] = ranksum(Perceived_cpd_BS,cpd_veridical(subjectsBS))
[P,H,STATS] = signrank(Perceived_cpd_BS,cpd_veridical(subjectsBS))
disp('Occluded')
[P,H,STATS] = ranksum(Perceived_cpd_Occ,cpd_veridical(subjectsOcc))
[P,H,STATS] = signrank(Perceived_cpd_Occ,cpd_veridical(subjectsOcc))
disp('DelSharp')
[P,H,STATS] = ranksum(Perceived_cpd_DelSh,cpd_veridical(subjectsDelSh))
[P,H,STATS] = signrank(Perceived_cpd_DelSh,cpd_veridical(subjectsDelSh))
disp('DelFuzzy')
[P,H,STATS] = ranksum(Perceived_cpd_DelFuzz,cpd_veridical(subjectsDelFuzz))
[P,H,STATS] = signrank(Perceived_cpd_DelFuzz,cpd_veridical(subjectsDelFuzz))



figure; plot([1 2], [Perceived_cpd_BS cpd_veridical(subjectsBS)])
axis([0.5 2.5 0.2 1])
ylabel('CPD')
% xlabel('VVIQ')
set(gca,'XTickLabel', {'', 'Perceived cpd BS','', 'cpd veridical',''}) 

figure; plot([1 2], [Perceived_cpd_Occ cpd_veridical(subjectsOcc)])
axis([0.5 2.5 0.2 1])
ylabel('CPD')
% xlabel('VVIQ')
set(gca,'XTickLabel', {'','Perceived cpd Occ', '','cpd veridical'}) 

figure; plot([1 2], [Perceived_cpd_DelSh cpd_veridical(subjectsDelSh)])
axis([0.5 2.5 0.2 1])
ylabel('CPD')
% xlabel('VVIQ')
set(gca,'XTickLabel', {'','Perceived cpd DelSh','', 'cpd veridical'}) 

figure; plot([1 2], [Perceived_cpd_DelFuzz cpd_veridical(subjectsDelFuzz)])
axis([0.5 2.5 0.2 1])
ylabel('CPD')
% xlabel('VVIQ')
set(gca,'XTickLabel', {'','Perceived cpd DelFuzz', '','cpd veridical'}) 


% boxplot figures

for i = 1:4
    switch i
        case 1
            X = [Perceived_cpd_BS cpd_veridical(subjectsBS)];
            Label = {'PSE BS', 'PTE BS'};
        case 2
            X = [Perceived_cpd_Occ cpd_veridical(subjectsOcc)];
            Label = {'PSE Occ', 'PTE Occ'};
        case 3
            X = [Perceived_cpd_DelSh cpd_veridical(subjectsDelSh)];
            Label = {'PSE DelSh', 'PTE DelSh'};
        case 4
            X = [Perceived_cpd_DelFuzz cpd_veridical(subjectsDelFuzz)];
            Label = {'PSE DelFuzz', 'PTE DelFuzz'};
    end
        
        
    figure; bx = boxplot(X,'Notch','on', 'MedianStyle', 'line');
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
    axis([0.7 2.3 0.25 1.1])
    set(gcf, 'Position', [200, 200, 900, 900])
    
end
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

