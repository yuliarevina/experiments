% Analysis script

ntrialseachcond = 5;


%% extract data
conditions = nan(5,ntrialseachcond,5);
tmp1 = [];
tmp2 = [];
results = nan(5,1,2);
for i = 1:2; %conditions
    %     conditions(:,i) = find(subjectdata(:,1) == i); %find all intact trials, all BS trials...
    %     tmp(:,i) = find(subjectdata(:,1) == i);
    for j = 1:5 %Orientations
        %       SFs(:,j) = find(subjectdata(:,2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         tmp2(:,j) = find(subjectdata(:,2) == j);
        %         subjectdata(tmp,tmp2)
        
        % renumber conditions to what they are in the subjectdata matrix
            switch i
                case 1
                    cond = 0;
                case 2
                    cond = 1;
            end
            
            switch j
                case 1
                    orient = 360 - orientations(1);
                case 2
                    orient = 360 - orientations(2);
                case 3
                    orient = 360 - orientations(3);
                case 4
                    orient = 360 - orientations(4);
                case 5
                    orient = 360 - orientations(5);
            end
        
            
            if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 1)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
            else % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 2)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                
            end
        %for the mistake in counterbalancing
%             tmp2 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
        %         conditions(j,:,i) = tmp;
        results(j,1,i) = size(tmp1,2)+size(tmp2,2);
        %for the mistake in counterbalancing
%          results(j,1,i) = size(tmp2,2);
    end
end



%% figure
figure; plot(1:5, results(1:5,1,1), 'ro-') %BS
hold on;
plot(1:5, results(1:5,1,2), 'bs-') %Fellow
% plot(1:5, results(1:5,1,3), 'go-') %occl
% plot(1:5, results(1:5,1,4), 'kx-') %del sharp
% plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 ntrialseachcond+0.5])
[leg] = legend('BS', 'Fellow', 'Location', 'Northwest');
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




%% palamedes analysis

disp ('Palamedes...')
%Stimulus intensities
StimLevels = [35 40 45 50 55]; 
figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condswitch = 1:2 %conditions
    
    switch condswitch
        case 1
            disp('BS')
        case 2
            disp('Fellow')
%         case 3
%             disp('Occluded')
%         case 4
%             disp('Deleted Sharp')
%         case 5
%             disp('Deleted Fuzzy')
    end
    
    %Number of positive responses (e.g., 'yes' or 'correct' at each of the
    %   entries of 'StimLevels'
    NumPos = [results(1,:,condswitch) results(2,:,condswitch) results(3,:,condswitch) results(4,:,condswitch) results(5,:,condswitch)];
    
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
    searchGrid.alpha = 25:.001:65; %PSE
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
    ProportionCorrectModel(condswitch,:) = PF(paramsValues,StimLevelsFineGrain);
    
    
    plot(StimLevels,ProportionCorrectObserved,'LineStyle', 'None','Color', colorpoints(condswitch),'Marker',markershape(condswitch),'MarkerFaceColor', 'None','markersize',10);  
  
    
    
%     searchGrid.alpha = [-1:.1:1];    %structure defining grid to
% %   searchGrid.beta = 10.^[-1:.1:2]; %search for initial values
% %   searchGrid.gamma = .5;
% %   searchGrid.lambda = [0:.005:.03];
% %   paramsFree = [1 1 0 1];
%     
    
%     disp('Goodness of Fit')
%     B = 1000;
%     [Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, NumPos, OutOfNum, paramsValues, paramsFree, B, PF,'searchGrid', searchGrid);
%   
%     disp(sprintf('Dev: %6.4f',Dev))
%     disp(sprintf('pDev: %6.4f',pDev))
%     disp(sprintf('N converged: %6.4f',sum(converged==1)))
%     disp('--') %empty line
end

legend('BS', 'Fellow', 'Location', 'Southeast');

for condswitch = 1:2
     plot(StimLevelsFineGrain,ProportionCorrectModel(condswitch,:),'-','color',colorpoints(condswitch),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - Orientation');
ylabel('Proportion "Comparison More Clockwise"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')