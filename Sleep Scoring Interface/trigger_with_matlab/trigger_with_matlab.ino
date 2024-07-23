
//Stim characteristics
unsigned long FrequencyStim = 10;            // Frequence of the stim


//// Define the pins
int IntanSync_StartStopRecording = 13;  // sends ttl to intan to synchronize recording --> dig 0
int IntanSync_SyncFrames = 12;          // sends ttl to intan to synchronize every 1000 frames --> dig 3

//int IntanNREM=8;   //High if Mouse in NREM sleep
//int IntanREM=7;    //High if Mouse in REM sleep
//int IntanWAKE=6;   //High if Mouse in Wake state
//int IntanWAKETHETA = 5; //High if Mouse in Wake Theta state


// Mouse 1
int StimInMatlab = 11;
int StimPin_Mouse1 = 9;           // controls the voltage generator
int IntanSync_Stim_Mouse1 = 10;   // controls the voltage generator


/////////////////////////////DO NOT MODIFY BELOW ///////////////////////////////


////Intern parameters
int input = 0;            // tracks what matlab has sent
// Stim parameters --> to calculate with the Duration and Frequency of the Stim
unsigned long StimRepeatsTps = 1000/(2*FrequencyStim); // duration in ms of one half cycle 


void setup() {
  Serial.begin(9600);

  randomSeed(analogRead(0));

  //// Start the pins
  pinMode(IntanSync_StartStopRecording, OUTPUT);
  digitalWrite(IntanSync_StartStopRecording, LOW);

  pinMode(IntanSync_SyncFrames, OUTPUT);
  digitalWrite(IntanSync_SyncFrames, LOW);

  pinMode(StimPin_Mouse1, OUTPUT);
  digitalWrite(StimPin_Mouse1, LOW);

  pinMode(IntanSync_Stim_Mouse1, OUTPUT);
  digitalWrite(IntanSync_Stim_Mouse1, LOW);

 
 // pinMode(IntanREM,INPUT);
 // pinMode(IntanNREM,INPUT);
 // pinMode(IntanWAKE,INPUT);
 // pinMode(IntanWAKETHETA,INPUT);
  
  pinMode(StimInMatlab,INPUT);
  
  pinMode(LED_BUILTIN,OUTPUT);
  digitalWrite(LED_BUILTIN,LOW);
}

void loop() {

  // get input from matlab if necessary

  if (Serial.available()) {
    input = Serial.read();
    Serial.flush();
  }


  //Start recording
  if (input == 1) {
    digitalWrite(IntanSync_StartStopRecording, HIGH);
  }
  
  //Stop recording
  else if (input == 3) {
    digitalWrite(IntanSync_StartStopRecording, LOW);
  }
  
  // Every Thousand frames synchronize with intan
  else if (input == 2) {
    digitalWrite(IntanSync_SyncFrames, HIGH);
    delay(5);

    digitalWrite(IntanSync_SyncFrames, LOW);
  }

  while (digitalRead(StimInMatlab) == 1)
  {
    digitalWrite(LED_BUILTIN,HIGH);
    // do stimulation
    digitalWrite(StimPin_Mouse1, HIGH);
    digitalWrite(IntanSync_Stim_Mouse1, HIGH);
    delay(StimRepeatsTps);
    digitalWrite(StimPin_Mouse1, LOW);
    digitalWrite(IntanSync_Stim_Mouse1, LOW);
    delay(StimRepeatsTps);
  }
  digitalWrite(LED_BUILTIN,LOW);
}
 



