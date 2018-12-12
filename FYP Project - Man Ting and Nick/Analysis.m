% Analysis script for Illusory Contours Expt

% Written by Yulia Revina, 2018, NTU, Singapore.


%% set parameters
ntrialseachcond = 20; %remember to double this number if testing con-vex and -cave together [convex =3]
convex = 2; %convex =1, concave =2; 3 to test both averaged together
outsidekey = 2; %normally should be 2 but try 1 if you think person mixed up the buttons

nDotPos = 7; %how many dot positions were there in total? (prob 7 or 9)
%% extract data
conditions = nan(5,ntrialseachcond,5);
tmp1 = [];
tmp2 = [];
results = nan(nDotPos,1,2);
for i = 1:5; %conditions
    %     conditions(:,i) = find(subjectdata(:,1) == i); %find all intact trials, all BS trials...
    %     tmp(:,i) = find(subjectdata(:,1) == i);
    for j = 1:nDotPos %dot positions
        %       SFs(:,j) = find(subjectdata(:,2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         conditions(j,:,i) = find(subjectdata(tmp(:,i),2) == j);
        %         tmp2(:,j) = find(subjectdata(:,2) == j);
        %         subjectdata(tmp,tmp2)
        
        % renumber conditions to what they are in the subjectdata matrix
%             switch i
%                 case 1
%                     cond = 0;
%                 case 2
%                     cond = 1;
%             end
            
            switch j
                case 1
%                     dotpos = -1;
%                     dotpos = -2;
                    dotpos = -3;
                case 2
%                     dotpos = -0.5;
%                     dotpos = -1;
                    dotpos = -2;
                case 3
                    dotpos = -1;
                case 4
%                     dotpos = 0.5;
%                     dotpos = 1;
                    dotpos = 0;
                case 5
%                     dotpos = 1;
%                     dotpos = 2;
                     dotpos = 1;

                case 6
                    %                     dotpos = 1;
                    %                     dotpos = 3;
                    dotpos = 2;
                    
                case 7
                    %                     dotpos = 1;
                    %                     dotpos = 4;
                    dotpos = 3;
%                 case 8
%                     %                     dotpos = 1;
%                     %                     dotpos = 4;
%                     dotpos = 3;
%                 case 9
%                     %                     dotpos = 1;
%                     %                     dotpos = 4;
%                     dotpos = 4;
            end
            
            if convex == 1 || convex == 2
                if i == 1 % if BS; responses are normal. L screen standard is L hand side for the participant.
                    %                 tmp1 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1)'; %INSIDE
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & (subjectdata(:,4) == convex) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==2 % fellow. Periphery. Occluder
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & (subjectdata(:,4) == convex) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==3
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & (subjectdata(:,4) == convex) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==4
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & (subjectdata(:,4) == convex) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==5
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & (subjectdata(:,4) == convex) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                end
            
            else %both concave and convex toegther
                if i == 1 % if BS; responses are normal. L screen standard is L hand side for the participant.
                    %                 tmp1 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == cond) & subjectdata(:,3) == 1)'; %INSIDE
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==2 % fellow. Periphery. Occluder
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==3
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==4
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                elseif i==5
                    tmp1 = find((subjectdata(:,2) == dotpos) & (subjectdata(:,1) == i) & subjectdata(:,5) == outsidekey)'; %OUTSIDE
                end
            end
        %for the mistake in counterbalancing
%             tmp2 = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 1)'; %standard second; check for trials where they answer 1st
        %         conditions(j,:,i) = tmp;
        results(j,1,i) = size(tmp1,2);
        %for the mistake in counterbalancing
%          results(j,1,i) = size(tmp2,2);
    end
end



%% figure with raw data
figure; plot(1:nDotPos, results(1:nDotPos,1,1), 'ro-') %BS
hold on;
plot(1:nDotPos, results(1:nDotPos,1,2), 'bs-') %Occ Peri
plot(1:nDotPos, results(1:nDotPos,1,3), 'go-') %Control Peri
plot(1:nDotPos, results(1:nDotPos,1,4), 'kx-') %Occ Fov
plot(1:nDotPos, results(1:nDotPos,1,5), 'cx-') %Control Fov
axis([0.5 nDotPos+0.5 -0.5 ntrialseachcond+0.5])
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




%% palamedes analysis & fitted psychometric functions figure

disp ('Palamedes...')
%Stimulus intensities
StimLevels = [-1, -0.5, 0, 0.5, 1]; %hardtask
StimLevels = [-2, -1, 0, 1, 2, 3, 4]; %hardtask
StimLevels = [-3, -2, -1, 0, 1, 2, 3]; %hardtask

figure('name','Maximum Likelihood Psychometric Function Fitting');
    axes
    hold on

for condswitch = 1:5 %conditions
    
    switch condswitch
        case 1
            disp('BS')
        case 2
            disp('Occluded Peri')
        case 3
            disp('Ctrl/Del Peri')
        case 4
            disp('Occluded Fovea')
        case 5
            disp('Ctrl/Del Fovea')
    end
    
    %Number of positive responses (e.g., 'yes' or 'correct' at each of the
    %   entries of 'StimLevels'
    NumPos = [results(1,:,condswitch) results(2,:,condswitch) results(3,:,condswitch) results(4,:,condswitch) results(5,:,condswitch) results(6,:,condswitch) results(7,:,condswitch)];
    
    %Number of trials at each entry of 'StimLevels'
    OutOfNum = repmat(ntrialseachcond,1, nDotPos);
    
    
    
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
    searchGrid.alpha = -3:.001:3; %PSE
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

legend('BS', 'Occ Peri', 'Ctrl/Del Peri', 'Occ Fov', 'Ctrl/Del Fov', 'Location', 'Southeast');

for condswitch = 1:5
     plot(StimLevelsFineGrain,ProportionCorrectModel(condswitch,:),'-','color',colorpoints(condswitch),'linewidth',2);
end



set(gca, 'fontsize',14);
set(gca, 'Xtick',StimLevels);
axis([min(StimLevels-0.05) max(StimLevels+0.05) 0 1]);
xlabel('Stimulus Intensity'); %change x label to something meaningful :)
ylabel('Proportion of ?'); %change y label to something meaningful :)
plot([-5 5],[0.5 0.5])
plot([0.0 0.0], [0 1], 'LineStyle', '--')