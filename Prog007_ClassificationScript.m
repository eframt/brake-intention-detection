% =========================================================================
%
%  Script to apply offline classification using SVM or LDA classification
%  methods with 10-fold cross validation and generates table of results.
%  
%
% =========================================================================

%% INITIALIZE
clear all; close all; clc
format short

Subject = 1; % (1,2,3,...12)


%% LOAD DATA

ClassMethod = 'SVM'; % 'SVM', 'LDA'
ResultType = 'RAW'; % 'RAW', 'CAR', 'ICA'

% _LINUX_ PATH
if(exist([pwd, '/Results/offline/', ClassMethod, '/', ResultType], 'dir')==7)
    path = [pwd, '/Results/offline/', ClassMethod, '/', ResultType];
else
    mkdir([pwd, '/Results/offline/', ClassMethod, '/', ResultType]);
    path = [pwd, '/Results/offline/', ClassMethod, '/', ResultType];
end
load([pwd '/experiment_rawdata/XY_S' sprintf('%0.3u',Subject)])

% _WINDOWS_ PATH
%if(exist([pwd, '\Results\offline\', ClassMethod, '\', ResultType], 'dir')==7)
%    path = [pwd, '\Results\offline\', ClassMethod, '\', ResultType];
%else
%    mkdir([pwd, '\Results\offline\', ClassMethod, '\', ResultType]);
%    path = [pwd, '\Results\offline\', ClassMethod, '\', ResultType];
%end
%load([pwd '\experiment_rawdata\XY_S' sprintf('%0.3u',Subject)])


%% Apply Classification Algorithm (SVM or LDA)

if(strcmp(ClassMethod,'SVM'))
    [Acc_PREvsPOS, Folds_PREvsPOS] = Compute_ClassificationCrossValidation(X_EEG_PREvsPOS, Y_EEG_PREvsPOS, 10, 'SVML', 'zscore', 'NO');
    [Acc_BINvsBRA, Folds_BINvsBRA] = Compute_ClassificationCrossValidation(Xb_EEG_BINvsBRA, Yb_EEG_BINvsBRA, 10, 'SVML', 'zscore', 'NO');
    [Acc_NOBvsBIN, Folds_NOBvsBIN] = Compute_ClassificationCrossValidation(Xb_EEG_NOBvsBIN, Yb_EEG_NOBvsBIN, 10, 'SVML', 'zscore', 'NO');
    [Acc_NOBvsBRA, Folds_NOBvsBRA] = Compute_ClassificationCrossValidation(Xb_EEG_NOBvsBRA, Yb_EEG_NOBvsBRA, 10, 'SVML', 'zscore', 'NO');
    %[SVM_bal.acc, SVM_bal.folds, SVM_bal.YEsti, SVM_bal.YEsti_RSquare, SVM_bal.YEsti_FScore, SVM_bal.YEsti_CFS]=Compute_ClassificationCrossValidation(Xbal_all, Ybal_all, 10, 'SVM', 'NO', 'NO', [1,2,3,4]);
elseif(strcmp(ClassMethod,'LDA'))
    [Acc_PREvsPOS, Folds_PREvsPOS] = Compute_ClassificationCrossValidation(X_EEG_PREvsPOS, Y_EEG_PREvsPOS, 10, 'LDA', 'zscore', 'NO');
    [Acc_BINvsBRA, Folds_BINvsBRA] = Compute_ClassificationCrossValidation(Xb_EEG_BINvsBRA, Yb_EEG_BINvsBRA, 10, 'LDA', 'zscore', 'NO');
    [Acc_NOBvsBIN, Folds_NOBvsBIN] = Compute_ClassificationCrossValidation(Xb_EEG_NOBvsBIN, Yb_EEG_NOBvsBIN, 10, 'LDA', 'zscore', 'NO');
    [Acc_NOBvsBRA, Folds_NOBvsBRA] = Compute_ClassificationCrossValidation(Xb_EEG_NOBvsBRA, Yb_EEG_NOBvsBRA, 10, 'LDA', 'zscore', 'NO');
else disp('Error: chose a classification method first!')
end


%% RESULTS TABLE
Res_PREvsPOS = horzcat(Acc_PREvsPOS.mean, Acc_PREvsPOS.stde, Acc_PREvsPOS.accu');
Res_BINvsBRA = horzcat(Acc_BINvsBRA.mean, Acc_BINvsBRA.stde, Acc_BINvsBRA.accu');
Res_NOBvsBIN = horzcat(Acc_NOBvsBIN.mean, Acc_NOBvsBIN.stde, Acc_NOBvsBIN.accu');
Res_NOBvsBRA = horzcat(Acc_NOBvsBRA.mean, Acc_NOBvsBRA.stde, Acc_NOBvsBRA.accu');


%% Save results
save([path '/S' sprintf('%0.3u', Subject) '_Results'], 'Res_PREvsPOS', 'Res_BINvsBRA', 'Res_NOBvsBIN', 'Res_NOBvsBRA');
save([path '/S' sprintf('%0.3u', Subject) '_Performance_Results'], 'Acc_PREvsPOS', 'Folds_PREvsPOS', 'Acc_BINvsBRA', 'Folds_BINvsBRA', 'Acc_NOBvsBIN', 'Folds_NOBvsBIN', 'Acc_NOBvsBRA', 'Folds_NOBvsBRA')