% Analysis both IC and RC compared
%% PSE SUBJECTS for Man Ting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:30];

%outliers
%periphery
subjectsBS_Convex_Outliers_IC = [1, 4, 9, 17, 20];
subjectsBS_Concave_Outliers_IC = [1, 4, 5, 9, 17, 18, 20, 22];
subjectsOccPeri_Convex_Outliers_IC = [1, 2, 4, 8, 9, 10, 15, 16, 17, 20, 22, 26, 27, 28];
subjectsOccPeri_Concave_Outliers_IC = [1, 4, 5, 8, 9, 17, 20, 25, 26, 27];
subjectsControlPeri_Convex_Outliers_IC = [1, 4, 17, 20, 24];
subjectsControlPeri_Concave_Outliers_IC = [1, 4, 10, 16, 17, 19, 20];
%fovea
subjectsOccFov_Convex_Outliers_IC = [1,4, 5, 8,9, 17, 20, 26];
subjectsOccFov_Concave_Outliers_IC = [1,4,5,8,9,16,17,20,23];
subjectsControlFov_Convex_Outliers_IC = [1,4,5,8,9,17,20 ];
subjectsControlFov_Concave_Outliers_IC = [1,4,7,14,17,20,26,29 ];

% everything
%periphery
subjectsBS_Convex_IC = [allsubs];
subjectsBS_Concave_IC= [allsubs];
subjectsOccPeri_Convex_IC= [allsubs];
subjectsOccPeri_Concave_IC= [allsubs];
subjectsControlPeri_Convex_IC= [allsubs];
subjectsControlPeri_Concave_IC= [allsubs];
%fovea
subjectsOccFov_Convex_IC= [allsubs];
subjectsOccFov_Concave_IC= [allsubs];
subjectsControlFov_Convex_IC= [allsubs];
subjectsControlFov_Concave_IC= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex_IC = setdiff(subjectsBS_Convex_IC, subjectsBS_Convex_Outliers_IC);
subjectsBS_Concave_IC= setdiff(subjectsBS_Concave_IC, subjectsBS_Concave_Outliers_IC);
subjectsOccPeri_Convex_IC=  setdiff(subjectsOccPeri_Convex_IC, subjectsOccPeri_Convex_Outliers_IC);
subjectsOccPeri_Concave_IC= setdiff(subjectsOccPeri_Concave_IC, subjectsOccPeri_Concave_Outliers_IC);
subjectsControlPeri_Convex_IC= setdiff(subjectsControlPeri_Convex_IC, subjectsControlPeri_Convex_Outliers_IC);
subjectsControlPeri_Concave_IC= setdiff(subjectsControlPeri_Concave_IC, subjectsControlPeri_Concave_Outliers_IC);
%fovea
subjectsOccFov_Convex_IC= setdiff(subjectsOccFov_Convex_IC, subjectsOccFov_Convex_Outliers_IC);
subjectsOccFov_Concave_IC= setdiff(subjectsOccFov_Concave_IC, subjectsOccFov_Concave_Outliers_IC);
subjectsControlFov_Convex_IC= setdiff(subjectsControlFov_Convex_IC, subjectsControlFov_Convex_Outliers_IC);
subjectsControlFov_Concave_IC= setdiff(subjectsControlFov_Concave_IC, subjectsControlFov_Concave_Outliers_IC);

%% PSE SUBJECTS FOR NICK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:33];

%outliers
%periphery
subjectsBS_Convex_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25:28];
subjectsBS_Concave_Outliers_RC = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsOccPeri_Convex_Outliers_RC = [1, 3:5, 8, 10, 11, 16, 18, 20, 21, 23, 25, 27, 28];
subjectsOccPeri_Concave_Outliers_RC = [1:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedPeri_Convex_Outliers_RC = [1, 3:5, 8:12, 16, 18, 20, 23, 25, 27, 28];
subjectsDeletedPeri_Concave_Outliers_RC = [1, 3:5, 8:11, 16, 18, 20, 22, 25, 27, 28];
%fovea
subjectsOccFov_Convex_Outliers_RC = [1, 3:5, 8, 10, 11,16, 18, 20, 22, 25, 27, 28, 32];
subjectsOccFov_Concave_Outliers_RC = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Convex_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Concave_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18:20, 25:28];

