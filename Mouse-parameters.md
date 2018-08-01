## .csv file
Each mouse parameters are saved in _.csv_ files. Each parameters file is named by the number of the mouse as follow: _number.csv_.

![](https://user-images.githubusercontent.com/41677251/43194171-0f018372-9002-11e8-92df-61645a3112da.PNG)

This file contains the channel numbers and sleep-scoring thresholds. Each parameter is identified by its position in the csv table, it is consequently important to always keep the parameters in the same order. 
**A template of this file is available, named _template.csv_.**

It is loaded on the press of the "Load Channel Parameters" button in the matlab interface.It is also used for post-processing, for the online simulation UI or for offline/online comparison functions. The function _getParams_ is used to load each parameter in a structure named 'mouse'.

paramsArray=readtable(file,'Delimiter',';','Format','%s%f');
mouse=struct;
mouse.PFCDeep=paramsArray{5,2};
mouse.PFCSup=paramsArray{4,2};
mouse.Bulb=paramsArray{1,2};
mouse.HPC=paramsArray{2,2};
mouse.Ref=paramsArray{8,2};
name1=strsplit(filename1,'.');
mouse.Number=name1{1};

This file is updated during the acquisition when the user changes the gamma and theta/delta thresholds.

## Saving Neuroscope parameters
In the folder containing the parameters .csv file, it is also possible to save the neuroscope parameters files (_amplifier.xml_ and _amplifier.nrs_) inside the "Neuroscope" folder, in a folder named like the number of the mouse. This way, the neuroscope layout file will be copied into the current acquisition folder on the press of the "Open Neuroscope" button.