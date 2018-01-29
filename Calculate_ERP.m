function [featuretmp] = Calculate_ERP(DataTmp, NumSampleVentana)

% select trials of interest
% tmpcfg = [];
% tmpcfg.trials = cfg.trials;
% tmpcfg.channel = cfg.channel;
% data = ft_selectdata(tmpcfg, data);

% % restore the provenance information
% [cfg, data] = rollback_provenance(cfg, data);

ntrials = numel(DataTmp.trial); %103
nlabels = numel(DataTmp.label); %30
Gran_tabla =zeros(ntrials,nlabels,NumSampleVentana);

tamano_trial = length(DataTmp.time{1});
tamano_ventana = tamano_trial/NumSampleVentana ; 
tamano_ventana = round(tamano_ventana);
trial_window = zeros(1:NumSampleVentana);

for i = 1:ntrials
    tmp_trial = DataTmp.trial{i}; % 30 x 376
    
    for l = 1:nlabels
        label_tmp = tmp_trial(l,:); % 1 x 376
           
        for n = 1:NumSampleVentana
            if (n < NumSampleVentana)
                trial_window(n) = mean(label_tmp(((n-1)*tamano_ventana+1):tamano_ventana*n));  
                Gran_tabla(i,l,n) = trial_window(n);
            
            elseif (n == NumSampleVentana)
                trial_window(n) = mean(label_tmp(((n-1)*tamano_ventana+1):end)); 
                Gran_tabla(i,l,n)= trial_window(n);
                
            end
        end
    end
end
 
 featuretmp = [];
 featuretmp.label = DataTmp.label;
 featuretmp.freq =  [1:NumSampleVentana] ; 
 featuretmp.powspctrm = Gran_tabla ;
 featuretmp.cfg = DataTmp.cfg ;
 featuretmp.dimord = 'rpt_chan_freq' ; 
end 
    