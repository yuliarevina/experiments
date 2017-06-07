% Psychometric function analysis
% Yulia Revina, NTU, SG

% For every condition [subjectdata(1)] we need to find when comparison was
% rated as denser [subjetdata(3) == 2], for each SF (subjectdata(2))

conditions = nan(5,10,5);
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


figure; plot(1:5, results(1:5,1,1), 'ro-') %intact
hold on;
plot(1:5, results(1:5,1,2), 'bs-') %BS
plot(1:5, results(1:5,1,3), 'go-') %occl
plot(1:5, results(1:5,1,4), 'kx-') %del sharp
plot(1:5, results(1:5,1,5), 'cx-') %del fuzzy
axis([0.5 5.5 -0.5 10.5])
legend('Intact', 'BS', 'Occl', 'Del Sharp', 'Del Fuzz', 'Location', 'Northwest')
hold off;