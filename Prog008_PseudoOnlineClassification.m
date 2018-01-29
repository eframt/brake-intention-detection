%% LOAD DATA (YOU HAVE TO RUN Prog003_ChannelsScript FIRST)

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


%% FEATURE EXTRACTION FOR TRAINING DATA
X_EEG_C1b_nobrake     = [];
X_EEG_C2b_brakeint    = [];
avg_segments  = 10;

% GET AVERAGE OF EEG VALUES IN EACH CONDITION DIVIDED IN X SEGMENTS (avg_segments)
AVG_EEGCond1b = Calculate_ERP(EEG_Cond1b,avg_segments);
AVG_EEGCond2b = Calculate_ERP(EEG_Cond2b,avg_segments);

for i=1:avg_segments
    X_EEG_C1b_nobrake = [X_EEG_C1b_nobrake squeeze(AVG_EEGCond1b.powspctrm(:,:,i))];
    X_EEG_C2b_brakeint = [X_EEG_C2b_brakeint squeeze(AVG_EEGCond2b.powspctrm(:,:,i))];
end

Y_EEG_C1b_nobrake  = ones(length(EEG_Cond1b.trial),1);
Y_EEG_C2b_brakeint = 2*ones(length(EEG_Cond2b.trial),1);


%% GENERATE TIME WINDOWS TO APPLY PSEUDO-ONLINE CLASSIFICATION
YEsti = [];
YEsti_vect = [];
onl_samples = 90;
%trialn = 3;

for i=1:onl_samples
    cfg                 = [];
    cfg.trials          = 'all';
    cfg.toilim          = [(-2*((BrakeIntentMinInterval) * (1/DATA.fsample)) + (.020*i)) (-((BrakeIntentMinInterval) * (1/DATA.fsample)) + .020*i)];
    EEG_Cond1b_vect(i)  = ft_redefinetrial(cfg, EEG_TOT);
    CAR_Cond1b_vect(i)  = ft_redefinetrial(cfg, CAR_TOT);
    
    % Feature extraction
    X_EEG_C1b_tmp{1,onl_samples} = [];
    avg_segments      = 10;

    % GET AVERAGE OF EEG VALUES IN EACH CONDITION DIVIDED IN X SEGMENTS (avg_segments)
    AVG_EEGCond1b_tmp = Calculate_ERP(EEG_Cond1b_vect(i), avg_segments);

    for j=1:avg_segments
        X_EEG_C1b_tmp{i} = [X_EEG_C1b_tmp{i} squeeze(AVG_EEGCond1b_tmp.powspctrm(:,:,j))];
    end
end


%%
v1 = 1:length(Y_EEG_C1b_nobrake);
v1_rand = v1(randperm(length(v1)));

for k=1:length(Y_EEG_C1b_nobrake)
    trialn = k;
    for i=1:onl_samples

        % Training of the classifier
        X_EEG_C1b_nobrake_train = X_EEG_C1b_nobrake;
        X_EEG_C2b_brakeint_train = X_EEG_C2b_brakeint;
        Y_EEG_C1b_nobrake_train = Y_EEG_C1b_nobrake;
        Y_EEG_C2b_brakeint_train = Y_EEG_C2b_brakeint;
        
        X_EEG_C1b_nobrake_train(k,:) = [];
        X_EEG_C2b_brakeint_train(k,:) = [];
        Y_EEG_C1b_nobrake_train(k,:) = [];
        Y_EEG_C2b_brakeint_train(k,:) = [];
        
        XTrain = vertcat(X_EEG_C1b_nobrake_train, X_EEG_C2b_brakeint_train); %Xb_EEG_NOBvsBIN
        YTrain = vertcat(Y_EEG_C1b_nobrake_train, Y_EEG_C2b_brakeint_train); %Yb_EEG_NOBvsBIN

        TrainModel = Compute_ClassificationTrain(XTrain,YTrain,'SVML','NO');

        % Classify the XTest data
        YEsti(i) = Compute_ClassificationApply(X_EEG_C1b_tmp{i}(v1_rand(k),:), TrainModel, 'SVML');
        %t(i) = EEG_Cond1b_tmp.time{1,1}(length(EEG_Cond1b_tmp.time{1,1})); 
    end
    YEsti_vect = [YEsti_vect; YEsti];
end

YTest = 2*ones(1,length(Y_EEG_C1b_nobrake));


%% Plots
figure(1)
t = -(BrakeIntentMinInterval/250):0.02:-(BrakeIntentMinInterval/250)+(1.8-.020);
%t = 0:0.02:(1.5-.02);

meanYEst_vect = mean(YEsti_vect,1);

plot(t,meanYEst_vect)
hold on
stem(mean(BrakeIntentIntervalVect)/250, 2, 'Color','red')


%%
figure(2)
Ycomp = [];
CompAcc = [];

for i=1:onl_samples
   Ycomp = YEsti_vect(:,i)==(YTest'); 
   CompAcc(i) = sum(Ycomp)/length(YTest);
end

plot(t, CompAcc, 'Color', 'black')
hold on
stem(mean(BrakeIntentIntervalVect)/250, 1, 'Color','red')
stem(0, 1, 'Color','green')
stem((mean(BrakeIntentIntervalVect) - std(BrakeIntentIntervalVect))/250, 1, '--r')
stem((mean(BrakeIntentIntervalVect) + std(BrakeIntentIntervalVect))/250, 1, '--r')
xlabel('Time in seconds');
ylabel('Accuracy of the prediction model');
title(['Results for pseudo-online classification for Subject ' num2str(Subject)]); 
legend('Accuracy estimation', 'Avg. braking response +/- std', 'Visual stimulus activation')


%% Save data
%save([path '\YEstimations_S' sprintf('%0.3u', Subject)], 'BrakeIntentMinInterval', 'BrakeIntentIntervalVect', 'DATA', 'EEG_TOT', 'CAR_TOT', 'EEG_Cond1b', 'EEG_Cond2b', 'YEsti_vect', 'meanYEst_vect', 'YTest', 'CAR_Cond1b_vect', 'CompAcc', 'EEG_Cond1b_vect'); %Win path
save([path '/YEstimations_S' sprintf('%0.3u', Subject)], 'BrakeIntentMinInterval', 'BrakeIntentIntervalVect', 'DATA', 'EEG_TOT', 'CAR_TOT', 'EEG_Cond1b', 'EEG_Cond2b', 'YEsti_vect', 'meanYEst_vect', 'YTest', 'CAR_Cond1b_vect', 'CompAcc', 'EEG_Cond1b_vect'); %Linux path
