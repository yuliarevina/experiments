% V1

nobvs = 26;
nobvsV2 = 7;
expt1subs = 1:13;
expt2subs = 14:26;

expt1V2subsBSROI = [2,7,9:13];
expt1V2subsACTUALROI = [2,7,9:13];

expt2V2subsBSROI = [14:16,19:20,24];
expt2V2subsACTUALROI = [14:16, 18:22,24:25];
expt2V2subsACTUALROI_V1matchV2 = [14,16, 18:20, 22, 24];

exptBothV2subsBSROI =  [2,7,9:16,19:20,24]; % only subs with V2 rois available
exptBothV2subsACTUALROI =  [2,7,9:16,18:22,24:25]; % only subs with V2 rois available


exptBothsubsACTUALROI_V1matchV2 = [2,7,9:14,16, 18:20,22,24]; %only subs where BOTH V1 and V2 are available (removes 3 V2 subs without a V1)

% ROIS
% 1 = BS_CON_V1
% 2 = ACTUAL_CON_V1
% 3 = V1_around_stim
% 4 = BS_CON_V2
% 5 = ACTUAL_CON_V2
% 6 = BS_EDGE_V1
% 7 = BS_EDGE_V2

% CONDS
% 1 = Intact
% 2 = BS
% 3 = Occluded
% 4 = DelSh
% 5 = DelFuzz
% 6 = CtrlFellow
% 7 = CtrlBS
% 8 = Grey




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%which experiment?
whichexpt = 2; %1 or 2 or 3(both)
whichrois = 1; % 1 normal results; 2 supplementary

%%%%%%%%%%%%%%%%%%%%%%%%%%%

if whichrois == 1
    rois = 1:3; %for main results V1
elseif whichrois == 2
    rois = [1,6, 4, 7]; %for supplementary fig with BS EDGE ROIs
end


if whichexpt == 1;
    subs = expt1subs;
    conds = [1,2,3,4,5,8];
elseif whichexpt == 2;
    subs = expt2subs;
    conds = [1,2,4,6,7,8];
else
    subs = [expt1subs, expt2subs];
    conds = [1,2,4,8];
    catIdx = repmat([zeros(1,length(expt1subs))'; ones(1,length(expt2subs))'],[length(conds), 1]);
end



clear data_to_plot
data_to_plot(:,:,1) = MRI_univariate.BS_CON_V1_all_expts;
data_to_plot(:,:,2) = MRI_univariate.ACTUAL_CON_V1_all_expts;
data_to_plot(:,:,3) = MRI_univariate.V1_outside_stim_all_expts;
data_to_plot(:,:,4) = MRI_univariate.BS_CON_V2_all_expts;
data_to_plot(:,:,5) = MRI_univariate.ACTUAL_CON_V2_all_expts;
data_to_plot(:,:,6) = MRI_univariate.BS_EDGE_V1_expt1;
data_to_plot(:,:,7) = MRI_univariate.BS_EDGE_V2_expt1;



clear x_index;
% initial_coords = [0, 100, 200, 300, 400, 500];
% initial_coords = [0, 200, 400, 600, 800, 1000];
initial_coords = [0, 250, 500, 750, 1000, 1250 1500 1750];
x_index(:,:,1) = initial_coords;
x_index(:,:,2) = initial_coords + 40;
x_index(:,:,3) = initial_coords + 80;
x_index(:,:,4) = initial_coords + 120;
x_index(:,:,5) = initial_coords + 160;
x_index(:,:,6) = initial_coords + 200;
x_index(:,:,7) = initial_coords + 240;



color_index(:,:,1) = [215/255, 20/255, 64/255];
color_index(:,:,2) = [24/255, 28/255, 98/255];
color_index(:,:,3) = [200/255, 200/255, 200/255];
color_index(:,:,4) = [141/255, 205/255, 255/255];
color_index(:,:,5) = [128/255, 128/255, 128/255];
color_index(:,:,6) = [91/255, 155/255, 213/255];
color_index(:,:,7) = [255/255, 255/255, 213/255];


