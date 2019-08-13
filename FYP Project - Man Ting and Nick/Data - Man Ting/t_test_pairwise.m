function [H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise (data1, data2)

mean(data1)
mean(data2)
[H,P, ~,STATS] = ttest(data1, data2)
%for bayes
raweffect = mean(data1) - mean(data2)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30