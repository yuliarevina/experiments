% Analyse Group data for Nick's study

%% PSE SUBJECTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:33];

%outliers
%periphery
subjectsBS_Convex_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25:28];
subjectsBS_Concave_Outliers = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsOccPeri_Convex_Outliers = [1, 3:5, 8, 10, 11, 16, 18, 20, 21, 23, 25, 27, 28];
subjectsOccPeri_Concave_Outliers = [1:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedPeri_Convex_Outliers = [1, 3:5, 8:12, 16, 18, 20, 23, 25, 27, 28];
subjectsDeletedPeri_Concave_Outliers = [1, 3:5, 8:11, 16, 18, 20, 22, 25, 27, 28];
%fovea
subjectsOccFov_Convex_Outliers = [1, 3:5, 8, 10, 11,16, 18, 20, 22, 25, 27, 28, 32];
subjectsOccFov_Concave_Outliers = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Convex_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Concave_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18:20, 25:28];

% everything
%periphery
subjectsBS_Convex = [allsubs];
subjectsBS_Concave= [allsubs];
subjectsOccPeri_Convex= [allsubs];
subjectsOccPeri_Concave= [allsubs];
subjectsDeletedPeri_Convex= [allsubs];
subjectsDeletedPeri_Concave= [allsubs];
%fovea
subjectsOccFov_Convex= [allsubs];
subjectsOccFov_Concave= [allsubs];
subjectsDeletedFov_Convex= [allsubs];
subjectsDeletedFov_Concave= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex = setdiff(subjectsBS_Convex, subjectsBS_Convex_Outliers);
subjectsBS_Concave= setdiff(subjectsBS_Concave, subjectsBS_Concave_Outliers);
subjectsOccPeri_Convex=  setdiff(subjectsOccPeri_Convex, subjectsOccPeri_Convex_Outliers);
subjectsOccPeri_Concave= setdiff(subjectsOccPeri_Concave, subjectsOccPeri_Concave_Outliers);
subjectsDeletedPeri_Convex= setdiff(subjectsDeletedPeri_Convex, subjectsDeletedPeri_Convex_Outliers);
subjectsDeletedPeri_Concave= setdiff(subjectsDeletedPeri_Concave, subjectsDeletedPeri_Concave_Outliers);
%fovea
subjectsOccFov_Convex= setdiff(subjectsOccFov_Convex, subjectsOccFov_Convex_Outliers);
subjectsOccFov_Concave= setdiff(subjectsOccFov_Concave, subjectsOccFov_Concave_Outliers);
subjectsDeletedFov_Convex= setdiff(subjectsDeletedFov_Convex, subjectsDeletedFov_Convex_Outliers);
subjectsDeletedFov_Concave= setdiff(subjectsDeletedFov_Concave, subjectsDeletedFov_Concave_Outliers);

% % number of subs with full datasets for anovas
% all_subs_for_anova = intersect(subjectsBS_Convex,subjectsBS_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccPeri_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccPeri_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlPeri_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlPeri_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccFov_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccFov_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlFov_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlFov_Concave);


meansubjectsBS_Convex_good = mean(Data_RC.PSE.BS.Convex(subjectsBS_Convex))
stdsubjectsBS_Convex_good = std(Data_RC.PSE.BS.Convex(subjectsBS_Convex))
mediansubjectsBS_Convex_good = median(Data_RC.PSE.BS.Convex(subjectsBS_Convex))
iqrsubjectsBS_Convex_good = iqr(Data_RC.PSE.BS.Convex(subjectsBS_Convex))

meansubjectsBS_Concave_good = mean(Data_RC.PSE.BS.Concave(subjectsBS_Concave))
stdsubjectsBS_Concave_good = std(Data_RC.PSE.BS.Concave(subjectsBS_Concave))
mediansubjectsBS_Concave_good = median(Data_RC.PSE.BS.Concave(subjectsBS_Concave))
iqrsubjectsBS_Concave_good = iqr(Data_RC.PSE.BS.Concave(subjectsBS_Concave))

meansubjectsOccPeri_Convex_good = mean(Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
stdsubjectsOccPeri_Convex_good = std(Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
mediansubjectsOccPeri_Convex_good = median(Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
iqrsubjectsOccPeri_Convex_good = iqr(Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))

meansubjectsOccPeri_Concave_good = mean(Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
stdsubjectsOccPeri_Concave_good = std(Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
mediansubjectsOccPeri_Concave_good = median(Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
iqrsubjectsOccPeri_Concave_good = iqr(Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))

meansubjectsDeletedPeri_Convex_good = mean(Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex))
stdsubjectsDeletedPeri_Convex_good = std(Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex))
mediansubjectsDeletedPeri_Convex_good = median(Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex))
iqrsubjectsDeletedPeri_Convex_good = iqr(Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex))

meansubjectsDeletedPeri_Concave_good = mean(Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave))
stdsubjectsDeletedPeri_Concave_good = std(Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave))
mediansubjectsDeletedPeri_Concave_good = median(Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave))
iqrsubjectsDeletedPeri_Concave_good = iqr(Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave))

meansubjectsOccFov_Convex_good = mean(Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex))
stdsubjectsOccFov_Convex_good = std(Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex))
mediansubjectsOccFov_Convex_good = median(Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex))
iqrsubjectsOccFov_Convex_good = iqr(Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex))

