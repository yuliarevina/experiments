% Psychometric function analysis
% Yulia Revina, NTU, SG

% For every condition [subjectdata(1)] we need to find when comparison was
% rated as denser [subjetdata(3) == 2], for each SF (subjectdata(2))

% for sub = 1:9
%     addpath(sprintf('C:/Users/HSS/Documents/GitHub/experiments/Data/SUB %d', sub))
% end

ntrialseachcond = 40;


%% extract data
conditions = nan(5,ntrialseachcond,5);
tmp1 = [];
tmp2 = [];
results = nan(5,1,5);
for i = 1:5; %conditions
    %     conditions(:,i) = find(subjectdata(:,1) == i); %find all intact trials, all BS trials...
    %     tmp(:,i) = find(subjectdata(:,1) == i);
    for j = 1:5 %SF
        %       SFs(:,j) = find(subjectdata(:,2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         tmp2(:,j) = find(subjectdata(:,2) == j);
        %         subjectdata(tmp,tmp2)
        
            tmp1 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 2 & subjectdata(:,5) == 1)'; %standard first; check for trials where they answer 2nd
            tmp2 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 1 & subjectdata(:,5) == 2)'; %standard second; check for trials where they answer 1st
        %for the mistake in counterbalancing
%             tmp2 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
        %         conditions(j,:,i) = tmp;
        results(j,1,i) = size(tmp1,2)+size(tmp2,2);
        %for the mistake in counterbalancing
%          results(j,1,i) = size(tmp2,2);
    end
end

%% figure
figure; plot(1:5, results(1:5,1,1), 'ro-') %intact
hold on;
plot(1:5, results(1:5,1,2), 'bs-') %BS
plot(1:5, results(1:5,1,3), 'go-') %occl
plot(1:5, results(1:5,1,4), 'kx-') %del sharp
plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 ntrialseachcond+0.5])
[leg] = legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Northwest');
ax = findobj(gcf,'type','axes'); %Retrieve the axes to be copied
hold off;


colorpoints(1) = 'r';
colorpoints(2) = 'b';
colorpoints(3) = 'g';
colorpoints(4) = 'k';
colorpoints(5) = 'c';

markershape(1) = 's';
markershape(2) = 's';
markershape(3) = 'o';
markershape(4) = 'x';
markershape(5) = 'x';

%% psignifit stuff
psignifitdata = zeros(5,3,5);
psignifitdata(1,1,:) = 0.25;
psignifitdata(2,1,:) = 0.30;
psignifitdata(3,1,:) = 0.35;
psignifitdata(4,1,:) = 0.40;
psignifitdata(5,1,:) = 0.45;

psignifitdata(:,2,1) = results(:,:,1)/ntrialseachcond;
psignifitdata(:,2,2) = results(:,:,2)/ntrialseachcond;
psignifitdata(:,2,3) = results(:,:,3)/ntrialseachcond;
psignifitdata(:,2,4) = results(:,:,4)/ntrialseachcond;
psignifitdata(:,2,5) = results(:,:,5)/ntrialseachcond;
psignifitdata(:,3,:) = ntrialseachcond;

figure;
psychometricfig = gcf;
% ax = findobj(gcf,'type','axes'); %Retrieve the axes to be copied


% legh = legend(ax);
% copyobj([legh,ax],psychometricfig);

axes1 = axes('Parent',psychometricfig);
box(axes1,'on');
hold(axes1,'on');

for condition = 1:5
%     plotpd(psignifitdata(:,:,condition), 'Color', colorpoints(condition), 'MarkerSize',20)  % plots the points
%     plot(psignifitdata(:,:,condition), 'Color', colorpoints(condition), 'MarkerSize',20)  % plots the points
    
    plot(psignifitdata(:,1,1)', psignifitdata(:,2,condition), 'LineStyle', 'None', 'Color', colorpoints(condition), 'Marker', markershape(condition), 'MarkerSize', 10) %intact
%     legend('1', '2')
    hold on
end

legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Southeast');

for condition = 1:5
    plotpd(psignifitdata(:,:,condition), 'LineStyle', 'None', 'Color', colorpoints(condition), 'Marker', markershape(condition), 'MarkerFaceColor', 'None','MarkerSize', 5)  % plots the points
    shape = 'cumulative Gaussian';   % what curve you want to fit
    prefs = batch('shape', shape, 'n_intervals', 1, 'runs', 2000);
    % n intervals corresponds to the space between the choices I think, runs is
    % how many bootstrap fittings you want to do
    
    outputPrefs = batch('write_pa', 'pa', 'write_th', 'th','write_st','st', 'write_sl', 'sl');
    % outputPrefs = batch('params', 'pa');
    % this just chooses what you want out of it - I wanted thresholds and
    % errors
    
    h2(condition,:) = psignifit(psignifitdata(:,:,condition), [prefs outputPrefs]);
    % h2 = pfit(data, [prefs]);
    % h2 = pfit(data, 'shape', shape, 'n_intervals', 1, 2000)
    % this will output it and work out the curve
    plot1(condition) = plotpf(shape, pa.est, 'Color', colorpoints(condition), 'Parent', axes1);
%     plot1(4) = plotpf(shape, pa.est, 'Color', colorpoints(condition), 'Parent', axes1);
    % plotpf(shape, h2.params.est)
    % Plot the fit to the original data
    
    [s, t] = findslope(shape, pa.est);
end

plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')

% plot1 = gcf;
% set(plot1(1),'DisplayName','Intact','Marker','o','Color',[1 0 0]);
% set(plot1(2),'DisplayName','BS','Marker','square','Color',[0 0 1]);
% set(plot1(3),'DisplayName','Occl','Marker','o','Color',[0 1 0]);
% set(plot1(4),'DisplayName','Del Sharp','Marker','x','Color',[0 0 0]);
% set(plot1(5),'DisplayName','Del Fuzz','Marker','x','Color',[0 1 1]);

% Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'Location','northwest');
% legend



