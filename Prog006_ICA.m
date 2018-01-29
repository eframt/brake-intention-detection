% =========================================================================
%
%  Script to apply ICA decomposition on EEG data
%  Use it with EEG dataset before or after segmentation
%  
%
% =========================================================================

%% COMPUTE ICA

cfg                 = [];
cfg.method          = 'runica';
comp                = ft_componentanalysis(cfg,EEG_TOT); % Modify EEG var accordingly


%% Plot time course

cfg          = [];
cfg.layout   = lay;
cfg.viewmode = 'component';
%cfg.gradscale = 1000;
%cfg.zscale   = [-10 10];
% cfg.comp     = [4 5 12 14 17 25 26 28 31 33];
ft_databrowser(cfg, comp);


%% VIZUALIZE CHARACTERISTICS OF THE COMPONENTS
for i=1:size(comp.topo,2) % for i=1:comp.cfg.numcomponent %size(comp.topo,2)
    
    close all
    
    % 1) -------------------------------
    % Plot topographycal map
    cfg                = [];
    
    cfg.component      = i;
    cfg.layout         = lay;
    cfg.comment        = 'no';
    cfg.marker         = 'labels';
    cfg.colorbar       = 'yes';
    cfg.markerfontsize =  10;
    cfg.zlim           = 'maxmin';
    %figure;ft_topoplotIC(cfg,comp); set(gcf,'Position',[15 758 670 323])
    cfg.zlim='maxabs';figure;ft_topoplotIC(cfg,comp); %set(gcf,'Position',[15 758 319 323])
    cfg.zlim='maxmin';figure;ft_topoplotIC(cfg,comp); %set(gcf,'Position',[348 758 337 323])
    
    pause
    
end % for i=1:size(comp.topo,2) % for i=1:comp.cfg.numcomponent %size(comp.topo,2)


%% RECONSTRUCT THE DATA REMOVING ARTIFACTUAL COMPONENTS

%DataICA.ComponentsToRemove = [1 3 4 5 8 9 10 12 15 21]; %S1
%DataICA.ComponentsToRemove = [2 4 5 7 8 9 11 16 19]; %S2
%DataICA.ComponentsToRemove = [1 2 3 5 7 11 15 17 16 18 20 23 26 27 29]; %S3
%DataICA.ComponentsToRemove = [1 2 4 6 7 8 10 11 15 19 28 30]; %S4
DataICA.ComponentsToRemove = [1 4 7 10 11 12 15 18 22 26 27 28 29 30]; %S5
%DataICA.ComponentsToRemove = [1 2 3 5 6 8 9 15 18 20 25 27 30]; %S6
%DataICA.ComponentsToRemove = [1 3 4 8 9 10 11 13 14 15 20 24 26 27 29 30]; %S7
%DataICA.ComponentsToRemove = [1 4 5 9 11 13 14 19 23]; %S8
%DataICA.ComponentsToRemove = [9 10 11 19]; %S9
%DataICA.ComponentsToRemove = [1 2 3 7 8 11 12 13 15 16 18 21 26 30]; %S10
%DataICA.ComponentsToRemove = [1 3 5 8 13 15 22 25 30]; %S11
%DataICA.ComponentsToRemove = [1 2 3 5 6 7 8 9 12 13 16 1720 21 24 25 27]; %12

cfg           = [];
cfg.component = [DataICA.ComponentsToRemove];
EEGafterica   = ft_rejectcomponent(cfg, comp);


%% CONFIGURATION FOR ICA FILTERING
    cfg.artfctdef.eog            = [];
    cfg.artfctdef.eog.bpfilter   = 'yes';
    cfg.artfctdef.eog.bpfilttype = 'but';
    cfg.artfctdef.eog.bpfreq     = [1 15];
    cfg.artfctdef.eog.bpfiltord  = 4;
    cfg.artfctdef.eog.hilbert    = 'yes';
    cfg.trl                      = cfg.trl;
    cfg.continuous               = 'yes';
    
    cfg.artfctdef.eog.channel      = 'all'; %Nx1 cell-array with selection of channels, see FT_CHANNELSELECTION for details
    cfg.artfctdef.eog.cutoff       = 4; %z-value at which to threshold (default = 4)
    cfg.artfctdef.eog.trlpadding   = -0.1;
    cfg.artfctdef.eog.fltpadding   = 0.1;
    cfg.artfctdef.eog.artpadding   = 0.1;
    [cfg, artifact]              = ft_artifact_eog(cfg, seg_data);    

    
%%    
    cfg.artfctdef.reject          = 'partial';
    data2 = ft_rejectartifact(cfg, seg_data);