meansubjectsOccFov_Concave_good = mean(Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave))
stdsubjectsOccFov_Concave_good = std(Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave))
mediansubjectsOccFov_Concave_good = median(Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave))
iqrsubjectsOccFov_Concave_good = iqr(Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave))

meansubjectsDeletedFov_Convex_good = mean(Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex))
stdsubjectsDeletedFov_Convex_good = std(Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex))
mediansubjectsDeletedFov_Convex_good = median(Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex))
iqrsubjectsDeletedFov_Convex_good = iqr(Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex))

meansubjectsDeletedFov_Concave_good = mean(Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave))
stdsubjectsDeletedFov_Concave_good = std(Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave))
mediansubjectsDeletedFov_Concave_good = median(Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave))
iqrsubjectsDeletedFov_Concave_good = iqr(Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave))


%% PLOT PSE
Alldatatoplot = [];
individdata= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot = [Data_RC.PSE.BS.Convex(subjectsBS_Convex); ...
    Data_RC.PSE.BS.Concave(subjectsBS_Concave); ...
    Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex); ...
    Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave); ...
    Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex); ...
    Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave)];
groups = [ones(1,length(subjectsBS_Convex))';2*ones(1,length(subjectsBS_Concave))'; ...
    3*ones(1,length(subjectsOccPeri_Convex))'; 4*ones(1,length(subjectsOccPeri_Concave))'; ...
    5*ones(1,length(subjectsDeletedPeri_Convex))'; ...
    6*ones(1,length(subjectsDeletedPeri_Concave))'; ...
    7*ones(1,length(subjectsOccFov_Convex))'; ...
    8*ones(1,length(subjectsOccFov_Concave))'; ...
    9*ones(1,length(subjectsDeletedFov_Convex))'; ...
    10*ones(1,length(subjectsDeletedFov_Concave))'];

individdata = {Data_RC.PSE.BS.Convex(subjectsBS_Convex); ...
    Data_RC.PSE.BS.Concave(subjectsBS_Concave); ...
    Data_RC.PSE.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_RC.PSE.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_RC.PSE.DelPeri.Convex(subjectsDeletedPeri_Convex); ...
    Data_RC.PSE.DelPeri.Concave(subjectsDeletedPeri_Concave); ...
    Data_RC.PSE.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_RC.PSE.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_RC.PSE.DelFov.Convex(subjectsDeletedFov_Convex); ...
    Data_RC.PSE.DelFov.Concave(subjectsDeletedFov_Concave)};


%% make boxplot for PSEs

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

for i = 1:10
    plot(i, mean(individdata{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'BS Convex', 'BS Concave', 'Occ Peri Convex', 'Occ Peri Concave', ...
     'Del Peri Convex', 'Del Peri Concave', 'Occ Fov Convex', 'Occ Fov Concave', 'Del Fov Convex', 'Del Fov Concave'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('PSE')
axis([0 11 -6 7])
set(gcf, 'Position', [200, 200, 1600, 900])

%% T TESTS
% CONVEX
disp('BS vs Occ Peri')
t_test_pairwise (Data_RC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)), Data_RC.PSE.OccPeri.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)))

disp('BS vs Ctrl Peri')
t_test_pairwise (Data_RC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsDeletedPeri_Convex)), Data_RC.PSE.DelPeri.Convex(intersect(subjectsBS_Convex,subjectsDeletedPeri_Convex)))

disp('BS vs Occ Fov')
t_test_pairwise (Data_RC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)), Data_RC.PSE.OccFov.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)))

disp('BS vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsDeletedFov_Convex)), Data_RC.PSE.DelFov.Convex(intersect(subjectsBS_Convex,subjectsDeletedFov_Convex)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (Data_RC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedPeri_Convex)), Data_RC.PSE.DelPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedPeri_Convex)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (Data_RC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)), Data_RC.PSE.OccFov.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedFov_Convex)), Data_RC.PSE.DelFov.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedFov_Convex)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (Data_RC.PSE.DelPeri.Convex(intersect(subjectsDeletedPeri_Convex,subjectsOccFov_Convex)), Data_RC.PSE.OccFov.Convex(intersect(subjectsDeletedPeri_Convex,subjectsOccFov_Convex)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.DelPeri.Convex(intersect(subjectsDeletedPeri_Convex,subjectsDeletedFov_Convex)), Data_RC.PSE.DelFov.Convex(intersect(subjectsDeletedPeri_Convex,subjectsDeletedFov_Convex)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.OccFov.Convex(intersect(subjectsOccFov_Convex,subjectsDeletedFov_Convex)), Data_RC.PSE.DelFov.Convex(intersect(subjectsOccFov_Convex,subjectsDeletedFov_Convex)))


% Concave
disp('BS vs Occ Peri')
t_test_pairwise (Data_RC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave)), Data_RC.PSE.OccPeri.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave)))

disp('BS vs Ctrl Peri')
t_test_pairwise (Data_RC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsDeletedPeri_Concave)), Data_RC.PSE.DelPeri.Concave(intersect(subjectsBS_Concave,subjectsDeletedPeri_Concave)))

disp('BS vs Occ Fov')
t_test_pairwise (Data_RC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave)), Data_RC.PSE.OccFov.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave)))

