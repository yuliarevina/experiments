% Analyse Group data for Man Ting's study

%% PSE SUBJECTS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:30];

%outliers
%periphery
subjectsBS_Convex_Outliers = [1, 4, 9, 17, 20];
subjectsBS_Concave_Outliers = [1, 4, 5, 9, 17, 18, 20, 22];
subjectsOccPeri_Convex_Outliers = [1, 2, 4, 8, 9, 10, 15, 16, 17, 20, 22, 26, 27, 28];
subjectsOccPeri_Concave_Outliers = [1, 4, 5, 8, 9, 17, 20, 25, 26, 27];
subjectsControlPeri_Convex_Outliers = [1, 4, 17, 20, 24];
subjectsControlPeri_Concave_Outliers = [1, 4, 10, 16, 17, 19, 20];
%fovea
subjectsOccFov_Convex_Outliers = [1,4, 5, 8,9, 17, 20, 26];
subjectsOccFov_Concave_Outliers = [1,4,5,8,9,16,17,20,23];
subjectsControlFov_Convex_Outliers = [1,4,5,8,9,17,20 ];
subjectsControlFov_Concave_Outliers = [1,4,7,14,17,20,26,29 ];

% everything
%periphery
subjectsBS_Convex = [allsubs];
subjectsBS_Concave= [allsubs];
subjectsOccPeri_Convex= [allsubs];
subjectsOccPeri_Concave= [allsubs];
subjectsControlPeri_Convex= [allsubs];
subjectsControlPeri_Concave= [allsubs];
%fovea
subjectsOccFov_Convex= [allsubs];
subjectsOccFov_Concave= [allsubs];
subjectsControlFov_Convex= [allsubs];
subjectsControlFov_Concave= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex = setdiff(subjectsBS_Convex, subjectsBS_Convex_Outliers);
subjectsBS_Concave= setdiff(subjectsBS_Concave, subjectsBS_Concave_Outliers);
subjectsOccPeri_Convex=  setdiff(subjectsOccPeri_Convex, subjectsOccPeri_Convex_Outliers);
subjectsOccPeri_Concave= setdiff(subjectsOccPeri_Concave, subjectsOccPeri_Concave_Outliers);
subjectsControlPeri_Convex= setdiff(subjectsControlPeri_Convex, subjectsControlPeri_Convex_Outliers);
subjectsControlPeri_Concave= setdiff(subjectsControlPeri_Concave, subjectsControlPeri_Concave_Outliers);
%fovea
subjectsOccFov_Convex= setdiff(subjectsOccFov_Convex, subjectsOccFov_Convex_Outliers);
subjectsOccFov_Concave= setdiff(subjectsOccFov_Concave, subjectsOccFov_Concave_Outliers);
subjectsControlFov_Convex= setdiff(subjectsControlFov_Convex, subjectsControlFov_Convex_Outliers);
subjectsControlFov_Concave= setdiff(subjectsControlFov_Concave, subjectsControlFov_Concave_Outliers);

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


meansubjectsBS_Convex_good = mean(Data_IC.PSE.BS.Convex(subjectsBS_Convex))
stdsubjectsBS_Convex_good = std(Data_IC.PSE.BS.Convex(subjectsBS_Convex))
mediansubjectsBS_Convex_good = median(Data_IC.PSE.BS.Convex(subjectsBS_Convex))
iqrsubjectsBS_Convex_good = iqr(Data_IC.PSE.BS.Convex(subjectsBS_Convex))

meansubjectsBS_Concave_good = mean(Data_IC.PSE.BS.Concave(subjectsBS_Concave))
stdsubjectsBS_Concave_good = std(Data_IC.PSE.BS.Concave(subjectsBS_Concave))
mediansubjectsBS_Concave_good = median(Data_IC.PSE.BS.Concave(subjectsBS_Concave))
iqrsubjectsBS_Concave_good = iqr(Data_IC.PSE.BS.Concave(subjectsBS_Concave))

meansubjectsOccPeri_Convex_good = mean(Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
stdsubjectsOccPeri_Convex_good = std(Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
mediansubjectsOccPeri_Convex_good = median(Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))
iqrsubjectsOccPeri_Convex_good = iqr(Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex))

meansubjectsOccPeri_Concave_good = mean(Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
stdsubjectsOccPeri_Concave_good = std(Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
mediansubjectsOccPeri_Concave_good = median(Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))
iqrsubjectsOccPeri_Concave_good = iqr(Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave))

