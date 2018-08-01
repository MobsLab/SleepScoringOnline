## 1. BCI Interface
![](https://user-images.githubusercontent.com/41677251/43193330-0df91334-9000-11e8-83e9-621514abfa70.PNG)
The software is constitued of three main blocks:

* _read_continuously.m:_ Matlab's automatically generated GUIDE file. Here, we deal with the user interface and saving the results files. This is the function where all the interface is defined and all the button functions are defined. To edit the interface, type _guide_ in Matlab's command prompt and open _read_continuously.fig_. Each button is associated with a _Callback_ function which will interact with Matlab variables. This is also the function where the results files are defined and prepared for saving in the _stop_button_Callback_ function. The saved Intan files are chosen in the _start_saving_ function.

* _boardUI.m:_ The boardUI class deals with the communication with the Intan board and manages the board acquisition parameters. BoardUI is setting up the RHD2000 board interface at startup. The _webcamInit_ and _refreshWebcam_ functions deal with the video feed from the webcam. _SetDigitalOutput_ is used to set the digital outputs of the Intan board when the mouse is in a defined sleep stage, this is used to trigger external instruments.

* _boardPlot.m:_ The boardPlot class displays the processed signals and the results of the sleep scoring process. All the processing is done inside this function. We store the signals prior to displaying and we process them prior to sending to the _sleepscoring_ and _deltadetection_ functions.

Two other functions are responsible of the main tasks and called inside //boardPlot.m//:

* _sleepscoring.m:_ The sleep scoring signal processing function and sleep stage determination algorithm.

* _deltaDetection.m:_ Delta wave detection algorithm and Arduino triggering.

## 2. Online Simulation Interface

![](https://user-images.githubusercontent.com/41677251/43524149-cb569a02-959e-11e8-8704-a132ff567805.png)
![](https://user-images.githubusercontent.com/41677251/43524489-bc1eb8f2-959f-11e8-8b52-90ca7a7f9a4c.png)