%% GET TRIAL - DATA EFRAIN 
% INITIALIZE
clear all; close all; clc
format short

Subject  = 1; % (1,2,3,...12) 12 participants total
run      = 2; % (1,2) 2 runs for some participants

% _LINUX_ PATH
path = 'experiment_rawdata/';

% _WINDOWS_ PATH
%ruta = 'experiment_rawdata\';

%% LOAD DATA

if(exist ([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '.mat'], 'file'))==2
    load([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run)])
else
    disp('Warning: No experiment file found! Please download at http://efra-mt.com/files/experiment_rawdata.zip');
end

%% CONVERT TO FIELDTRIP FORMAT
% DATA COMPLETE, AF3 y AF4 EOC

% ========================================================================
% NOTE: From subject 5, values of visual stimulus signal must be inverted
% y(42). Also for subject 1 & 4 run 2.
% ========================================================================
if (Subject >= 5) || (Subject == 1 && run == 2) || (Subject == 4 && run == 2)
    y(42,:)=~y(42,:);
end

% Construct DATA structure                       
Data                  = [];
Data.fsample          = 250;
Data.label            = {'FP1';'FP2';'EOC1';'EOC2';'F7';'F3';'FZ';'F4';'F8';'FC5';'FC1';'FC2';'FC6';'T7';'C3';'CZ';'C4';'T8';'CP5';'CP1';'CP2';'CP6';'P7';'P3';'PZ';'P4';'P8';'PO7';'PO3';'PO4';'PO8';'OZ';'BRAKE';'THROTTLE';'LIGHT'};
Data.time             = y(1,:);  % Nchannels x Nsamples
Data.trial            = y([2:33 40:42],:); % 32 EEG Channels + Digital IO (Brake + Throttle + Visual stim)

% subject Info 
SubjectInfo.subject = Subject;
SubjectInfo.run     = run;


%% Save

save([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '_D001'], 'Data', 'SubjectInfo');
