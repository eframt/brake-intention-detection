# Brake intention detection using brain signals

This MATLAB project was created to discriminate brake intention from normal driving using EEG signals and machine learning techniques. Bioelectrical signals were acquired at 250 Hz with g.Nautilus equipment from g.tech, using 30 EEG and 2 EOG channels. The dataset was constructed with information of 12 healthy subjects (8 males / 4 females) between 25-38 years that conducted real car driving in an low-traffic road. Vehicle signals (brake and gas pedal activation) were acquired using an embedded system (details of this project will be available soon) connected to the OBD port of the car. 

In the experiments, drivers had to drive as they regularly do in accordance with official traffic regulations, but were instucted to apply the brakes whenever a red light located inside the car turned on. Data segmentation and preprocessing is carried out with [Fieldtrip toolbox](http://www.fieldtriptoolbox.org/).

## Getting started

### Prerequisites

First, clone or download this repository to your PC.

```
$ git clone https://github.com/eframt/brake-intention-detection.git
```
Then, download the following files on the master directory before running the scripts:
  - [experiments_rawdata.zip](http://efra-mt.com/files/experiments_rawdata.zip) (contains raw data of experiments)
  - [lib.zip](http://efra-mt.com/files/lib.zip) (contains libraries needed to run the scripts)

```
$ cd brake-intention-detection
$ wget http://efra-mt.com/files/experiments_rawdata.zip
$ wget http://efra-mt.com/files/lib.zip
```
  
Once downloaded, unzip the files in the root directory of this project in order to generate folders with the same name as the zip file.

```
$ unzip experiments_rawdata.zip
$ unzip lib.zip
```

## Running the scripts

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
