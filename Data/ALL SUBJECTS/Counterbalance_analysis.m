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
subjectsIntact = [1:10];
subjectsIntactCounterbalance = [11:37];
subjectsBS = [1:10];
subjectsBSCounterbalance = [11:37];
subjectsOcc = [1:10];
subjectsOccCounterbalance = [11:37];
subjectsDelSh = [1:10];
subjectsDelShCounterbalance = [11:37];
subjectsDelFuzz = [1:10];
subjectsDelFuzzCounterbalance = [11:37];

if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
     subjectsIntactCounterbalance = setdiff(subjectsIntactCounterbalance, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
     subjectsBSCounterbalance = setdiff(subjectsBSCounterbalance,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
     subjectsOccCounterbalance = setdiff(subjectsOccCounterbalance, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
     subjectsDelShCounterbalance = setdiff(subjectsDelShCounterbalance,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
     subjectsDelFuzzCounterbalance = setdiff(subjectsDelFuzzCounterbalance, subjectsDelFuzzOutliers);
end

%means
meanIntactPSE = mean(Intact(subjectsIntact,1));
 meanIntactPSECounterbalance = mean(Intact(subjectsIntactCounterbalance,1));
meanBSPSE = mean(BS(subjectsBS,1));
 meanBSPSECounterbalance = mean(BS(subjectsBSCounterbalance,1));
meanOccludedPSE = mean(Occluded(subjectsOcc,1));
 meanOccludedPSECounterbalance = mean(Occluded(subjectsOccCounterbalance,1));
meanDelShPSE = mean(DeletedSharp(subjectsDelSh,1));
 meanDelShPSECounterbalance = mean(DeletedSharp(subjectsDelShCounterbalance,1));
meanDelFuzPSE = mean(DeletedFuzzy(subjectsDelFuzz,1));
 meanDelFuzPSECounterbalance = mean(DeletedFuzzy(subjectsDelFuzzCounterbalance,1));

%medians
medianIntactPSE = median(Intact(subjectsIntact,1));
 medianIntactPSECounterbalance = median(Intact(subjectsIntactCounterbalance,1));
medianBSPSE = median(BS(subjectsBS,1));
 medianBSPSECounterbalance = median(BS(subjectsBSCounterbalance,1));
medianOccludedPSE = median(Occluded(subjectsOcc,1));
 medianOccludedPSECounterbalance = median(Occluded(subjectsOccCounterbalance,1));
medianDelShPSE = median(DeletedSharp(subjectsDelSh,1));
 medianDelShPSECounterbalance = median(DeletedSharp(subjectsDelShCounterbalance,1));
medianDelFuzPSE = median(DeletedFuzzy(subjectsDelFuzz,1));
 medianDelFuzPSECounterbalance = median(DeletedFuzzy(subjectsDelFuzzCounterbalance,1));

%group data for boxplot
Alldatatoplot = [Intact(subjectsIntact,1); Intact(subjectsIntactCounterbalance,1);BS(subjectsBS,1); BS(subjectsBSCounterbalance,1); ...
    Occluded(subjectsOcc,1); Occluded(subjectsOccCounterbalance,1); DeletedSharp(subjectsDelSh,1); DeletedSharp(subjectsDelShCounterbalance,1); ...
    DeletedFuzzy(subjectsDelFuzz,1); DeletedFuzzy(subjectsDelFuzzCounterbalance,1)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsIntactCounterbalance))'; 3*ones(1,length(subjectsBS))'; ...
    4*ones(1,length(subjectsBSCounterbalance))';5*ones(1,length(subjectsOcc))'; 6*ones(1,length(subjectsOccCounterbalance))'; 7*ones(1,length(subjectsDelSh))'; 8*ones(1,length(subjectsDelShCounterbalance))'; ...
    9*ones(1,length(subjectsDelFuzz))'; 10*ones(1,length(subjectsDelFuzzCounterbalance))'];

individdata = {Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1) BS(subjectsBS,1), BS(subjectsBSCounterbalance,1), ...
    Occluded(subjectsOcc,1),Occluded(subjectsOccCounterbalance,1), DeletedSharp(subjectsDelSh,1), DeletedSharp(subjectsDelShCounterbalance,1), DeletedFuzzy(subjectsDelFuzz,1), DeletedFuzzy(subjectsDelFuzzCounterbalance,1)};




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
plot([0 11],[0.3 0.3], 'g--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact','IntactC', 'Blindspot', 'BlindspotC', 'Occluded', 'OccludedC', 'Deleted Sharp', 'Deleted Sharp C', 'Deleted Fuzzy', 'Deleted Fuzzy C'}) 
set(gca, 'TickDir', 'out')
ylabel('PSE')
% axis([0 6 0.25 0.7])
set(gcf, 'Position', [200, 200, 1600, 900])



