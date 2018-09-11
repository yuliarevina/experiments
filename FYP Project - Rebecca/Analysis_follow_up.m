% Analysis script

ntrialseachcond = 30;


%% extract data
conditions = nan(7,ntrialseachcond,5);
tmp1 = [];
tmp2 = [];
results = nan(7,1,2);
for i = 1:3; %conditions
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
                case 3
                    cond = 2;
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
                case 6
                    orient = 360 - orientations(6);
                case 7
                    orient = 360 - orientations (7);
            end
        
            
            if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 1)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
            elseif cond == 1 % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                tmp1 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 2 & subjectdata(:,3) == 2)'; %standard first; check for trials where they answer 2nd
                tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
            elseif cond == 2 % annulus fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
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
plot(1:5, results(1:5,1,3), 'go-') %Fellow annulus
% plot(1:5, results(1:5,1,3), 'go-') %occl
% plot(1:5, results(1:5,1,4), 'kx-') %del sharp
% plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 ntrialseachcond+0.5])
[leg] = legend('BS', 'Fellow', 'Annulus', 'Location', 'Northwest');
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
% StimLevels = [35 40 45 50 55]; %hardtask
% StimLevels = [25 35 45 55 65]; %easytask
StimLevels = [22.5 30 37.5 45 52.5 60 67.5]; %mediumtask

figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condswitch = 1:3 %conditions
    
    switch condswitch
        case 1
            disp('BS')
        case 2
            disp('Fellow')
        case 3
            disp('Annulus')
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

legend('BS', 'Fellow', 'Annulus', 'Location', 'Southeast');

