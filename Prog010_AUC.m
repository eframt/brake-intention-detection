% =========================================================================
%
%  Script to generate AUC charts & confusion matrix for all participants
%  
%  
%
% =========================================================================

%% COMPUTES AUC
% INITIALIZE
clear all; close all; clc
format short

%% LOAD DATA

ClassMethod = 'SVM'; % 'SVM', 'LDA'
ResultType = 'ICA'; % 'RAW', 'CAR', 'ICA'
path = pwd;


%%
%figure(1)
for i=1:12
    %load([ruta '\offline\Results\' ClassMethod '\' ResultType '\' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Win path
    load([path '/offline/Results/' ClassMethod '/' ResultType '/' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Linux path
    
    n = 2; % number of classes
    m = length(Folds_PREvsPOS.YEsti);
    Targets = zeros(n, m);
    Outputs = zeros(n, m);

    for j=1:m
       k = Folds_PREvsPOS.YEsti(j);
       l = Folds_PREvsPOS.YTest(j);
       Targets(k,j) = 1;
       Outputs(l,j) = 1;
    end
    
    figure(i)
    plotconfusion(Targets,Outputs)
end