%% INITIALIZE
clear all; close all; clc
format short

Subject = 1; % (1,2,3,...12) 12 participants total

pathdefinitions

%% LOAD DATA

% _LINUX_ PATH
path = 'experiment_rawdata/';

% _WINDOWS_ PATH
%path = 'experiment_rawdata\';

%== NOTE: Some of the subjects only have 1 run.
if (Subject == 2) || (Subject == 3) || (Subject == 8) || (Subject == 9) || (Subject == 10) || (Subject == 12)
    DATA = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'DATA');
    DATA = DATA.('DATA');
    SubjectInfo = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'SubjectInfo');
    endTrialThres = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'endTrialThres');
else
    DATA1 = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'DATA');
    DATA1 = DATA1.('DATA');
    DATA2 = load([path 'S' sprintf('%0.3u',Subject) '_R002' '_D002' '.mat'], 'DATA');
    DATA2 = DATA2.('DATA');
    SubjectInfo = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'SubjectInfo');
    endTrialThres = load([path 'S' sprintf('%0.3u',Subject) '_R001' '_D002' '.mat'], 'endTrialThres');
end


%% JOIN DATASETS FOR SESSION 1 & 2 (IF APPLICABLE)
if (Subject == 2) || (Subject == 3) || (Subject == 8) || (Subject == 9) || (Subject == 10) || (Subject == 12)
     %DATA = DATA;
else
    cfg = [];
     DATA = ft_appenddata(cfg, DATA1, DATA2);
     DATA.fsample = DATA1.fsample;
end

     
%% APPLY FT_PREPROCESSING TO GENERATE EEG, EOC AND CAR CHANNELS
cfg = []; 
 cfg.channel   = {'EOC1','EOC2'};
 EOC           = ft_preprocessing(cfg,DATA);
 
 cfg = []; 
 cfg.channel    = {'FP1','FP2','F7','F3','FZ','F4','F8','FC5','FC1','FC2','FC6','T7','C3','CZ','C4','T8','CP5','CP1','CP2','CP6','P7','P3','PZ','P4','P8','PO7','PO3','PO4','PO8','OZ'};
 EEG            = ft_preprocessing(cfg,DATA);
 
 cfg = []; 
 cfg.channel    = {'LIGHT','THROTTLE','BRAKE'};
 CAR            = ft_preprocessing(cfg,DATA);
 
 
%% TRIAL SEGMENTATION FOR EEG AND CAR SIGNALS FROM -1.5s TO 1.5s
cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [-1.5 1.5];
EEG_TOT       = ft_redefinetrial(cfg,EEG);
CAR_TOT       = ft_redefinetrial(cfg,CAR);

% == WARNING: SIGNAL CONDITIONING (I.E. CAR OR ICA FILTERING) MUST BE APPLIED BEFORE CONTINUING THIS SCRIPT
% FOR CAR USE: Prog004_CAR_BPF script
% FOR ICA USE: Prog005_CrearLay & Prog006_ICA script

%% FOR CONDITION 1 WE KEEP EEG AND CAR FROM -1.5s TO 0s

cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [-1.5 0.0];
EEG_Cond1       = ft_redefinetrial(cfg,EEG);
CAR_Cond1       = ft_redefinetrial(cfg,CAR);


%% FOR CONDITION 2 WE KEEP WITH EEG AND CAR FROM 0s TO 1.5s

cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [0.0 1.5];
EEG_Cond2       = ft_redefinetrial(cfg, EEG);
CAR_Cond2       = ft_redefinetrial(cfg, CAR);


%% REMOVE TRIALS WITH BRAKE ACTIVATION BEFORE VISUAL STIM (COND1) & TRIALS WHERE USER DIDN'T BRAKE (COND2)

