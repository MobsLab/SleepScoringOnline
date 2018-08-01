## 1. BCI Interface
![](https://user-images.githubusercontent.com/41677251/43193330-0df91334-9000-11e8-83e9-621514abfa70.PNG)
The software is constitued of three main blocks:

* _read_continuously.m:_ Matlab's automatically generated GUIDE file. Here, we deal with the user interface and saving the results files.

* _boardUI.m:_ The boardUI class deals with the communication with the Intan board and manages the board acquisition parameters.

* _boardPlot.m:_ The boardPlot class displays the processed signals and the results of the sleep scoring process.

Two other functions are responsible of the main tasks and called inside //boardPlot.m//:

* _sleepscoring.m:_ The sleep scoring signal processing function and sleep stage determination algorithm.

* _deltaDetection.m:_ Delta wave detection algorithm and Arduino triggering.

## 2. Online Simulation Interface

![](https://user-images.githubusercontent.com/41677251/43524149-cb569a02-959e-11e8-8704-a132ff567805.png)
