% =========================================================================
% Script 
% 
% 
% =========================================================================

%% INITIALIZE
clear all; close all; clc
format short

Fs = 250; % Sampling rate

%% LOAD DATA

path = pwd;


%% Construct Table of mean values from each EEG channel
means = zeros(1,32);
meanTable = [];

for i=1:10
    load([path '/experiment_rawdata/S' sprintf('%0.3u', i) '_R001']);
    
    for j=1:32
        t = y(1,5/Fs:length(y));
        eeg = y(2:33,5/Fs:length(y));
        means(j) = mean(eeg(j,:)); 
    end    
    meanTable = vertcat(meanTable, means);
end
    

%% Plot EEG channels average for all subjects
x = 1:32;
xlabels = {'FP1' , 'FP2' , 'AF3' , 'AF4' , 'F7' , 'F3' , 'FZ' , 'F4' , 'F8' , 'FC5' , 'FC1' , 'FC2' , 'FC6' , 'T7' , 'C3' , 'CZ', 'C4' , 'T8' , 'CP5' , 'CP1' , 'CP2', 'CP6' , 'P7' , 'P3' , 'PZ' , 'P4' , 'P8' , 'PO7' , 'PO3' , 'PO4' , 'PO8' , 'OZ'};
p = plot(x,meanTable(1,:),x,meanTable(2,:),x,meanTable(3,:),x,meanTable(4,:),x,meanTable(5,:),x,meanTable(6,:),x,meanTable(7,:),x,meanTable(8,:),x,meanTable(9,:),x,meanTable(10,:));
legend('Subject 1', 'Subject 2', 'Subject 3', 'Subject 4', 'Subject 5', 'Subject 6', 'Subject 7', 'Subject 8', 'Subject 9', 'Subject 10');
xlabel('Channel');
ylabel('EEG amplitude in uV');
set(gca,'XTick',1:32,'XTickLabel',xlabels);
p(1).Marker = '*';
p(2).Marker = '.';
p(3).Marker = 'o';
p(4).Marker = '+';
p(5).Marker = 'x';
p(6).Marker = 's';
p(7).Marker = 'd';
p(8).Marker = 'v';
p(9).Marker = '^';
p(10).Marker = '<';

%% FFT
Fs = 250;          % Sampling frequency
T = 1/Fs;          % Sample time
%NFFT = [];        % Length of signal
Yeeg = [];
f = [];

for i=1:10
    load([ruta 'S' sprintf('%0.3u', i) '_R001']);
    
    t = y(1,(5*Fs):length(y));
    eeg = y(2:33,5*Fs:length(y));
    
        for j=1:32        
        NFFT = 2^nextpow2(length(eeg)); % Next power of 2 from length of y
        Yeeg{j} = fft(eeg(j,:),NFFT)/(length(eeg));
        f{j} = Fs/2*linspace(0,1,NFFT/2+1);
        
        % Plot single-sided amplitude spectrum.
        subplot(2,5,i)
        plot(f{i},2*abs(Yeeg{i}(1:NFFT/2+1))) 
        title('Single-Sided Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        hold on
        end

end
