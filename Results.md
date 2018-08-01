## File output

Most of the results files are generated in read_continuously.m, except for digitalout.dat which contains the real time hypnogram.

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
9. **Sleep stage**: Current sleep stage, 1=NREM, 2=REM, 3=Wake

### Hypnogram
Because the intan outputs the sleep stage in the digitalout 9 to 11 pins, an hypnogram traducing the results of the sleepscoring process is stored in _digitalout.dat_ . This can be used to evaluate the performance of the sleep scoring process during the night, without posterior adjustment of the thresholds. The hypnogram can be obtained with the following bit of code:

`fileinfo = dir('digitalout.dat');`

`num_samples = fileinfo.bytes/2; % uint16 = 2 bytes`

`fid = fopen('digitalout.dat', 'r');`

`hypnogramOnline = fread(fid, num_samples, 'uint16')/256;`

`hypnogramOnline=hypnogramOnline(1:20000:end);`

`fclose(fid);`

`hypnogramOnline(hypnogramOnline==4)=3;`