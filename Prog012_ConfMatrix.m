%% PLOTS CONFUSION MATRICES
% INITIALIZE
clear all; close all; clc
format short


%% LOAD DATA

ClassMethod = 'SVM'; % 'SVM', 'LDA'
ResultType = 'ICA'; % 'RAW', 'CAR', 'CAR-ICA', 'ICA'

% _LINUX_ PATH
%ruta = '/media/efrain/OS/Documents and Settings/efrainpc/Mis documentos/MATLAB/ITESM/Tesis/';

% _WINDOWS_ PATH
ruta = 'C:\Users\efrainpc\Documents\MATLAB\ITESM\Tesis\';


%%

conf_mat = zeros(2,2);

for i=1:12
    %load([ruta 'Results\' ClassMethod '\' ResultType '\' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Win path
    load([ruta '/Results/' ClassMethod '/' ResultType '/' 'S' sprintf('%0.3u', i) '_Performance_Results']); % Linux path
    
    conf_mat = conf_mat + Acc_NOBvsBIN.conf;
end

conf_mat = conf_mat ./ 12;