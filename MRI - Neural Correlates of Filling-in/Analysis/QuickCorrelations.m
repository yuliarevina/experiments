col = 18;

col2correlatewith = 12;

figure; scatter(unnamed(:,col), unnamed(:,col2correlatewith)); lsline; [r,p] = corr(unnamed(:,col), unnamed(:,col2correlatewith), 'rows', 'complete'), %title([num2str(r), '  ', num2str(p)]);
[r, p] = corr(unnamed(:,col), unnamed(:,col2correlatewith), 'Type', 'Spearman', 'rows', 'complete')
% [r, p] = corr(unnamed(:,col), unnamed(:,col2correlatewith), 'Type', 'Pearson')
title(sprintf('r = %f, p = %f', r, p))



%% Quick boxplots
figure;
% for column = 1:15
bx = boxplot(data(:,:))
hold on
set(gca, 'XTickLabel', {'Intact v BS', 'Intact v Occ', 'Intact v DelSh', 'Intact v DelFuzz', 'Intact v Fix', 'BS v Occ'...
    'BS v DelSh', 'BS v DelFuzz', 'BS v Fix', 'Occ v DelSh', 'Occ v DelFuzz', 'Occ v Fix', 'DelSh v DelFuzz', 'DelSh v Fix', 'DelFuzz v Fix'})
ax = gca;
set(gca, 'fontsize',13);
h = get(bx(5,:),{'XData','YData'});
for k=1:size(h,1)
    patch(h{k,1},h{k,2},[0.4 0.8 0.85]);
    patch(h{k,1},h{k,2},'y');
end
ax.Children = ax.Children([end 1:end-1]);

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines,'linewidth',1, 'Color', 'r');
set(lines,'linewidth',3)

plotspreadhandles = plotSpread(data, 'distributionMarkers', 'O', 'distributionColors', 'g');
%     set(ah{3}, 'MarkerSize', 20)
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',10);
plot([0:16], zeros(1,17))
% end


%% Quick t-tests on z-scores
col1 = 34;
col2 = 6;

mean(unnamed(:,col1))
mean(unnamed(:,col2))

% [H,P] = ttest(unnamed(:,col1), unnamed(:,col2))

% [H,P] = ttest(unnamed(:,col1), unnamed(:,col2), 'tail', 'left')


[H,P] = ttest(unnamed(:,col1))

%% Quick bar chart for univariate analysis

nobvs = 11;
nobvsV2 = 7;

% 1. BS conservative
% 2. BS liberal
% 3. Actual conservative
% 4. Actual liberal
% 5. V1 around stim
% 6. V1 for comparison with V2
% 7. V2
%
%
%
% nSub = 11;

data_to_plot = zeros(nobvs,6,6);
data_to_plotV2 = zeros(nobvsV2,6,6);
data_to_plot_blk_as_fix_and_stim = zeros(nobvs,7,3);

data_to_plot(:,:,1) = MRI_univariate.BS_con;
data_to_plot(:,:,2) = MRI_univariate.BS_lib;
data_to_plot(:,:,3) = MRI_univariate.BS_edge;
data_to_plot(:,:,4) = MRI_univariate.Actual_con;
data_to_plot(:,:,5) = MRI_univariate.V1;
data_to_plot(:,:,6) = MRI_univariate.Actual_lib;
data_to_plotV2(:,:,6) = V1vsV2(:,1:6);
data_to_plotV2(:,:,7) = V1vsV2(:,7:12);
data_to_plot_blk_as_fix_and_stim(:,:,1) = MRI_univariate.BS_con_blk_as_fix_and_stim;
data_to_plot_blk_as_fix_and_stim(:,:,2) = MRI_univariate.Actual_con_blk_as_fix_and_stim;
data_to_plot_blk_as_fix_and_stim(:,:,3) = MRI_univariate.V1_blk_as_fix_and_stim;

clear x_index;
initial_coords = [0, 100, 200, 300, 400, 500];
initial_coords = [0, 200, 400, 600, 800, 1000];
initial_coords = [0, 250, 500, 750, 1000, 1250];
x_index(:,:,1) = initial_coords
x_index(:,:,2) = initial_coords + 40
x_index(:,:,3) = initial_coords + 80
x_index(:,:,4) = initial_coords + 120
x_index(:,:,5) = initial_coords + 160
x_index(:,:,6) = initial_coords + 200
x_index(:,:,7) = initial_coords + 240

