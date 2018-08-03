## Principle

It is also possible to use the interface to stimulate during other events such as specific sleep stages. To do so, it is possible to either code an other arduino interface or use the Intan board 8-10 digitalOut pins that correspond to the current sleep stage:
* 8 => NREM
* 9 => REM
* 10 => Wake

To successfully use the digitalOut pin to trigger the arduino, a [pull up resistor](https://learn.sparkfun.com/tutorials/pull-up-resistors) might be necessary.

From this, it is possible to code a new arduino interface between the equipment to be triggered and the Intan:
![](https://user-images.githubusercontent.com/41677251/43254358-82d299c4-90c7-11e8-8118-0aadf1c78002.PNG)
Above is an example of how the BCI can be used with a custom arduino interface to trigger an optogenetic stimulation on a specific sleep stage.

## Code Example

```int StimPin = 13; // controls the voltage generator
int IsStimOnorOff = 10; // this pin goes from high to low according to whether --> goes to intan 2
int StartStimPin = 11; // sends ttl to intan during stimulation --> goes to intan dig 1
int StartStopRecording = 12; // sends ttl to intan to synchronize recording --> goes to intan dig 0
int StimPinCopy = 9; // controls the voltage generator

//the arduino can stimulate or not
int input = 0; // tracks what matlab has sent
unsigned long soundtime = 0;
unsigned long InterStimTime = 120000; //two minutes between stims * en ms
const int NumStims = 1;
// insert 'random' order here
 int CycleRepeats[NumStims] = {300}; // nmbr de cycles
unsigned long StimRepeatsTps[NumStims] = {50}; // half duty cycle

void setup() {
  Serial.begin(9600);
  randomSeed(analogRead(0));
  pinMode(StimPin, OUTPUT);
  digitalWrite(StimPinCopy, LOW);
  pinMode(StimPinCopy, OUTPUT);
  digitalWrite(StimPin, LOW);
  pinMode(StartStimPin, OUTPUT);
  digitalWrite(StartStimPin, LOW);
  pinMode(StartStopRecording, OUTPUT);
  digitalWrite(StartStopRecording, LOW);
  pinMode(IsStimOnorOff, OUTPUT);
  digitalWrite(IsStimOnorOff, LOW);

}

void loop() {

  if (Serial.available()) {
    input = Serial.read();
    Serial.flush();
  }

  //Start recording
  if (input == 5) {
    digitalWrite(StartStopRecording, HIGH);   // turn the LED on (HIGH is the voltage level)
  }
  //Stop recording
  else if (input == 6) {
    digitalWrite(StartStopRecording, LOW);   // turn the LED on (HIGH is the voltage level)
  }
  else  {
    digitalWrite(IsStimOnorOff, input);   // turn the LED on (HIGH is the voltage level)
  }

  if (digitalRead(IsStimOnorOff) == HIGH) {
    // increment by 1ms
    soundtime = soundtime + 1;
    delay(1);

    if (soundtime > InterStimTime) {
      // choose stimulation
      int WhichStim = (random(0, NumStims));

      // do stimulation
      int rptnum = CycleRepeats[WhichStim];
      unsigned long tpwait = StimRepeatsTps[WhichStim];

      digitalWrite(StartStimPin, HIGH);
      for (int s = 0; s < rptnum ; s++) {
        digitalWrite(StimPin, HIGH);
        digitalWrite(StimPinCopy, HIGH);
        delay(tpwait);
        digitalWrite(StimPin, LOW);
        digitalWrite(StimPinCopy, LOW);
        delay(tpwait);
      }
      digitalWrite(StartStimPin, LOW);

      soundtime = 30 * 1000; // take into account the 30s stimulation
    }

  }
}
```