% Analysis for Ehinger et al follow up

% Yulia Revina 2020

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Everything we need is in subjectdata folder

% Just do a simple extraction

% Unambig Fellow Only [0 0 1] -> LEFT is corr
Resp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 0 & subjectdata(:,3) == 1 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/30;
disp(sprintf('Unambig Fellow Only [0 0 1] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 0 & subjectdata(:,3) == 1);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Unambig Fellow Only [0 0 1] Confidence = %f %', AverageConfidence))

% Unambig Fellow Only [0 0 2] -> RIGHT is corr
Resp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 0 & subjectdata(:,3) == 2 & subjectdata(:,5) == 2);
PercentCorr = 100*length(Resp)/30;
disp(sprintf('Unambig Fellow Only [0 0 2] RIGHT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 0 & subjectdata(:,3) == 2);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Unambig Fellow Only [0 0 2] Confidence = %f %', AverageConfidence))

% Unambig L BS [0 2 1] -> LEFT is corr
Resp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 2 & subjectdata(:,3) == 1 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/30;
disp(sprintf('Unambig L BS [0 2 1] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 2 & subjectdata(:,3) == 1);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Unambig L BS [0 2 1] Confidence = %f %', AverageConfidence))

% Unambig R BS [0 1 2] -> RIGHT is corr
Resp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 1 & subjectdata(:,3) == 2 & subjectdata(:,5) == 2);
PercentCorr = 100*length(Resp)/30;
disp(sprintf('Unambig R BS [0 1 2] RIGHT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 0 & subjectdata(:,2) == 1 & subjectdata(:,3) == 2);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Unambig R BS [0 1 2] Confidence = %f %', AverageConfidence))


% Ambig Fellow Only [1 0 0] -> None is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 0 & subjectdata(:,3) == 0 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/120;
disp(sprintf('Ambig Fellow Only [1 0 0] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 0 & subjectdata(:,3) == 0);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig Fellow Only [1 0 0] Confidence = %f %', AverageConfidence))

% Ambig Both BS [1 3 0] -> None is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 0 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/40;
disp(sprintf('Ambig Both BS [1 3 0] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 0);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig Both BS [1 3 0] Confidence = %f %', AverageConfidence))


% Ambig Both BS [1 3 1] -> LEFT is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 1 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/40;
disp(sprintf('Ambig Both BS [1 3 1] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 1);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig Both BS [1 3 1] Confidence = %f %', AverageConfidence))

% Ambig Both BS [1 3 2] -> RIGHT is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 2 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/40;
disp(sprintf('Ambig Both BS [1 3 2] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 3 & subjectdata(:,3) == 2);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig Both BS [1 3 2] Confidence = %f %', AverageConfidence))

% Ambig L BS [1 2 0] -> None is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 2 & subjectdata(:,3) == 0 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/60;
disp(sprintf('Ambig L BS [1 2 0] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 2 & subjectdata(:,3) == 0);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig L BS [1 2 0] Confidence = %f %', AverageConfidence))

% Ambig R BS [1 1 0] -> None is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 1 & subjectdata(:,3) == 0 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/60;
disp(sprintf('Ambig R BS [1 1 0] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 1 & subjectdata(:,3) == 0);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig R BS [1 1 0] Confidence = %f %', AverageConfidence))

% Ambig R BS [1 1 1] -> LEFT is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 1 & subjectdata(:,3) == 1 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/60;
disp(sprintf('Ambig R BS [1 1 1] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 1 & subjectdata(:,3) == 1);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig R BS [1 1 1] Confidence = %f %', AverageConfidence))


% Ambig R BS [1 2 2] -> RIGHT is corr, calculate where they say left
Resp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 2 & subjectdata(:,3) == 2 & subjectdata(:,5) == 1);
PercentCorr = 100*length(Resp)/60;
disp(sprintf('Ambig R BS [1 2 2] LEFT = %f %', PercentCorr))
ConfidenceResp = find(subjectdata(:,1) == 1 & subjectdata(:,2) == 2 & subjectdata(:,3) == 2);
AverageConfidence = mean(subjectdata(ConfidenceResp, 7));
disp(sprintf('Ambig R BS [1 2 2] Confidence = %f %', AverageConfidence))


%% Draw chart for individ subj (load data separately)

% IndividualResult = [];

