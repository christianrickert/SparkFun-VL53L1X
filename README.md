# SparkFun-DistanceSensorVL53L1X
Demonstration of the SparkFun VL53L1X Distance Sensor

![Screenshot of the graphical user interface](https://github.com/crickert1234/SparkFun-VL53L1X/blob/master/DistanceSensorVL53L1X.png)

## Hardware
* [SparkFun RedBoard - Programmed with Arduino](https://www.sparkfun.com/products/13975)
* [SparkFun Qwiic Shield for Arduino](https://www.sparkfun.com/products/14352)
* [SparkFun Distance Sensor Breakout - 4 Meter, VL53L1X (Qwiic)](https://www.sparkfun.com/products/14722)

## Communication
The connection between the RedBoard and the graphical user interface is realized via virtual COM drivers from [FTDI](http://www.ftdichip.com/Drivers/VCP.htm). The communication is implemented through a custom serial port handshake, i.e. the RedBoard will not record or transmit new data before the previous transmission has been confirmed by the graphical user interface.

## Averaging
The sketch contains a basic Java-class for a circular buffer that can be used as a template for other projects. Previous sensor values are averaged with the help of the circular buffer to calculate the moving average.