meansubjectsControlPeri_Convex_good = mean(Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex))
stdsubjectsControlPeri_Convex_good = std(Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex))
mediansubjectsControlPeri_Convex_good = median(Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex))
iqrsubjectsControlPeri_Convex_good = iqr(Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex))

meansubjectsControlPeri_Concave_good = mean(Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave))
stdsubjectsControlPeri_Concave_good = std(Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave))
mediansubjectsControlPeri_Concave_good = median(Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave))
iqrsubjectsControlPeri_Concave_good = iqr(Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave))

meansubjectsOccFov_Convex_good = mean(Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex))
stdsubjectsOccFov_Convex_good = std(Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex))
mediansubjectsOccFov_Convex_good = median(Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex))
iqrsubjectsOccFov_Convex_good = iqr(Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex))

meansubjectsOccFov_Concave_good = mean(Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave))
stdsubjectsOccFov_Concave_good = std(Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave))
mediansubjectsOccFov_Concave_good = median(Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave))
iqrsubjectsOccFov_Concave_good = iqr(Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave))

meansubjectsControlFov_Convex_good = mean(Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex))
stdsubjectsControlFov_Convex_good = std(Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex))
mediansubjectsControlFov_Convex_good = median(Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex))
iqrsubjectsControlFov_Convex_good = iqr(Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex))

meansubjectsControlFov_Concave_good = mean(Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave))
stdsubjectsControlFov_Concave_good = std(Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave))
mediansubjectsControlFov_Concave_good = median(Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave))
iqrsubjectsControlFov_Concave_good = iqr(Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave))


%% PLOT PSE
Alldatatoplot = [];
individdata= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot = [Data_IC.PSE.BS.Convex(subjectsBS_Convex); ...
    Data_IC.PSE.BS.Concave(subjectsBS_Concave); ...
    Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex); ...
    Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave); ...
    Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex); ...
    Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave)];
groups = [ones(1,length(subjectsBS_Convex))';2*ones(1,length(subjectsBS_Concave))'; ...
    3*ones(1,length(subjectsOccPeri_Convex))'; 4*ones(1,length(subjectsOccPeri_Concave))'; ...
    5*ones(1,length(subjectsControlPeri_Convex))'; ...
    6*ones(1,length(subjectsControlPeri_Concave))'; ...
    7*ones(1,length(subjectsOccFov_Convex))'; ...
    8*ones(1,length(subjectsOccFov_Concave))'; ...
    9*ones(1,length(subjectsControlFov_Convex))'; ...
    10*ones(1,length(subjectsControlFov_Concave))'];

individdata = {Data_IC.PSE.BS.Convex(subjectsBS_Convex); ...
    Data_IC.PSE.BS.Concave(subjectsBS_Concave); ...
    Data_IC.PSE.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_IC.PSE.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_IC.PSE.CtrlPeri.Convex(subjectsControlPeri_Convex); ...
    Data_IC.PSE.CtrlPeri.Concave(subjectsControlPeri_Concave); ...
    Data_IC.PSE.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_IC.PSE.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_IC.PSE.CtrlFov.Convex(subjectsControlFov_Convex); ...
    Data_IC.PSE.CtrlFov.Concave(subjectsControlFov_Concave)};


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
     'Ctrl Peri Convex', 'Ctrl Peri Concave', 'Occ Fov Convex', 'Occ Fov Concave', 'Ctrl Fov Convex', 'Ctrl Fov Concave'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('PSE')
axis([0 11 -6 7])
set(gcf, 'Position', [200, 200, 1600, 900])

%% T TESTS
% CONVEX
disp('BS vs Occ Peri')
t_test_pairwise (Data_IC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)), Data_IC.PSE.OccPeri.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)))

disp('BS vs Ctrl Peri')
t_test_pairwise (Data_IC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsControlPeri_Convex)), Data_IC.PSE.CtrlPeri.Convex(intersect(subjectsBS_Convex,subjectsControlPeri_Convex)))

disp('BS vs Occ Fov')
t_test_pairwise (Data_IC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)), Data_IC.PSE.OccFov.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)))