% x_index(:,:,1) = initial_coords
% x_index(:,:,2) = initial_coords + 60
% x_index(:,:,3) = initial_coords + 100
% x_index(:,:,4) = initial_coords + 140
% x_index(:,:,5) = initial_coords + 180
% x_index(:,:,6) = initial_coords + 220
% x_index(:,:,7) = initial_coords + 260

color_index(:,:,1) = [237/255, 125/255, 49/255];
color_index(:,:,2) = [255/255, 175/255, 99/255];
color_index(:,:,3) = [255/255, 255/255, 49/255];
color_index(:,:,4) = [141/255, 205/255, 255/255];
color_index(:,:,5) = [128/255, 128/255, 128/255];
color_index(:,:,6) = [91/255, 155/255, 213/255];
color_index(:,:,7) = [255/255, 255/255, 213/255];

% bardata(1) = [];
% bardata(2) = [];
% bardata(3) = [];
% bardata(4) = [];
% bardata(5) = [];


%everything
figure;
whattoplot = [1,4, 5]; %which conditions in data-to-plot
% whattoplot = [1:5];
for i = whattoplot
% BS conservative
switch i %assign x position on the graph. e.g. cond 4 not always need to be 4th bar on the barchart
    case 1
        j = 1;
    case 2
        j = 2;
    case 3
        j = 2;
    case 4
        j = 3;
    case 5
        j = 5;
    case 6
        j = 2;
end
SEM = std(data_to_plot(:,:,i))/sqrt(length(data_to_plot(:,:,i)));
bardata(j) = bar(x_index(:,:,j), mean(data_to_plot(:,:,i)), 'FaceColor', color_index(:,:,j), 'BarWidth', 0.15);
hold on
e = errorbar(x_index(:,:,j), mean(data_to_plot(:,:,i)),SEM, 'o');
e.Color = 'k';
e.LineWidth = 2;

% catindex = repmat([1;6;12;18;24;30], 1,6)'
catindex = [x_index(:,1,j)* ones(1, nobvs)'; x_index(:,2,j)* ones(1, nobvs)'; x_index(:,3,j) * ones(1, nobvs)'; x_index(:,4,j) * ones(1, nobvs)'; x_index(:,5,j)* ones(1, nobvs)'; x_index(:,6,j) * ones(1, nobvs)'];

