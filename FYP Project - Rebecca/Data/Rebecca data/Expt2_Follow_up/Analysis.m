% Analysis script

ntrialseachcond = 50;


%% extract data
conditions = nan(5,ntrialseachcond,5);
tmp1 = [];
tmp2 = [];
results = nan(5,1,2);
for i = 1:2; %conditions
    %     conditions(:,i) = find(subjectdata(:,1) == i); %find all intact trials, all BS trials...
    %     tmp(:,i) = find(subjectdata(:,1) == i);
    for j = 1:5 %Orientations
        %       SFs(:,j) = find(subjectdata(:,2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         tmp2(:,j) = find(subjectdata(:,2) == j);
        %         subjectdata(tmp,tmp2)
        
        % renumber conditions to what they are in the subjectdata matrix
            switch i
                case 1
                    cond = 0;
                case 2
                    cond = 1;
            end
            
            switch j
                case 1
                    orient = 360 - orientations(1);
                case 2
                    orient = 360 - orientations(2);
                case 3
                    orient = 360 - orientations(3);
                case 4
                    orient = 360 - orientations(4);
                case 5
                    orient = 360 - orientations(5);
            end
        
            
            if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 1)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
            else % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 2)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                
            end
        %for the mistake in counterbalancing
%             tmp2 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
        %         conditions(j,:,i) = tmp;
        results(j,1,i) = size(tmp1,2)+size(tmp2,2);
        %for the mistake in counterbalancing
%          results(j,1,i) = size(tmp2,2);
    end
end



%% figure
figure; plot(1:5, results(1:5,1,1), 'ro-') %BS
hold on;
plot(1:5, results(1:5,1,2), 'bs-') %Fellow
% plot(1:5, results(1:5,1,3), 'go-') %occl
% plot(1:5, results(1:5,1,4), 'kx-') %del sharp
% plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 ntrialseachcond+0.5])
[leg] = legend('BS', 'Fellow', 'Location', 'Northwest');
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




%% palamedes analysis

disp ('Palamedes...')
%Stimulus intensities
% StimLevels = [35 40 45 50 55]; %hardtask
% StimLevels = [25 35 45 55 65]; %easytask
StimLevels = [30 37.5 45 52.5 60]; %mediumtask

figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condswitch = 1:2 %conditions
    
    switch condswitch
        case 1
            disp('BS')
        case 2
            disp('Fellow')