%% significant diffs for PSEs medians

disp('Intact vs IntactC')
[p,h,stats] = ranksum(Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1)) %independent samples
% [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),1),BS(intersect(subjectsIntact,subjectsBS),1)) %paired samples

disp('BS vs BS_C')
[p,h,stats] = ranksum(BS(subjectsBS,1),BS(subjectsBSCounterbalance,1)) %independent samples

disp('Occ vs OccC')
[p,h,stats] = ranksum(Occluded(subjectsOcc,1),Occluded(subjectsOccCounterbalance,1)) %independent samples

disp('DelSh vs DelSh_C')
[p,h,stats] = ranksum(DeletedSharp(subjectsDelSh,1),DeletedSharp(subjectsDelShCounterbalance,1)) %independent samples

disp('DelFuzz vs DelFuzz_C')
[p,h,stats] = ranksum(DeletedFuzzy(subjectsDelFuzz,1),DeletedFuzzy(subjectsDelFuzzCounterbalance,1)) %independent samples


% ------------

disp('Intact vs BS')
% [p,h,stats] = ranksum(Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1)) %independent samples
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),1),BS(intersect(subjectsIntact,subjectsBS),1)) %paired samples

disp('Intact vs Occ')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsOcc),1),Occluded(intersect(subjectsIntact,subjectsOcc),1)) %paired samples

disp('Intact vs DelSh')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelSh),1),DeletedSharp(intersect(subjectsIntact,subjectsDelSh),1)) %paired samples

disp('Intact vs DelFuz')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),1)) %paired samples

disp('BS vs Occ')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsOcc),1),Occluded(intersect(subjectsBS,subjectsOcc),1)) %paired samples

disp('BS vs DelSh')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelSh),1),DeletedSharp(intersect(subjectsBS,subjectsDelSh),1)) %paired samples

disp('BS vs DelFuz')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),1)) %paired samples

disp('Occ vs DelSh')
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelSh),1),DeletedSharp(intersect(subjectsOcc,subjectsDelSh),1)) %paired samples

disp('Occ vs DelFuzz')
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),1)) %paired samples

disp('DelSh vs DelFuzz')
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),1),DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),1)) %paired samples

% -----------

disp('IntactC vs BS_C')
% [p,h,stats] = ranksum(Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1)) %independent samples
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsBSCounterbalance),1),BS(intersect(subjectsIntactCounterbalance,subjectsBSCounterbalance),1)) %paired samples