plotspreadhandles = plotSpread([data_to_plot(:,:,i)], 'distributionIdx', catindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
%     set(ah{3}, 'MarkerSize', 20)
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',5);
% set(gca, 'XTick', [0 20 40 60 80 100 120 140 160])

% bardata(2) = [];
% bardata(3) = [];
% bardata(4) = [];
% bardata(5) = [];
end
set(gca, 'XTickLabel', {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Grey Screen', 'Black Screen'})
% set(gca, 'ylabel', {'Beta weight'})
ylabel('Beta Weight')
set(gcf, 'Position', [500 200 2000 1000])
set(gca, 'XTick', initial_coords + 40)
set(gca, 'fontsize',20);
ax = gca;
ax.XLim = [-30 1500];
ax.YLim = [-1.1 2];
% axes([-1 2 -10 350])
axislabels = {'BS Cons','BS lib', 'BS edge', 'Actual Stim Cons', 'V1 outside Stim',  'Actual Stim Lib'}
% axislabels = {'BS Cons', 'Actual Stim Cons', 'V1 outside Stim'}
% legend([bardata(whattoplot)],axislabels(whattoplot))

%%
clear x_index
initial_coords = [0, 100, 200, 300, 400, 500, 600];
initial_coords = [0, 200, 400, 600, 800, 1000, 1200];
initial_coords = [0, 250, 500, 750, 1000, 1250, 1500];

x_index(:,:,1) = initial_coords
x_index(:,:,2) = initial_coords + 40
x_index(:,:,3) = initial_coords + 80
x_index(:,:,4) = initial_coords + 120
x_index(:,:,5) = initial_coords + 160
x_index(:,:,6) = initial_coords + 200
x_index(:,:,7) = initial_coords + 240

hold on
for i = [2,4,6] %bar position
    switch i
        case 2
            j = 1; %which index in data matrix (i and j opposite to what they are above, maybe should change later!)
        case 4
            j = 2;
        case 6
            j = 3;
    end
    SEM = std(data_to_plot_blk_as_fix_and_stim(:,:,j))/sqrt(length(data_to_plot_blk_as_fix_and_stim(:,:,j)));
    bardata(i) = bar(x_index(:,:,i), mean(data_to_plot_blk_as_fix_and_stim(:,:,j)), 'FaceColor', color_index(:,:,i), 'BarWidth', 0.15);
    hold on
    e = errorbar(x_index(:,:,i), mean(data_to_plot_blk_as_fix_and_stim(:,:,j)),SEM, 'o');
    e.Color = 'k';
    e.LineWidth = 2;
    
    % catindex = repmat([1;6;12;18;24;30], 1,6)'
    catindex = [x_index(:,1,i)* ones(1, nobvs)'; x_index(:,2,i)* ones(1, nobvs)'; x_index(:,3,i) * ones(1, nobvs)'; x_index(:,4,i) * ones(1, nobvs)'; x_index(:,5,i)* ones(1, nobvs)'; x_index(:,6,i) * ones(1, nobvs)'; x_index(:,7,i) * ones(1, nobvs)'];
%     catindex = [x_index(:,1,1)* ones(1, nobvs)'; x_index(:,3,2)* ones(1, nobvs)';  x_index(:,6,2) * ones(1, nobvs)';
    plotspreadhandles = plotSpread([data_to_plot_blk_as_fix_and_stim(:,:,j)], 'distributionIdx', catindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
    %     set(ah{3}, 'MarkerSize', 20)
    set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',5);
    % set(gca, 'XTick', [0 20 40 60 80 100 120 140 160])
end
set(gca, 'XTickLabel', {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Grey Screen', 'Black Screen'})
% set(gca, 'ylabel', {'Beta weight'})
ylabel('Beta Weight')
set(gcf, 'Position', [500 200 2000 1000])
set(gca, 'XTick', initial_coords + 40)
set(gca, 'fontsize',20);
ax = gca;
ax.XLim = [-30 1750];
ax.YLim = [-1.1 2];
axislabels = {'BS Cons','BS Cons blk as stim', 'Actual Stim Cons', 'Actual Stim Cons blk as stim', 'V1 outside Stim',  'V1 outside Stim blk as stim'}
% axislabels = {'BS Cons', 'Actual Stim Cons', 'V1 outside Stim'}
legend(bardata,axislabels)
%%
%v2
%everything
initial_coords = [-200, -100, -0, 100, 200, 300];
% initial_coords = [0, 200, 400, 600, 800, 1000];
x_index(:,:,1) = initial_coords
x_index(:,:,2) = initial_coords + 40
x_index(:,:,3) = initial_coords + 80
x_index(:,:,4) = initial_coords + 120
x_index(:,:,5) = initial_coords + 160
x_index(:,:,6) = initial_coords + 200
x_index(:,:,7) = initial_coords + 240
figure;
nObvsV2 = 7;
for i = [6:7]
% BS conservative
SEM = std(data_to_plotV2(:,:,i))/sqrt(length(data_to_plotV2(:,:,i)));
bardata(i) = bar(x_index(:,:,i), mean(data_to_plotV2(:,:,i)), 'FaceColor', color_index(:,:,i), 'BarWidth', 0.2);
hold on
e = errorbar(x_index(:,:,i), mean(data_to_plotV2(:,:,i)),SEM, 'o');
e.Color = 'k';
e.LineWidth = 2;

% catindex = repmat([1;6;12;18;24;30], 1,6)'
catindex = [x_index(:,1,i)* ones(1, nObvsV2)'; x_index(:,2,i)* ones(1, nObvsV2)'; x_index(:,3,i) * ones(1, nObvsV2)'; x_index(:,4,i) * ones(1, nObvsV2)'; x_index(:,5,i)* ones(1, nObvsV2)'; x_index(:,6,i) * ones(1, nObvsV2)']

plotspreadhandles = plotSpread([data_to_plotV2(:,:,i)], 'distributionIdx', catindex, 'distributionMarkers', 'O', 'distributionColors', 'k', 'spreadWidth', 70);
%     set(ah{3}, 'MarkerSize', 20)
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',5);
% set(gca, 'XTick', [0 20 40 60 80 100 120 140 160])

% bardata(2) = [];
% bardata(3) = [];
% bardata(4) = [];
% bardata(5) = [];
end
set(gca, 'XTickLabel', {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Grey Screen'})
% set(gca, 'ylabel', {'Beta weight'})
ylabel('Beta Weight')
set(gcf, 'Position', [500 200 2000 1000])
set(gca, 'XTick', initial_coords+220)
set(gca, 'fontsize',20);
ax = gca;
ax.XLim = [-30 570];
ax.YLim = [-0.7 2];
% axes([-1 2 -10 350])
legend([bardata(6) bardata(7)],{'V1 BS cons','V2 BS cons'})

%% t tests

% BS con ROI
disp ('Intact vs BS')
mean(MRI_univariate.BS_con(:,1))
mean(MRI_univariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1), MRI_univariate.BS_con(:,2))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,1)) - mean(MRI_univariate.BS_con(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs Occ')
mean(MRI_univariate.BS_con(:,1))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1), MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,1)) - mean(MRI_univariate.BS_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs DelSh')
mean(MRI_univariate.BS_con(:,1))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,1)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs DelFuzzy')
mean(MRI_univariate.BS_con(:,1))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,1)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs Grey')
mean(MRI_univariate.BS_con(:,1))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,1)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%%
disp ('BS vs Occ')
mean(MRI_univariate.BS_con(:,2))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,2), MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,2)) - mean(MRI_univariate.BS_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS vs DelSh')
mean(MRI_univariate.BS_con(:,2))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,2), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,2)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('BS vs DelFuzzy')
mean(MRI_univariate.BS_con(:,2))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,2), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,2)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS vs Grey')
mean(MRI_univariate.BS_con(:,2))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,2), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,2)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('Occ vs DelSh')
mean(MRI_univariate.BS_con(:,3))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,3), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,3)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ vs DelFuzzy')
mean(MRI_univariate.BS_con(:,3))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,3), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,3)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ vs Grey')
mean(MRI_univariate.BS_con(:,3))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,3), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,3)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('DelSh vs DelFuzzy')
mean(MRI_univariate.BS_con(:,4))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,4), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,4)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Delsh vs Grey')
mean(MRI_univariate.BS_con(:,4))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,4), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,4)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('DelFuzz vs Grey')
mean(MRI_univariate.BS_con(:,5))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,5), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_con(:,5)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30