figure; 
for i = 1:4
    plot(IndividualResult(i),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [0 0 1])
    hold on
end
for i = 5:8
    plot(IndividualResult(i),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [1 0 0])
    hold on
end
for i = 9:12
    plot(IndividualResult(i),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [0 1 0])
    hold on
end
set ( gca, 'xdir', 'reverse' )
set ( gca, 'ydir', 'reverse' )
% axis ([120 0 12 1])
% axis ([0 120 12 1])
plot([50 50],[0 12], '--')
plot([55.83 55.83], [0 12], '-')
xlabel('% LEFT')
ylabel('Condition')
ax = gca;
ax.YTick = ([0:12])
ax.YTickLabel = {'', 'Unambiguous Fellow Eye Inset R', 'Unambiguous Fellow Eye Inset L', 'Unambiguous L BS Inset R', ...
    'Unambiguous R BS Inset L', 'Ambiguous Fellow Only Inset None', 'Ambiguous Both BS Inset None', ...
    'Ambiguous Both BS Inset R', 'Ambiguous Both BS Inset L', 'Ambiguous L BS Inset None', 'Ambiguous L BS Inset L', ...
    'Ambiguous R BS Inset None', 'Ambiguous R BS Inset R'};

%% Draw chart for group result
nSubs = 19;

% all subs
subs = 1:nSubs;
%%"good" subs only
subs = [1, 2, 4, 6, 8, 10:14, 17:19];
figure; 
for subNum = subs
    for i = 1:4
%         plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', [48/255 56/255 196/255], 'MarkerEdgeColor', 'none')
        plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k')
        hold on
    end
    for i = 5:8
%         plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', [255/255 40/255 128/255], 'MarkerEdgeColor', 'none')
        plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k')
        hold on
    end
    for i = 9:12
%         plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', [100/255 255/255 255/255], 'MarkerEdgeColor', 'none')
        plot(GroupData(subNum,i),i, 'o', 'LineStyle', '-', 'MarkerSize', 5, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k')
        hold on
    end
end

%plot the means
for i = 1:4
    plot(nanmean(GroupData(subs,i)),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [24/255 28/255 98/255], 'MarkerEdgeColor', [0 0 0])
    hold on
end
for i = 5:8
    plot(nanmean(GroupData(subs,i)),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [215/255 20/255 64/255], 'MarkerEdgeColor', [0 0 0])
    hold on
end
for i = 9:12
    plot(nanmean(GroupData(subs,i)),i, 'o', 'LineStyle', '-', 'MarkerSize', 10, 'MarkerFaceColor', [50/255 188/255 173/255], 'MarkerEdgeColor', [0 0 0])
    hold on
end
   
set ( gca, 'xdir', 'reverse' )
set ( gca, 'ydir', 'reverse' )
% axis ([120 0 12 1])
% axis ([0 120 12 1])
plot([50 50],[0 12], '--')
plot([nanmean(nanmean(GroupData(subs,5:8))), nanmean(nanmean(GroupData(subs,5:8)))], [0 12], '-')
xlabel('% LEFT')
ylabel('Condition')
ax = gca;
ax.YTick = ([0:12]);
ax.YTickLabel = {'', 'Unambiguous Fellow Eye Inset R', 'Unambiguous Fellow Eye Inset L', 'Unambiguous L BS Inset R', ...
    'Unambiguous R BS Inset L', 'Ambiguous Fellow Only Inset None', 'Ambiguous Both BS Inset None', ...
    'Ambiguous Both BS Inset R', 'Ambiguous Both BS Inset L', 'Ambiguous L BS Inset None', 'Ambiguous L BS Inset L', ...
    'Ambiguous R BS Inset None', 'Ambiguous R BS Inset R'};
set(gcf, 'Position', [500 500 1000 650])

%% STATS

for condition = 9:12
 [mean1, mean2, H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise(GroupData(subs, condition), nanmean(GroupData(subs, [5:8]),2));
 [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -50, 50, nanmean(GroupData(subs, condition)));
 fprintf ('Mean1 = %5.4g, Mean2 = %5.4g, t(%d) = %#5.5g, p = %5.4g, B(%5.4g, %5.4g) = %5.5g \n \n', mean1, mean2, STATS.df, STATS.tstat, P, lowerBound, upperBound, BF)
end
