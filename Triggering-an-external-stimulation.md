## Sound

The brain computer interface, in its present configuration is focused on Delta wave sound stimulation. It is interfaced with an arduino and a TD amplifier. The arduino is triggered via serial communication, the graphical interface enables the user to select the mode (1 vs 10 shots, delay vs no delay) and the type of sound, each mode and sound characteristics can be changed in the arduino code.

In the graphical interface, the user can also chose a minimum refractory time between stimulations and restrict the stimulations to a certain or multiple sleep stages. The user is also given the possibility to send random triggers.
![](https://user-images.githubusercontent.com/41677251/43528325-fc072612-95a8-11e8-810c-1b46bf0788ae.PNG)
## Triggering something else

It is also possible to use the interface to stimulate during other events such as specific sleep stages. To do so, it is possible to either code an other arduino interface or use the Intan board 8-10 digitalOut pins that correspond to the current sleep stage:
* 8 => NREM
* 9 => REM
* 10 => Wake

To successfully use the digitalOut pin to trigger the arduino, a [pull up resistor](https://learn.sparkfun.com/tutorials/pull-up-resistors) might be necessary.

From this, it is possible to code an arduino interface between the equipment to be triggered and the Intan:
![](https://user-images.githubusercontent.com/41677251/43254358-82d299c4-90c7-11e8-8118-0aadf1c78002.PNG)
Above is an example of how the BCI can be used with a custom arduino interface to trigger an optogenetic stimulation on a specific sleep stage.