%%% actual stim con roi
disp ('Intact vs BS')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.Actual_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.Actual_con(:,2))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.Actual_con(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs Occ')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.Actual_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.Actual_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.Actual_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Intact vs DelSh')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.Actual_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.Actual_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.Actual_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('Intact vs DelFuzzy')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.Actual_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.Actual_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.Actual_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('Intact vs Grey')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.Actual_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.Actual_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.Actual_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%%
disp ('BS vs Occ')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.Actual_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.Actual_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.Actual_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS vs DelSh')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.Actual_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.Actual_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.Actual_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('BS vs DelFuzzy')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.Actual_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.Actual_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.Actual_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS vs Grey')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.Actual_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.Actual_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.Actual_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('Occ vs DelSh')
mean(MRI_univariate.Actual_con(:,3))
mean(MRI_univariate.Actual_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,3), MRI_univariate.Actual_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,3)) - mean(MRI_univariate.Actual_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ vs DelFuzzy')
mean(MRI_univariate.Actual_con(:,3))
mean(MRI_univariate.Actual_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,3), MRI_univariate.Actual_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,3)) - mean(MRI_univariate.Actual_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ vs Grey')
mean(MRI_univariate.Actual_con(:,3))
mean(MRI_univariate.Actual_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,3), MRI_univariate.Actual_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,3)) - mean(MRI_univariate.Actual_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('DelSh vs DelFuzzy')
mean(MRI_univariate.Actual_con(:,4))
mean(MRI_univariate.Actual_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,4), MRI_univariate.Actual_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,4)) - mean(MRI_univariate.Actual_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Delsh vs Grey')
mean(MRI_univariate.Actual_con(:,4))
mean(MRI_univariate.Actual_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,4), MRI_univariate.Actual_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,4)) - mean(MRI_univariate.Actual_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%%
disp ('DelFuzz vs Grey')
mean(MRI_univariate.Actual_con(:,5))
mean(MRI_univariate.Actual_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,5), MRI_univariate.Actual_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,5)) - mean(MRI_univariate.Actual_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



%%% actual stim con roi > BS con roi
disp ('Intact actual vs Intact BS')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.BS_con(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.BS_con(:,1))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.BS_con(:,1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS actual vs BS BS')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.BS_con(:,2))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.BS_con(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ actual vs Occ BS')
mean(MRI_univariate.Actual_con(:,3))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,3), MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,3)) - mean(MRI_univariate.BS_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelSh actual vs DelSh BS')
mean(MRI_univariate.Actual_con(:,4))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,4), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,4)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('DelFuz actual vs DelFuzz BS')
mean(MRI_univariate.Actual_con(:,5))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,5), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,5)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Grey actual vs Grey BS')
mean(MRI_univariate.Actual_con(:,6))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,6), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,6)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% actual stim con roi > BS lib roi
disp ('Intact actual vs Intact BS')
mean(MRI_univariate.Actual_con(:,1))
mean(MRI_univariate.BS_lib(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,1), MRI_univariate.BS_lib(:,1))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,1)) - mean(MRI_univariate.BS_lib(:,1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS actual vs BS BS')
mean(MRI_univariate.Actual_con(:,2))
mean(MRI_univariate.BS_lib(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,2), MRI_univariate.BS_lib(:,2))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,2)) - mean(MRI_univariate.BS_lib(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ actual vs Occ BS')
mean(MRI_univariate.Actual_con(:,3))
mean(MRI_univariate.BS_lib(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,3), MRI_univariate.BS_lib(:,3))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,3)) - mean(MRI_univariate.BS_lib(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelSh actual vs DelSh BS')
mean(MRI_univariate.Actual_con(:,4))
mean(MRI_univariate.BS_lib(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,4), MRI_univariate.BS_lib(:,4))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,4)) - mean(MRI_univariate.BS_lib(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('DelFuz actual vs DelFuzz BS')
mean(MRI_univariate.Actual_con(:,5))
mean(MRI_univariate.BS_lib(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,5), MRI_univariate.BS_lib(:,5))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,5)) - mean(MRI_univariate.BS_lib(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Grey actual vs Grey BS')
mean(MRI_univariate.Actual_con(:,6))
mean(MRI_univariate.BS_lib(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.Actual_con(:,6), MRI_univariate.BS_lib(:,6))
%for bayes
raweffect = mean(MRI_univariate.Actual_con(:,6)) - mean(MRI_univariate.BS_lib(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



%%% BS con roi < BS lib roi
disp ('Intact BS lib vs Intact BS con')
mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,1), MRI_univariate.BS_con(:,1))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,1)) - mean(MRI_univariate.BS_con(:,1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS BSlib vs BS BScon')
mean(MRI_univariate.BS_lib(:,2))
mean(MRI_univariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,2), MRI_univariate.BS_con(:,2))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,2)) - mean(MRI_univariate.BS_con(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ BSlib vs Occ BScon')
mean(MRI_univariate.BS_lib(:,3))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,3), MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,3)) - mean(MRI_univariate.BS_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelSh BSlib vs DelSh BScon')
mean(MRI_univariate.BS_lib(:,4))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,4), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,4)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('DelFuz BSlib vs DelFuzz BScon')
mean(MRI_univariate.BS_lib(:,5))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,5), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,5)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Grey BSlib vs Grey BScon')
mean(MRI_univariate.BS_lib(:,6))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_lib(:,6), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_lib(:,6)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% BS edge stringgent roi > BS con roi
disp ('Intact BS_edge vs Intact BS con')
mean(MRI_univariate.BS_edge(:,1))
mean(MRI_univariate.BS_con(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,1), MRI_univariate.BS_con(:,1))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,1)) - mean(MRI_univariate.BS_con(:,1))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('BS BS_edge vs BS BScon')
mean(MRI_univariate.BS_edge(:,2))
mean(MRI_univariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,2), MRI_univariate.BS_con(:,2))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,2)) - mean(MRI_univariate.BS_con(:,2))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Occ BS_edge vs Occ BScon')
mean(MRI_univariate.BS_edge(:,3))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,3), MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,3)) - mean(MRI_univariate.BS_con(:,3))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelSh BS_edge vs DelSh BScon')
mean(MRI_univariate.BS_edge(:,4))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,4), MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,4)) - mean(MRI_univariate.BS_con(:,4))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('DelFuz BS_edge vs DelFuzz BScon')
mean(MRI_univariate.BS_edge(:,5))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,5), MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,5)) - mean(MRI_univariate.BS_con(:,5))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

