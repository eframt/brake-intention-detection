% =========================================================================
%
%  Script to apply preprocesing filters like CAR, Laplacian, Band pass
%  filtering, etc.
%  
%
% =========================================================================

%% PREPROCESSING: CAR|LAPLACIAN FILTERING

%Commom average reference filtering
SubjectInfo.Filtering = 'CAR';
% Apply CAR
cfg            = [];
cfg.reref      = 'yes';
cfg.refchannel = 'all';
EEG_CAR  = ft_preprocessing(cfg,EEG_TOT); %Mod on 02-11-17


%% PREPROCESSING: BPF

cfg           = [];
cfg.demean    = 'yes';
cfg.dftfilter = 'yes';
cfg.bpfilter  = 'yes';
cfg.bpfreq    = [1 45];
cfg.dftfreq   = [60 120 180]; 
EEG           = ft_preprocessing(cfg,EEG);