disp('BS vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.BS.Convex(intersect(subjectsBS_Convex,subjectsControlFov_Convex)), Data_IC.PSE.CtrlFov.Convex(intersect(subjectsBS_Convex,subjectsControlFov_Convex)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (Data_IC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlPeri_Convex)), Data_IC.PSE.CtrlPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlPeri_Convex)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (Data_IC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)), Data_IC.PSE.OccFov.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlFov_Convex)), Data_IC.PSE.CtrlFov.Convex(intersect(subjectsOccPeri_Convex,subjectsControlFov_Convex)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (Data_IC.PSE.CtrlPeri.Convex(intersect(subjectsControlPeri_Convex,subjectsOccFov_Convex)), Data_IC.PSE.OccFov.Convex(intersect(subjectsControlPeri_Convex,subjectsOccFov_Convex)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.CtrlPeri.Convex(intersect(subjectsControlPeri_Convex,subjectsControlFov_Convex)), Data_IC.PSE.CtrlFov.Convex(intersect(subjectsControlPeri_Convex,subjectsControlFov_Convex)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.OccFov.Convex(intersect(subjectsOccFov_Convex,subjectsControlFov_Convex)), Data_IC.PSE.CtrlFov.Convex(intersect(subjectsOccFov_Convex,subjectsControlFov_Convex)))


% Concave
disp('BS vs Occ Peri')
t_test_pairwise (Data_IC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave)), Data_IC.PSE.OccPeri.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave)))

disp('BS vs Ctrl Peri')
t_test_pairwise (Data_IC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsControlPeri_Concave)), Data_IC.PSE.CtrlPeri.Concave(intersect(subjectsBS_Concave,subjectsControlPeri_Concave)))

disp('BS vs Occ Fov')
t_test_pairwise (Data_IC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave)), Data_IC.PSE.OccFov.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave)))

disp('BS vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.BS.Concave(intersect(subjectsBS_Concave,subjectsControlFov_Concave)), Data_IC.PSE.CtrlFov.Concave(intersect(subjectsBS_Concave,subjectsControlFov_Concave)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (Data_IC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlPeri_Concave)), Data_IC.PSE.CtrlPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlPeri_Concave)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (Data_IC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave)), Data_IC.PSE.OccFov.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlFov_Concave)), Data_IC.PSE.CtrlFov.Concave(intersect(subjectsOccPeri_Concave,subjectsControlFov_Concave)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (Data_IC.PSE.CtrlPeri.Concave(intersect(subjectsControlPeri_Concave,subjectsOccFov_Concave)), Data_IC.PSE.OccFov.Concave(intersect(subjectsControlPeri_Concave,subjectsOccFov_Concave)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.CtrlPeri.Concave(intersect(subjectsControlPeri_Concave,subjectsControlFov_Concave)), Data_IC.PSE.CtrlFov.Concave(intersect(subjectsControlPeri_Concave,subjectsControlFov_Concave)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (Data_IC.PSE.OccFov.Concave(intersect(subjectsOccFov_Concave,subjectsControlFov_Concave)), Data_IC.PSE.CtrlFov.Concave(intersect(subjectsOccFov_Concave,subjectsControlFov_Concave)))
%% UNDERESTIMATION OF CURVATURE

BS_flat_subs = intersect(subjectsBS_Convex,subjectsBS_Concave);
OccPeri_flat_subs = intersect(subjectsOccPeri_Convex,subjectsOccPeri_Concave);
CtrlPeri_flat_subs =  intersect(subjectsControlPeri_Convex,subjectsControlPeri_Concave);
OccFov_flat_subs = intersect(subjectsOccFov_Convex,subjectsOccFov_Concave);
CtrlFov_flat_subs = intersect(subjectsControlFov_Convex,subjectsControlFov_Concave);

BS_flattenning = Data_IC.PSE.BS.Underestimation_of_curvature(BS_flat_subs);
OccludedPeri_flattenning = Data_IC.PSE.OccPeri.Underestimation_of_curvature(OccPeri_flat_subs);
ControlPeri_flattenning = Data_IC.PSE.CtrlPeri.Underestimation_of_curvature(CtrlPeri_flat_subs);
OccludedFov_flattenning =Data_IC.PSE.OccFov.Underestimation_of_curvature(OccFov_flat_subs);
ControlFov_flattenning =Data_IC.PSE.CtrlFov.Underestimation_of_curvature(CtrlFov_flat_subs);

BS_flattenning_all = Data_IC.PSE.BS.Underestimation_of_curvature();
OccludedPeri_flattenning_all = Data_IC.PSE.OccPeri.Underestimation_of_curvature();
ControlPeri_flattenning_all = Data_IC.PSE.CtrlPeri.Underestimation_of_curvature();
OccludedFov_flattenning_all =Data_IC.PSE.OccFov.Underestimation_of_curvature();
ControlFov_flattenning_all =Data_IC.PSE.CtrlFov.Underestimation_of_curvature();

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
%% T TESTS
disp('BS vs Occ Peri')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,OccPeri_flat_subs)), OccludedPeri_flattenning_all(intersect(BS_flat_subs,OccPeri_flat_subs)))

