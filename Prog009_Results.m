%% JOINS OFFLINE RESULTS FOR ALL PARTICIPANTS IN ONE TABLE
% INITIALIZE
clear all; close all; clc
format short


%% LOAD DATA

ClassMethod = 'SVM'; % 'SVM', 'LDA'
ResultType = 'ICA'; % 'RAW', 'CAR', 'ICA'
path = pwd;


%% RESULTS TABLE FOR ALL SUBJECTS

BINvsBRA = [];
NOBvsBIN = [];
NOBvsBRA = [];
PREvsPOS = [];

avgBINvsBRA = [];
avgNOBvsBIN = [];
avgNOBvsBRA = [];
avgPREvsPOS = [];

for i=1:12
    %load([path '\offline\Results\' ClassMethod '\' ResultType '\' 'S' sprintf('%0.3u', i) '_Results']); % Win path
    load([path '/offline/Results/' ResultType '/' 'S' sprintf('%0.3u', i) '_Results']); % Linux path
    %load([path '\offline\Results\' ClassMethod '\' ResultType '\' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Win path
    load([path '/offline/Results/' ResultType '/' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Linux path
    BINvsBRA = vertcat(BINvsBRA, Res_BINvsBRA);
    NOBvsBIN = vertcat(NOBvsBIN, Res_NOBvsBIN);
    NOBvsBRA = vertcat(NOBvsBRA, Res_NOBvsBRA);
    PREvsPOS = vertcat(PREvsPOS, Res_PREvsPOS);
end

avgBINvsBRA = BINvsBRA(:,3:12)';
avgNOBvsBIN = NOBvsBIN(:,3:12)';
avgNOBvsBRA = NOBvsBRA(:,3:12)';
avgPREvsPOS = PREvsPOS(:,3:12)';


%% Plot
figure(1)
subplot(2,2,1)
boxplot(avgPREvsPOS);
ylim([0 100])
xlabel('Subject')
ylabel('Accuracy (10-fold CV)')
title('Accuracy Performance (Pre-stimulus vs Pos-stimulus)')

subplot(2,2,2)
boxplot(avgNOBvsBRA);
ylim([0, 100]);
xlabel('Subject')
ylabel('Accuracy (10-fold CV)')
title('Accuracy Performance (No-braking vs Braking)')

subplot(2,2,3)
boxplot(avgBINvsBRA);
ylim([0 100])
xlabel('Subject')
ylabel('Accuracy (10-fold CV)')
title('Accuracy Performance (Brake-intention vs Braking)')

subplot(2,2,4)
boxplot(avgNOBvsBIN);
ylim([0 100])
xlabel('Subject')
ylabel('Accuracy (10-fold CV)')
title('Accuracy Performance (No-brake vs Brake-intention)')

%% Save result tables

%save([path '\offline\Results\' ClassMethod '\' ResultType '\ResultTable'], 'PREvsPOS', 'BINvsBRA', 'NOBvsBIN', 'NOBvsBRA'); % Win path
save([path '/offline/Results/' ResultType '/ResultTable'], 'PREvsPOS', 'BINvsBRA', 'NOBvsBIN', 'NOBvsBRA'); % Linux path
