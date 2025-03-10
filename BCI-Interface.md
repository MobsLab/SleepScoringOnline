The interface is launched by running **_read_continuously.m_** in Matlab, it is organised as displayed below:

![](https://user-images.githubusercontent.com/41677251/43532135-b2dd0f7a-95b1-11e8-91be-222eb78e68aa.PNG)

The interface is divided into two main panels: the left panel is focused on delta detection and sound stimulation and the right panel focused on sleep scoring.

## Delta detection
The detection is performed by **_deltaDetection.m_** Matlab function.
It is done using PFC deep and PFC sup signals. After being substracted (PFC deep - PFC sup), the user can apply a filter on the resulting substracted signal or detect on the unfiltered signal. Deltas are detected based on three criterions: 
* Crossing the threshold 
* Remaining above the threshold for a duration between the minimum and the maximum duration 
* Respecting refractory time between 2 detections. 
All these parameters can be set by the user on the Delta Detection panel. It is also possible to set multiplicative pre-factors for each PFC deep and PFC sup LFP signals. 
Check Pre-Processing chapter in Online Simulation page to see how to to compute optimal values for these parameters to enhance the detection precision. (https://github.com/MobsLab/DeltaFeedBack/wiki/Online-Simulation-Interface).
Check Results page to see how detections timestamps are saved (https://github.com/MobsLab/DeltaFeedBack/wiki/Saved-Results). 


## Sleep scoring
* Sleep scoring is done using the channels set by the user in the parameters file. The user is given the choice of the thresholds.
The phase space displays points corresponding to the last two hours and the trajectory of the last ten points.
The distribution of the gamma power and the theta/delta ratio are plotted on each side. The theta/delta ratio distribution is plotted for all the points (blue distribution) and only for the points below the gamma power threshold (red distribution), allowing for a more accurate setting of the gamma threshold value.
After modifying the threshold, the user can recompute the hypnogram and the statistics by pressing the **_recompute hypnogram_** button.
It is also possible to visualize the transitions between the different sleep stages in a graph by pressing the **_compute transitions_** button.

* In the interface, the displayed hypnogram covers the last hour of recording. It is possible to navigate in the recording using the slider. Just under the hypnogram is displayed the delta density in a 4 seconds window.

* After some time, when the mouse has gone trough the three different sleep stages, it is possible to fit a Gaussian Mixture model on the points. From this Gaussian Mixture model, we can get the posterior probability of the mouse being in each of the three sleep stages at any time.

## Miscelaneous
If a webcam is connected to the computer, a preview is available to check the experimental conditions. A mask is applied to the webcam video feed to restrict it to the area of interest (ie. the cages), this mask can be adjusted in **_boardUI.m_**

It is possible to create a .evt file to open in neuroscope with events at the delta detections.