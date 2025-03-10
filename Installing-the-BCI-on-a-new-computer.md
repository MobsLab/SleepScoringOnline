## Mandatory software:
The BCI must be installed on a Windows operating computer, as the Intan RHD2000 Matlab toolbox is not available on Linux and Mac.
* Matlab
* RHD2000 Toolbox (http://intantech.com/RHD2000_matlab_toolbox.html)
* RHD2000 Driver (http://intantech.com/downloads.html)

## Installation procedure:

* Install the RHD2000 drivers
* Install the RHD2000 Matlab toolbox
* Clone the BCI git repository
* launch **_read_continuously.m_**

## Troubleshooting:

* Check that the Intan USB licence key is plugged in.
* Check that the Intan Board is connected to the computer
* Check that the Intan RHD2000 toolbox is in the Matlab path

### In case of a "library not found" error, try installing the following compilers:

* Microsoft SDK
* Visual Studio
* MinGW