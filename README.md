# brake-intention-detection
Brake intention detection using EEG signals and machine learning

The MATLAB scripts are organized as follows:

- In order to generate Fieltrip trials with EEG and vehicle information, run Prog001_GetTrial, Prog002_GetBlocks and 
Prog003_ChannelsScript.

- Prog004, Prog005_CrearLay and Prog006_ICA are optional in case signal preprocessing is required (i.e. CAR filtering,
ICA decomposition)

- To apply offline classification, after running Prog001_GetTrial, Prog002_GetBlocks and Prog003_ChannelsScript,
run Prog007_ClassificationScript. If you want to plot the results
  for all the participants, run Prog009_Results.
  
- To apply pseudo-online classification, after running Prog001_GetTrial, Prog002_GetBlocks and Prog003_ChannelsScript,
run Prog008_PseudoOnlineClassification.

- Prog010_AUC, Prog011_Statistics and Prog012_ConfMatrix are optional for further analysis like confusion matrices,
boxplot of braking response, etc.
