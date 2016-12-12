# Crazyflie 2.0 - Custom Firmware

Custom firmware to control the Crazyflie 2.0 nano-copter. 

## Building

`
$ make
`

To deploy the crazyflie: 

* put quadcopter in flash mode (hold pwr button for 3 seconds until blue lights blink) 
* run `make upload`


## Notes


This makefile took a long time to get right - I had to recreate it based on the one from the Crazyflie-firmware repo. Hopefully someone else can use it as a guide later. 
