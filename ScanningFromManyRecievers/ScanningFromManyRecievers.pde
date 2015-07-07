import processing.serial.*;
import java.io.FileNotFoundException;
import java.lang.IllegalThreadStateException;
import java.io.File;
import java.io.PrintWriter;
import java.lang.Thread;
import java.util.HashMap;
Serial serial;
File folderPath;

int delay = 6;
int offset = delay;
int maxNumOfScans = 2; // MUST BE EQUAL TO THE READERS SCAN VALUE
int counter = 0;
String dir = "C:\\Users\\Public\\TXTs"; //Directory to store the TXTs

int [] CATCONTROLREQUESTON = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01
};
int [] CATCONTROLREQUESTOFF = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};
Radio [] recievers = new Radio[(serial.list()).length];

int fileCounter = 0;
int currentTime = 0;
int scanDesignator = 0;

void setup() {
  for (int i = 0; i < recievers.length; i++) {
    recievers[i] = new Radio(serial.list()[i], maxNumOfScans);
  }

  int x = 0;
  while (new File (dir + "\\set" + x).exists()) {
    x++;
  }
  dir = dir + "\\set" +  x;
  folderPath = new File(dir);
  folderPath.mkdirs();
}

void draw() {
  currentTime = millis()/1000;


  if (delay == currentTime) {
    for (int i = 0; i < recievers.length; i++) {
      new Thread(recievers[i]).start();
   }
    fileCounter++;
    delay += offset;
  }
}

void keyPressed() {
  if (key == ' ') {
    for (int i = 0; i < recievers.length; i++) {

      while (recievers[i].isRunning () == true) {
        //wait for each iindividual thread to stop running and then exit the program
      }
      
    } 
    Converter con = new Converter(dir);
    con.convert();
    exit();
    println("DONE");
  }
}

public void folderSelected(File selection) {
  if (selection == null) {
    println("NO SELECTION MADE");
    exit();
  } else {
    
  }
}

