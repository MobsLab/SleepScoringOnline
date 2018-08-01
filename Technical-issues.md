## Lag

### Internal hard drive

We noticed that when recording on the internal drive, Windows periodically ran background tasks that slowed the execution of the script and created lag. To solve that problem, we started to record on external disk drives which seems to be enough to solve that problem.

### Trigger lag

We also noticed a variable lag between the trigger and the effective emission of the sound, this lag seems to be caused by the different elements of the transmission chain. We did not find any solution to this issue, apart from adding two other controls: the signal from the amplifier to the loudspeaker and a microphone in the experiment box. Both were connected to the Intan AnalogIn input.

![](https://user-images.githubusercontent.com/41677251/43201292-5bb43cee-9018-11e8-9d3d-e95d521be59b.png)![](https://user-images.githubusercontent.com/41677251/43201293-5bcba0a0-9018-11e8-96cb-edef92f8c2a2.png)

These graphs give us a glimpse of the experimental lag between the trigger and the effective emission which was measured between 50 and 150 milliseconds.

## Clock unsynchronization 

We noticed that when using both Matlab's clock and the Intan timestamps, after some time the recordings start to unsynchronize. To answer this problem we decided to use the Intan board Timestamps exclusively, which also makes post processing easier. 

## Noisy signal

If the noise in the signal is quite strong, you can check multiple things:  
* Grounding 
* Faraday cage.
* External hard disk docks, as we noticed that one of these docks was creating a strong background noise when placed in a close radius from the Intan board.