disp ('Grey BS_edge vs Grey BScon')
mean(MRI_univariate.BS_edge(:,6))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_edge(:,6), MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(MRI_univariate.BS_edge(:,6)) - mean(MRI_univariate.BS_con(:,6))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30




%%% BS V1 < BS V2
disp ('Intact V1 vs Intact V2')
mean(V1vsV2(:,1))
mean(V1vsV2(:,7))
[H,P, ~,STATS] = ttest(V1vsV2(:,1), V1vsV2(:,7))
%for bayes
raweffect = mean(V1vsV2(:,1)) - mean(V1vsV2(:,7))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% BS V1 < BS V2
disp ('BS V1 vs BS V2')
mean(V1vsV2(:,2))
mean(V1vsV2(:,8))
[H,P, ~,STATS] = ttest(V1vsV2(:,2), V1vsV2(:,8))
%for bayes
raweffect = mean(V1vsV2(:,2)) - mean(V1vsV2(:,8))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% BS V1 < BS V2
disp ('Occ V1 vs Occ V2')
mean(V1vsV2(:,3))
mean(V1vsV2(:,9))
[H,P, ~,STATS] = ttest(V1vsV2(:,3), V1vsV2(:,9))
%for bayes
raweffect = mean(V1vsV2(:,3)) - mean(V1vsV2(:,9))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% BS V1 < BS V2
disp ('DeletedSharp V1 vs DeletedSharp V2')
mean(V1vsV2(:,4))
mean(V1vsV2(:,10))
[H,P, ~,STATS] = ttest(V1vsV2(:,4), V1vsV2(:,10))
%for bayes
raweffect = mean(V1vsV2(:,4)) - mean(V1vsV2(:,10))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% BS V1 < BS V2
disp ('DeletedFuzzy V1 vs DeletedFuzzy V2')
mean(V1vsV2(:,5))
mean(V1vsV2(:,11))
[H,P, ~,STATS] = ttest(V1vsV2(:,5), V1vsV2(:,11))
%for bayes
raweffect = mean(V1vsV2(:,5)) - mean(V1vsV2(:,11))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% BS V1 < BS V2
disp ('Grey V1 vs Grey V2')
mean(V1vsV2(:,6))
mean(V1vsV2(:,12))
[H,P, ~,STATS] = ttest(V1vsV2(:,6), V1vsV2(:,12))
%for bayes
raweffect = mean(V1vsV2(:,6)) - mean(V1vsV2(:,12))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% from baseline
disp ('Intact BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,1))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,1) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('BS BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,2))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,2) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('OCc BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,3))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,3) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelSh BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,4))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,4) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('DelFuzz BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,5))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,5) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


