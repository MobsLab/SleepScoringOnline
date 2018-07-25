## Sleep Scoring

### Bandpass filtering:

Filter each channel signal using a bandpass filter with the following frequencies:

* Gamma: 50-70Hz
* Theta: 5-10Hz
* Delta: 2-5Hz

### Hilbert transform:

Compute the Hilbert transform of the signal and then its modulus which corresponds to the enveloppe of the signal.

### Signal power:

To get the power for each band, we compute the mean value of the enveloppe.

## Delta detection

### Signal Substraction:

To avoid false positives, the Delta detection process is conducted on the signal resulting from the difference between the deep PFC and superficial PFC signals.

### Filtering:

The signal is filtered using a lowpass filter, the cutoff frequency is set at 8Hz.

### Delta selection:

A duration condition is applied to the delta signal: each delta must last between 50 and 150 milliseconds (these durations can be changed in the interface).