disp('BS vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsDeletedFov_Concave)), Data_RC.PSE.DelFov.Concave(intersect(subjectsBS_Concave,subjectsDeletedFov_Concave)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (Data_RC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedPeri_Concave)), Data_RC.PSE.DelPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedPeri_Concave)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (Data_RC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave)), Data_RC.PSE.OccFov.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedFov_Concave)), Data_RC.PSE.DelFov.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedFov_Concave)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (Data_RC.PSE.DelPeri.Concave(intersect(subjectsDeletedPeri_Concave,subjectsOccFov_Concave)), Data_RC.PSE.OccFov.Concave(intersect(subjectsDeletedPeri_Concave,subjectsOccFov_Concave)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.DelPeri.Concave(intersect(subjectsDeletedPeri_Concave,subjectsDeletedFov_Concave)), Data_RC.PSE.DelFov.Concave(intersect(subjectsDeletedPeri_Concave,subjectsDeletedFov_Concave)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (Data_RC.PSE.OccFov.Concave(intersect(subjectsOccFov_Concave,subjectsDeletedFov_Concave)), Data_RC.PSE.DelFov.Concave(intersect(subjectsOccFov_Concave,subjectsDeletedFov_Concave)))

%% UNDERESTIMATION OF CURVATURE & Foveal bias

%Select subs
BS_flat_subs = intersect(subjectsBS_Convex,subjectsBS_Concave);
OccPeri_flat_subs = intersect(subjectsOccPeri_Convex,subjectsOccPeri_Concave);
DelPeri_flat_subs =  intersect(subjectsDeletedPeri_Convex,subjectsDeletedPeri_Concave);
OccFov_flat_subs = intersect(subjectsOccFov_Convex,subjectsOccFov_Concave);
DelFov_flat_subs = intersect(subjectsDeletedFov_Convex,subjectsDeletedFov_Concave);

%% UNDERESTIMATION OF CURVATURE

BS_flattenning = Data_RC.PSE.BS.Underestimation_of_curvature(BS_flat_subs);
OccludedPeri_flattenning = Data_RC.PSE.OccPeri.Underestimation_of_curvature(OccPeri_flat_subs);
ControlPeri_flattenning = Data_RC.PSE.DelPeri.Underestimation_of_curvature(DelPeri_flat_subs);
OccludedFov_flattenning =Data_RC.PSE.OccFov.Underestimation_of_curvature(OccFov_flat_subs);
ControlFov_flattenning =Data_RC.PSE.DelFov.Underestimation_of_curvature(DelFov_flat_subs);

BS_flattenning_all = Data_RC.PSE.BS.Underestimation_of_curvature();
OccludedPeri_flattenning_all = Data_RC.PSE.OccPeri.Underestimation_of_curvature();
ControlPeri_flattenning_all = Data_RC.PSE.DelPeri.Underestimation_of_curvature();
OccludedFov_flattenning_all =Data_RC.PSE.OccFov.Underestimation_of_curvature();
ControlFov_flattenning_all =Data_RC.PSE.DelFov.Underestimation_of_curvature();

Alldatatoplot_FLAT = [];
individdata_FLAT= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot_FLAT = [BS_flattenning; ...
    OccludedPeri_flattenning; ...
    ControlPeri_flattenning; ...
    OccludedFov_flattenning; ...
    ControlFov_flattenning; ...
   ];
groups_FLAT = [ones(1,length(BS_flattenning))';2*ones(1,length(OccludedPeri_flattenning))'; ...
    3*ones(1,length(ControlPeri_flattenning))'; 4*ones(1,length(OccludedFov_flattenning))'; ...
    5*ones(1,length(ControlFov_flattenning))'; ...
   ];

individdata_FLAT = {BS_flattenning; ...
    OccludedPeri_flattenning; ...
    ControlPeri_flattenning; ...
    OccludedFov_flattenning; ...
    ControlFov_flattenning};

%% UNDERESTIMATION OF CURVATURE for dot eye analysis

OccludedFov_flattenning_BS =Data_RC.PSE.OccFov.Underestimation_of_curvature_BS(OccFov_flat_subs);
OccludedFov_flattenning_Fellow =Data_RC.PSE.OccFov.Underestimation_of_curvature_Fellow(OccFov_flat_subs);
DelFov_flattenning_BS =Data_RC.PSE.DelFov.Underestimation_of_curvature_BS(CtrlFov_flat_subs);
DelFov_flattenning_Fellow =Data_RC.PSE.DelFov.Underestimation_of_curvature_Fellow(CtrlFov_flat_subs);

OccludedFov_flattenning_all_BS =Data_RC.PSE.OccFov.Underestimation_of_curvature_BS();
OccludedFov_flattenning_all_Fellow =Data_RC.PSE.OccFov.Underestimation_of_curvature_Fellow();
ControlFov_flattenning_all_BS =Data_RC.PSE.DelFov.Underestimation_of_curvature_BS();
ControlFov_flattenning_all_Fellow =Data_RC.PSE.DelFov.Underestimation_of_curvature_Fellow();
%% Foveal bias
BS_fov_bias = Data_RC.PSE.BS.Foveal_bias(BS_flat_subs);
OccludedPeri_fov_bias = Data_RC.PSE.OccPeri.Foveal_bias(OccPeri_flat_subs);
ControlPeri_fov_bias = Data_RC.PSE.DelPeri.Foveal_bias(DelPeri_flat_subs);
OccludedFov_fov_bias =Data_RC.PSE.OccFov.Foveal_bias(OccFov_flat_subs);
ControlFov_fov_bias =Data_RC.PSE.DelFov.Foveal_bias(DelFov_flat_subs);

BS_fov_bias_all = Data_RC.PSE.BS.Foveal_bias();
OccludedPeri_fov_bias_all = Data_RC.PSE.OccPeri.Foveal_bias();
ControlPeri_fov_bias_all = Data_RC.PSE.DelPeri.Foveal_bias();
OccludedFov_fov_bias_all =Data_RC.PSE.OccFov.Foveal_bias();
ControlFov_fov_bias_all =Data_RC.PSE.DelFov.Foveal_bias();

Alldatatoplot_FLAT = [];
individdata_FLAT= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot_FLAT = [BS_fov_bias; ...
    OccludedPeri_fov_bias; ...
    ControlPeri_fov_bias; ...
    OccludedFov_fov_bias; ...
    ControlFov_fov_bias; ...
   ];
groups_FLAT = [ones(1,length(BS_fov_bias))';2*ones(1,length(OccludedPeri_fov_bias))'; ...
    3*ones(1,length(ControlPeri_fov_bias))'; 4*ones(1,length(OccludedFov_fov_bias))'; ...
    5*ones(1,length(ControlFov_fov_bias))'; ...
   ];

individdata_FLAT = {BS_fov_bias; ...
    OccludedPeri_fov_bias; ...
    ControlPeri_fov_bias; ...
    OccludedFov_fov_bias; ...
    ControlFov_fov_bias};
%% T TESTS for underestimation
disp('BS vs Occ Peri')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,OccPeri_flat_subs)), OccludedPeri_flattenning_all(intersect(BS_flat_subs,OccPeri_flat_subs)))

