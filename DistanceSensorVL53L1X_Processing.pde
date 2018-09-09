/*
  DistanceSensorVL53L1X Processing
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
import java.nio.*;
import processing.serial.*;
import controlP5.*;


// constants
ControlP5 cp5;
static final int cr = 13;           // DEC integer value of the carriage return character
static final int lf = 10;           // DEC integer value of the line feed character
static final int tb = 9;            // DEC integer value of the tabulator character
static final int bi = 2;            // number of bytes expected per data value
static final int nv = 1;            // number of expected values per data transmission
static final int nb = bi * nv + 2;  // number of bytes expected per data transmission (handshake + data)


// variables
byte[] offBuffer = new byte[4096];  // buffer for offset correction, maximum size
byte[] inBuffer = new byte[nb];     // buffer for data transmission, data transmission size
int value = 0;                      // single sensor reading


// configure serial port
Serial serialPort = new Serial(this, "COM3", 115200);


// functions
void ONLINE() {
  cp5.getController("ONLINE").setColorForeground(color(255, 0, 0));
  dispose();
}

void RESET() {
  cp5.getController("ONLINE").setColorForeground(color(100, 100, 100));
  cp5.getController("d [mm]").setMax(1000);
}

void receiveSensorData() {

  // wait for data block
  while (serialPort.available() < nb)
    delay(1);

  // correct data offset, look for carriage return character
  serialPort.readBytesUntil(cr, offBuffer);

  // begin data processing, end with line feed character
  serialPort.readBytesUntil(lf, inBuffer);
  value = ByteBuffer.wrap(inBuffer).order(ByteOrder.LITTLE_ENDIAN).getShort(0);
  if (value > cp5.getController("d [mm]").getMax())
    cp5.getController("d [mm]").setMax(value);
  cp5.getController("d [mm]").setValue(value);
  println(value); print(" ");

  // confirm data transmission, return tabulator character
  cp5.getController("ONLINE").setColorForeground(color(0, 255, 0));
  serialPort.write(tb);

}


void setup() {

  while (serialPort.available() > 0)  // clear (pull) read buffer
    serialPort.read();
  serialPort.clear();                 // clear (push) write buffer

  size(750, 250); // canvas size
  background(color(64, 64, 64));

  cp5 = new ControlP5(this);          // constructor

  cp5.addBang("ONLINE")
    .setPosition(50, 50)
    .setSize(50, 50)
    .setColorForeground(color(100, 100, 100));

  cp5.addBang("RESET")
    .setPosition(50, 150)
    .setSize(50, 50)
    .setColorForeground(color(100, 100, 100));

  cp5.addSlider("d [mm]")
    .setPosition(150, 50)
    .setSize(500, 50)
    .setRange(0, 1000)
    .setValue(1)
    .setColorForeground(color(0, 128, 255))
    .setColorBackground(color(128,128,128));

}


void draw() {     // main loop
  receiveSensorData();
}


void dispose() {  // finally
    print("Stopping ...");
    serialPort.stop();
    println(" done.");
}
