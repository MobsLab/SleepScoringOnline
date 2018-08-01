After the experiment, we use the function _processRawData.m_ to do the post-processing.

We kept a way of storing files which allows to execute Sophie.B & Karim.J offline Sleep-Scoring functions as _SleepScoringOBGamma.m_.

Acquisitions are stored in corresponding mice folders. 
For each mouse folder, the user have to create a "PostProcessing" subfolder containing the _.xml_ file. 

Once the Parameters File is loaded thanks to _getParams.m_ function, the rest of the script will execute the following functions: 
* _RefSubstraction_multi.m_ : to substract the reference signal to all channels

* _moveFiles.m_ : which creates "Processed" and "DeltaDetection" folders. 

Results matrix form Sleep-Scoring and Delta Detections are moved in "DeltaDetection/fires" folder.

_digitalin.dat_; _digitalout.dat_, _analogin.dat_ and _sleepstage.mat_ are stored in "Processed" folder. 

Finally, the _.xml_ file is moved from "PostProcessing" folder to the "Processed" folder. 

* _ndm_lfp_ command is then called from matlab 

* "ChannelsToAnalyse" and "LFPData" folders are then created. _LFP.mat_ files are then generated with _GetLFP.m_ function. 