disp('BS vs Ctrl Peri')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,DelPeri_flat_subs)), ControlPeri_flattenning_all(intersect(BS_flat_subs,DelPeri_flat_subs)))

disp('BS vs Occ Fov')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(BS_flat_subs,OccFov_flat_subs)))

disp('BS vs Ctrl Fov')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,DelFov_flat_subs)), ControlFov_flattenning_all(intersect(BS_flat_subs,DelFov_flat_subs)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,DelPeri_flat_subs)), ControlPeri_flattenning_all(intersect(OccPeri_flat_subs,DelPeri_flat_subs)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,DelFov_flat_subs)), ControlFov_flattenning_all(intersect(OccPeri_flat_subs,DelFov_flat_subs)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (ControlPeri_flattenning_all(intersect(DelPeri_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(DelPeri_flat_subs,OccFov_flat_subs)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (ControlPeri_flattenning_all(intersect(DelPeri_flat_subs,DelFov_flat_subs)), ControlFov_flattenning_all(intersect(DelPeri_flat_subs,DelFov_flat_subs)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (OccludedFov_flattenning_all(intersect(OccFov_flat_subs,DelFov_flat_subs)), ControlFov_flattenning_all(intersect(OccFov_flat_subs,DelFov_flat_subs)))


% from Zero
disp('BS')
t_test_from_zero (BS_flattenning)

disp('Occ Peri')
t_test_from_zero (OccludedPeri_flattenning)

disp('Ctrl Peri')
t_test_from_zero (ControlPeri_flattenning)

disp('Occ Fov')
t_test_from_zero (OccludedFov_flattenning)

disp('Ctrl Fov')
t_test_from_zero (ControlFov_flattenning)


% from individual flat value

disp('BS')
t_test_pairwise (BS_flattenning, Data_RC.PSE.Flat_value(BS_flat_subs))

disp('Occ Peri')
t_test_pairwise (OccludedPeri_flattenning, Data_RC.PSE.Flat_value(OccPeri_flat_subs))

disp('Ctrl Peri')
t_test_pairwise (ControlPeri_flattenning, Data_RC.PSE.Flat_value(DelPeri_flat_subs))

disp('Occ Fov')
t_test_pairwise (OccludedFov_flattenning, Data_RC.PSE.Flat_value(OccFov_flat_subs))

disp('Ctrl Fov')
t_test_pairwise (ControlFov_flattenning, Data_RC.PSE.Flat_value(DelFov_flat_subs))


%% T TESTS for Fov Bias
disp('BS vs Occ Peri')
t_test_pairwise (BS_fov_bias_all(intersect(BS_flat_subs,OccPeri_flat_subs)), OccludedPeri_fov_bias_all(intersect(BS_flat_subs,OccPeri_flat_subs)))

disp('BS vs Ctrl Peri')
t_test_pairwise (BS_fov_bias_all(intersect(BS_flat_subs,DelPeri_flat_subs)), ControlPeri_fov_bias_all(intersect(BS_flat_subs,DelPeri_flat_subs)))

disp('BS vs Occ Fov')
t_test_pairwise (BS_fov_bias_all(intersect(BS_flat_subs,OccFov_flat_subs)), OccludedFov_fov_bias_all(intersect(BS_flat_subs,OccFov_flat_subs)))

disp('BS vs Ctrl Fov')
t_test_pairwise (BS_fov_bias_all(intersect(BS_flat_subs,DelFov_flat_subs)), ControlFov_fov_bias_all(intersect(BS_flat_subs,DelFov_flat_subs)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (OccludedPeri_fov_bias_all(intersect(OccPeri_flat_subs,DelPeri_flat_subs)), ControlPeri_fov_bias_all(intersect(OccPeri_flat_subs,DelPeri_flat_subs)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (OccludedPeri_fov_bias_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)), OccludedFov_fov_bias_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (OccludedPeri_fov_bias_all(intersect(OccPeri_flat_subs,DelFov_flat_subs)), ControlFov_fov_bias_all(intersect(OccPeri_flat_subs,DelFov_flat_subs)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (ControlPeri_fov_bias_all(intersect(DelPeri_flat_subs,OccFov_flat_subs)), OccludedFov_fov_bias_all(intersect(DelPeri_flat_subs,OccFov_flat_subs)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (ControlPeri_fov_bias_all(intersect(DelPeri_flat_subs,DelFov_flat_subs)), ControlFov_fov_bias_all(intersect(DelPeri_flat_subs,DelFov_flat_subs)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (OccludedFov_fov_bias_all(intersect(OccFov_flat_subs,DelFov_flat_subs)), ControlFov_fov_bias_all(intersect(OccFov_flat_subs,DelFov_flat_subs)))


% from Zero
disp('BS')
t_test_from_zero (BS_fov_bias)

disp('Occ Peri')
t_test_from_zero (OccludedPeri_fov_bias)

disp('Ctrl Peri')
t_test_from_zero (ControlPeri_fov_bias)

disp('Occ Fov')
t_test_from_zero (OccludedFov_fov_bias)

disp('Ctrl Fov')
t_test_from_zero (ControlFov_fov_bias)

%% PLOT FLATNESS OR foveal bias

figure; bx = boxplot(Alldatatoplot_FLAT,groups_FLAT,'Notch','off', 'MedianStyle', 'line');
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

for i = 1:5
    plot(i, mean(individdata_FLAT{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata_FLAT,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blind Spot', 'Occluded Peri', 'Deleted Peri', 'Occluded Fovea', ...
     'Deleted Fovea'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
% ylabel('Underestimation of Curvature')
ylabel('Foveal Bias')
axis([0 6 -3 4])
set(gcf, 'Position', [200, 200, 1600, 900])


%% SLOPE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:33];

%outliers
%periphery
subjectsBS_Convex_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25:28];
subjectsBS_Concave_Outliers = [1, 3:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsOccPeri_Convex_Outliers = [1, 3:5, 8, 10, 11, 16, 18, 20, 23, 25, 27, 28];
subjectsOccPeri_Concave_Outliers = [1:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedPeri_Convex_Outliers = [1, 3:5, 8, 10:12, 16, 18, 20, 23, 25, 27, 28];
subjectsDeletedPeri_Concave_Outliers = [1, 3:5, 8, 10, 11, 16, 18, 20, 22, 25, 27, 28];
%fovea
subjectsOccFov_Convex_Outliers = [1, 3:5, 8, 10, 11, 16, 18, 20, 22, 25, 27, 28, 32];
subjectsOccFov_Concave_Outliers = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Convex_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Concave_Outliers = [1, 3:5, 7, 8, 10, 11, 16, 18:20, 25:28];

% everything
%periphery
subjectsBS_Convex = [allsubs];
subjectsBS_Concave= [allsubs];
subjectsOccPeri_Convex= [allsubs];
subjectsOccPeri_Concave= [allsubs];
subjectsDeletedPeri_Convex= [allsubs];
subjectsDeletedPeri_Concave= [allsubs];
%fovea
subjectsOccFov_Convex= [allsubs];
subjectsOccFov_Concave= [allsubs];
subjectsDeletedFov_Convex= [allsubs];
subjectsDeletedFov_Concave= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex = setdiff(subjectsBS_Convex, subjectsBS_Convex_Outliers);
subjectsBS_Concave= setdiff(subjectsBS_Concave, subjectsBS_Concave_Outliers);
subjectsOccPeri_Convex=  setdiff(subjectsOccPeri_Convex, subjectsOccPeri_Convex_Outliers);
subjectsOccPeri_Concave= setdiff(subjectsOccPeri_Concave, subjectsOccPeri_Concave_Outliers);
subjectsDeletedPeri_Convex= setdiff(subjectsDeletedPeri_Convex, subjectsDeletedPeri_Convex_Outliers);
subjectsDeletedPeri_Concave= setdiff(subjectsDeletedPeri_Concave, subjectsDeletedPeri_Concave_Outliers);
%fovea
subjectsOccFov_Convex= setdiff(subjectsOccFov_Convex, subjectsOccFov_Convex_Outliers);
subjectsOccFov_Concave= setdiff(subjectsOccFov_Concave, subjectsOccFov_Concave_Outliers);
subjectsDeletedFov_Convex= setdiff(subjectsDeletedFov_Convex, subjectsDeletedFov_Convex_Outliers);
subjectsDeletedFov_Concave= setdiff(subjectsDeletedFov_Concave, subjectsDeletedFov_Concave_Outliers);

% % number of subs with full datasets for anovas
% all_subs_for_anova = intersect(subjectsBS_Convex,subjectsBS_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccPeri_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccPeri_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlPeri_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlPeri_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccFov_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsOccFov_Concave);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlFov_Convex);
% all_subs_for_anova = intersect(all_subs_for_anova,subjectsControlFov_Concave);


meansubjectsBS_Convex_good = mean(Data_RC.Slope.BS.Convex(subjectsBS_Convex))
stdsubjectsBS_Convex_good = std(Data_RC.Slope.BS.Convex(subjectsBS_Convex))
mediansubjectsBS_Convex_good = median(Data_RC.Slope.BS.Convex(subjectsBS_Convex))
iqrsubjectsBS_Convex_good = iqr(Data_RC.Slope.BS.Convex(subjectsBS_Convex))

meansubjectsBS_Concave_good = mean(Data_RC.Slope.BS.Concave(subjectsBS_Concave))
stdsubjectsBS_Concave_good = std(Data_RC.Slope.BS.Concave(subjectsBS_Concave))
mediansubjectsBS_Concave_good = median(Data_RC.Slope.BS.Concave(subjectsBS_Concave))
iqrsubjectsBS_Concave_good = iqr(Data_RC.Slope.BS.Concave(subjectsBS_Concave))

meansubjectsOccPeri_Convex_good = mean(Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
stdsubjectsOccPeri_Convex_good = std(Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
mediansubjectsOccPeri_Convex_good = median(Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
iqrsubjectsOccPeri_Convex_good = iqr(Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))

meansubjectsOccPeri_Concave_good = mean(Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
stdsubjectsOccPeri_Concave_good = std(Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
mediansubjectsOccPeri_Concave_good = median(Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
iqrsubjectsOccPeri_Concave_good = iqr(Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))

meansubjectsDeletedPeri_Convex_good = mean(Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex))
stdsubjectsDeletedPeri_Convex_good = std(Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex))
mediansubjectsDeletedPeri_Convex_good = median(Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex))
iqrsubjectsDeletedPeri_Convex_good = iqr(Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex))

meansubjectsDeletedPeri_Concave_good = mean(Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave))
stdsubjectsDeletedPeri_Concave_good = std(Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave))
mediansubjectsDeletedPeri_Concave_good = median(Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave))
iqrsubjectsDeletedPeri_Concave_good = iqr(Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave))

meansubjectsOccFov_Convex_good = mean(Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex))
stdsubjectsOccFov_Convex_good = std(Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex))
mediansubjectsOccFov_Convex_good = median(Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex))
iqrsubjectsOccFov_Convex_good = iqr(Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex))

meansubjectsOccFov_Concave_good = mean(Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave))
stdsubjectsOccFov_Concave_good = std(Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave))
mediansubjectsOccFov_Concave_good = median(Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave))
iqrsubjectsOccFov_Concave_good = iqr(Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave))

meansubjectsDeletedFov_Convex_good = mean(Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex))
stdsubjectsDeletedFov_Convex_good = std(Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex))
mediansubjectsDeletedFov_Convex_good = median(Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex))
iqrsubjectsDeletedFov_Convex_good = iqr(Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex))

meansubjectsDeletedFov_Concave_good = mean(Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave))
stdsubjectsDeletedFov_Concave_good = std(Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave))
mediansubjectsDeletedFov_Concave_good = median(Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave))
iqrsubjectsDeletedFov_Concave_good = iqr(Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave))