disp('IntactC vs OccC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsOccCounterbalance),1),Occluded(intersect(subjectsIntactCounterbalance,subjectsOccCounterbalance),1)) %paired samples

disp('IntactC vs DelShC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsDelShCounterbalance),1),DeletedSharp(intersect(subjectsIntactCounterbalance,subjectsDelShCounterbalance),1)) %paired samples

disp('IntactC vs DelFuzC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsDelFuzzCounterbalance),1),DeletedFuzzy(intersect(subjectsIntactCounterbalance,subjectsDelFuzzCounterbalance),1)) %paired samples

disp('BS_C vs Occ_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsOccCounterbalance),1),Occluded(intersect(subjectsBSCounterbalance,subjectsOccCounterbalance),1)) %paired samples

disp('BS_C vs DelSh_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsDelShCounterbalance),1),DeletedSharp(intersect(subjectsBSCounterbalance,subjectsDelShCounterbalance),1)) %paired samples

disp('BS_C vs DelFuz_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsDelFuzzCounterbalance),1),DeletedFuzzy(intersect(subjectsBSCounterbalance,subjectsDelFuzzCounterbalance),1)) %paired samples

disp('Occ_C vs DelSh_C')
[p,h,stats] = signrank(Occluded(intersect(subjectsOccCounterbalance,subjectsDelShCounterbalance),1),DeletedSharp(intersect(subjectsOccCounterbalance,subjectsDelShCounterbalance),1)) %paired samples

disp('Occ_C vs DelFuzz_C')
[p,h,stats] = signrank(Occluded(intersect(subjectsOccCounterbalance,subjectsDelFuzzCounterbalance),1),DeletedFuzzy(intersect(subjectsOccCounterbalance,subjectsDelFuzzCounterbalance),1)) %paired samples

disp('DelSh_C vs DelFuzz_C')
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelShCounterbalance,subjectsDelFuzzCounterbalance),1),DeletedFuzzy(intersect(subjectsDelShCounterbalance,subjectsDelFuzzCounterbalance),1)) %paired samples

% ------------------------------



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;


% %outliers
subjectsIntactOutliers = [];
subjectsBSOutliers = [19 26, 29, 32];
subjectsOccOutliers = [1 6 17 19 20 27, 29, 32, 36, 37];
subjectsDelShOutliers = [1 6 9 19 20 27, 29, 32, 37];
subjectsDelFuzzOutliers = [1 19 20 27, 29, 37];

% everything 
subjectsIntact = [1:10];
subjectsIntactCounterbalance = [11:37];
subjectsBS = [1:10];
subjectsBSCounterbalance = [11:37];
subjectsOcc = [1:10];
subjectsOccCounterbalance = [11:37];
subjectsDelSh = [1:10];
subjectsDelShCounterbalance = [11:37];
subjectsDelFuzz = [1:10];
subjectsDelFuzzCounterbalance = [11:37];

if removeoutliers %overwrite the sublists
    subjectsIntact = setdiff(subjectsIntact, subjectsIntactOutliers);
     subjectsIntactCounterbalance = setdiff(subjectsIntactCounterbalance, subjectsIntactOutliers);
    subjectsBS = setdiff(subjectsBS,subjectsBSOutliers);
     subjectsBSCounterbalance = setdiff(subjectsBSCounterbalance,subjectsBSOutliers);
    subjectsOcc = setdiff(subjectsOcc, subjectsOccOutliers);
     subjectsOccCounterbalance = setdiff(subjectsOccCounterbalance, subjectsOccOutliers);
    subjectsDelSh = setdiff(subjectsDelSh,subjectsDelShOutliers);
     subjectsDelShCounterbalance = setdiff(subjectsDelShCounterbalance,subjectsDelShOutliers);
    subjectsDelFuzz = setdiff(subjectsDelFuzz, subjectsDelFuzzOutliers);
     subjectsDelFuzzCounterbalance = setdiff(subjectsDelFuzzCounterbalance, subjectsDelFuzzOutliers);
end

%means
meanIntactSlope =  mean(Intact(subjectsIntact,2));
 meanIntactSlopeCounterbalance = mean(Intact(subjectsIntactCounterbalance,2));
meanBSSlope = mean(BS(subjectsBS,2));
 meanBSSlopeCounterbalance = mean(BS(subjectsBSCounterbalance,2));
meanOccludedSlope = mean(Occluded(subjectsOcc,2));
 meanOccludedSlopeCounterbalance = mean(Occluded(subjectsOccCounterbalance,2));
meanDelShSlope = mean(DeletedSharp(subjectsDelSh,2));
 meanDelShSlopeCounterbalance = mean(DeletedSharp(subjectsDelShCounterbalance,2));
meanDelFuzSlope = mean(DeletedFuzzy(subjectsDelFuzz,2));
 meanDelFuzSlopeCounterbalance = mean(DeletedFuzzy(subjectsDelFuzzCounterbalance,2));

%medians
medianIntactSlope = median(Intact(subjectsIntact,2));
 medianIntactSlopeCounterbalance = median(Intact(subjectsIntactCounterbalance,2));
medianBSSlope = median(BS(subjectsBS,2));
 medianBSSlopeCounterbalance = median(BS(subjectsBSCounterbalance,2));
medianOccludedSlope = median(Occluded(subjectsOcc,2));
 medianOccludedSlopeCounterbalance = median(Occluded(subjectsOccCounterbalance,2));
medianDelShSlope = median(DeletedSharp(subjectsDelSh,2));
 medianDelShSlopeCounterbalance = median(DeletedSharp(subjectsDelShCounterbalance,2));
medianDelFuzSlope = median(DeletedFuzzy(subjectsDelFuzz,2));
 medianDelFuzSlopeCounterbalance = median(DeletedFuzzy(subjectsDelFuzzCounterbalance,2));

%group data for boxplot
Alldatatoplot = [Intact(subjectsIntact,2); Intact(subjectsIntactCounterbalance,2);BS(subjectsBS,2); BS(subjectsBSCounterbalance,2); ...
    Occluded(subjectsOcc,2); Occluded(subjectsOccCounterbalance,2); DeletedSharp(subjectsDelSh,2); DeletedSharp(subjectsDelShCounterbalance,2); ...
    DeletedFuzzy(subjectsDelFuzz,2); DeletedFuzzy(subjectsDelFuzzCounterbalance,2)];
groups = [ones(1,length(subjectsIntact))';2*ones(1,length(subjectsIntactCounterbalance))'; 3*ones(1,length(subjectsBS))'; ...
    4*ones(1,length(subjectsBSCounterbalance))';5*ones(1,length(subjectsOcc))'; 6*ones(1,length(subjectsOccCounterbalance))'; 7*ones(1,length(subjectsDelSh))'; 8*ones(1,length(subjectsDelShCounterbalance))'; ...
    9*ones(1,length(subjectsDelFuzz))'; 10*ones(1,length(subjectsDelFuzzCounterbalance))'];

individdata = {Intact(subjectsIntact,2),Intact(subjectsIntactCounterbalance,2) BS(subjectsBS,2), BS(subjectsBSCounterbalance,2), ...
    Occluded(subjectsOcc,2),Occluded(subjectsOccCounterbalance,2), DeletedSharp(subjectsDelSh,2), DeletedSharp(subjectsDelShCounterbalance,2), DeletedFuzzy(subjectsDelFuzz,2), DeletedFuzzy(subjectsDelFuzzCounterbalance,2)};

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
% plot([0 11],[0.3 0.3], 'g--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 0.5);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);

% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Intact','IntactC', 'Blindspot', 'BlindspotC', 'Occluded', 'OccludedC', 'Deleted Sharp', 'Deleted Sharp C', 'Deleted Fuzzy', 'Deleted Fuzzy C'}) 
set(gca, 'TickDir', 'out')
ylabel('Slope')
% axis([0 6 0.25 0.7])
set(gcf, 'Position', [200, 200, 1600, 900])


%% significant diffs for Slopes medians

disp('Intact vs IntactC')
[p,h,stats] = ranksum(Intact(subjectsIntact,2),Intact(subjectsIntactCounterbalance,2)) %independent samples
% [p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),1),BS(intersect(subjectsIntact,subjectsBS),1)) %paired samples

disp('BS vs BS_C')
[p,h,stats] = ranksum(BS(subjectsBS,2),BS(subjectsBSCounterbalance,2)) %independent samples

disp('Occ vs OccC')
[p,h,stats] = ranksum(Occluded(subjectsOcc,2),Occluded(subjectsOccCounterbalance,2)) %independent samples

disp('DelSh vs DelSh_C')
[p,h,stats] = ranksum(DeletedSharp(subjectsDelSh,2),DeletedSharp(subjectsDelShCounterbalance,2)) %independent samples

disp('DelFuzz vs DelFuzz_C')
[p,h,stats] = ranksum(DeletedFuzzy(subjectsDelFuzz,2),DeletedFuzzy(subjectsDelFuzzCounterbalance,2)) %independent samples


% ------------

disp('Intact vs BS')
% [p,h,stats] = ranksum(Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1)) %independent samples
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsBS),2),BS(intersect(subjectsIntact,subjectsBS),2)) %paired samples

