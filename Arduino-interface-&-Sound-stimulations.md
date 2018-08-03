## Principle

The brain computer interface, in its present configuration is focused on Delta wave sound stimulation. It is interfaced with an arduino and a TD amplifier. The arduino is triggered via serial communication, the graphical interface enables the user to select the mode (1 vs 10 shots, delay vs no delay) and the type of sound, each mode and sound characteristics can be changed in the arduino code.

In the graphical interface, the user can also choose a minimum refractory time between stimulations and restrict the stimulations to a certain or multiple sleep stages. The user is also given the possibility to send random triggers.

![](https://user-images.githubusercontent.com/41677251/43528325-fc072612-95a8-11e8-810c-1b46bf0788ae.PNG)

## Establishing a link
To establish a link between Matlab and the Arduino board, we use Matlab's serial interface. After selecting the correct COM port number (in Settings=>Devices), we establish a connection using matlab's _fopen_ function.

## Triggering the arduino
To trigger the arduino, we send over the serial link a binary file using **_fwrite_** in **_BoardPlot.m_** function:

The mode and the sound are sent to the arduino as an integer AB.The decade A (first byte) corresponds to the mode and the unit B (second byte) is the sound type. Here is the little Matlab function which writes in the Arduino board.  

`function obj=testArduino(obj)`

`if strcmp(arduino.Status,'open')`

`fwrite(arduino,1*10+obj.sound_tone);`

`end`

`end`

## After the trigger
After receiving a trigger, the arduino first decodes the number (mode and sount type). Then it does two things: 

* it sends a ttl back to the Intan board's digital out allowing to measure the effective stimulation time, which is processed into **_fires_actual_times.mat_**. Trigger lags measures are presented in the **Technical issues** page. 
* The arduino board also triggers the TDT amplifier to generate the stimulation. We use the TrigIn of the TDT to start generate the stimulation, and we use its Digital Inputs to apply the write sound mode. Here is the complete electric block diagram:
 
![](https://user-images.githubusercontent.com/41677251/43641808-4e12e996-9725-11e8-9d03-ab40f7542165.PNG)

To control different sound modes generation with TDT amplifier, it is interfaced with **RPvdsEx** software. (https://www.tdt.com/files/manuals/RPvdsEx_Manual.pdf) 

![](https://user-images.githubusercontent.com/41677251/43640396-17a0db84-9720-11e8-9179-f4652a1048c0.PNG)

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