%% PLOT SLOPE
Alldatatoplot = [];
individdata= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot = [Data_RC.Slope.BS.Convex(subjectsBS_Convex); ...
    Data_RC.Slope.BS.Concave(subjectsBS_Concave); ...
    Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex); ...
    Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave); ...
    Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex); ...
    Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave)];
groups = [ones(1,length(subjectsBS_Convex))';2*ones(1,length(subjectsBS_Concave))'; ...
    3*ones(1,length(subjectsOccPeri_Convex))'; 4*ones(1,length(subjectsOccPeri_Concave))'; ...
    5*ones(1,length(subjectsDeletedPeri_Convex))'; ...
    6*ones(1,length(subjectsDeletedPeri_Concave))'; ...
    7*ones(1,length(subjectsOccFov_Convex))'; ...
    8*ones(1,length(subjectsOccFov_Concave))'; ...
    9*ones(1,length(subjectsDeletedFov_Convex))'; ...
    10*ones(1,length(subjectsDeletedFov_Concave))'];

individdata = {Data_RC.Slope.BS.Convex(subjectsBS_Convex); ...
    Data_RC.Slope.BS.Concave(subjectsBS_Concave); ...
    Data_RC.Slope.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_RC.Slope.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_RC.Slope.DelPeri.Convex(subjectsDeletedPeri_Convex); ...
    Data_RC.Slope.DelPeri.Concave(subjectsDeletedPeri_Concave); ...
    Data_RC.Slope.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_RC.Slope.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_RC.Slope.DelFov.Convex(subjectsDeletedFov_Convex); ...
    Data_RC.Slope.DelFov.Concave(subjectsDeletedFov_Concave)};


%% make boxplot for PSEs

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
% plot([0 11],[0.0 0.0], 'g--')

for i = 1:10
    plot(i, mean(individdata{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'BS Convex', 'BS Concave', 'Occ Peri Convex', 'Occ Peri Concave', ...
     'Del Peri Convex', 'Del Peri Concave', 'Occ Fov Convex', 'Occ Fov Concave', 'Del Fov Convex', 'Del Fov Concave'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('Slope')
axis([0 11 32 39])
set(gcf, 'Position', [200, 200, 1600, 900])


%% STATS

% Collapse Across curvature

disp('BS vs Occ Peri')
t_test_pairwise ([Data_RC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)); Data_RC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave))], ...
    [Data_RC.Slope.OccPeri.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)); Data_RC.Slope.OccPeri.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave))])

