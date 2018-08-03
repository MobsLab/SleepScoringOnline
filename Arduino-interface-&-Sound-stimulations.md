## Principle

The brain computer interface, in its present configuration is focused on Delta wave sound stimulation. It is interfaced with an arduino and a TD amplifier. The arduino is triggered via serial communication, the graphical interface enables the user to select the mode and the type of sound, each mode and sound characteristics can be changed in the arduino code.

Four modes are available:
* mode 0, no sound
* mode 1, 1 shot
* mode 2, 10 shots
* mode 3, 1 delayed shot 
* mode 4, 10 delayed shots

Two sound modes are available
* sound_mode 0, Tone sound 
* sound_mode 1, Gaussian sound

In the graphical interface, the user can also choose a minimum refractory time between stimulations and restrict the stimulations to a certain or multiple sleep stages. The user is also given the possibility to send random triggers.

![](https://user-images.githubusercontent.com/41677251/43528325-fc072612-95a8-11e8-810c-1b46bf0788ae.PNG)

## Establishing a link
To establish a link between Matlab and the Arduino board, we use Matlab's serial interface. After selecting the correct COM port number (in Settings=>Devices), we establish a connection using matlab's **_fopen_** function.

## Triggering the arduino
To trigger the arduino, we send over the serial link a binary file using **_fwrite_** in **_BoardPlot.m_** function:

**The mode and the sound are sent to the arduino as an integer AB.The decade A (first byte) corresponds to the mode and the unit B (second byte) is the sound type.** Here is the little Matlab function which writes these twoe bytes in the Arduino board.  

`function obj=testArduino(obj)`

`if strcmp(arduino.Status,'open')`

`fwrite(arduino,1*10+obj.sound_tone);`

`end`

`end`

## After the trigger
After receiving a trigger, the arduino **_DeltaTone_Last_** program first decodes the number sent by Matlab (mode and sound type). Then it does three things: 

* Serial communication is flushed to be ready to receive the next trigger. 

* It sends a ttl back to the Intan board's digital out allowing to measure the effective stimulation time, which is processed into **_fires_actual_times.mat_**. Trigger lags measures are presented in the **Technical issues** page. 

* Finally, Arduino board triggers the TDT amplifier to generate the stimulation. We use the **TrigIn** of the TDT to start the stimulation generation, and we send different bytes combinations to its Digital Inputs to apply the write sound mode. 

Software manual: (https://www.tdt.com/files/manuals/RPvdsEx_Manual.pdf)
TDT amplifier real time processor manual: (https://www.tdt.com/files/manuals/Sys3Manual/RP21.pdf)

Here is the complete electric block diagram:
 
![](https://user-images.githubusercontent.com/41677251/43641808-4e12e996-9725-11e8-9d03-ab40f7542165.PNG)

The HDMI numbers were chosen to match with Delock terminal block Adaptator ones (https://www.delock.de/produkte/694_Terminalblock/65318/merkmale.html?setLanguage=en). This adaptator is connected to  the amplifier Digital Input/Output DB-25 Interface. It allows us to select the pins corresponding to Digital Inputs in the connector. 

Here is the pin vs DI/O corresponding table taken from the manual:

![](https://user-images.githubusercontent.com/41677251/43648434-ac9c1ba8-973a-11e8-8a50-b5770b3e7931.png) 

To control different sound modes generation with TDT amplifier, it is interfaced with **RPvdsEx** software. This software offers the possibility to control the TDT processor in order to manipulate TDT Digital Inputs in real time. 

Here the program that we compiled on TDT amplifier for our use:

![](https://user-images.githubusercontent.com/41677251/43640396-17a0db84-9720-11e8-9179-f4652a1048c0.PNG)

TDT Digital Inputs are represented by **_BitIn_** boxes. The M value inside the box corresponds to the Digital Input binary number:

* M = 1 corresponds to DI0

* M = 2 corresponds to DI1

* M = 4 corresponds to DI2

* M = 8 corresponds to DI3

The **_FromBits_** box combines all the bytes to make an integer output which will sent to the multiplexer (**_MuxIn_** box). The multiplexer will select the entry (Tone or Gaussian Noise) corresponding to this value.  Arduino DO 30 triggers threw the BNC wire the sending of the selected sound to the speaker.  
 
## Code example

 ```void loop(){
  // ---------------------------------------------------------------------------
  // receive MATLAB information, send tone trigger to TDT, and TTL to Intan Device
  // ---------------------------------------------------------------------------
  if (Serial.available() >0){
    order=Serial.read();
    if(order>=00 && order<70){
      sound=order%10;// sound is the unit of the serial reading
      order=order/10;// order is the decade of the serial reading
    }
    Serial.flush(); 
    //--------------------------------------------------------------------------
    // mode 1: direct tone
    //--------------------------------------------------------------------------
    if (sound==0) { // select tone mode
      digitalWrite(24,LOW);
      digitalWrite(28,LOW);
      }
    if(sound==1) {
      digitalWrite(24,LOW);
      digitalWrite(28,HIGH);
    }
    if (order==1){
    
    digitalWrite(27,HIGH);    //Intan event      
    delay(10);
    digitalWrite(27,LOW);
        
    digitalWrite(30,HIGH);    //TDT
    delay(10);
    digitalWrite(30,LOW);
    
    digitalWrite(22,HIGH);    //Trigger digital
    delay(10);
    digitalWrite(22,LOW);} 
 ```