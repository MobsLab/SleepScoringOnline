## Establishing a link
To establish a link between Matlab and the Arduino board, we use Matlab's serial interface. After selecting the correct COM port number (in Settings=>Devices), we establish a connection using matlab's _fopen_ function.

## Triggering the arduino
To trigger the arduino, we send over the serial link a binary file using **_fwrite_**:

The mode and the sound are sent to the arduino as an integer AB => A is the mode and B is the sound type

`function obj=testArduino(obj)`

`if strcmp(arduino.Status,'open')`

`fwrite(arduino,1*10+obj.sound_tone);`

`end`

`end`

* First byte corresponds to the mode: delay vs no delay and number of stims (1 here)
* Second byte corresponds to the sound tone requested.

## After the trigger
After receiving a trigger, the arduino sends a ttl back to the Intan board's digital out allowing to measure the effective stimulation time, which is processed into **_fires_actual_times.mat_**. The arduino board also triggers the TDT amplifier to generate the stimulation.
 
![](https://user-images.githubusercontent.com/41677251/43640313-c6d726cc-971f-11e8-8d14-f72f570da949.PNG)

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