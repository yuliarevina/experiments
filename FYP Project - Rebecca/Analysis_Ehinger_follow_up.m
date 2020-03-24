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
