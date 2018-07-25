## Data acquisition
The data is sent to Matlab by the Intan board by dataBlocks of 60 points, we then average each channel in Matlab. The signal is consequently subsampled from 20.000Hz  to 333,33Hz. The raw, un-subsampled signal is still saved in the selected acquisition directory.
## Sleep Scoring

### Bandpass filtering:

Filter each channel signal using a bandpass filter with the following frequencies:

* Gamma: 50-70Hz
* Theta: 5-10Hz
* Delta: 2-5Hz

These filters are from Matlab's designfilt function, which outputs a FIR filter with the required parameters. We decided to use the maximum order permitted by the size of the signal we were filtering (1/3 of the number of points). The signal length being 1000 points, we settled for an order of 332, which gives satisfactory results.

### Hilbert transform:

Compute the Hilbert transform of the signal and then its modulus which corresponds to the enveloppe of the signal.

### Signal power:

To get the power for each band, we compute the mean value of the enveloppe. We then compute the ratio between the theta power and delta power. To avoid divergences, we use a minimal value threshold for the delta signal, which we empirically set at 0.1.

## Delta detection

### Signal Substraction:

To avoid false positives, the Delta detection process is conducted on the signal resulting from the difference between the deep PFC and superficial PFC signals.

### Filtering:

The signal is filtered using a lowpass filter, the cutoff frequency is set at 8Hz. For this purpose, we use Matlab's butterworth filter at a lower order (between 4 and 8). This choice is motivated by the necessity to limit phase divergence on the edges of the signal. We noticed a strong delay between the raw and filtered signal with higher order filters or with lower cutoff frequencies. Matlab's designfilt FIR filter was also rejected because of these issues. 

### Delta selection:

A duration condition is applied to the delta signal: each delta must last between 50 and 150 milliseconds (these durations can be changed in the interface).