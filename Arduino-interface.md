## Establishing a link
To establish a link between Matlab and the Arduino board, we use Matlab's serial interface. After selecting the correct COM port number (in Settings=>Devices), we establish a connection using matlab's _fopen_ function.

## Triggering the arduino
To trigger the arduino, we send over the serial link a binary file using _fwrite_:
* First byte corresponds to the mode: delay vs no delay and number of stims
* Second byte corresponds to the sound tone requested.

## After the trigger
After receiving a trigger, the arduino sends a ttl back to the Intan board's digital out allowing to measure the effective stimulation time, which is processed into _fires_actual_times.mat_. The arduino board also triggers the TDT amplifier to generate the stimulation. 



