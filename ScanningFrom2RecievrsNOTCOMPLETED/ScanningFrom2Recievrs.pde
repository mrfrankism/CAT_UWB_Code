import processing.serial.*;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.PrintWriter;
import java.lang.Thread;
import java.util.HashMap;
Serial serial;
File folderPath;

int delay = 5;
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
  for(int i = 0; i < recievers.length; i++){
   recievers[i] = new Radio(serial.list()[i], maxNumOfScans); 
  }
  
  int x = 0;
  while(new File(dir + "\\set" + x).exists()){
    x++;
  }
  dir = dir + "\\set" +  x;
  folderPath = new File(dir);
  folderPath.mkdirs();
  
 
  try{
  PrintWriter setup = new PrintWriter (new File(dir + "\\SETUP.txt"));
  setup.println(maxNumOfScans);
  setup.flush();
  setup.close();
  }catch(FileNotFoundException e){
   println("Setup File could not be created");
  exit(); 
  }
  
  
}

void draw() {
  currentTime = millis()/1000;


  if (delay == currentTime) {
    for(int i = 0; i < recievers.length; i++){
     recievers[0].startScan();
    }
    fileCounter++;
    delay+=offset;
    
    
    
  }
}

void keyPressed(){
 if(key == ' '){
   for(int i = 0; i < recievers.length; i++){
    while(recievers[i].isRunning() == true){
      //wait for each iindividual thread to stop running and then exit the program
 }
 } 
  exit();
}
}