% everything
%periphery
subjectsBS_Convex_RC = [allsubs];
subjectsBS_Concave_RC = [allsubs];
subjectsOccPeri_Convex_RC = [allsubs];
subjectsOccPeri_Concave_RC = [allsubs];
subjectsDeletedPeri_Convex_RC = [allsubs];
subjectsDeletedPeri_Concave_RC = [allsubs];
%fovea
subjectsOccFov_Convex_RC = [allsubs];
subjectsOccFov_Concave_RC = [allsubs];
subjectsDeletedFov_Convex_RC = [allsubs];
subjectsDeletedFov_Concave_RC = [allsubs];

%minus outliers
%periphery
subjectsBS_Convex_RC = setdiff(subjectsBS_Convex_RC, subjectsBS_Convex_Outliers_RC);
subjectsBS_Concave_RC = setdiff(subjectsBS_Concave_RC, subjectsBS_Concave_Outliers_RC);
subjectsOccPeri_Convex_RC =  setdiff(subjectsOccPeri_Convex_RC, subjectsOccPeri_Convex_Outliers_RC);
subjectsOccPeri_Concave_RC = setdiff(subjectsOccPeri_Concave_RC, subjectsOccPeri_Concave_Outliers_RC);
subjectsDeletedPeri_Convex_RC = setdiff(subjectsDeletedPeri_Convex_RC, subjectsDeletedPeri_Convex_Outliers_RC);
subjectsDeletedPeri_Concave_RC = setdiff(subjectsDeletedPeri_Concave_RC, subjectsDeletedPeri_Concave_Outliers_RC);
%fovea
subjectsOccFov_Convex_RC= setdiff(subjectsOccFov_Convex_RC, subjectsOccFov_Convex_Outliers_RC);
subjectsOccFov_Concave_RC= setdiff(subjectsOccFov_Concave_RC, subjectsOccFov_Concave_Outliers_RC);
subjectsDeletedFov_Convex_RC= setdiff(subjectsDeletedFov_Convex_RC, subjectsDeletedFov_Convex_Outliers_RC);
subjectsDeletedFov_Concave_RC= setdiff(subjectsDeletedFov_Concave_RC, subjectsDeletedFov_Concave_Outliers_RC);

%% UNDERESTIMATION OF CURVATURE & Foveal bias MAN TING

%Select subs

BS_flat_subs_IC = intersect(subjectsBS_Convex_IC,subjectsBS_Concave_IC);
OccPeri_flat_subs_IC = intersect(subjectsOccPeri_Convex_IC,subjectsOccPeri_Concave_IC);
CtrlPeri_flat_subs_IC =  intersect(subjectsControlPeri_Convex_IC,subjectsControlPeri_Concave_IC);
OccFov_flat_subs_IC = intersect(subjectsOccFov_Convex_IC,subjectsOccFov_Concave_IC);
CtrlFov_flat_subs_IC = intersect(subjectsControlFov_Convex_IC,subjectsControlFov_Concave_IC);
%% UNDERESTIMATION OF CURVATURE & Foveal bias NICK

%Select subs
BS_flat_subs_RC = intersect(subjectsBS_Convex_RC,subjectsBS_Concave_RC);
OccPeri_flat_subs_RC = intersect(subjectsOccPeri_Convex_RC,subjectsOccPeri_Concave_RC);
DelPeri_flat_subs_RC =  intersect(subjectsDeletedPeri_Convex_RC,subjectsDeletedPeri_Concave_RC);
OccFov_flat_subs_RC = intersect(subjectsOccFov_Convex_RC,subjectsOccFov_Concave_RC);
DelFov_flat_subs_RC = intersect(subjectsDeletedFov_Convex_RC,subjectsDeletedFov_Concave_RC);

%% UNDERESTIMATION OF CURVATURE MAN TING

BS_flattenning_IC = Data_IC.PSE.BS.Underestimation_of_curvature(BS_flat_subs_IC);
OccludedPeri_flattenning_IC = Data_IC.PSE.OccPeri.Underestimation_of_curvature(OccPeri_flat_subs_IC);
ControlPeri_flattenning_IC = Data_IC.PSE.CtrlPeri.Underestimation_of_curvature(CtrlPeri_flat_subs_IC);
OccludedFov_flattenning_IC =Data_IC.PSE.OccFov.Underestimation_of_curvature(OccFov_flat_subs_IC);
ControlFov_flattenning_IC =Data_IC.PSE.CtrlFov.Underestimation_of_curvature(CtrlFov_flat_subs_IC);