% newfig= figure;
% legh = legend(ax);
% % psychometricfig = gcf;
% copyobj([legh,ax],newfig);

hold off;

%% palamedes analysis

disp ('Palamedes...')
%Stimulus intensities
StimLevels = [0.25 0.30 0.35 0.40 0.45]; 
figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condition = 1:5 %conditions
    
    switch condition
        case 1
            disp('Intact')
        case 2
            disp('Blindspot')
        case 3
            disp('Occluded')
        case 4
            disp('Deleted Sharp')
        case 5
            disp('Deleted Fuzzy')
    end
    
    %Number of positive responses (e.g., 'yes' or 'correct' at each of the
    %   entries of 'StimLevels'
    NumPos = [results(1,:,condition) results(2,:,condition) results(3,:,condition) results(4,:,condition) results(5,:,condition)];
    
    %Number of trials at each entry of 'StimLevels'
    OutOfNum = [ntrialseachcond ntrialseachcond ntrialseachcond ntrialseachcond ntrialseachcond];
    
    
    
    %Use the Logistic function
    PF = @PAL_Logistic;
    %@PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull,
    %PAL_Quick, PAL_logQuick,
    %PAL_CumulativeNormal, PAL_HyperbolicSecant
    
    %Threshold and Slope are free parameters, guess and lapse rate are fixed
    paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
    
    %Parameter grid defining parameter space through which to perform a
    %brute-force search for values to be used as initial guesses in iterative
    %parameter search.
    searchGrid.alpha = 0.25:.001:.45; %PSE
    searchGrid.beta = logspace(0,1,101); %slope
    searchGrid.gamma = 0.0;  %scalar here (since fixed) but may be vector %guess rate (lower asymptote)
    searchGrid.lambda = 0.02;  %ditto % lapse rate, finger error, upper asympt
    
    %Perform fit
    disp('Fitting function.....');
    [paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels,NumPos, ...
        OutOfNum,searchGrid,paramsFree,PF);
    
    disp('done:')
    message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
    disp(message);
    message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
    disp(message);
    
    %Create simple plot
    ProportionCorrectObserved=NumPos./OutOfNum;
    StimLevelsFineGrain=[min(StimLevels-0.05):max(StimLevels+0.05)./1000:max(StimLevels+0.05)];
    ProportionCorrectModel(condition,:) = PF(paramsValues,StimLevelsFineGrain);
    
    
    plot(StimLevels,ProportionCorrectObserved,'LineStyle', 'None','Color', colorpoints(condition),'Marker',markershape(condition),'MarkerFaceColor', 'None','markersize',10);  
    
    
    
%     searchGrid.alpha = [-1:.1:1];    %structure defining grid to
% %   searchGrid.beta = 10.^[-1:.1:2]; %search for initial values
% %   searchGrid.gamma = .5;
% %   searchGrid.lambda = [0:.005:.03];
% %   paramsFree = [1 1 0 1];
%     
    
    disp('Goodness of Fit')
    B = 1000;
    [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF,'searchGrid', searchGrid);
  
    disp(sprintf('Dev: %6.4f',Dev))
    disp(sprintf('pDev: %6.4f',pDev))
    disp(sprintf('N converged: %6.4f',sum(converged==1)))
    disp('--') %empty line
end

legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Southeast');

for condition = 1:5
     plot(StimLevelsFineGrain,ProportionCorrectModel(condition,:),'-','color',colorpoints(condition),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - cycles per deg SF');
ylabel('Proportion "Comparison More Stripes"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')