% Psychometric function analysis
% Yulia Revina, NTU, SG

% For every condition [subjectdata(1)] we need to find when comparison was
% rated as denser [subjetdata(3) == 2], for each SF (subjectdata(2))

for sub = 1:9
    addpath(sprintf('C:/Users/HSS/Documents/GitHub/experiments/Data/SUB %d', sub))
end

ntrialseachcond = 40;


%% extract data
conditions = nan(5,ntrialseachcond,5);
tmp = [];
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
        tmp = find((subjectdata(:,2) == j) & (subjectdata(:,1) == i) & subjectdata(:,3) == 2)';
%         conditions(j,:,i) = tmp;
        results(j,1,i) = size(tmp,2);

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
    
    [s, t] = findslope(shape, pa.est)
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