%% V1
%everything
figure;
whattoplot = rois; %which ROIs in data-to-plot
% whattoplot = [1:5];
for i = whattoplot
% BS conservative
switch i %assign x position on the graph. e.g. cond 4 not always need to be 4th bar on the barchart
    case 1
        j = 1; % j = bar position in each bar group (each group is ROI)
    case 2
        j = 2;
    case 3
        j = 3;
    case 4
        j = 3;
    case 5
        j = 5;
    case 6
        j = 2;
    case 7
        j = 4;
   
end
SEM = nanstd(data_to_plot(subs,conds,i))/sqrt(length(data_to_plot(subs,conds,i)));
bardata(j) = bar(x_index(:,1:length(conds),j), nanmean(data_to_plot(subs,conds,i)), 'FaceColor', color_index(:,:,j), 'BarWidth', 0.15);
hold on
e = errorbar(x_index(:,1:length(conds),j), nanmean(data_to_plot(subs,conds,i)),SEM, 'LineStyle', 'None');
e.Color = [0.5 0.5 0.5];
e.LineWidth = 2;
e.LineStyle = 'None';

% catindex = repmat([1;6;12;18;24;30], 1,6)'
clear catindex
distindex = [];
for conditionnum = 1:length(conds)
    distindex = [distindex; x_index(:,conditionnum,j)* ones(1, length(subs))'];   
end
% catindex = [x_index(:,1,j)* ones(1, length(subs))'; x_index(:,2,j)* ones(1, length(subs))'; ...
%     x_index(:,3,j) * ones(1, length(subs))'; x_index(:,4,j) * ones(1, length(subs))'; ...
%     x_index(:,5,j)* ones(1, length(subs))'; x_index(:,6,j) * ones(1, length(subs))'];
% 
if whichexpt == 3 %we need 2 categories
    plotspreadhandles = plotSpread([data_to_plot(subs,conds,i)], 'categoryIdx', catIdx,'categoryMarkers',{'o','o'},'categoryColors',{'y','c'}, 'distributionIdx', distindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
else %we don't need to define separate categories
    plotspreadhandles = plotSpread([data_to_plot(subs,conds,i)], 'distributionIdx', distindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
    set(plotspreadhandles{1},'MarkerFaceColor','y', 'MarkerSize',5);
end
%     set(ah{3}, 'MarkerSize', 20)
% set(plotspreadhandles{1},'MarkerFaceColor','y', 'MarkerSize',5);
set(plotspreadhandles{1},'MarkerEdgeColor','k', 'MarkerSize',5);
% set(plotspreadhandles{2},'MarkerFaceColor','k', 'MarkerSize',5);
% set(gca, 'XTick', [0 20 40 60 80 100 120 140 160])

% bardata(2) = [];
% bardata(3) = [];
% bardata(4) = [];
% bardata(5) = [];


end

xlabels = {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Ctrl Fellow', 'Ctrl BS', 'Grey Screen'};
set(gca, 'XTickLabel', xlabels(conds))
% set(gca, 'ylabel', {'Beta weight'})
ylabel('Beta Weight')
set(gcf, 'Position', [500 200 2000 1000])
set(gca, 'XTick', initial_coords + 40)
set(gca, 'fontsize',20);
ax = gca;
ax.XLim = [-50 1400];
ax.YLim = [-1.5 2];
% axes([-1 2 -10 350])
axislabels = {'BS CON','ACTUAL CON', 'V1 around stimulus', 'BS CON V2', 'ACTUAL CON V2',  'BS EDGE V1', 'BS EDGE V2'};
% axislabels = {'BS Cons', 'Actual Stim Cons', 'V1 outside Stim'}
legend([bardata()],axislabels(whattoplot))

%% V2
figure;
whattoplot = [1 4 2 5]; %which ROIs in data-to-plot
% whattoplot = [1:5];
for i = whattoplot %plot BS ROI first
% BS conservative
switch i %assign x position on the graph. e.g. cond 4 not always need to be 4th bar on the barchart
    case 1
        j = 1; % j = bar position in each bar group (each group is ROI)
    case 2
        j = 3;
    case 3
        j = 3;
    case 4
        j = 2;
    case 5
        j = 4;
    case 6
        j = 2;
    case 7
        j = 4;
   
end

%select the correct group of subs for this ROI
if i == 1 || i == 4
    tmpsubsexpt1 = expt1V2subsBSROI;
    tmpsubsexpt2 = expt2V2subsBSROI;
    tmpsubsboth = exptBothV2subsBSROI;
elseif i == 2 || i == 5
    tmpsubsexpt1 = expt1V2subsACTUALROI;
    tmpsubsexpt2 = expt2V2subsACTUALROI_V1matchV2;
    tmpsubsboth = exptBothsubsACTUALROI_V1matchV2;
end

%select the correct group of subs for each experiment
if whichexpt == 1;
    subs = tmpsubsexpt1;
elseif whichexpt == 2;
    subs = tmpsubsexpt2;
else
    subs = tmpsubsboth;
    catIdx = repmat([zeros(1,length(tmpsubsexpt1))'; ones(1,length(tmpsubsexpt2))'],[length(conds), 1]);
end

SEM = nanstd(data_to_plot(subs,conds,i))/sqrt(length(data_to_plot(subs,conds,i)));
bardata(j) = bar(x_index(:,1:length(conds),j), nanmean(data_to_plot(subs,conds,i)), 'FaceColor', color_index(:,:,j), 'BarWidth', 0.15);
hold on
e = errorbar(x_index(:,1:length(conds),j), nanmean(data_to_plot(subs,conds,i)),SEM, 'LineStyle', 'None');
e.Color = [0.5 0.5 0.5];
e.LineWidth = 2;
e.LineStyle = 'None';

% catindex = repmat([1;6;12;18;24;30], 1,6)'

distindex = [];
for conditionnum = 1:length(conds)
    distindex = [distindex; x_index(:,conditionnum,j)* ones(1, length(subs))'];   
end
% catindex = [x_index(:,1,j)* ones(1, length(subs))'; x_index(:,2,j)* ones(1, length(subs))'; ...
%     x_index(:,3,j) * ones(1, length(subs))'; x_index(:,4,j) * ones(1, length(subs))'; ...
%     x_index(:,5,j)* ones(1, length(subs))'; x_index(:,6,j) * ones(1, length(subs))'];
% 
if whichexpt == 3 %we need 2 categories
    plotspreadhandles = plotSpread([data_to_plot(subs,conds,i)], 'categoryIdx', catIdx,'categoryMarkers',{'o','o'},'categoryColors',{'y','c'}, 'distributionIdx', distindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
else %we don't need to define separate categories
    plotspreadhandles = plotSpread([data_to_plot(subs,conds,i)], 'distributionIdx', distindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
    set(plotspreadhandles{1},'MarkerFaceColor','y', 'MarkerSize',5);
end
%     set(ah{3}, 'MarkerSize', 20)
% set(plotspreadhandles{1},'MarkerFaceColor','y', 'MarkerSize',5);
set(plotspreadhandles{1},'MarkerEdgeColor','k', 'MarkerSize',5);
% set(plotspreadhandles{2},'MarkerFaceColor','k', 'MarkerSize',5);
% set(gca, 'XTick', [0 20 40 60 80 100 120 140 160])

% bardata(2) = [];
% bardata(3) = [];
% bardata(4) = [];
% bardata(5) = [];


end

% %plot lines between dots
% % looks a bit messy so maybe comment this out
% for eachcond = 1:length(conds)
%     plot(squeeze(x_index(1,eachcond,[1,2])), squeeze(data_to_plot(tmpsubsboth,conds(eachcond),[1 4])))
%     hold on
% end
% for eachcond = 1:length(conds)
%     plot(squeeze(x_index(1,eachcond,[3,4])), squeeze(data_to_plot(tmpsubsboth,conds(eachcond),[2 5])))
%     hold on
% end


xlabels = {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Ctrl Fellow', 'Ctrl BS', 'Grey Screen'};
set(gca, 'XTickLabel', xlabels(conds))
% set(gca, 'ylabel', {'Beta weight'})
ylabel('Beta Weight')
set(gcf, 'Position', [500 200 2000 1000])
set(gca, 'XTick', initial_coords + 40)
set(gca, 'fontsize',20);
ax = gca;
ax.XLim = [-50 1400];
ax.YLim = [-1.5 2];
% axes([-1 2 -10 350])
axislabels = {'BS CON','ACTUAL CON', 'V1 around stimulus', 'BS CON V2', 'ACTUAL CON V2',  'BS EDGE V1', 'BS EDGE V2'};
% axislabels = {'BS Cons', 'Actual Stim Cons', 'V1 outside Stim'}
legend([bardata()],axislabels(whattoplot))


%% Stats - Conditions against one another
conditionsnames = {'Intact', 'BS', 'Occluded', 'DelSh', 'DelFuzzy', 'Ctrl Fellow', 'CtrlBS', 'Grey'};


% 1 = BS CON V1 ROI
% 2 = ACTUAL CON V1 ROI
% 4 = BS CON V2
% 5 = ACTUAL CON V2
% 6 = BS EDGE V1
% 7 = BS EDGE V2


whichexpt = 2; % 1 or 2 or 3both
roi = 5;

if whichexpt == 1
    subs = [1:13];
elseif whichexpt == 2
    subs = [14:26];
elseif whichexpt == 3
    subs = [1:26];
end






%for both expts
for eachcond = 1:7 %for intact, BS etc
    for eachcomparisoncond = eachcond+1:8
        % choose which subs to use, we only want subs with no NaNs in both
        % conditions. This is important for calculating the correct means
        % for the pairwise comparison. E.g. Intact mean for IntactvsBS is
        % not the same as IntactvsOccluded because different groups of
        % Intact subs are used. nanmean(Intact) just gives the general mean
        % which is what's on the graph, but not what we use for t-test.
        % For BayesFactor we can use the overall mean as the more
        % theoretical one is fine (rather than the one we used for the
        % specific comparison in ttest due to missing data in that specific pair of conds).
        % This is what I did in beh paper.
        data_ = data_to_plot(subs,:,:); %select the correct bit of the dataset for each experiment. Tmpsubs vector is only as long as each experiment
        % eg 1 to 13, and then it doesn't work for experiment 2 because we
        % need to index 14 to 26 instead. So if we extract data(14:26) into
        % data (1:13) then can index without fear :)
        tmpsubs = ~isnan(data_to_plot(subs,eachcond,roi)) & ~isnan(data_to_plot(subs,eachcomparisoncond,roi));
        disp (fprintf ('%s vs %s', conditionsnames{eachcond}, conditionsnames{eachcomparisoncond}))
        [H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise(data_(tmpsubs,eachcond,roi), data_(tmpsubs,eachcomparisoncond,roi));
        [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -1, 1, nanmean(data_to_plot(subs,eachcond,roi)))
        %     lowerBound
        %     upperBound
        %     BF
    end
end


%% Stats - Conditions against ZERO
conditionsnames = {'Intact', 'BS', 'Occluded', 'DelSh', 'DelFuzzy', 'Ctrl Fellow', 'CtrlBS', 'Grey'};


% 1 = BS CON V1 ROI
% 2 = ACTUAL CON V1 ROI
% 4 = BS CON V2
% 5 = ACTUAL CON V2
% 6 = BS EDGE V1
% 7 = BS EDGE V2


whichexpt = 1; % 1 or 2 or 3both
roi = 2;

if whichexpt == 1
    subs = [1:13];
elseif whichexpt == 2
    subs = [14:26];
elseif whichexpt == 3
    subs = [1:26];
end






%for both expts
for eachcond = 1:8 %for intact, BS etc
        % choose which subs to use, we only want subs with no NaNs in both
        % conditions. This is important for calculating the correct means
        % for the pairwise comparison. E.g. Intact mean for IntactvsBS is
        % not the same as IntactvsOccluded because different groups of
        % Intact subs are used. nanmean(Intact) just gives the general mean
        % which is what's on the graph, but not what we use for t-test.
        % For BayesFactor we can use the overall mean as the more
        % theoretical one is fine (rather than the one we used for the
        % specific comparison in ttest due to missing data in that specific pair of conds).
        % This is what I did in beh paper.
        data_ = data_to_plot(subs,:,:); %select the correct bit of the dataset for each experiment. Tmpsubs vector is only as long as each experiment
        % eg 1 to 13, and then it doesn't work for experiment 2 because we
        % need to index 14 to 26 instead. So if we extract data(14:26) into
        % data (1:13) then can index without fear :)
        tmpsubs = ~isnan(data_to_plot(subs,eachcond,roi));
        fprintf ('%s', conditionsnames{eachcond})
        [H,P, STATS, raweffect, SE, corrected_SE] = t_test_from_zero(data_(tmpsubs,eachcond,roi));
        [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -1, 1, 0)
        %     lowerBound
        %     upperBound
        %     BF
end


%% Stats - ROIs against each other for a specific condition
conditionsnames = {'Intact', 'BS', 'Occluded', 'DelSh', 'DelFuzzy', 'Ctrl Fellow', 'CtrlBS', 'Grey'};


% 1 = BS CON V1 ROI
% 2 = ACTUAL CON V1 ROI
% 3 = V1 around stim
% 4 = BS CON V2
% 5 = ACTUAL CON V2
% 6 = BS EDGE V1
% 7 = BS EDGE V2


whichexpt = 1; % 1 or 2 or 3both
roi = 4;
roi2 = 7;

if whichexpt == 1
    subs = [1:13];
elseif whichexpt == 2
    subs = [14:26];
elseif whichexpt == 3
    subs = [1:26];
end






%for both expts
for eachcond = 1:8 %for intact, BS etc
        % choose which subs to use, we only want subs with no NaNs in both
        % conditions. This is important for calculating the correct means
        % for the pairwise comparison. E.g. Intact mean for IntactvsBS is
        % not the same as IntactvsOccluded because different groups of
        % Intact subs are used. nanmean(Intact) just gives the general mean
        % which is what's on the graph, but not what we use for t-test.
        % For BayesFactor we can use the overall mean as the more
        % theoretical one is fine (rather than the one we used for the
        % specific comparison in ttest due to missing data in that specific pair of conds).
        % This is what I did in beh paper.
        data_ = data_to_plot(subs,:,:); %select the correct bit of the dataset for each experiment. Tmpsubs vector is only as long as each experiment
        % eg 1 to 13, and then it doesn't work for experiment 2 because we
        % need to index 14 to 26 instead. So if we extract data(14:26) into
        % data (1:13) then can index without fear :)
        tmpsubs = ~isnan(data_to_plot(subs,eachcond,roi)) & ~isnan(data_to_plot(subs,eachcond,roi2));
        fprintf ('%s for %d vs %d ROIs', conditionsnames{eachcond}, roi, roi2)
        [H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise(data_(tmpsubs,eachcond,roi),data_(tmpsubs,eachcond,roi2));
        [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -1, 1, nanmean(data_to_plot(subs,eachcond,roi)))
        %     lowerBound
        %     upperBound
        %     BF
end