i = 1;
while i <= size(CAR_Cond1.trial,2)
   if sum(CAR_Cond1.trial{1,i}(1,:)) ~= 0
       EEG_Cond1.trial(i)           = [];
       CAR_Cond1.trial(i)           = [];
       EEG_Cond2.trial(i)           = [];
       CAR_Cond2.trial(i)           = [];
       EEG_Cond1.time(i)            = [];
       CAR_Cond1.time(i)            = [];
       EEG_Cond2.time(i)            = [];
       CAR_Cond2.time(i)            = [];
       EEG_Cond1.sampleinfo(i,:)    = [];
       CAR_Cond1.sampleinfo(i,:)    = [];
       EEG_Cond2.sampleinfo(i,:)    = [];
       CAR_Cond2.sampleinfo(i,:)    = [];
       %tambien para la EEG_TOT y CAR_TOT original
       EEG_TOT.trial(i)           = [];
       CAR_TOT.trial(i)           = [];
       EEG_TOT.time(i)            = [];
       CAR_TOT.time(i)            = [];
       EEG_TOT.sampleinfo(i,:)    = [];
       CAR_TOT.sampleinfo(i,:)    = [];
       i = i-1;
   elseif sum(CAR_Cond2.trial{1,i}(1,:)) == 0
       EEG_Cond1.trial(i)           = [];
       CAR_Cond1.trial(i)           = [];
       EEG_Cond2.trial(i)           = [];
       CAR_Cond2.trial(i)           = [];
       EEG_Cond1.time(i)            = [];
       CAR_Cond1.time(i)            = [];
       EEG_Cond2.time(i)            = [];
       CAR_Cond2.time(i)            = [];
       EEG_Cond1.sampleinfo(i,:)    = [];
       CAR_Cond1.sampleinfo(i,:)    = [];
       EEG_Cond2.sampleinfo(i,:)    = [];
       CAR_Cond2.sampleinfo(i,:)    = [];
       %tambien para la EEG_TOT y CAR_TOT original
       EEG_TOT.trial(i)           = [];
       CAR_TOT.trial(i)           = [];
       EEG_TOT.time(i)            = [];
       CAR_TOT.time(i)            = [];
       EEG_TOT.sampleinfo(i,:)    = [];
       CAR_TOT.sampleinfo(i,:)    = [];       
       i = i-1;
   end
   i = i+1;
end


%% DETERMINE FASTEST REACTION TIME TO DEFINE TIME WINDOW OF BRAKE "INTENTION"

BrakeIntentIntervalVect = zeros(1,size(CAR_Cond2.trial,2));
BrakeIntentMinInterval = size(CAR_Cond2.trial{1},2); % Initialize to max time for debugging

for i=1:size(CAR_Cond2.trial,2)
    VectorBrakeLight = CAR_Cond2.trial{1,i}(1,:);
    
    for j=1:length(VectorBrakeLight)
       if(VectorBrakeLight(j) == 1)
           BrakeIntentIntervalVect(i) = j;
           
           if(j < BrakeIntentMinInterval)
               BrakeIntentMinInterval = j;
               FastestTrial = i;
           end
           break
       end
    end
end


%% REMOVE TRIALS WITH SECTIONS SMALLER THAN MIN INTERVAL

i = 1;
while i <= size(CAR_Cond1.trial,2)
    if (endTrialThres.endTrialThres * DATA.fsample - BrakeIntentIntervalVect(i)) < (BrakeIntentMinInterval)
       EEG_Cond1.trial(i)           = [];
       CAR_Cond1.trial(i)           = [];
       EEG_Cond2.trial(i)           = [];
       CAR_Cond2.trial(i)           = [];
       EEG_Cond1.time(i)            = [];
       CAR_Cond1.time(i)            = [];
       EEG_Cond2.time(i)            = [];
       CAR_Cond2.time(i)            = [];
       EEG_Cond1.sampleinfo(i,:)    = [];
       CAR_Cond1.sampleinfo(i,:)    = [];
       EEG_Cond2.sampleinfo(i,:)    = [];
       CAR_Cond2.sampleinfo(i,:)    = [];
       BrakeIntentIntervalVect(i)   = [];
       %tambien para la EEG_TOT y CAR_TOT original
       EEG_TOT.trial(i)           = [];
       CAR_TOT.trial(i)           = [];
       EEG_TOT.time(i)            = [];
       CAR_TOT.time(i)            = [];
       EEG_TOT.sampleinfo(i,:)    = [];
       CAR_TOT.sampleinfo(i,:)    = [];
       i = i - 1;
    end
    i = i + 1;
end


%% FOR CONDITION 1B WE ADJUST THE TIME INTERVAL TO BE THE SAME AS IN BRAKE INTENTION CONDITION

cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [-((BrakeIntentMinInterval) * (1/DATA.fsample)) 0];
EEG_Cond1b       = ft_redefinetrial(cfg, EEG_Cond1);
CAR_Cond1b       = ft_redefinetrial(cfg, CAR_Cond1);


%% FOR CONDITION 2b & 3b WE ALIGN DATA TO RESPONSE TIME & WE DEFINE THE SAME TIME INTERVAL BEFORE AND AFTER BRAKING
% INDIVIDUAL OFFSETS OF EACH TRIAL ARE DEFINED FIRST

cfg             = [];
cfg.trials      = 'all';
cfg.offset       = -(BrakeIntentIntervalVect);
EEG_Cond2_       = ft_redefinetrial(cfg, EEG_Cond2);
CAR_Cond2_       = ft_redefinetrial(cfg, CAR_Cond2);

% ALIGNMENT IS PERFORMED BASED ON THE NEW REFERENCE
% CONDITION 2b

cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [-((BrakeIntentMinInterval) * 1/DATA.fsample) 0];
EEG_Cond2b      = ft_redefinetrial(cfg, EEG_Cond2_);
CAR_Cond2b      = ft_redefinetrial(cfg, CAR_Cond2_);

% CONDITION 3b

