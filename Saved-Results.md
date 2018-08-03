## File output

Most of the results files are generated in **_read_continuously.m_**, except for **_digitalout.dat_** which contains the real time hypnogram. 

* Intan TimeStamps 

Saved timestamps are coming from Intan. Matlab function **_read_next.m_** refreshes the _datablock object_ at each datablock. The _datablock object_ is initialized in **_run_button_Callback_** function. 

`handles.datablock = rhd2000.datablock.Datablock(handles.boardUI.Board)`

 Timestamps are continuously refreshed in **_uptade_display.m_** function and recovered in **_newdata_time_** array in **_process_data_block_** function:*

`handles.datablock.read_next(handles.boardUI.Board)`

`newdata_time = datablock.Timestamps` 

### Sleep scoring
Sleep scoring results are stored in **_sleepstage.mat_** which contains the _allresult_ matrix with the following columns:

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
Because the intan outputs the sleep stage in the digitalout 8 to 10 pins, an hypnogram corresponding to the results of the sleep scoring process is stored in **_digitalout.dat_** . This can be used to evaluate the performance of the sleep scoring process during the night, without posterior adjustment of the thresholds. The hypnogram can be obtained with the following bit of code:

`fileinfo = dir('digitalout.dat');`

`num_samples = fileinfo.bytes/2; % uint16 = 2 bytes`

`fid = fopen('digitalout.dat', 'r');`

`hypnogramOnline = fread(fid, num_samples, 'uint16')/256;`

`hypnogramOnline=hypnogramOnline(1:20000:end);`

`fclose(fid);`

`hypnogramOnline(hypnogramOnline==4)=3;`

### Fires and Detection matrix
When Delta Waves detection is activated, two types of timestamps are saved: timestamps corresponding to the detection itself (beginning end ending of delta waves) and the timestames corresponding to fires (sound stimulation sent by the arduino). The lag between these two (the fire and the end of the detection) is approximately 40ms (see "Technical Issues" chapter for more information).

* **_detections_matrix.mat_** contains the timestamps corresponding to the beginning and ending of each detected Delta Wave. This matrix is composed by 12 columns: 
1. **End of Delta Wave** in 0.1 ms
2. **Start of Delta Wave** in 0.1 ms
3. **Delta Wave Duration** in s
4. **Sound Mode**
5. **Delta threshold for detection** in mV
6. **PFC deep prefactor**
7. **PFC deep channel**
8. **PFC sup prefactor**
9. **PFC sup channel**
10. **Filter Status** (1 if activated, 0 otherwise)
11. **Cutoff Frequency** in Hz
12. **Filter Order**

* **_fires_matrix.mat_** contains the timestamps corresponding to all effective stimulations but contains also timestamps corresponding to stimulations that have been avoided because of the stimulation refractory time condition. This matrix is composed by 10 columns:
1. **Fires timestamps** in 0.1 ms
2. **Sound mode**
3. **Delta threshold for detection** in mV
4. **PFC deep prefactor**
5. **PFC deep channel**
6. **PFC sup prefactor**
7. **PFC sup channel**
8. **Filter Status** (1 if activated, 0 otherwise)
9. **Cutoff Frequency** in Hz
10. **Filter Order**

* **_fires_actual_time.mat_** contains the timestamps in 0.1 ms corresponding to all effective stimulations, taking in account the refractory time between two stimulations. 

* **_digin_matrix.mat_** contains the timestamps in 0.1 ms corresponding to 3.3 V pulses sent on any Intan Digital Inputs (from DI1 to DI4) during the acquisition. 
