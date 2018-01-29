%% COMPUTES BOX PLOTS FOR BRAKE REACTION TIMES
% INITIALIZE
clear all; close all; clc
format short


%% LOAD DATA

% _LINUX_ PATH
path = 'experiment_rawdata/';

% _WINDOWS_ PATH
%path = 'experiment_rawdata\';


%% GENERATION OF REACTION TIMES
BRV = [];
SJT = [];

load([path 'BRV_S001_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S002_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 2*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S003_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 3*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S004_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 4*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S005_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 5*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S006_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 6*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S007_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 7*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S008_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 8*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S009_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 9*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S010_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 10*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S011_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 11*ones(1, length(BrakeIntentIntervalVect))];
load([path 'BRV_S012_D002'])
BRV = [BRV BrakeIntentIntervalVect];
SJT = [SJT 12*ones(1, length(BrakeIntentIntervalVect))];


%%
BrakeResponseTimeVect = (BRV - 1) * 1/250;
avg = mean(BrakeResponseTimeVect);
std_dev = std(BrakeResponseTimeVect);
minT = min(BrakeResponseTimeVect);
maxT = max(BrakeResponseTimeVect);

boxplot(BrakeResponseTimeVect, SJT)
ylim([0 1.5])
xlabel('Subject')
ylabel('Braking response in sec')
title('Braking response times for all subjects')