/*
  DistanceSensorVL53L1X Arduino
  Copyright (C) 2018  Christian Rickert

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program; if not, write to the Free Software Foundation, Inc.,
  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


// imports
#include <SparkFun_VL53L1X_Arduino_Library.h>
#include <vl53l1_register_map.h>
#include <Wire.h>


// constants
VL53L1X sensor;
const byte c = 1;       // number of bytes per char/int
const byte i = 2;       // number of bytes per int


// type definitions
typedef union {
  char asByte[c];
  char asChar;
  char asInt;
} character;
character sign;         // for serial handshaking

typedef union {
  byte asByte[i];
  int asInt;
} integer;
integer number;         // for serial transmission

// variables
int value = 0;          // sensor reading [mm]


void setup() {

  // configure I2C
  Wire.begin();
  Wire.setClock(400000)          // fast mode, standard: 100k
  
  // configure sensor
  sensor.begin();

  // configure serial port
  Serial.begin(115200);
  while (Serial.available())     // clear (pull) read buffer
    Serial.read();
  Serial.flush();                // clear (push) write buffer

}


void loop() {

  while (not sensor.newDataReady())
    delay(1);

  // read sensor value from memory
  value = sensor.getDistance();

  // begin of data transmission
  sign.asChar = '\r';
  Serial.write(sign.asByte, c);

  // perform data transmission
  number.asInt = value;
  Serial.write(number.asByte, i);

  // end of data transmission
  sign.asChar = '\n';
  Serial.write(sign.asByte, c);
  Serial.flush();                             // wait for outgoing transmission

  // waiting for response
  while (Serial.available() < c)
    delay(1);

  // fetching response, do nothing
  if (Serial.read() == sign.asInt);
    // do nothing

}