disp('BS vs Ctrl Peri')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,CtrlPeri_flat_subs)), ControlPeri_flattenning_all(intersect(BS_flat_subs,CtrlPeri_flat_subs)))

disp('BS vs Occ Fov')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(BS_flat_subs,OccFov_flat_subs)))

disp('BS vs Ctrl Fov')
t_test_pairwise (BS_flattenning_all(intersect(BS_flat_subs,CtrlFov_flat_subs)), ControlFov_flattenning_all(intersect(BS_flat_subs,CtrlFov_flat_subs)))

%~~
disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,CtrlPeri_flat_subs)), ControlPeri_flattenning_all(intersect(OccPeri_flat_subs,CtrlPeri_flat_subs)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(OccPeri_flat_subs,OccFov_flat_subs)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (OccludedPeri_flattenning_all(intersect(OccPeri_flat_subs,CtrlFov_flat_subs)), ControlFov_flattenning_all(intersect(OccPeri_flat_subs,CtrlFov_flat_subs)))

%~~
disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (ControlPeri_flattenning_all(intersect(CtrlPeri_flat_subs,OccFov_flat_subs)), OccludedFov_flattenning_all(intersect(CtrlPeri_flat_subs,OccFov_flat_subs)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (ControlPeri_flattenning_all(intersect(CtrlPeri_flat_subs,CtrlFov_flat_subs)), ControlFov_flattenning_all(intersect(CtrlPeri_flat_subs,CtrlFov_flat_subs)))

%~~
disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (OccludedFov_flattenning_all(intersect(OccFov_flat_subs,CtrlFov_flat_subs)), ControlFov_flattenning_all(intersect(OccFov_flat_subs,CtrlFov_flat_subs)))


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
t_test_pairwise (BS_flattenning, Data_IC.PSE.Flat_value(BS_flat_subs))

disp('Occ Peri')
t_test_pairwise (OccludedPeri_flattenning, Data_IC.PSE.Flat_value(OccPeri_flat_subs))

disp('Ctrl Peri')
t_test_pairwise (ControlPeri_flattenning, Data_IC.PSE.Flat_value(CtrlPeri_flat_subs))

disp('Occ Fov')
t_test_pairwise (OccludedFov_flattenning, Data_IC.PSE.Flat_value(OccFov_flat_subs))

disp('Ctrl Fov')
t_test_pairwise (ControlFov_flattenning, Data_IC.PSE.Flat_value(CtrlFov_flat_subs))
%% PLOT FLATNESS

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
set(gca,'XTickLabel', {'Blind Spot', 'Occluded Peri', 'Control Peri', 'Occluded Fovea', ...
     'Control Fovea'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('Underestimation of Curvature')
axis([0 6 -1 3])
set(gcf, 'Position', [200, 200, 1600, 900])


%% SLOPE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:30];

%outliers
%periphery
subjectsBS_Convex_Outliers = [1, 4, 9, 17, 20];
subjectsBS_Concave_Outliers = [1, 4, 9, 17, 18, 20, 22];
subjectsOccPeri_Convex_Outliers = [1, 2, 4, 15, 16, 17, 20];
subjectsOccPeri_Concave_Outliers = [1, 4, 17, 20, 25];
subjectsControlPeri_Convex_Outliers = [1, 4, 17, 20, 24];
subjectsControlPeri_Concave_Outliers = [1, 4, 10, 16, 17, 19, 20];
%fovea
subjectsOccFov_Convex_Outliers = [1,4, 17, 20, 26];
subjectsOccFov_Concave_Outliers = [1,4,5,16,17,20,23];
subjectsControlFov_Convex_Outliers = [1,4,5,8,9,17,20 ];
subjectsControlFov_Concave_Outliers = [1,4,7,14,17,20,26,29 ];

% everything
%periphery
subjectsBS_Convex = [allsubs];
subjectsBS_Concave= [allsubs];
subjectsOccPeri_Convex= [allsubs];
subjectsOccPeri_Concave= [allsubs];
subjectsControlPeri_Convex= [allsubs];
subjectsControlPeri_Concave= [allsubs];
%fovea
subjectsOccFov_Convex= [allsubs];
subjectsOccFov_Concave= [allsubs];
subjectsControlFov_Convex= [allsubs];
subjectsControlFov_Concave= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex = setdiff(subjectsBS_Convex, subjectsBS_Convex_Outliers);
subjectsBS_Concave= setdiff(subjectsBS_Concave, subjectsBS_Concave_Outliers);
subjectsOccPeri_Convex=  setdiff(subjectsOccPeri_Convex, subjectsOccPeri_Convex_Outliers);
subjectsOccPeri_Concave= setdiff(subjectsOccPeri_Concave, subjectsOccPeri_Concave_Outliers);
subjectsControlPeri_Convex= setdiff(subjectsControlPeri_Convex, subjectsControlPeri_Convex_Outliers);
subjectsControlPeri_Concave= setdiff(subjectsControlPeri_Concave, subjectsControlPeri_Concave_Outliers);
%fovea
subjectsOccFov_Convex= setdiff(subjectsOccFov_Convex, subjectsOccFov_Convex_Outliers);
subjectsOccFov_Concave= setdiff(subjectsOccFov_Concave, subjectsOccFov_Concave_Outliers);
subjectsControlFov_Convex= setdiff(subjectsControlFov_Convex, subjectsControlFov_Convex_Outliers);
subjectsControlFov_Concave= setdiff(subjectsControlFov_Concave, subjectsControlFov_Concave_Outliers);

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


meansubjectsBS_Convex_good = mean(Data_IC.Slope.BS.Convex(subjectsBS_Convex))
stdsubjectsBS_Convex_good = std(Data_IC.Slope.BS.Convex(subjectsBS_Convex))
mediansubjectsBS_Convex_good = median(Data_IC.Slope.BS.Convex(subjectsBS_Convex))
iqrsubjectsBS_Convex_good = iqr(Data_IC.Slope.BS.Convex(subjectsBS_Convex))

meansubjectsBS_Concave_good = mean(Data_IC.Slope.BS.Concave(subjectsBS_Concave))
stdsubjectsBS_Concave_good = std(Data_IC.Slope.BS.Concave(subjectsBS_Concave))
mediansubjectsBS_Concave_good = median(Data_IC.Slope.BS.Concave(subjectsBS_Concave))
iqrsubjectsBS_Concave_good = iqr(Data_IC.Slope.BS.Concave(subjectsBS_Concave))

meansubjectsOccPeri_Convex_good = mean(Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
stdsubjectsOccPeri_Convex_good = std(Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
mediansubjectsOccPeri_Convex_good = median(Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))
iqrsubjectsOccPeri_Convex_good = iqr(Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex))

meansubjectsOccPeri_Concave_good = mean(Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
stdsubjectsOccPeri_Concave_good = std(Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
mediansubjectsOccPeri_Concave_good = median(Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))
iqrsubjectsOccPeri_Concave_good = iqr(Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave))

meansubjectsControlPeri_Convex_good = mean(Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex))
stdsubjectsControlPeri_Convex_good = std(Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex))
mediansubjectsControlPeri_Convex_good = median(Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex))
iqrsubjectsControlPeri_Convex_good = iqr(Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex))

