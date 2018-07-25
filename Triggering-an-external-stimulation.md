## Sound

The brain computer interface, in its present configuration is focused on Delta wave sound stimulation. It is interfaced with an arduino and a TD amplifier. The arduino is triggered via serial communication, the graphical interface enables the user to select the mode (1 vs 10 shots, delay vs no delay) and the type of sound, each mode and sound characteristics can be changed in the arduino code.

In the graphical interface, the user can also chose a minimum refractory time between stimulations and restrict the stimulations to a certain or multiple sleep stages.

## Triggering something else

It is also possible to use the interface to stimulate during other events such as specific sleep stages. To do so, it is possible to either code an other arduino interface or use the Intan board 8-11 digitalOut pins that correspond to the current sleep stage:
* 8 => NREM
* 9 => REM
* 10 => Wake

From this, it is possible to code an arduino interface between the equipment to be triggered and the Intan.
