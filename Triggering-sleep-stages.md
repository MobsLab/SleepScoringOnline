It is also possible to use the interface to stimulate during other events such as specific sleep stages. To do so, it is possible to either code an other arduino interface or use the Intan board 8-10 digitalOut pins that correspond to the current sleep stage:
* 8 => NREM
* 9 => REM
* 10 => Wake

To successfully use the digitalOut pin to trigger the arduino, a [pull up resistor](https://learn.sparkfun.com/tutorials/pull-up-resistors) might be necessary.

From this, it is possible to code a new arduino interface between the equipment to be triggered and the Intan:
![](https://user-images.githubusercontent.com/41677251/43254358-82d299c4-90c7-11e8-8118-0aadf1c78002.PNG)
Above is an example of how the BCI can be used with a custom arduino interface to trigger an optogenetic stimulation on a specific sleep stage.