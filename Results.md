## File output
### Sleep scoring
Sleep scoring results are stored in _sleepstage.mat_ which contains the _allresult_ matrix with the following columns:

1. **Matlab counter:** Matlab is supposed to iterate every second, it seems that it is not perfectly accurate.
2. **Time:** in seconds, calculated from the Intan timestamps, accurate timestamps for post processing.
3. **Gamma power:** Gamma (50-70 Hz) power in the olfactory bulb calculated on a three second window, used for sleep scoring.
4. **Theta power:** Theta (5-10 Hz) power in the hippocamp calculated on a three second window.
5. **Delta Power:** Delta (2-5 Hz) power in the hippocamp calculated on a three second window.
6. **Theta/Delta:** Calculated on a three second window, used for sleep scoring.
7. **Delta power:** Delta (2-5 Hz) power in the PFCdeep-PFCsup signal.
8. **Number of delta detections in the last second:** Number of delta detected in the last second
9. **Sleep stage**: 1=NREM, 2=REM, 3=Wake
