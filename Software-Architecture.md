
The software is constitued of three main blocks:

*_ read_continuously.m:_ Matlab's automatically generated GUIDE file. Here, we deal with the user interface and saving the results files.

* _boardUI.m: _The boardUI class deals with the communication with the Intan board and manages the board acquisition parameters.

*_ boardPlot.m: _The boardPlot class displays the processed signals and the results of the sleep scoring process.

Two other functions are responsible of the main tasks and called inside //boardPlot.m//:

* _sleepscoring.m:_ The sleep scoring signal processing function and sleep stage determination algorithm.

* _deltaDetection.m: _Delta wave detection algorithm and Arduino triggering.