%         case 3
%             disp('Occluded')
%         case 4
%             disp('Deleted Sharp')
%         case 5
%             disp('Deleted Fuzzy')
    end
    
    %Number of positive responses (e.g., 'yes' or 'correct' at each of the
    %   entries of 'StimLevels'
    NumPos = [results(1,:,condswitch) results(2,:,condswitch) results(3,:,condswitch) results(4,:,condswitch) results(5,:,condswitch)];
    
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
    searchGrid.alpha = 25:.001:65; %PSE
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
    ProportionCorrectModel(condswitch,:) = PF(paramsValues,StimLevelsFineGrain);
    
    
    plot(StimLevels,ProportionCorrectObserved,'LineStyle', 'None','Color', colorpoints(condswitch),'Marker',markershape(condswitch),'MarkerFaceColor', 'None','markersize',10);  
  
    
    
%     searchGrid.alpha = [-1:.1:1];    %structure defining grid to
% %   searchGrid.beta = 10.^[-1:.1:2]; %search for initial values
% %   searchGrid.gamma = .5;
% %   searchGrid.lambda = [0:.005:.03];
% %   paramsFree = [1 1 0 1];

    searchGrid.alpha = 25:.001:65; %PSE
    searchGrid.beta = logspace(0,1,101); %slope
    searchGrid.gamma = 0.02;  %scalar here (since fixed) but may be vector %guess rate (lower asymptote)
    searchGrid.lambda = 0.02;  %ditto % lapse rate, finger error, upper asympt
    paramsFree = [1 1 0 1];
    
    disp('Goodness of Fit')
    B = 1000;
    [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF,'searchGrid', searchGrid);
  
    disp(sprintf('Dev: %6.4f',Dev))
    disp(sprintf('pDev: %6.4f',pDev))
    disp(sprintf('N converged: %6.4f',sum(converged==1)))
    disp('--') %empty line
end

legend('BS', 'Fellow', 'Location', 'Southeast');

for condswitch = 1:2
     plot(StimLevelsFineGrain,ProportionCorrectModel(condswitch,:),'-','color',colorpoints(condswitch),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - Orientation');
ylabel('Proportion "Comparison More Clockwise"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')

%% GROUP ANALYSIS
% subs = [1:3 6 8:14 16:17 19:21 23 25 41]; % 'good' subjects
% subs = [4 7 15 18 22 24 26:40]; % 'bad' subjects
subs = 1:13;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;


% % % %outliers
 subjectsBSOutliers = [5];
 subjectsFellowOutliers = [2:3, 5:7, 12];
subjectsAnnulusOutliers = [5:7, 12:13];
% % subjectsIntactOutliers = [];
% % subjectsBSOutliers = [19 26, 29, 32];
% % subjectsOccOutliers = [1 6 17 19 20 27, 29, 32, 36, 37];
% % subjectsDelShOutliers = [1 6 9 19 20 27, 29, 32, 37];
% % subjectsDelFuzzOutliers = [1 19 20 27, 29, 37];

% everything 

subjectsBS = [subs];
subjectsFellow = [subs];
subjectsAnnulus = [subs];

if removeoutliers %overwrite the sublists
   
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsFellow = setdiff(subjectsFellow, subjectsFellowOutliers);
    subjectsAnnulus = setdiff(subjectsAnnulus, subjectsAnnulusOutliers);
end

%means

meanBSPSE = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,1));
meanFellowPSE = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,2));
meanAnnulusPSE = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,3));


%medians
medianBSPSE = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,1));
medianFellowPSE = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,2));
medianAnnulusPSE = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,3));

%group data for boxplot
Alldatatoplot = [BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,1); BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,2); ...
    BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,3)];
groups = [ones(1,length(subjectsBS))';2*ones(1,length(subjectsFellow))'; 3*ones(1,length(subjectsAnnulus))'];

individdata = {BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,1), BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,2), ...
    BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,3)};

%%
%% make boxplot for PSEs
figure; bx = boxplot(Alldatatoplot,groups,'Notch','off', 'MedianStyle', 'line');
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
plot([0 4],[45 45], 'g--')
plot([1 2 3],[mean(individdata{1}), mean(individdata{2}), mean(individdata{3})], 'gs')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blindspot', 'Fellow', 'Annulus'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE')
axis([0 4 40 50])
set(gcf, 'Position', [200, 200, 1350, 900])

%% significant diffs for PSEs medians

disp('BS vs Fellow')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,1),PSE_Slope_Fellow(subjectsFellow,1)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),1),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),2)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),1),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),2))

disp('BS vs Annulus')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,1),PSE_Slope_Fellow(subjectsFellow,1)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),1),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),3)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),1),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),3))

disp('Fellow vs Annulus')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,1),PSE_Slope_Fellow(subjectsFellow,1)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),2),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),3)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),2),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),3))

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;


% % % %outliers
% % subjectsIntactOutliers = [];
% % subjectsBSOutliers = [19 26, 29, 32];
% % subjectsOccOutliers = [1 6 17 19 20 27, 29, 32, 36, 37];
% % subjectsDelShOutliers = [1 6 9 19 20 27, 29, 32, 37];
% % subjectsDelFuzzOutliers = [1 19 20 27, 29, 37];

% everything 

subjectsBS = [subs];
subjectsFellow = [subs];
subjectsAnnulus = [subs];

 subjectsBSOutliers = [5];
 subjectsFellowOutliers = [2:3, 5];
subjectsAnnulusOutliers = [5:6, 13];


if removeoutliers %overwrite the sublists
   
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
    subjectsFellow = setdiff(subjectsFellow, subjectsFellowOutliers);
    subjectsAnnulus = setdiff(subjectsAnnulus, subjectsAnnulusOutliers);
