medianIntactPSE_good = median(Intact([11 12 14:22 24 26 27 29 30 33:36],1));
medianBSPSE_good = median(BS([11 12 14:22 24 26 27 29 30 33:36],1));
medianOccludedPSE_good = median(Occluded([11 12 14:22 24 26 27 29 30 33:36],1));
medianDelShPSE_good = median(DeletedSharp([11 12 14:22 24 26 27 29 30 33:36],1));
medianDelFuzPSE_good = median(DeletedFuzzy([11 12 14:22 24 26 27 29 30 33:36],1));



medianIntactPSE_bad = median(Intact([10 13 23 25 28 31 32 37],1));
medianBSPSE_bad = median(BS([10 13 23 25 28 31 32 37],1));
medianOccludedPSE_bad = median(Occluded([10 13 23 25 28 31 32 37],1));
medianDelShPSE_bad = median(DeletedSharp([10 13 23 25 28 31 32 37],1));
medianDelFuzPSE_bad = median(DeletedFuzzy([10 13 23 25 28 31 32 37],1));

disp('Intact')
[p,h,stats] = ranksum(Intact([11 12 14:22 24 26 27 29 30 33:36],1),Intact([11 12 14:22 24 26 27 29 30 33:36],1)) %independent samples
disp('BS')
[p,h,stats] = ranksum(BS([11 12 14:22 24 26 27 29 30 33:36],1),BS([10 13 23 25 28 31 32 37],1)) %independent samples
disp('Occ')
[p,h,stats] = ranksum(Occluded([11 12 14:22 24 26 27 29 30 33:36],1),Occluded([10 13 23 25 28 31 32 37],1)) %independent samples
disp('DelSh')
[p,h,stats] = ranksum(DeletedSharp([11 12 14:22 24 26 27 29 30 33:36],1),DeletedSharp([10 13 23 25 28 31 32 37],1)) %independent samples
disp('DelFuz')
[p,h,stats] = ranksum(DeletedFuzzy([10 13 23 25 28 31 32 37],1),DeletedFuzzy([10 13 23 25 28 31 32 37],1)) %independent samples