meansubjectsControlPeri_Concave_good = mean(Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave))
stdsubjectsControlPeri_Concave_good = std(Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave))
mediansubjectsControlPeri_Concave_good = median(Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave))
iqrsubjectsControlPeri_Concave_good = iqr(Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave))

meansubjectsOccFov_Convex_good = mean(Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex))
stdsubjectsOccFov_Convex_good = std(Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex))
mediansubjectsOccFov_Convex_good = median(Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex))
iqrsubjectsOccFov_Convex_good = iqr(Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex))

meansubjectsOccFov_Concave_good = mean(Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave))
stdsubjectsOccFov_Concave_good = std(Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave))
mediansubjectsOccFov_Concave_good = median(Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave))
iqrsubjectsOccFov_Concave_good = iqr(Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave))

meansubjectsControlFov_Convex_good = mean(Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex))
stdsubjectsControlFov_Convex_good = std(Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex))
mediansubjectsControlFov_Convex_good = median(Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex))
iqrsubjectsControlFov_Convex_good = iqr(Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex))

meansubjectsControlFov_Concave_good = mean(Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave))
stdsubjectsControlFov_Concave_good = std(Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave))
mediansubjectsControlFov_Concave_good = median(Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave))
iqrsubjectsControlFov_Concave_good = iqr(Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave))