BS_flattenning_all_IC = Data_IC.PSE.BS.Underestimation_of_curvature();
OccludedPeri_flattenning_all_IC = Data_IC.PSE.OccPeri.Underestimation_of_curvature();
ControlPeri_flattenning_all_IC = Data_IC.PSE.CtrlPeri.Underestimation_of_curvature();
OccludedFov_flattenning_all_IC =Data_IC.PSE.OccFov.Underestimation_of_curvature();
ControlFov_flattenning_all_IC =Data_IC.PSE.CtrlFov.Underestimation_of_curvature();
%% UNDERESTIMATION OF CURVATURE NICK

BS_flattenning_RC = Data_RC.PSE.BS.Underestimation_of_curvature(BS_flat_subs_RC);
OccludedPeri_flattenning_RC = Data_RC.PSE.OccPeri.Underestimation_of_curvature(OccPeri_flat_subs_RC);
ControlPeri_flattenning_RC = Data_RC.PSE.DelPeri.Underestimation_of_curvature(DelPeri_flat_subs_RC);
OccludedFov_flattenning_RC =Data_RC.PSE.OccFov.Underestimation_of_curvature(OccFov_flat_subs_RC);
ControlFov_flattenning_RC =Data_RC.PSE.DelFov.Underestimation_of_curvature(DelFov_flat_subs_RC);

BS_flattenning_all_RC = Data_RC.PSE.BS.Underestimation_of_curvature();
OccludedPeri_flattenning_all_RC = Data_RC.PSE.OccPeri.Underestimation_of_curvature();
ControlPeri_flattenning_all_RC = Data_RC.PSE.DelPeri.Underestimation_of_curvature();
OccludedFov_flattenning_all_RC =Data_RC.PSE.OccFov.Underestimation_of_curvature();
ControlFov_flattenning_all_RC =Data_RC.PSE.DelFov.Underestimation_of_curvature();

%% PLOT data together
Alldatatoplot_FLAT = [];
individdata_FLAT= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot_FLAT = [BS_flattenning_IC; ...
    BS_flattenning_RC;
    OccludedPeri_flattenning_IC; ...
    OccludedPeri_flattenning_RC; ...
    ControlPeri_flattenning_IC; ...
    ControlPeri_flattenning_RC; ...
    OccludedFov_flattenning_IC; ...
    OccludedFov_flattenning_RC; ...
    ControlFov_flattenning_IC; ...
    ControlFov_flattenning_RC; ...
   ];
groups_FLAT = [ones(1,length(BS_flattenning_IC))'; ...
    2*ones(1,length(BS_flattenning_RC))'; ...
    3*ones(1,length(OccludedPeri_flattenning_IC))'; ...
    4*ones(1,length(OccludedPeri_flattenning_RC))'; ...
    5*ones(1,length(ControlPeri_flattenning_IC))'; ...
    6*ones(1,length(ControlPeri_flattenning_RC))'; ...
    7*ones(1,length(OccludedFov_flattenning_IC))'; ...
    8*ones(1,length(OccludedFov_flattenning_RC))'; ...
    9*ones(1,length(ControlFov_flattenning_IC))'; ...
    10*ones(1,length(ControlFov_flattenning_RC))'; ...
   ];

individdata_FLAT = {BS_flattenning_IC; ...
    BS_flattenning_RC; ...
    OccludedPeri_flattenning_IC; ...
    OccludedPeri_flattenning_RC; ...
    ControlPeri_flattenning_IC; ...
    ControlPeri_flattenning_RC; ...
    OccludedFov_flattenning_IC; ...
    OccludedFov_flattenning_RC; ...
    ControlFov_flattenning_IC; ...
    ControlFov_flattenning_RC; ...
    };

%% Foveal bias MAN TING
BS_fov_bias_IC = Data_IC.PSE.BS.Foveal_bias(BS_flat_subs_IC);
OccludedPeri_fov_bias_IC = Data_IC.PSE.OccPeri.Foveal_bias(OccPeri_flat_subs_IC);
ControlPeri_fov_bias_IC = Data_IC.PSE.CtrlPeri.Foveal_bias(CtrlPeri_flat_subs_IC);
OccludedFov_fov_bias_IC =Data_IC.PSE.OccFov.Foveal_bias(OccFov_flat_subs_IC);
ControlFov_fov_bias_IC =Data_IC.PSE.CtrlFov.Foveal_bias(CtrlFov_flat_subs_IC);