disp ('Grey BS con from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.BS_con(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.BS_con(:,6))
%for bayes
raweffect = mean(mean(MRI_univariate.BS_con(:,6) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



%%% V2 from baseline
disp ('Intact V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,7))
[H,P, ~,STATS] = ttest(V1vsV2(:,7))
%for bayes
raweffect = mean(mean(V1vsV2(:,7) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% V2 from baseline
disp ('BS V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,8))
[H,P, ~,STATS] = ttest(V1vsV2(:,8))
%for bayes
raweffect = mean(mean(V1vsV2(:,8) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V2 from baseline
disp ('Occ V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,9))
[H,P, ~,STATS] = ttest(V1vsV2(:,9))
%for bayes
raweffect = mean(mean(V1vsV2(:,9) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30



%%% V2 from baseline
disp ('DelSh V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,10))
[H,P, ~,STATS] = ttest(V1vsV2(:,10))
%for bayes
raweffect = mean(mean(V1vsV2(:,10) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V2 from baseline
disp ('DelFuzz V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,11))
[H,P, ~,STATS] = ttest(V1vsV2(:,11))
%for bayes
raweffect = mean(mean(V1vsV2(:,11) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V2 from baseline
disp ('Grey V2 from baseline')
% mean(V1vsV2(:,1))
mean(V1vsV2(:,12))
[H,P, ~,STATS] = ttest(V1vsV2(:,12))
%for bayes
raweffect = mean(mean(V1vsV2(:,12) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V1 around stim from baseline
disp ('Intact V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,1))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,1))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,1) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V1 around stim from baseline
disp ('BS V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,2))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,2))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,2) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V1 around stim from baseline
disp ('Occ V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,3))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,3))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,3) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V1 around stim from baseline
disp ('DelSh V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,4))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,4))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,4) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% V1 around stim from baseline
disp ('DelFuzz V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,5))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,5))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,5) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30


%%% V1 around stim from baseline
disp ('Grey V1 around stim from baseline')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_univariate.V1(:,6))
[H,P, ~,STATS] = ttest(MRI_univariate.V1(:,6))
%for bayes
raweffect = mean(mean(MRI_univariate.V1(:,6) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30