%% PLOT SLOPE
Alldatatoplot = [];
individdata= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot = [Data_IC.Slope.BS.Convex(subjectsBS_Convex); ...
    Data_IC.Slope.BS.Concave(subjectsBS_Concave); ...
    Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex); ...
    Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave); ...
    Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex); ...
    Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave)];
groups = [ones(1,length(subjectsBS_Convex))';2*ones(1,length(subjectsBS_Concave))'; ...
    3*ones(1,length(subjectsOccPeri_Convex))'; 4*ones(1,length(subjectsOccPeri_Concave))'; ...
    5*ones(1,length(subjectsControlPeri_Convex))'; ...
    6*ones(1,length(subjectsControlPeri_Concave))'; ...
    7*ones(1,length(subjectsOccFov_Convex))'; ...
    8*ones(1,length(subjectsOccFov_Concave))'; ...
    9*ones(1,length(subjectsControlFov_Convex))'; ...
    10*ones(1,length(subjectsControlFov_Concave))'];

individdata = {Data_IC.Slope.BS.Convex(subjectsBS_Convex); ...
    Data_IC.Slope.BS.Concave(subjectsBS_Concave); ...
    Data_IC.Slope.OccPeri.Convex(subjectsOccPeri_Convex); ...
    Data_IC.Slope.OccPeri.Concave(subjectsOccPeri_Concave); ...
    Data_IC.Slope.CtrlPeri.Convex(subjectsControlPeri_Convex); ...
    Data_IC.Slope.CtrlPeri.Concave(subjectsControlPeri_Concave); ...
    Data_IC.Slope.OccFov.Convex(subjectsOccFov_Convex); ...
    Data_IC.Slope.OccFov.Concave(subjectsOccFov_Concave); ...
    Data_IC.Slope.CtrlFov.Convex(subjectsControlFov_Convex); ...
    Data_IC.Slope.CtrlFov.Concave(subjectsControlFov_Concave)};


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
     'Ctrl Peri Convex', 'Ctrl Peri Concave', 'Occ Fov Convex', 'Occ Fov Concave', 'Ctrl Fov Convex', 'Ctrl Fov Concave'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('Slope')
axis([0 11 0 7])
set(gcf, 'Position', [200, 200, 1600, 900])


%% STATS

% Collapse Across curvature

disp('BS vs Occ Peri')
t_test_pairwise ([Data_IC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)); Data_IC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave))], ...
    [Data_IC.Slope.OccPeri.Convex(intersect(subjectsBS_Convex,subjectsOccPeri_Convex)); Data_IC.Slope.OccPeri.Concave(intersect(subjectsBS_Concave,subjectsOccPeri_Concave))])

disp('BS vs Ctrl Peri')
t_test_pairwise ([Data_IC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsControlPeri_Convex)); Data_IC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsControlPeri_Concave))], ...
    [Data_IC.Slope.CtrlPeri.Convex(intersect(subjectsBS_Convex,subjectsControlPeri_Convex)); Data_IC.Slope.CtrlPeri.Concave(intersect(subjectsBS_Concave,subjectsControlPeri_Concave))])

disp('BS vs Occ Fov')
t_test_pairwise ([Data_IC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)); Data_IC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave))], ...
    [Data_IC.Slope.OccFov.Convex(intersect(subjectsBS_Convex,subjectsOccFov_Convex)); Data_IC.Slope.OccFov.Concave(intersect(subjectsBS_Concave,subjectsOccFov_Concave))])

disp('BS vs Ctrl Fov')
t_test_pairwise ([Data_IC.Slope.BS.Convex(intersect(subjectsBS_Convex,subjectsControlFov_Convex)); Data_IC.Slope.BS.Concave(intersect(subjectsBS_Concave,subjectsControlFov_Concave))], ...
    [Data_IC.Slope.CtrlFov.Convex(intersect(subjectsBS_Convex,subjectsControlFov_Convex)); Data_IC.Slope.CtrlFov.Concave(intersect(subjectsBS_Concave,subjectsControlFov_Concave))])

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise ([Data_IC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlPeri_Convex)); Data_IC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlPeri_Concave))], ...
    [Data_IC.Slope.CtrlPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlPeri_Convex)); Data_IC.Slope.CtrlPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlPeri_Concave))])