end

%means

meanBSSlope = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,4));
meanFellowSlope = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,5));
meanAnnulusSlope = mean(BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,6));


%medians
medianBSSlope = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,4));
medianFellowSlope = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,5));
medianAnnulusSlope = median(BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,6));

%group data for boxplot
Alldatatoplot = [BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,4); BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,5); ...
    BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,6)];
groups = [ones(1,length(subjectsBS))';2*ones(1,length(subjectsFellow))'; 3*ones(1,length(subjectsAnnulus))'];

individdata = {BS_Fellow_Annulus_PSE_Slope_new(subjectsBS,4), BS_Fellow_Annulus_PSE_Slope_new(subjectsFellow,5), ...
    BS_Fellow_Annulus_PSE_Slope_new(subjectsAnnulus,6)};

%%
%% make boxplot for Slopes
figure; bx = boxplot(Alldatatoplot,groups,'Notch','off', 'MedianStyle', 'line');
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
plot([0 3],[45 45], 'g--')
plot([1 2 3],[mean(individdata{1}), mean(individdata{2}), mean(individdata{3})], 'gs')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blindspot', 'Fellow', 'Annulus'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope')
axis([0 4 -0.01 0.305])
set(gcf, 'Position', [200, 200, 1350, 900])

%% significant diffs for Slopes medians

disp('BS vs Fellow')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),4),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),5)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),4),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsFellow),5))

disp('BS vs Annulus')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,1),PSE_Slope_Fellow(subjectsFellow,1)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),4),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),6)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),4),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsBS,subjectsAnnulus),6))

disp('Fellow vs Annulus')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,1),PSE_Slope_Fellow(subjectsFellow,1)) %independent samples
[p,h,stats] = signrank(BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),5),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),6)) %paired samples
[H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),5),BS_Fellow_Annulus_PSE_Slope_new(intersect(subjectsFellow,subjectsAnnulus),6))


%% BS Sizes

BS_medians = median(BS_Sizes);

figure; bx = boxplot(BS_Sizes,'Notch','on', 'MedianStyle', 'line', 'whisker', 0.9826);

%% Confidence

%  Confidence Var
% 1 BS Corr
% 2 BS Incorr
% 3 Fellow Corr
% 4 Fellow Incorr
% 5 Annulus Corr
% 6 Annulus Incorr


BS_conf(:,1) = Confidence(:,1); %corr
BS_conf(:,2) = Confidence(:,2); %incorr
Fellow_conf(:,1) = Confidence(:,3);
Fellow_conf(:,2) = Confidence(:,4);
Annulus_conf(:,1) = Confidence(:,5);
Annulus_conf(:,2) = Confidence(:,6);


BS_ambig_conf = Confidence(:,8);
Fellow_ambig_conf = Confidence(:,9);
Annulus_ambig_conf = Confidence(:,10);

mean(BS_conf)
mean(Fellow_conf)
mean(Annulus_conf)

meanCorrectAllConds = mean([BS_conf(:,1); Fellow_conf(:,1); Annulus_conf(:,1)])
meanInCorrectAllConds = mean([BS_conf(:,2); Fellow_conf(:,2); Annulus_conf(:,2)])

