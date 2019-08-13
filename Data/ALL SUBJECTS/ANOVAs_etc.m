[p,table,stats] = anovan([Data_25_45.Slope.Intact(subjects_all); Data_25_45.Slope.BS(subjects_all); ...
    Data_25_45.Slope.Occluded(subjects_all); Data_25_45.Slope.DeletedSharp(subjects_all); Data_25_45.Slope.DeletedFuzzy(subjects_all)], ...
{unnamed1,Subjects},...
 'random',2,'varnames', {'Condition','Subjects'});



[p,tbl,stats] = friedman([Data_25_45.Slope.Intact(subjects_all), Data_25_45.Slope.BS(subjects_all), ...
    Data_25_45.Slope.Occluded(subjects_all), Data_25_45.Slope.DeletedSharp(subjects_all), Data_25_45.Slope.DeletedFuzzy(subjects_all)])


[p,tbl,stats] = friedman([Data_25_45.Slope.BS(subjects_all), ...
    Data_25_45.Slope.Occluded(subjects_all), Data_25_45.Slope.DeletedSharp(subjects_all), Data_25_45.Slope.DeletedFuzzy(subjects_all)])


subjects_all = intersect(subjectsIntact,subjectsBS);
subjects_all = intersect(subjects_all,subjectsOcc);
subjects_all = intersect(subjects_all,subjectsDelSh);
subjects_all = intersect(subjects_all,subjectsDelFuzz);


subjects_all = intersect(subjectsIntact20_60,subjectsBS20_60);
subjects_all = intersect(subjects_all,subjectsOcc20_60);
subjects_all = intersect(subjects_all,subjectsDelSh20_60);
subjects_all = intersect(subjects_all,subjectsDelFuzz20_60);



[p,tbl,stats] = friedman([Data_20_60.Slope.Intact(subjects_all-37), Data_20_60.Slope.BS(subjects_all-37), ...
    Data_20_60.Slope.Occluded(subjects_all-37), Data_20_60.Slope.DeletedSharp(subjects_all-37), Data_20_60.Slope.DeletedFuzzy(subjects_all-37)])


[p,tbl,stats] = friedman([Data_20_60.Slope.BS(subjects_all-37), ...
    Data_20_60.Slope.Occluded(subjects_all-37), Data_20_60.Slope.DeletedSharp(subjects_all-37), Data_20_60.Slope.DeletedFuzzy(subjects_all-37)])