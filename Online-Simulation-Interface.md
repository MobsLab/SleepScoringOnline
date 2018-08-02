As we were developing the BCI, we found it necessary to develop another User Interface which simulates Intan live acquisition from recorded LFP signals, and which performs Sleep Scoring and Delta Detection. It allowed us to test our algorithm, without having to do a recording session. As the Online Simulation Interface generates Delta detections matrix, we were also able to compare these results with offline detections (check the next chapter to see these comparisons).

Here is how the Interface looks like:
![](https://user-images.githubusercontent.com/41677251/43520501-5d61e746-9593-11e8-97c0-b8249fc95ddf.png)

A timer object calls Update_Display Callback function, in which other
Tool Functions are called to update data, perform treatments and display results.