disp('Intact vs Occ')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsOcc),2),Occluded(intersect(subjectsIntact,subjectsOcc),2)) %paired samples

disp('Intact vs DelSh')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelSh),2),DeletedSharp(intersect(subjectsIntact,subjectsDelSh),2)) %paired samples

disp('Intact vs DelFuz')
[p,h,stats] = signrank(Intact(intersect(subjectsIntact,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsIntact,subjectsDelFuzz),2)) %paired samples

disp('BS vs Occ')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsOcc),2),Occluded(intersect(subjectsBS,subjectsOcc),2)) %paired samples

disp('BS vs DelSh')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelSh),2),DeletedSharp(intersect(subjectsBS,subjectsDelSh),2)) %paired samples

disp('BS vs DelFuz')
[p,h,stats] = signrank(BS(intersect(subjectsBS,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsBS,subjectsDelFuzz),2)) %paired samples

disp('Occ vs DelSh')
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelSh),2),DeletedSharp(intersect(subjectsOcc,subjectsDelSh),2)) %paired samples

disp('Occ vs DelFuzz')
[p,h,stats] = signrank(Occluded(intersect(subjectsOcc,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsOcc,subjectsDelFuzz),2)) %paired samples

disp('DelSh vs DelFuzz')
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelSh,subjectsDelFuzz),2),DeletedFuzzy(intersect(subjectsDelSh,subjectsDelFuzz),2)) %paired samples