disp('Occ Peri vs Occ Fov')
t_test_pairwise ([Data_IC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)); Data_IC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave))], ...
    [Data_IC.Slope.OccFov.Convex(intersect(subjectsOccPeri_Convex,subjectsOccFov_Convex)); Data_IC.Slope.CtrlPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsOccFov_Concave))])

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise ([Data_IC.Slope.OccPeri.Convex(intersect(subjectsOccPeri_Convex,subjectsControlFov_Convex)); Data_IC.Slope.OccPeri.Concave(intersect(subjectsOccPeri_Concave,subjectsControlFov_Concave))], ...
    [Data_IC.Slope.CtrlFov.Convex(intersect(subjectsOccPeri_Convex,subjectsControlFov_Convex)); Data_IC.Slope.CtrlFov.Concave(intersect(subjectsOccPeri_Concave,subjectsControlFov_Concave))])

disp('Ctrl Peri vs Occ Fov')
t_test_pairwise ([Data_IC.Slope.CtrlPeri.Convex(intersect(subjectsControlPeri_Convex,subjectsOccFov_Convex)); Data_IC.Slope.CtrlPeri.Concave(intersect(subjectsControlPeri_Concave,subjectsOccFov_Concave))], ...
    [Data_IC.Slope.OccFov.Convex(intersect(subjectsControlPeri_Convex,subjectsOccFov_Convex)); Data_IC.Slope.OccFov.Concave(intersect(subjectsControlPeri_Concave,subjectsOccFov_Concave))])

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise ([Data_IC.Slope.CtrlPeri.Convex(intersect(subjectsControlPeri_Convex,subjectsControlFov_Convex)); Data_IC.Slope.CtrlPeri.Concave(intersect(subjectsControlPeri_Concave,subjectsControlFov_Concave))], ...
    [Data_IC.Slope.CtrlFov.Convex(intersect(subjectsControlPeri_Convex,subjectsControlFov_Convex)); Data_IC.Slope.CtrlFov.Concave(intersect(subjectsControlPeri_Concave,subjectsControlFov_Concave))])

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise ([Data_IC.Slope.OccFov.Convex(intersect(subjectsOccFov_Convex,subjectsControlFov_Convex)); Data_IC.Slope.OccFov.Concave(intersect(subjectsOccFov_Concave,subjectsControlFov_Concave))], ...
    [Data_IC.Slope.CtrlFov.Convex(intersect(subjectsOccFov_Convex,subjectsControlFov_Convex)); Data_IC.Slope.CtrlFov.Concave(intersect(subjectsOccFov_Concave,subjectsControlFov_Concave))])


% Collapse Across curvature by averaging

%problem is, not all subs have both Convex and Concave recorded so have to
%find who does first

BS_both_curvatures = intersect(subjectsBS_Convex,subjectsBS_Concave);
OccPeri_both_curvatures = intersect(subjectsOccPeri_Convex,subjectsOccPeri_Concave);
CtrlPeri_both_curvatures  =  intersect(subjectsControlPeri_Convex,subjectsControlPeri_Concave);
OccFov_both_curvatures  = intersect(subjectsOccFov_Convex,subjectsOccFov_Concave);
CtrlFov_both_curvatures  = intersect(subjectsControlFov_Convex,subjectsControlFov_Concave);

disp('BS vs Occ Peri')
t_test_pairwise (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccPeri.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2))
[p,h,stats] = signrank(mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccPeri.Convex(intersect(BS_both_curvatures,OccPeri_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(BS_both_curvatures,OccPeri_both_curvatures))],2), 'method','approximate')

disp('BS vs Ctrl Peri')
t_test_pairwise (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,CtrlPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlPeri.Convex(intersect(BS_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(BS_both_curvatures,CtrlPeri_both_curvatures))],2))
[p,h,stats] = signrank (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,CtrlPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlPeri.Convex(intersect(BS_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(BS_both_curvatures,CtrlPeri_both_curvatures))],2), 'method', 'approximate')