BS_fov_bias_all_IC = Data_IC.PSE.BS.Foveal_bias();
OccludedPeri_fov_bias_all_IC = Data_IC.PSE.OccPeri.Foveal_bias();
ControlPeri_fov_bias_all_IC = Data_IC.PSE.CtrlPeri.Foveal_bias();
OccludedFov_fov_bias_all_IC =Data_IC.PSE.OccFov.Foveal_bias();
ControlFov_fov_bias_all_IC =Data_IC.PSE.CtrlFov.Foveal_bias();
%% Foveal bias NICK
BS_fov_bias_RC = Data_RC.PSE.BS.Foveal_bias(BS_flat_subs_RC);
OccludedPeri_fov_bias_RC = Data_RC.PSE.OccPeri.Foveal_bias(OccPeri_flat_subs_RC);
ControlPeri_fov_bias_RC = Data_RC.PSE.DelPeri.Foveal_bias(DelPeri_flat_subs_RC);
OccludedFov_fov_bias_RC =Data_RC.PSE.OccFov.Foveal_bias(OccFov_flat_subs_RC);
ControlFov_fov_bias_RC =Data_RC.PSE.DelFov.Foveal_bias(DelFov_flat_subs_RC);

BS_fov_bias_all_RC = Data_RC.PSE.BS.Foveal_bias();
OccludedPeri_fov_bias_all_RC = Data_RC.PSE.OccPeri.Foveal_bias();
ControlPeri_fov_bias_all_RC = Data_RC.PSE.DelPeri.Foveal_bias();
OccludedFov_fov_bias_all_RC =Data_RC.PSE.OccFov.Foveal_bias();
ControlFov_fov_bias_all_RC =Data_RC.PSE.DelFov.Foveal_bias();

%% Plot all foveal bias together
Alldatatoplot_FLAT = [];
individdata_FLAT= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot_FLAT = [BS_fov_bias_IC; ...
    BS_fov_bias_RC; ...
    OccludedPeri_fov_bias_IC; ...
    OccludedPeri_fov_bias_RC; ...
    ControlPeri_fov_bias_IC; ...
    ControlPeri_fov_bias_RC; ...
    OccludedFov_fov_bias_IC; ...
    OccludedFov_fov_bias_RC; ...
    ControlFov_fov_bias_IC; ...
    ControlFov_fov_bias_RC; ...
   ];
groups_FLAT = [ones(1,length(BS_fov_bias_IC))'; ...
    2*ones(1,length(BS_fov_bias_RC))'; ...
    3*ones(1,length(OccludedPeri_fov_bias_IC))'; ...
    4*ones(1,length(OccludedPeri_fov_bias_RC))'; ...
    5*ones(1,length(ControlPeri_fov_bias_IC))'; ...
    6*ones(1,length(ControlPeri_fov_bias_RC))'; ...
    7*ones(1,length(OccludedFov_fov_bias_IC))'; ...
    8*ones(1,length(OccludedFov_fov_bias_RC))'; ...
    9*ones(1,length(ControlFov_fov_bias_IC))'; ...
    10*ones(1,length(ControlFov_fov_bias_RC))'; ...
   ];

individdata_FLAT = {BS_fov_bias_IC; ...
    BS_fov_bias_RC; ...
    OccludedPeri_fov_bias_IC; ...
    OccludedPeri_fov_bias_RC; ...
    ControlPeri_fov_bias_IC; ...
    ControlPeri_fov_bias_RC; ...
    OccludedFov_fov_bias_IC; ...
    OccludedFov_fov_bias_RC; ...
    ControlFov_fov_bias_IC; ...
    ControlFov_fov_bias_RC; ...
    };

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
plot([0 11],[1.375 1.375], 'g--')
for i = 1:10
    plot(i, mean(individdata_FLAT{i}), 'Marker', 's', 'MarkerFaceColor',[1 1 1], 'MarkerSize',12)
