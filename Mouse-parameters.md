## .csv file
Each mouse parameters are saved in _.csv_ files. Each parameters file is named by the number of the mouse.

![](https://user-images.githubusercontent.com/41677251/43194171-0f018372-9002-11e8-92df-61645a3112da.PNG)

This file is loaded on the press of the "Load Channel Parameters" button in the matlab interface.
Each parameters is identified by its position in the csv table, it is consequently important to always keep the parameters in the same order. 

This file is updated during the acquisition when the user changes the gamma and theta/delta thresholds.

A template of this file is available, named _template.csv_.

## Saving Neuroscope parameters
In the folder containing the parameters .csv file, it is also possible to save the neuroscope parameters files (_amplifier.xml _and _amplifier.nrs_) inside the "Neuroscope" folder, in a folder named like the number of the mouse. This way, the neuroscope layout file will be copied into the current acquisition folder on the press of the "Open Neuroscope" button.