## Hypnograms Comparison 
To validate our work, we compared the results of the online sleep scoring against sleep scoring results from the **_sleepScoringOBGamma_** function. The latter are considered to be the ground truth. Post processing codes like **_compareHypnograms_** generate metrics and figures such as balanced accuracy, Cohen's Kappa or a confusion matrix that allow us to measure the accuracy of our process.

From this we can see that accuracy for NREM and Wake is excellent (over 95%), REM accuracy is bit lower, as REM often gets mistaken for NREM sleep (25% of the time).
## Delta Detection Comparison 
