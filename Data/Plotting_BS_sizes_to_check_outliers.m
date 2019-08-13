figure;
hist(BS_size(:,2))

figure;
boxplot(BS_Sizes(:,5))

figure;
boxplot(BS_Sizes(:,2))



figure;
hist(unnamed(:,1),5)

figure;
hist(unnamed(:,2),5)

figure;
hist(unnamed(:,3))

figure;
hist(unnamed(:,4))



figure;
boxplot([unnamed(:,1),unnamed(:,2)])
hold on
plot([6.9294975,4.5604425,7.96848,4.737495], 'go')
% plot([0:5], [19.12 19.12 19.12 19.12 19.12 19.12], 'y')
% plot([0:5], [-5.26173 -5.26173 -5.26173 -5.26173 -5.26173 -5.26173], 'y')
% plot([0:5], [13.025 13.025 13.025 13.025 13.025 13.025], 'c')
% plot([0:5], [0.8333 0.8333 0.8333 0.8333 0.8333 0.8333], 'c')


iqr([unnamed(:,1),unnamed(:,2),unnamed(:,3),unnamed(:,4)])
figure;
boxplot(unnamed(:,2))

figure;
boxplot(unnamed(:,3))

figure;
boxplot(unnamed(:,4))