end
% plot([0 6],[0.489 0.489], 'k--')
plotspreadhandles = plotSpread(individdata_FLAT,'distributionMarkers', 'o', 'distributionColors', 'k','spreadWidth', 1);
set(plotspreadhandles{1},'MarkerFaceColor','k', 'MarkerSize',5);



% set(findall(3,'type','line','color','k'),'markerSize',16)
set(gca, 'fontsize',16);
set(gca,'XTickLabel', {'Blind Spot IC', 'Blind Spot RC', 'Occluded Peri IC', 'Occluded Peri RC', 'Ctrl Peri IC', 'Deleted Peri RC', 'Occluded Fovea IC', ...
     'Occluded Fovea RC', 'Ctrl Fovea IC', 'Deleted Fovea RC'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('Underestimation of Curvature')
% ylabel('Foveal Bias')
axis([0 11 -2 3])
set(gcf, 'Position', [200, 200, 1600, 900])


%% T TESTS for underestimation
disp('BS IC vs BS RC')
t_test_2_groups(BS_flattenning_IC, BS_flattenning_RC)

disp('Occ Peri IC vs Occ Peri RC')
t_test_2_groups(OccludedPeri_flattenning_IC, OccludedPeri_flattenning_RC)

disp('Ctrl Peri IC vs Del Peri RC')
t_test_2_groups(ControlPeri_flattenning_IC, ControlPeri_flattenning_RC)

disp('Occ Fov IC vs Occ Fov RC')
t_test_2_groups(OccludedFov_flattenning_IC, OccludedFov_flattenning_RC)

disp('Ctrl Fov IC vs Del Fov RC')
t_test_2_groups(ControlFov_flattenning_IC, ControlFov_flattenning_RC)


disp('Occluded Peri RC vs Ctrl Peri IC')
t_test_2_groups(OccludedPeri_flattenning_RC, ControlPeri_flattenning_IC)


disp('Deleted Peri RC vs Ctrl Peri IC')
t_test_2_groups(ControlPeri_flattenning_RC, ControlPeri_flattenning_IC)


disp('Occluded Fov RC vs Ctrl Fov IC')
t_test_2_groups(OccludedFov_flattenning_RC, ControlFov_flattenning_IC)


disp('Deleted Fov RC vs Ctrl Fov IC')
t_test_2_groups(ControlFov_flattenning_RC, ControlFov_flattenning_IC)

%% T TESTS for foveal bias
disp('BS IC vs BS RC')
t_test_2_groups(BS_fov_bias_IC, BS_fov_bias_RC)

disp('Occ Peri IC vs Occ Peri RC')
t_test_2_groups(OccludedPeri_fov_bias_IC, OccludedPeri_fov_bias_RC)

disp('Ctrl Peri IC vs Del Peri RC')
t_test_2_groups(ControlPeri_fov_bias_IC, ControlPeri_fov_bias_RC)

disp('Occ Fov IC vs Occ Fov RC')
t_test_2_groups(OccludedFov_fov_bias_IC, OccludedFov_fov_bias_RC)

disp('Ctrl Fov IC vs Del Fov RC')
t_test_2_groups(ControlFov_fov_bias_IC, ControlFov_fov_bias_RC)

disp('Occluded Peri RC vs Ctrl Peri IC')
t_test_2_groups(OccludedPeri_fov_bias_RC, ControlPeri_fov_bias_IC)

disp('Deleted Peri RC vs Ctrl Peri IC')
t_test_2_groups(ControlPeri_fov_bias_RC, ControlPeri_fov_bias_IC)

disp('Occluded Fov RC vs Ctrl Fov IC')
t_test_2_groups(OccludedFov_fov_bias_RC, ControlFov_fov_bias_IC)

disp('Deleted Fov RC vs Ctrl Fov IC')
t_test_2_groups(ControlFov_fov_bias_RC, ControlFov_fov_bias_IC)

%% SLOPE MAN tING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:30];

%outliers
%periphery
subjectsBS_Convex_Outliers_IC = [1, 4, 9, 17, 20];
subjectsBS_Concave_Outliers_IC = [1, 4, 9, 17, 18, 20, 22];
subjectsOccPeri_Convex_Outliers_IC = [1, 2, 4, 15, 16, 17, 20];
subjectsOccPeri_Concave_Outliers_IC = [1, 4, 17, 20, 25];
subjectsControlPeri_Convex_Outliers_IC = [1, 4, 17, 20, 24];
subjectsControlPeri_Concave_Outliers_IC = [1, 4, 10, 16, 17, 19, 20];
%fovea
subjectsOccFov_Convex_Outliers_IC = [1,4, 17, 20, 26];
subjectsOccFov_Concave_Outliers_IC = [1,4,5,16,17,20,23];
subjectsControlFov_Convex_Outliers_IC = [1,4,5,8,9,17,20 ];
subjectsControlFov_Concave_Outliers_IC = [1,4,7,14,17,20,26,29 ];

% everything
%periphery
subjectsBS_Convex_IC = [allsubs];
subjectsBS_Concave_IC= [allsubs];
subjectsOccPeri_Convex_IC= [allsubs];
subjectsOccPeri_Concave_IC= [allsubs];
subjectsControlPeri_Convex_IC= [allsubs];
subjectsControlPeri_Concave_IC= [allsubs];
%fovea
subjectsOccFov_Convex_IC= [allsubs];
subjectsOccFov_Concave_IC= [allsubs];
subjectsControlFov_Convex_IC= [allsubs];
subjectsControlFov_Concave_IC= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex_IC = setdiff(subjectsBS_Convex_IC, subjectsBS_Convex_Outliers_IC);
subjectsBS_Concave_IC= setdiff(subjectsBS_Concave_IC, subjectsBS_Concave_Outliers_IC);
subjectsOccPeri_Convex_IC=  setdiff(subjectsOccPeri_Convex_IC, subjectsOccPeri_Convex_Outliers_IC);
subjectsOccPeri_Concave_IC= setdiff(subjectsOccPeri_Concave_IC, subjectsOccPeri_Concave_Outliers_IC);
subjectsControlPeri_Convex_IC= setdiff(subjectsControlPeri_Convex_IC, subjectsControlPeri_Convex_Outliers_IC);
subjectsControlPeri_Concave_IC= setdiff(subjectsControlPeri_Concave_IC, subjectsControlPeri_Concave_Outliers_IC);
%fovea
subjectsOccFov_Convex_IC= setdiff(subjectsOccFov_Convex_IC, subjectsOccFov_Convex_Outliers_IC);
subjectsOccFov_Concave_IC= setdiff(subjectsOccFov_Concave_IC, subjectsOccFov_Concave_Outliers_IC);
subjectsControlFov_Convex_IC= setdiff(subjectsControlFov_Convex_IC, subjectsControlFov_Convex_Outliers_IC);
subjectsControlFov_Concave_IC= setdiff(subjectsControlFov_Concave_IC, subjectsControlFov_Concave_Outliers_IC);
%% SLOPE NICK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLOPE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
removeoutliers = 1;

allsubs = [1:33];

%outliers
%periphery
subjectsBS_Convex_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25:28];
subjectsBS_Concave_Outliers_RC = [1, 3:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsOccPeri_Convex_Outliers_RC = [1, 3:5, 8, 10, 11, 16, 18, 20, 23, 25, 27, 28];
subjectsOccPeri_Concave_Outliers_RC = [1:5, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedPeri_Convex_Outliers_RC = [1, 3:5, 8, 10:12, 16, 18, 20, 23, 25, 27, 28];
subjectsDeletedPeri_Concave_Outliers_RC = [1, 3:5, 8, 10, 11, 16, 18, 20, 22, 25, 27, 28];
%fovea
subjectsOccFov_Convex_Outliers_RC = [1, 3:5, 8, 10, 11, 16, 18, 20, 22, 25, 27, 28, 32];
subjectsOccFov_Concave_Outliers_RC = [1, 3:5, 8:11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Convex_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18, 20, 25, 27, 28];
subjectsDeletedFov_Concave_Outliers_RC = [1, 3:5, 7, 8, 10, 11, 16, 18:20, 25:28];

% everything
%periphery
subjectsBS_Convex_RC = [allsubs];
subjectsBS_Concave_RC= [allsubs];
subjectsOccPeri_Convex_RC= [allsubs];
subjectsOccPeri_Concave_RC= [allsubs];
subjectsDeletedPeri_Convex_RC= [allsubs];
subjectsDeletedPeri_Concave_RC= [allsubs];
%fovea
subjectsOccFov_Convex_RC= [allsubs];
subjectsOccFov_Concave_RC= [allsubs];
subjectsDeletedFov_Convex_RC= [allsubs];
subjectsDeletedFov_Concave_RC= [allsubs];

%minus outliers
%periphery
subjectsBS_Convex_RC = setdiff(subjectsBS_Convex_RC, subjectsBS_Convex_Outliers_RC);
subjectsBS_Concave_RC= setdiff(subjectsBS_Concave_RC, subjectsBS_Concave_Outliers_RC);
subjectsOccPeri_Convex_RC=  setdiff(subjectsOccPeri_Convex_RC, subjectsOccPeri_Convex_Outliers_RC);
subjectsOccPeri_Concave_RC= setdiff(subjectsOccPeri_Concave_RC, subjectsOccPeri_Concave_Outliers_RC);
subjectsDeletedPeri_Convex_RC= setdiff(subjectsDeletedPeri_Convex_RC, subjectsDeletedPeri_Convex_Outliers_RC);
subjectsDeletedPeri_Concave_RC= setdiff(subjectsDeletedPeri_Concave_RC, subjectsDeletedPeri_Concave_Outliers_RC);
%fovea
subjectsOccFov_Convex_RC= setdiff(subjectsOccFov_Convex_RC, subjectsOccFov_Convex_Outliers_RC);
subjectsOccFov_Concave_RC= setdiff(subjectsOccFov_Concave_RC, subjectsOccFov_Concave_Outliers_RC);
subjectsDeletedFov_Convex_RC= setdiff(subjectsDeletedFov_Convex_RC, subjectsDeletedFov_Convex_Outliers_RC);
subjectsDeletedFov_Concave_RC= setdiff(subjectsDeletedFov_Concave_RC, subjectsDeletedFov_Concave_Outliers_RC);


%% PLOT SLOPE for both IC and RC, averaging over curvature

% IC average over curvature
BS_both_curvatures_IC = intersect(subjectsBS_Convex_IC,subjectsBS_Concave_IC);
OccPeri_both_curvatures_IC = intersect(subjectsOccPeri_Convex_IC,subjectsOccPeri_Concave_IC);
CtrlPeri_both_curvatures_IC  =  intersect(subjectsControlPeri_Convex_IC,subjectsControlPeri_Concave_IC);
OccFov_both_curvatures_IC  = intersect(subjectsOccFov_Convex_IC,subjectsOccFov_Concave_IC);
CtrlFov_both_curvatures_IC  = intersect(subjectsControlFov_Convex_IC,subjectsControlFov_Concave_IC);

% RC average over curvature
BS_both_curvatures_RC = intersect(subjectsBS_Convex_RC,subjectsBS_Concave_RC);
OccPeri_both_curvatures_RC = intersect(subjectsOccPeri_Convex_RC,subjectsOccPeri_Concave_RC);
DelPeri_both_curvatures_RC  =  intersect(subjectsDeletedPeri_Convex_RC,subjectsDeletedPeri_Concave_RC);
OccFov_both_curvatures_RC  = intersect(subjectsOccFov_Convex_RC,subjectsOccFov_Concave_RC);
DelFov_both_curvatures_RC  = intersect(subjectsDeletedFov_Convex_RC,subjectsDeletedFov_Concave_RC);

Alldatatoplot = [];
individdata= [];
%group data for boxplot 0.25 - 0.45

Alldatatoplot = ...
    [mean([Data_IC.Slope.BS.Convex(BS_both_curvatures_IC), Data_IC.Slope.BS.Concave(BS_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.BS.Convex(BS_both_curvatures_RC), Data_RC.Slope.BS.Concave(BS_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.OccPeri.Convex(OccPeri_both_curvatures_IC),Data_IC.Slope.OccPeri.Concave(OccPeri_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.OccPeri.Convex(OccPeri_both_curvatures_RC),Data_RC.Slope.OccPeri.Concave(OccPeri_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.CtrlPeri.Convex(CtrlPeri_both_curvatures_IC),Data_IC.Slope.CtrlPeri.Concave(CtrlPeri_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.DelPeri.Convex(DelPeri_both_curvatures_RC),Data_RC.Slope.DelPeri.Concave(DelPeri_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.OccFov.Convex(OccFov_both_curvatures_IC), Data_IC.Slope.OccFov.Concave(OccFov_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.OccFov.Convex(OccFov_both_curvatures_RC), Data_RC.Slope.OccFov.Concave(OccFov_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.CtrlFov.Convex(CtrlFov_both_curvatures_IC),Data_IC.Slope.CtrlFov.Concave(CtrlFov_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.DelFov.Convex(DelFov_both_curvatures_RC),Data_RC.Slope.DelFov.Concave(DelFov_both_curvatures_RC)],2)];

groups = [ones(1,length(BS_both_curvatures_IC))'; ...
    2*ones(1,length(BS_both_curvatures_RC))'; ...
    
    3*ones(1,length(OccPeri_both_curvatures_IC))'; ...
    4*ones(1,length(OccPeri_both_curvatures_RC))'; ...
    
    5*ones(1,length(CtrlPeri_both_curvatures_IC))'; ...
    6*ones(1,length(DelPeri_both_curvatures_RC))'; ...
    
    7*ones(1,length(OccFov_both_curvatures_IC))'; ...
    8*ones(1,length(OccFov_both_curvatures_RC))'; ...
    
    9*ones(1,length(CtrlFov_both_curvatures_IC))'; ...
    10*ones(1,length(DelFov_both_curvatures_RC))'];

individdata = {mean([Data_IC.Slope.BS.Convex(BS_both_curvatures_IC), Data_IC.Slope.BS.Concave(BS_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.BS.Convex(BS_both_curvatures_RC), Data_RC.Slope.BS.Concave(BS_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.OccPeri.Convex(OccPeri_both_curvatures_IC),Data_IC.Slope.OccPeri.Concave(OccPeri_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.OccPeri.Convex(OccPeri_both_curvatures_RC),Data_RC.Slope.OccPeri.Concave(OccPeri_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.CtrlPeri.Convex(CtrlPeri_both_curvatures_IC),Data_IC.Slope.CtrlPeri.Concave(CtrlPeri_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.DelPeri.Convex(DelPeri_both_curvatures_RC),Data_RC.Slope.DelPeri.Concave(DelPeri_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.OccFov.Convex(OccFov_both_curvatures_IC), Data_IC.Slope.OccFov.Concave(OccFov_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.OccFov.Convex(OccFov_both_curvatures_RC), Data_RC.Slope.OccFov.Concave(OccFov_both_curvatures_RC)],2); ...
    
    mean([Data_IC.Slope.CtrlFov.Convex(CtrlFov_both_curvatures_IC),Data_IC.Slope.CtrlFov.Concave(CtrlFov_both_curvatures_IC)],2); ...
    mean([Data_RC.Slope.DelFov.Convex(DelFov_both_curvatures_RC),Data_RC.Slope.DelFov.Concave(DelFov_both_curvatures_RC)],2)};


%% make boxplot for Slopes

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
set(gca,'XTickLabel', {'BS IC', 'BS RC', 'Occ Peri IC', 'Occ Peri RC', ...
     'Ctrl Peri IC', 'Del Peri RC', 'Occ Fov IC', 'Occ Fov RC', 'Ctrl Fov IC', 'Del Fov RC'}) 
set(gca, 'XTickLabelRotation', 45);
set(gca, 'TickDir', 'out')
ylabel('Slope')
% axis([0 11 32 39])
axis([0 11 20 31])
set(gcf, 'Position', [200, 200, 1600, 900])


%% T TESTS for slope
disp('BS IC vs BS RC')
t_test_2_groups(individdata{1}, individdata{2})

disp('Occ Peri IC vs Occ Peri RC')
t_test_2_groups(individdata{3}, individdata{4})

disp('Ctrl Peri IC vs Del Peri RC')
t_test_2_groups(individdata{5}, individdata{6})

disp('Occ Fov IC vs Occ Fov RC')
t_test_2_groups(individdata{7}, individdata{8})

disp('Ctrl Fov IC vs Del Fov RC')
t_test_2_groups(individdata{9}, individdata{10})


disp('Occ Peri RC vs Ctrl Peri IC')
t_test_2_groups(individdata{4}, individdata{5})

disp('Del Peri RC vs Ctrl Peri IC')
t_test_2_groups(individdata{6}, individdata{5})

disp('Occ Fov RC vs Ctrl Fov IC')
t_test_2_groups(individdata{8}, individdata{9})

disp('Del Fov RC vs Ctrl Fov IC')
t_test_2_groups(individdata{10}, individdata{9})