for condswitch = 1:3
     plot(StimLevelsFineGrain,ProportionCorrectModel(condswitch,:),'-','color',colorpoints(condswitch),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity - Orientation');
ylabel('Proportion "Comparison More Clockwise"');
plot([0 5],[0.5 0.5])
plot([0.3 0.3], [0 1], 'LineStyle', '--')


%% confidence ratings

% BS
% Fellow
% Annulus

%Check confidence for correct answers
% Check confidence for ambiguous conditions
% for BS fellow and annulus

%Perhaps people are more confident for the BS in ambiguous cases. Etc

%% extract data
% conditions = nan(5,ntrialseachcond,5);
tmp3 = [];
tmp4 = [];
tmp5 = [];
tmp6 = [];
tmp7 = [];
tmp8 = [];
tmp9 = [];
tmp10 = [];
tmp11 = [];
tmp12 = [];
tmp13 = [];
tmp14 = [];
tmp15 = [];
tmp16 = [];
tmp17 = [];
tmp18 = [];
tmp19 = [];
tmp20 = [];
tmp21 = [];
tmp22 = [];
tmp23 = [];
tmp24 = [];
tmp25 = [];
tmp26 = [];
tmp27 = [];


BS_confidence = nan(ntrialseachcond,5) ;
Fellow_confidence = nan(ntrialseachcond,5) ;
Annulus_confidence = nan(ntrialseachcond,5) ;

BS_correct_confidence = nan(ntrialseachcond,5) ;
BS_incorrect_confidence = nan(ntrialseachcond,5) ;

Fellow_correct_confidence = nan(ntrialseachcond,5) ;
Fellow_incorrect_confidence = nan(ntrialseachcond,5) ;

Annulus_correct_confidence = nan(ntrialseachcond,5) ;
Annulus_incorrect_confidence = nan(ntrialseachcond,5) ;


% results = nan(5,1,2);
for i = 1:3; %conditions
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
                case 3
                    cond = 2;
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
        
            %-----------------------------------------------------------------
            %find all conditions - gives confidence ratings for each orientation (1
            %column = one orientation
            
            if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                tmp3 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond))'; %orientation = 45 deg and BS trial
                BS_confidence(:, j) = subjectdata(tmp3, 6);
                %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
            elseif cond == 1 % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                tmp4 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond))'; %orientation = 45 deg and Fellow trial
                Fellow_confidence(:, j) = subjectdata(tmp4, 6);
                %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
            elseif cond == 2 % annulus fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                tmp5 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) )'; %orientation = 45 deg and Annulus trial
                Annulus_confidence(:,j) = subjectdata(tmp5, 6);
                %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
            end
            
            
            if j == 1 || j == 2 %if the comparison orientation was below 45, then we need all trials where they answered 'standard' for correct answer and 'comparison' for incorrect
                %---------------------------------------------------------------------
                %find all trials for each condition and orientation which were correct (45
                %deg cannot do because ambiguous)
                if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                    tmp6 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)'; %comparison below 45, so answering 'standard' is the correct answer
                    tmp7 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)'; %comparison below 45, so answering 'standard' is the correct answer
                    
                    tmp8 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)'; %comparison below 45, so answering 'comparison' is the incorrect answer
                    tmp9 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)'; %comparison below 45, so answering 'comparison' is the incorrect answer

                    BS_correct_confidence(1:length(subjectdata([tmp6 tmp7],6)), j) = subjectdata([tmp6, tmp7], 6);
                    BS_incorrect_confidence(1:length(subjectdata([tmp8 tmp9],6)), j) = subjectdata([tmp8 tmp9], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
                elseif cond == 1 % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                    tmp8 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)';
                    tmp9 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)';

                    tmp10 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)';
                    tmp11 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)';
                    
                    Fellow_correct_confidence(1:length(subjectdata([tmp8 tmp9],6)), j) = subjectdata([tmp8 tmp9], 6);
                    Fellow_incorrect_confidence(1:length(subjectdata([tmp10 tmp11],6)), j) = subjectdata([tmp10 tmp11], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                elseif cond == 2 % annulus fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                    tmp12 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)';
                    tmp13 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)';

                    tmp14 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)';
                    tmp15 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)';
                    
                    Annulus_correct_confidence(1:length(subjectdata([tmp12 tmp13],6)),j) = subjectdata([tmp12 tmp13], 6);
                    Annulus_incorrect_confidence(1:length(subjectdata([tmp14 tmp15],6)),j) = subjectdata([tmp14  tmp15], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                end
                
                
            elseif j == 4 || j == 5 %if the comparison orientation was above 45, then we need all trials where they answered 'comparison'
                %--------------------------------------------------------------------
                %find all trials for each condition and orientation which were incorrect
                
                if cond == 0 % if BS; responses are normal. L screen standard is L hand side for the participant.
                    tmp16 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)'; %comparison below 45, so answering 'comparison' is the correct answer
                    tmp17 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)'; %comparison below 45, so answering 'comparison' is the correct answer

                    tmp18 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)'; %comparison below 45, so answering 'standard' is the incorrect answer
                    tmp19 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)'; %comparison below 45, so answering 'standard' is the incorrect answer

                    BS_correct_confidence(1:length(subjectdata([tmp16 tmp17],6)), j) = subjectdata([tmp16 tmp17], 6);
                    BS_incorrect_confidence(1:length(subjectdata([tmp18 tmp19],6)), j) = subjectdata([tmp18 tmp19], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 2)'; %standard second; check for trials where they answer 1st
                elseif cond == 1 % fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                    tmp20 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)';
                    tmp21 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)';

                    tmp22 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)';
                    tmp23 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)';

                    Fellow_correct_confidence(1:length(subjectdata([tmp20 tmp21],6)), j) = subjectdata([tmp20 tmp21], 6);
                    Fellow_incorrect_confidence(1:length(subjectdata([tmp22 tmp23],6)), j) = subjectdata([tmp22 tmp23], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                elseif cond == 2 % annulus fellow. Swap which answer is correct. Because if Standard was on the L screen, that was Participant's RIGHT hand side (cos of the mirroring)
                    tmp24 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 1)';
                    tmp25 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 2)';

                    tmp26 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1 & subjectdata(:,4) == 2)';
                    tmp27 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 2 & subjectdata(:,4) == 1)';

                    Annulus_correct_confidence(1:length(subjectdata([tmp24 tmp25],6)),j) = subjectdata([tmp24 tmp25], 6);
                    Annulus_incorrect_confidence(1:length(subjectdata([tmp26 tmp27],6)),j) = subjectdata([tmp26 tmp27], 6);
                    %                 tmp2 = find((subjectdata(:,2) == orient) & (subjectdata(:,1) == cond) & subjectdata(:,4) == 1 & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
                end
                
            end %if

    end
end