disp('Corr vs Incorr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(mean([BS_conf(:,1), Fellow_conf(:,1), Annulus_conf(:,1)],2),mean([BS_conf(:,2), Fellow_conf(:,2), Annulus_conf(:,2)],2)) %paired samples
t_test_pairwise (mean([BS_conf(:,1), Fellow_conf(:,1), Annulus_conf(:,1)],2),mean([BS_conf(:,2), Fellow_conf(:,2), Annulus_conf(:,2)],2))

disp('BS corr vs Fellow Corr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_conf(:,1), Fellow_conf(:,1)) %paired samples
t_test_pairwise (BS_conf(:,1), Fellow_conf(:,1))


disp('BS corr vs Annulus Corr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_conf(:,1), Annulus_conf(:,1)) %paired samples
t_test_pairwise (BS_conf(:,1), Annulus_conf(:,1))


disp('Fellow corr vs Annulus Corr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(Fellow_conf(:,1), Annulus_conf(:,1)) %paired samples
t_test_pairwise (Fellow_conf(:,1), Annulus_conf(:,1))

%~~~~~~~~~~~~~~~~~~~~

disp('BS incorr vs Fellow incorr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_conf(:,2), Fellow_conf(:,2)) %paired samples
t_test_pairwise (BS_conf(:,2), Fellow_conf(:,2))


disp('BS incorr vs Annulus incorr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_conf(:,2), Annulus_conf(:,2)) %paired samples
t_test_pairwise (BS_conf(:,2), Annulus_conf(:,2))


disp('Fellow incorr vs Annulus incorr')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(Fellow_conf(:,2), Annulus_conf(:,2)) %paired samples
t_test_pairwise (Fellow_conf(:,2), Annulus_conf(:,2))

%%
%%group data for boxplot
Alldatatoplot = [BS_conf(:,1), BS_conf(:,2), Fellow_conf(:,1), Fellow_conf(:,2), Annulus_conf(:,1), Annulus_conf(:,2)];
groups = [ones(1,length(BS_conf))';2*ones(1,length(BS_conf))'; 3*ones(1,length(BS_conf))'; 4*ones(1,length(BS_conf))'; 5*ones(1,length(BS_conf))';6*ones(1,length(BS_conf))'];

individdata = {BS_conf(:,1), BS_conf(:,2), Fellow_conf(:,1), Fellow_conf(:,2), Annulus_conf(:,1), Annulus_conf(:,2)};


%% plot confidence
figure; bx = boxplot(Alldatatoplot,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
    if mod(k,2) == 0; %even number
        patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
    else
        patch(h{k,1},h{k,2},'y');
    end
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
plot([0 11],[0.0 0.0], 'g--')

for i = 1:6
    plot(i, mean(individdata{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'BS Corr', 'Fellow Corr', 'Annulus Corr','BS Incorr', 'Fellow Incorr', 'Annulus Incorr'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
% ylabel('Underestimation of Curvature')
ylabel('Confidence')
axis([0 7 0.5 3])
set(gcf, 'Position', [200, 200, 900, 900])

%% Confidence ambiguous conds only

disp('BS  vs Fellow ')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_ambig_conf, Fellow_ambig_conf) %paired samples
t_test_pairwise (BS_ambig_conf, Fellow_ambig_conf)


disp('BS  vs Annulus ')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(BS_ambig_conf, Annulus_ambig_conf) %paired samples
t_test_pairwise (BS_ambig_conf, Annulus_ambig_conf)

disp('Fellow  vs Annulus ')
% [p,h,stats] = ranksum(PSE_Slope_BS(subjectsBS,3),PSE_Slope_Fellow(subjectsFellow,4)) %independent samples
[p,h,stats] = signrank(Fellow_ambig_conf, Annulus_ambig_conf) %paired samples
t_test_pairwise (Fellow_ambig_conf, Annulus_ambig_conf)


%%
%%group data for boxplot
Alldatatoplot = [BS_ambig_conf, Fellow_ambig_conf, Annulus_ambig_conf];
groups = [ones(1,length(BS_conf))';2*ones(1,length(BS_conf))'; 3*ones(1,length(BS_conf))'];

individdata = {BS_ambig_conf, Fellow_ambig_conf, Annulus_ambig_conf};

%% plot confidence
figure; bx = boxplot(Alldatatoplot,groups,'Notch','off', 'MedianStyle', 'line');
ax = gca;

h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
    if mod(k,2) == 0; %even number
        patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
    else
        patch(h{k,1},h{k,2},'y');
    end
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
plot([0 11],[0.0 0.0], 'g--')

for i = 1:3
    plot(i, mean(individdata{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'BS', 'Fellow', 'Annulus'}) 
% set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
% ylabel('Underestimation of Curvature')
ylabel('Confidence')
axis([0 4 0.5 3])
set(gcf, 'Position', [200, 200, 900, 900])