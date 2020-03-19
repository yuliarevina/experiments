function [H,P, STATS, raweffect, SE, corrected_SE] = t_test_from_zero (data)

mean(data)
[H,P, ~,STATS] = ttest(data)
%for bayes
raweffect = mean(mean(data) - 0)
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30