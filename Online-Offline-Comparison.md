## Hypnograms Comparison 
To validate our work, we compared the results of the online sleep scoring against sleep scoring results from the **_sleepScoringOBGamma.m_** function. The latter are considered to be the ground truth. Post processing codes like **_compareHypnograms.m_** generate metrics and figures such as balanced accuracy, Cohen's Kappa or a confusion matrix that allow us to measure the accuracy of our process.

![](https://user-images.githubusercontent.com/41677251/43653100-5be594fc-9747-11e8-87f6-5bb44298b499.png)

From this we can see that accuracy for NREM and Wake is excellent (over 95%), REM accuracy is bit lower, as REM often gets mistaken for NREM sleep (25% of the time). This can be explained by multiple reasons:
* Because of the post processing on offline sleep scoring results like concatenating close short intervals or dropping sub 3 seconds intervals.
* The value of the Theta/Delta threshold also has an important effect on this: we computed a ROC curve and realised that it is possible to get close to 100% accuracy on REM sleep by setting a lower T/D ratio. However it comes at the expense of accuracy on NREM sleep.

## Delta Detection Comparison 

We also compared results of online vs offline delta detection algorithms. 

**_compare_detections.m_** function generates comparisons figures between any detection matrix generated with _read_continuously.m_, _SleepScoring_Simulation.m_ or _CreateDeltaWavesOffline.m_ functions.
This comparison function computes different statistics to compare detections:

* **_f1 score_**, which takes in account both precision and recall probabilities.
* Online and Offline inter duration between Delta Waves distributions. 
* Online and Offline Delta Waves duration distributions. 
* Cross_correlation between online and offline detections.

It is also possible to mean these results with several nights. 

![](https://user-images.githubusercontent.com/41677251/43653526-a10a86cc-9748-11e8-8453-c024a9905dba.png)
 