cfg             = [];
cfg.trials      = 'all';
cfg.toilim      = [0.0 (BrakeIntentMinInterval) * 1/DATA.fsample];
EEG_Cond3b      = ft_redefinetrial(cfg, EEG_Cond2_);
CAR_Cond3b      = ft_redefinetrial(cfg, CAR_Cond2_);

% == WARNING: TO APPLY OFFLINE CLASSIFICATION CONTINUE WITH THIS SCRIPT AND THEN Prog007_ClassificationScript
% FOR PSEUDO ONLINE CLASSIFICATION CONTINUE WITH: Prog008_PseudoOnlineClassification

%% PLOT EEG 
 
        cfg = [];
        cfg.viewmode = 'vertical';
        cfg.renderer = 'painters';
        %cfg.colorgroups = 'allblack';
        %cfg.linewidth = 200;
        ft_databrowser(cfg,EEG_TOT);
        ft_databrowser(cfg,CAR_TOT);
        
        
%% FEATURE EXTRACTION
%X_EEG_C1 = zeros(length(EEG_Cond1.trial),length(EEG_Cond1.label),10);
X_EEG_C1_prestim      = [];
X_EEG_C2_posstim      = [];
X_EEG_C1b_nobrake     = [];
X_EEG_C2b_brakeint    = [];
X_EEG_C3b_braking     = [];
avg_segments  = 10;

% GET AVERAGE OF EEG VALUES IN EACH CONDITION DIVIDED IN X SEGMENTS (avg_segments)
AVG_EEGCond1 = Calculate_ERP(EEG_Cond1,avg_segments);
AVG_EEGCond2 = Calculate_ERP(EEG_Cond2,avg_segments);
AVG_EEGCond1b = Calculate_ERP(EEG_Cond1b,avg_segments);
AVG_EEGCond2b = Calculate_ERP(EEG_Cond2b,avg_segments);
AVG_EEGCond3b = Calculate_ERP(EEG_Cond3b,avg_segments);

for i=1:avg_segments
    X_EEG_C1_prestim = [X_EEG_C1_prestim squeeze(AVG_EEGCond1.powspctrm(:,:,i))];
    X_EEG_C2_posstim = [X_EEG_C2_posstim squeeze(AVG_EEGCond2.powspctrm(:,:,i))];
    X_EEG_C1b_nobrake = [X_EEG_C1b_nobrake squeeze(AVG_EEGCond1b.powspctrm(:,:,i))];
    X_EEG_C2b_brakeint = [X_EEG_C2b_brakeint squeeze(AVG_EEGCond2b.powspctrm(:,:,i))];
    X_EEG_C3b_braking = [X_EEG_C3b_braking squeeze(AVG_EEGCond3b.powspctrm(:,:,i))];
end

% GENERATING Y VECTORS (CLASS LABELS)
Y_EEG_C1_prestim   = ones(length(EEG_Cond1.trial),1);
Y_EEG_C2_posstim   = 2*ones(length(EEG_Cond2.trial),1);
Y_EEG_C1b_nobrake  = ones(length(EEG_Cond1b.trial),1);
Y_EEG_C2b_brakeint = 2*ones(length(EEG_Cond2b.trial),1);
Y_EEG_C3b_braking  = 3*ones(length(EEG_Cond3b.trial),1);

% GET X & Y MATRICES FOR THE MODEL
X_EEG_PREvsPOS = vertcat(X_EEG_C1_prestim, X_EEG_C2_posstim);
Y_EEG_PREvsPOS = vertcat(Y_EEG_C1_prestim, Y_EEG_C2_posstim);
Xb_EEG_NOBvsBIN = vertcat(X_EEG_C1b_nobrake, X_EEG_C2b_brakeint);
Yb_EEG_NOBvsBIN = vertcat(Y_EEG_C1b_nobrake, Y_EEG_C2b_brakeint);
Xb_EEG_NOBvsBRA = vertcat(X_EEG_C1b_nobrake, X_EEG_C3b_braking);
Yb_EEG_NOBvsBRA = vertcat(Y_EEG_C1b_nobrake, Y_EEG_C3b_braking);
Xb_EEG_BINvsBRA = vertcat(X_EEG_C2b_brakeint, X_EEG_C3b_braking);
Yb_EEG_BINvsBRA = vertcat(Y_EEG_C2b_brakeint, Y_EEG_C3b_braking);


%% SAVE JOINED SESSIONS
save([path 'XY_S' sprintf('%0.3u',Subject)], 'X_EEG_PREvsPOS', 'Xb_EEG_NOBvsBIN','Xb_EEG_NOBvsBRA','Xb_EEG_BINvsBRA','Y_EEG_PREvsPOS','Yb_EEG_NOBvsBIN','Yb_EEG_NOBvsBRA','Yb_EEG_BINvsBRA')
save([path 'BRV_S' sprintf('%0.3u',Subject) '_D002'], 'BrakeIntentIntervalVect')
        