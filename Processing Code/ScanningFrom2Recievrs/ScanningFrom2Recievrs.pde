import processing.serial.*;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.PrintWriter;
import java.lang.Thread;
import java.util.HashMap;

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
boolean [] running = {
  false, false, false
};//SET TO HOW MANY COM PORTS THERE AREE
int fileCounter = 0;
int currentTime = 0;
int scanDesignator = 0;

void setup() {
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


  if (delay == currentTime && running [0] == false && running [1] == false && running[2] == false) {
    //println("HERE");
    //thread("getScanFromCOM4");
    //thread("getScanFromCOM5");
    thread("getScanFromCOM3");
    fileCounter++;
    delay+=offset;
    
    
    
  }
}



public void getScanFromCOM4() { // implement int to choose which comPort to read From
  
  running[0] = true;
  String COM = "COM4";
  int zeroCounter = 0;
  int x = 0;
  PrintWriter objWriter;
  Serial objSerial;

 // println("Turning on Serial"); 
  objSerial = new Serial(this, COM, 9600);


  try {

    objWriter = new PrintWriter (new File(folderPath.getPath()+ "\\WaveformData" + COM + "-" + millis() + "-" + maxNumOfScans +"-"+ fileCounter +".txt"));
  }
  catch(FileNotFoundException e) {
    println("NO FILE FOUND:"+ COM);
    exit();
    objWriter = createWriter("C:\\Users\\Public\\WaveformData" + COM + "-" + counter + "-" + maxNumOfScans +" "+ fileCounter +".txt");
  }



  for (int numOfScans = 0; numOfScans < maxNumOfScans; numOfScans ++) {

    for (int i = 0; i < CATCONTROLREQUESTON.length; i++) {
      objSerial.write(CATCONTROLREQUESTON[i]); 
     // println(CATCONTROLREQUESTON[i]);
    }
    
    

    boolean messageComplete = false;
    while (messageComplete == false) {
      
      
      while (objSerial.available () >0) {

        char buffer = objSerial.readChar(); 
        if (buffer == 0) {
          if (zeroCounter > 40) {
            

            // Close the port
            for (int i = 0; i < CATCONTROLREQUESTOFF.length; i++) {
              objSerial.write(CATCONTROLREQUESTOFF[i]);
            }
            objSerial.clear(); 
            messageComplete = true;
            //println("DONE");
          }

          zeroCounter++; 
          objWriter.print(buffer);
        } else {
          objWriter.print(buffer); 
          zeroCounter = 0;
        }       
        x++; 
       // println(buffer); 
       // println(x);
      }
    }
  }
  println(millis());
  objWriter.flush(); 
  objWriter.close(); 
  objSerial.stop();
  running[0] = false;
}

public void getScanFromCOM5() { // implement int to choose which comPort to read From
  running[1] = true;
  String COM = "COM5";
  int zeroCounter = 0;
  int x = 0;
  PrintWriter objWriter;
  Serial objSerial;

  //println("Turning on Serial"); 
  objSerial = new Serial(this, COM, 9600);


  try {

    objWriter = new PrintWriter (new File(folderPath.getPath() +"\\WaveformData" + COM + "-" + millis() + "-" + maxNumOfScans +"-"+ fileCounter +".txt"));
  }
  catch(FileNotFoundException e) {
    println("NO FILE FOUND:"+ COM);
    exit();
    objWriter = createWriter("C:\\Users\\Public\\WaveformData" + COM + "-" + counter + "-" + fileCounter +".txt");
  }



  for (int numOfScans = 0; numOfScans < maxNumOfScans; numOfScans ++) {

    for (int i = 0; i < CATCONTROLREQUESTON.length; i++) {
      objSerial.write(CATCONTROLREQUESTON[i]); 
     // println(CATCONTROLREQUESTON[i]);
    }
    
    

    boolean messageComplete = false;
    while (messageComplete == false) {
      
      
      while (objSerial.available () >0) {

        char buffer = objSerial.readChar(); 
        if (buffer == 0) {
          if (zeroCounter > 40) {
            

            // Close the port
            for (int i = 0; i < CATCONTROLREQUESTOFF.length; i++) {
              objSerial.write(CATCONTROLREQUESTOFF[i]);
            }
            objSerial.clear(); 
            messageComplete = true;
           // println("DONE");
          }

          zeroCounter++; 
          objWriter.print(buffer);
        } else {
          objWriter.print(buffer); 
          zeroCounter = 0;
        }       
        x++; 
        //println(buffer); 
       // println(x);
      }
    }
  }
  println(millis());
  objWriter.flush(); 
  objWriter.close(); 
  objSerial.stop();
  running[1] = false;
}

public void getScanFromCOM3() { // implement int to choose which comPort to read From
  running[2] = true;
  String COM = "COM3";
  int zeroCounter = 0;
  int x = 0;
  PrintWriter objWriter;
  Serial objSerial;

 // println("Turning on Serial"); 
  objSerial = new Serial(this, COM, 9600);


  try {

    objWriter = new PrintWriter (new File(folderPath.getPath() + "\\WaveformData" + COM + "-" + millis() + "-" + maxNumOfScans +"-"+ fileCounter +".txt"));
  }
  catch(FileNotFoundException e) {
    println("NO FILE FOUND:"+ COM);
    exit();
    objWriter = createWriter("C:\\Users\\Public\\WaveformData" + COM + "-" + counter + "-" + maxNumOfScans +" "+ fileCounter +".txt");
  }



  for (int numOfScans = 0; numOfScans < maxNumOfScans; numOfScans ++) {

    for (int i = 0; i < CATCONTROLREQUESTON.length; i++) {
      objSerial.write(CATCONTROLREQUESTON[i]); 
     // println(CATCONTROLREQUESTON[i]);
    }
    
    

    boolean messageComplete = false;
    while (messageComplete == false) {
      
      
      while (objSerial.available () >0) {

        char buffer = objSerial.readChar(); 
        if (buffer == 0) {
          if (zeroCounter > 40) {
            

            // Close the port
            for (int i = 0; i < CATCONTROLREQUESTOFF.length; i++) {
              objSerial.write(CATCONTROLREQUESTOFF[i]);
            }
            objSerial.clear(); 
            messageComplete = true;
            //println("DONE");
          }

          zeroCounter++; 
          objWriter.print(buffer);
        } else {
          objWriter.print(buffer); 
          zeroCounter = 0;
        }       
        x++; 
       // println(buffer); 
       // println(x);
      }
    }
  }
  println(millis());
  objWriter.flush(); 
  objWriter.close(); 
  objSerial.stop();
  running[2] = false;
}

void keyPressed(){
 if(key == ' '){
   for(int i = 0; i < running.length; i++){
    while(running[i] == true){
      //wait for each iindividual thread to stop running and then exit the program
 }
 } 
  exit();
}
}
