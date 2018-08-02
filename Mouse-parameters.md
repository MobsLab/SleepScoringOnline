## .csv file
Each mouse parameters are saved in _.csv_ files. Each parameters file is named by the number of the mouse as follow: **_<mouse_number>.csv_**. All parameter files are saved in the "ParamsSouris" folder. 

![](https://user-images.githubusercontent.com/41677251/43194171-0f018372-9002-11e8-92df-61645a3112da.PNG)

This file contains the channel numbers and sleep-scoring thresholds. Each parameter is identified by its position in the csv table, it is consequently important to always keep the parameters in the same order. 
**A template of this file is available, named _template.csv_.**

It is loaded on the press of the "Load Channel Parameters" button in the matlab interface.It is also used for post-processing, for the online simulation UI or for offline/online comparison functions. The function **_getParams.m_** is used to load each parameter in a structure named 'mouse'.

_getParams.m_:
```paramsArray=readtable(file,'Delimiter',';','Format','%s%f');
mouse=struct;
mouse.PFCDeep=paramsArray{5,2};
mouse.PFCSup=paramsArray{4,2};
mouse.Bulb=paramsArray{1,2};
mouse.HPC=paramsArray{2,2};
mouse.Ref=paramsArray{8,2};
name1=strsplit(filename1,'.');
mouse.Number=name1{1};
```
This file is updated during the acquisition when the user changes the gamma and theta/delta thresholds.

## Saving Neuroscope parameters
In the "ParamsSouris" folder containing the parameters .csv files, it is also possible to save the neuroscope parameters files (**_amplifier.xml_** and **_amplifier.nrs_**) inside the "Neuroscope" folder, in a folder named like the number of the mouse. This way, the neuroscope layout file will be copied into the current acquisition folder on the press of the "Open Neuroscope" button.

![](https://user-images.githubusercontent.com/41677251/43527271-7ae69ace-95a6-11e8-8c62-57767373f5e3.png)
