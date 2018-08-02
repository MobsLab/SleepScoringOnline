Here is how the saving path folder looks like just after the acquisition:
![](https://user-images.githubusercontent.com/41677251/43531386-f0f92b60-95af-11e8-80c2-6cbd81d12b19.PNG)

**_processRawData.m_** function performs post-processing.

We kept a way of storing files which allows to execute Sophie.B & Karim.J offline Sleep-Scoring functions as _SleepScoringOBGamma.m_.

Acquisitions are stored in corresponding mice folders.For each one of them, the user have to create a "PostProcessing" subfolder containing the _.xml_ file. 

Once the Parameters File is loaded thanks to _getParams.m_ function, the rest of the script will execute the following functions: 
* _RefSubstraction_multi.m_ : to substract the reference signal to all channels

* _moveFiles.m_ : which creates "Processed" and "DeltaDetection" folders. 

--> Results matrix from Sleep-Scoring and Delta Detections are moved in "DeltaDetection/fires" folder.

--> _digitalin.dat_; _digitalout.dat_;  _analogin.dat_ and _sleepstage.mat_ are stored in "Processed" folder. 

--> _.xml_ file is moved from "PostProcessing" folder to the "Processed" folder. 

* _ndm_lfp_ command is called from Matlab

* Creation of "ChannelsToAnalyse" and "LFPData" folders. _LFP.mat_ files are then generated with _GetLFP.m_ function. 

**Attention: to convert the generated LFP signals in mV, a multiplication by a factor of 0.195e-3 is necessary.** 

Now, here is how processed files should be stored (do not pay attention to _onlinedetection.mat_ and _offlinedetection.mat_ files) :

![](https://user-images.githubusercontent.com/41677251/43531593-66ddc50c-95b0-11e8-85dd-f6f8a08b6265.png)