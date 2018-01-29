%% 1) CONSTRUCT LAYOUT FILED

% Go to fieldtrip, select a template *.lay file and keep only the
% electrodes of interes in the recording order
load('lay.mat');


%% 2) CREATE THE 2-D LAYOUT OF THE CHANNELS LOCATION

% Prepre layout
cfg                      = [];
cfg.layout                = 'electrodes_lay.lay';
lay                      = ft_prepare_layout(cfg);

% Plot layout
cfg                       = [];
cfg.layout                = lay;
ft_layoutplot(cfg)

% Save layout
save('lay','lay')
