col = 15;

col2correlatewith = 16;

figure; scatter(unnamed(:,col), unnamed(:,col2correlatewith)); lsline; [r,p] = corr(unnamed(:,col), unnamed(:,col2correlatewith)), title([num2str(r), '  ', num2str(p)]);
[r, p] = corr(unnamed(:,col), unnamed(:,col2correlatewith), 'Type', 'Spearman')




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

nobvs = 7;

SEM = std(data)/sqrt(length(data(:,1)));
figure; bar(mean(data), 'y');
hold on
e = errorbar(mean(data),SEM, 'o');
e.Color = 'k';
e.LineWidth = 2;

plotspreadhandles = plotSpread(data, 'distributionMarkers', 'O', 'distributionColors', 'k');
%     set(ah{3}, 'MarkerSize', 20)
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',5);
set(gca, 'XTickLabel', {'Intact', 'Blind Spot', 'Occluded', 'Deleted Sharp', 'Deleted Fuzzy', 'Grey Screen'})
set(gcf, 'Position', [500 500 600 500])
