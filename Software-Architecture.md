
The software is constitued of three main blocks:

* //__read_continuously.m :__// Matlab's automatically generated GUIDE file. Here, we deal with the user interface and saving the results files.

* //__boardUI.m :__// The boardUI class deals with the communication with the Intan board and manages the board acquisition parameters.

* //__boardPlot.m :__// The boardPlot class displays the processed signals and the results of the sleep scoring process.

Two other functions are responsible of the main tasks and called inside //boardPlot.m//:

* //__sleepscoring.m :__// The sleep scoring signal processing function and sleep stage determination algorithm.

* //__deltaDetection.m :__// Delta wave detection algorithm and Arduino triggering.