disp('BS vs Ctrl Peri')
t_test_pairwise ([Data_RC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsDeletedPeri_Convex)); Data_RC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsDeletedPeri_Concave))], ...
    [Data_RC.Slope.DelPeri.Convex(intersect(subjectsBS_Convex,subjectsDeletedPeri_Convex)); Data_RC.Slope.DelPeri.Concave(intersect(subjectsBS_Concave,subjectsDeletedPeri_Concave))])

disp('BS vs Occ Fov')
t_test_pairwise ([Data_RC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)); Data_RC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave))], ...
    [Data_RC.Slope.OccFov.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)); Data_RC.Slope.OccFov.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave))])

disp('BS vs Ctrl Fov')
t_test_pairwise ([Data_RC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsDeletedFov_Concave))], ...
    [Data_RC.Slope.DelFov.Convex(intersect(subjectsBS_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.DelFov.Concave(intersect(subjectsBS_Concave,subjectsDeletedFov_Concave))])

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise ([Data_RC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedPeri_Convex)); Data_RC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedPeri_Concave))], ...
    [Data_RC.Slope.DelPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedPeri_Convex)); Data_RC.Slope.DelPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedPeri_Concave))])

disp('Occ Peri vs Occ Fov')
t_test_pairwise ([Data_RC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)); Data_RC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave))], ...
    [Data_RC.Slope.OccFov.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)); Data_RC.Slope.DelPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave))])

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise ([Data_RC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedFov_Concave))], ...
    [Data_RC.Slope.DelFov.Convex(intersect(subjectsOccPeri_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.DelFov.Concave(intersect(subjectsOccPeri_Concave,subjectsDeletedFov_Concave))])

disp('Ctrl Peri vs Occ Fov')
t_test_pairwise ([Data_RC.Slope.DelPeri.Convex(intersect(subjectsDeletedPeri_Convex,subjectsOccFov_Convex)); Data_RC.Slope.DelPeri.Concave(intersect(subjectsDeletedPeri_Concave,subjectsOccFov_Concave))], ...
    [Data_RC.Slope.OccFov.Convex(intersect(subjectsDeletedPeri_Convex,subjectsOccFov_Convex)); Data_RC.Slope.OccFov.Concave(intersect(subjectsDeletedPeri_Concave,subjectsOccFov_Concave))])

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise ([Data_RC.Slope.DelPeri.Convex(intersect(subjectsDeletedPeri_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.DelPeri.Concave(intersect(subjectsDeletedPeri_Concave,subjectsDeletedFov_Concave))], ...
    [Data_RC.Slope.DelFov.Convex(intersect(subjectsDeletedPeri_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.DelFov.Concave(intersect(subjectsDeletedPeri_Concave,subjectsDeletedFov_Concave))])

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise ([Data_RC.Slope.OccFov.Convex(intersect(subjectsOccFov_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.OccFov.Concave(intersect(subjectsOccFov_Concave,subjectsDeletedFov_Concave))], ...
    [Data_RC.Slope.DelFov.Convex(intersect(subjectsOccFov_Convex,subjectsDeletedFov_Convex)); Data_RC.Slope.DelFov.Concave(intersect(subjectsOccFov_Concave,subjectsDeletedFov_Concave))])


% Collapse Across curvature by averaging

%problem is, not all subs have both Convex and Concave recorded so have to
%find who does first

BS_both_curvatures = intersect(subjectsBS_Convex,subjectsBS_Concave);
OccPeri_both_curvatures = intersect(subjectsOccPeri_Convex,subjectsOccPeri_Concave);
DelPeri_both_curvatures  =  intersect(subjectsDeletedPeri_Convex,subjectsDeletedPeri_Concave);
OccFov_both_curvatures  = intersect(subjectsOccFov_Convex,subjectsOccFov_Concave);
DelFov_both_curvatures  = intersect(subjectsDeletedFov_Convex,subjectsDeletedFov_Concave);

disp('BS vs Occ Peri')
t_test_pairwise (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccPeri.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2))
[p,h,stats] = signrank(mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccPeri.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), 'method','approximate')

disp('BS vs Ctrl Peri')
t_test_pairwise (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,DelPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelPeri.Convex(intersect(BS_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(BS_both_curvatures,DelPeri_both_curvatures))],2))
[p,h,stats] = signrank (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,DelPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelPeri.Convex(intersect(BS_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(BS_both_curvatures,DelPeri_both_curvatures))],2), 'method', 'approximate')

disp('BS vs Occ Fov')
t_test_pairwise (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('BS vs Ctrl Fov')
t_test_pairwise (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(BS_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(BS_both_curvatures,DelFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_RC.Slope.BS.Convex(intersect(BS_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.BS.Concave(intersect(BS_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(BS_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(BS_both_curvatures,DelFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelPeri.Convex(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelPeri.Convex(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(OccPeri_both_curvatures,DelPeri_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Occ Fov')
t_test_pairwise (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(OccPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(OccPeri_both_curvatures,DelFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_RC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(OccPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(OccPeri_both_curvatures,DelFov_both_curvatures))],2), 'method', 'approximate')

disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (mean([Data_RC.Slope.DelPeri.Convex(intersect(DelPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(DelPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(DelPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(DelPeri_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_RC.Slope.DelPeri.Convex(intersect(DelPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(DelPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.OccFov.Convex(intersect(DelPeri_both_curvatures,OccFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(DelPeri_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (mean([Data_RC.Slope.DelPeri.Convex(intersect(DelPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(DelPeri_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(DelPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(DelPeri_both_curvatures,DelFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_RC.Slope.DelPeri.Convex(intersect(DelPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelPeri.Concave(intersect(DelPeri_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(DelPeri_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(DelPeri_both_curvatures,DelFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (mean([Data_RC.Slope.OccFov.Convex(intersect(OccFov_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(OccFov_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(OccFov_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(OccFov_both_curvatures,DelFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_RC.Slope.OccFov.Convex(intersect(OccFov_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.OccFov.Concave(intersect(OccFov_both_curvatures,DelFov_both_curvatures))],2), ...
    mean([Data_RC.Slope.DelFov.Convex(intersect(OccFov_both_curvatures,DelFov_both_curvatures)), Data_RC.Slope.DelFov.Concave(intersect(OccFov_both_curvatures,DelFov_both_curvatures))],2),'method', 'approximate')


%for dot eye analysis
t_test_pairwise (mean([Data_RC.Slope.OccFov.BS_convex(OccFov_both_curvatures), Data_RC.Slope.OccFov.BS_concave(OccFov_both_curvatures)],2), ...
    mean([Data_RC.Slope.OccFov.Fellow_convex(OccFov_both_curvatures), Data_RC.Slope.OccFov.Fellow_concave(OccFov_both_curvatures)],2))

t_test_pairwise (mean([Data_RC.Slope.DelFov.BS_convex(DelFov_both_curvatures), Data_RC.Slope.DelFov.BS_concave(DelFov_both_curvatures)],2), ...
    mean([Data_RC.Slope.DelFov.Fellow_convex(DelFov_both_curvatures), Data_RC.Slope.DelFov.Fellow_concave(DelFov_both_curvatures)],2))

%% RT

% exclude subs with bad fix

%extract individual RTs
for i = 1:5
%     if subjectdata(:,1) == i %BS
        tmp = find(subjectdata(:,1) == i);
        disp(sprintf('RT Condition %d',i))
        mean(subjectdata(tmp,6))
        median(subjectdata(tmp,6))
%     end
end

% figure; hist(Data_RC.RT(:,1),10)

%% GROUP RT
excludedsubs = [1, 3:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
allsubs = [1:33];
goodsubs = setdiff(allsubs,excludedsubs);

% mean_RT_good = mean(mean_RT(goodsubs,:), 1)

individdataRT = {Data_RC.RT(goodsubs,1), Data_RC.RT(goodsubs,5), Data_RC.RT(goodsubs,3), Data_RC.RT(goodsubs,4), Data_RC.RT(goodsubs,2)}

figure; hist(Data_RC.RT(goodsubs, :))

figure; bar(mean(Data_RC.RT(goodsubs,[1 5 3 4 2]),1), 'y')
hold on
stderror = std(Data_RC.RT(goodsubs,[1 5 3 4 2])) / sqrt( length( goodsubs ))
errorbar(mean(Data_RC.RT(goodsubs, [1 5 3 4 2]),1),stderror, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 2)


plotspreadhandles = plotSpread(individdataRT,'distributionMarkers', 'o', 'distributionColors', 'r','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',2);

set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blind Spot', 'Occ Peri', 'Del Peri', 'Occ Fov', 'Del Fov'}) 
% set(gca, 'fontsize',10);
set(gca, 'TickDir', 'out')
ylabel('Mean Reaction Time (s)')
axis ([0 6 0.0 3.0])

%% T TEST RT

disp('BS vs Occ Peri')
t_test_pairwise ((Data_RC.RT(goodsubs,1)), (Data_RC.RT(goodsubs,5)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,1), Data_RC.RT(goodsubs,5), 'method', 'approximate')

disp('BS vs Ctrl Peri')
t_test_pairwise ((Data_RC.RT(goodsubs,1)), (Data_RC.RT(goodsubs,3)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,1), Data_RC.RT(goodsubs,3), 'method', 'approximate')

disp('BS vs Occ Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,1)), (Data_RC.RT(goodsubs,4)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,1), Data_RC.RT(goodsubs,4), 'method', 'approximate')

disp('BS vs Ctrl Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,1)), (Data_RC.RT(goodsubs,2)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,1), Data_RC.RT(goodsubs,2), 'method', 'approximate')

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise ((Data_RC.RT(goodsubs,5)), (Data_RC.RT(goodsubs,3)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,5), Data_RC.RT(goodsubs,3), 'method', 'approximate')

disp('Occ Peri vs Occ Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,5)), (Data_RC.RT(goodsubs,4)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,5), Data_RC.RT(goodsubs,4), 'method', 'approximate')

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,5)), (Data_RC.RT(goodsubs,2)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,5), Data_RC.RT(goodsubs,2), 'method', 'approximate')


disp('Ctrl Peri vs Occ Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,3)), (Data_RC.RT(goodsubs,4)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,3), Data_RC.RT(goodsubs,4), 'method', 'approximate')

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,3)), (Data_RC.RT(goodsubs,2)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,3), Data_RC.RT(goodsubs,2), 'method', 'approximate')

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise ((Data_RC.RT(goodsubs,4)), (Data_RC.RT(goodsubs,2)))
[p,h,stats]= signrank (Data_RC.RT(goodsubs,4), Data_RC.RT(goodsubs,2), 'method', 'approximate')