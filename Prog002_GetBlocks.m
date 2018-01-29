%% GET BLOCKS - EFRAIN DATA
% INITIALIZE
clear all; close all; clc
format short

Subject         = 1; %(1,2,3,...12) 12 participants total
run             = 2; %(1,2) 2 runs for some participants
endTrialThres   = 1.5; %Invertal for first trial segmentation in seconds 
trialMinLen     = endTrialThres * 2;
initDelay       = 5; %Remove first initDelay seconds for signal stabilization

% _LINUX_ PATH
path = 'experiment_rawdata/';

% _WINDOWS_ PATH
%path = 'experiment_rawdata\';


%% LOAD DATA

load([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '_D001' '.mat'])

if(exist ([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '_D001' '.mat'], 'file'))==2
    load([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '_D001' '.mat'])
else
    disp('Warning: No data file found! Please run Prog001_GetTrial.m first!');
end


%% BEGIN & END OF EVERY TRIAL. REFERENCE: Start of visual stimulus
% Visual stimulus signal (red light)
VectorLight = Data.trial(35,:);

% Identify moment where red light turned on: Change from 0 to 1 on VectorLight
VectorInicioLight = diff(VectorLight);
VectorInicioLight = [0  VectorInicioLight];
VectorInicioLight(VectorInicioLight<=0) = 0;


%% PLOT FOR DEBUGGING (OPTIONAL)

figure, hold on
plot(Data.time,VectorLight,'r')
%stem(Data.time,VectorFinTrial,'b')
stem(Data.time,VectorInicioLight,'m')
%legend('BRAKE','FinTrial','InicioBrake')


%% GET BEGIN & END INDEXES FOR EVERY TRIAL &
% INDEX WHERE THE VISUAL STIMULUS APPEARED (t0)

IndT0      = find(VectorInicioLight==1);
IndT0_diff = [trialMinLen * Data.fsample diff(IndT0)];

% REMOVE FALSE STIMULI SIGNALS DUE GLITCHES
i=1;
while i < length(IndT0)
   if IndT0_diff(i) < trialMinLen * Data.fsample;
       IndT0_diff(i)  = [];
       IndT0(i)       = [];
       i = i-1;
   end
   i = i+1;
end

IndFin    = IndT0 + (endTrialThres * Data.fsample); %vector with indexes for trial ends
IndIni    = [(IndFin(1) - (initDelay * Data.fsample))  IndFin(1:(end-1))+1]; %vector with indexes for trial starts


%% PLOT FOR DEBUGGING (OPTIONAL)

figure, hold on
plot(Data.time,VectorLight,'k')
stem(Data.time(IndIni),VectorLight(IndIni),'or','MarkerFaceColor','r')
stem(Data.time(IndT0),VectorLight(IndT0),'sg','MarkerFaceColor','g')
stem(Data.time(IndFin),VectorLight(IndFin),'db','MarkerFaceColor','b')
legend('LIGHT SIGNAL','Start','Brake','End')


%% TRIAL GENARATION IN FIELDTRIP FORMAT

DATA.time       = cell(1,length(IndIni));  % Nchannels x Nsamples
DATA.trial      = cell(1,length(IndIni)); 
DATA.label      = Data.label; 
DATA.fsample    = Data.fsample; 

% Get and save every trial
for i=1:length(DATA.trial)
    
    % Get trial data
    DATA.trial{i} = Data.trial(:,IndIni(i):IndFin(i));
    
    % Build time vector: t0 represents the instant where the red light
    % is turned on randomly
    Nsamples  = size(DATA.trial{i},2);
    DATA.time{i} = ((1:1:Nsamples)-(IndT0(i)-IndIni(i)+1))/DATA.fsample;   
    %DATA.time{i}  = Data.time(:,IndIni(i):IndFin(i));
    
end 


%% PLOT FOR DEBUGGING (OPTIONAL)

for i=1:length(DATA.trial)
    
    figure(1), clf
    plot(DATA.time{i},abs(DATA.trial{i}(end,:)/max(abs(DATA.trial{i}(end,:)))),'k','LineWidth',1)
    hold on
    plot(DATA.time{i},DATA.trial{i},'LineWidth',1)    
    xlabel('Time (s)'), ylabel('Amplitude'), title(['Vehicle data Trial' num2str(i)])
    legend()
    grid on
%     set(gca,'Xlim',[-0.5 1])
    
    pause
    
end % for i=1:120


%% SAVE 
save([path 'S' sprintf('%0.3u',Subject) '_R' sprintf('%0.3u',run) '_D002'], 'DATA', 'SubjectInfo', 'endTrialThres')