% -----------

disp('IntactC vs BS_C')
% [p,h,stats] = ranksum(Intact(subjectsIntact,1),Intact(subjectsIntactCounterbalance,1)) %independent samples
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsBSCounterbalance),2),BS(intersect(subjectsIntactCounterbalance,subjectsBSCounterbalance),2)) %paired samples

disp('IntactC vs OccC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsOccCounterbalance),2),Occluded(intersect(subjectsIntactCounterbalance,subjectsOccCounterbalance),2)) %paired samples

disp('IntactC vs DelShC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsDelShCounterbalance),2),DeletedSharp(intersect(subjectsIntactCounterbalance,subjectsDelShCounterbalance),2)) %paired samples

disp('IntactC vs DelFuzC')
[p,h,stats] = signrank(Intact(intersect(subjectsIntactCounterbalance,subjectsDelFuzzCounterbalance),2),DeletedFuzzy(intersect(subjectsIntactCounterbalance,subjectsDelFuzzCounterbalance),2)) %paired samples

disp('BS_C vs Occ_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsOccCounterbalance),2),Occluded(intersect(subjectsBSCounterbalance,subjectsOccCounterbalance),2)) %paired samples

disp('BS_C vs DelSh_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsDelShCounterbalance),2),DeletedSharp(intersect(subjectsBSCounterbalance,subjectsDelShCounterbalance),2)) %paired samples

disp('BS_C vs DelFuz_C')
[p,h,stats] = signrank(BS(intersect(subjectsBSCounterbalance,subjectsDelFuzzCounterbalance),2),DeletedFuzzy(intersect(subjectsBSCounterbalance,subjectsDelFuzzCounterbalance),2)) %paired samples

disp('Occ_C vs DelSh_C')
[p,h,stats] = signrank(Occluded(intersect(subjectsOccCounterbalance,subjectsDelShCounterbalance),2),DeletedSharp(intersect(subjectsOccCounterbalance,subjectsDelShCounterbalance),2)) %paired samples

disp('Occ_C vs DelFuzz_C')
[p,h,stats] = signrank(Occluded(intersect(subjectsOccCounterbalance,subjectsDelFuzzCounterbalance),2),DeletedFuzzy(intersect(subjectsOccCounterbalance,subjectsDelFuzzCounterbalance),2)) %paired samples

disp('DelSh_C vs DelFuzz_C')
[p,h,stats] = signrank(DeletedSharp(intersect(subjectsDelShCounterbalance,subjectsDelFuzzCounterbalance),2),DeletedFuzzy(intersect(subjectsDelShCounterbalance,subjectsDelFuzzCounterbalance),2)) %paired samples

% ------------------------------