disp('BS vs Occ Fov')
t_test_pairwise (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(BS_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(BS_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('BS vs Ctrl Fov')
t_test_pairwise (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(BS_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(BS_both_curvatures,CtrlFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_IC.Slope.BS.Convex(intersect(BS_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.BS.Concave(intersect(BS_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(BS_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(BS_both_curvatures,CtrlFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlPeri.Convex(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlPeri.Convex(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(OccPeri_both_curvatures,CtrlPeri_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Occ Fov')
t_test_pairwise (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(OccPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(OccPeri_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_IC.Slope.OccPeri.Convex(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.OccPeri.Concave(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(OccPeri_both_curvatures,CtrlFov_both_curvatures))],2), 'method', 'approximate')

disp('Ctrl Peri vs Occ Fov')
t_test_pairwise (mean([Data_IC.Slope.CtrlPeri.Convex(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_IC.Slope.CtrlPeri.Convex(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.OccFov.Convex(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(CtrlPeri_both_curvatures,OccFov_both_curvatures))],2), 'method', 'approximate')

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise (mean([Data_IC.Slope.CtrlPeri.Convex(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures))],2))
[p,h,stats]=signrank (mean([Data_IC.Slope.CtrlPeri.Convex(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlPeri.Concave(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(CtrlPeri_both_curvatures,CtrlFov_both_curvatures))],2), 'method', 'approximate')

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise (mean([Data_IC.Slope.OccFov.Convex(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures))],2))
[p,h,stats]= signrank (mean([Data_IC.Slope.OccFov.Convex(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.OccFov.Concave(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures))],2), ...
    mean([Data_IC.Slope.CtrlFov.Convex(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures)), Data_IC.Slope.CtrlFov.Concave(intersect(OccFov_both_curvatures,CtrlFov_both_curvatures))],2),'method', 'approximate')

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

% figure; hist(Data_IC.RT(:,1),10)


excludedsubs = [1, 4, 17, 20];
allsubs = [1:30];
goodsubs = setdiff(allsubs,excludedsubs);

% mean_RT_good = mean(mean_RT(goodsubs,:), 1)

individdataRT = {Data_IC.RT(goodsubs,1), Data_IC.RT(goodsubs,5), Data_IC.RT(goodsubs,3), Data_IC.RT(goodsubs,4), Data_IC.RT(goodsubs,2)}

figure; hist(Data_IC.RT(goodsubs, :))

figure; bar(mean(Data_IC.RT(goodsubs,[1 5 3 4 2]),1), 'y')
hold on
stderror = std(Data_IC.RT(goodsubs,[1 5 3 4 2])) / sqrt( length( goodsubs ))
errorbar(mean(Data_IC.RT(goodsubs, [1 5 3 4 2]),1),stderror, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 2)


plotspreadhandles = plotSpread(individdataRT,'distributionMarkers', 'o', 'distributionColors', 'r','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','r', 'MarkerSize',2);

set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blind Spot', 'Occ Peri', 'Ctrl Peri', 'Occ Fov', 'Ctrl Fov'}) 
% set(gca, 'fontsize',10);
set(gca, 'TickDir', 'out')
ylabel('Mean Reaction Time (s)')
axis ([0 6 0.0 1.0])

%% T TEST RT

disp('BS vs Occ Peri')
t_test_pairwise ((Data_IC.RT(goodsubs,1)), (Data_IC.RT(goodsubs,5)))

disp('BS vs Ctrl Peri')
t_test_pairwise ((Data_IC.RT(goodsubs,1)), (Data_IC.RT(goodsubs,3)))

disp('BS vs Occ Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,1)), (Data_IC.RT(goodsubs,4)))

disp('BS vs Ctrl Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,1)), (Data_IC.RT(goodsubs,2)))

disp('Occ Peri vs Ctrl Peri')
t_test_pairwise ((Data_IC.RT(goodsubs,5)), (Data_IC.RT(goodsubs,3)))

disp('Occ Peri vs Occ Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,5)), (Data_IC.RT(goodsubs,4)))

disp('Occ Peri vs Ctrl Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,5)), (Data_IC.RT(goodsubs,2)))

disp('Ctrl Peri vs Occ Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,3)), (Data_IC.RT(goodsubs,4)))

disp('Ctrl Peri vs Ctrl Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,3)), (Data_IC.RT(goodsubs,2)))

disp('Occ Fov vs Ctrl Fov')
t_test_pairwise ((Data_IC.RT(goodsubs,4)), (Data_IC.RT(goodsubs,2)))