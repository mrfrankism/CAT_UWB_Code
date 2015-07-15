import processing.serial.*;
import java.lang.Thread;

int [] CATCONTROLREQUESTON = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01
};
int [] CATCONTROLREQUESTOFF = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};

public class Radio implements Runnable{
 private String COM;
 private boolean running;
 private int maxNumOfScans;
 private Serial objSerial;
 private int currentGainVal;
 private int fileCounter;
 Radio(String com, int n){
  COM = com;
  maxNumOfScans = n;  
 } 
  
  public void setCurrentGain(int g){
   currentGainVal = g; 
   fileCounter = 0;
  }
  public void setNumOfScans(int o){
   maxNumOfScans = o; 
  }
  
  public boolean isRunning(){
   return running; 
  }
  
  public void run(){
    fileCounter++;
   running = true;
  int zeroCounter = 0;
  int x = 0;
  PrintWriter objWriter;
  Serial objSerial;

 // println("Turning on Serial"); 
  objSerial = new Serial(new Complete_Automation_Reciever(), COM, 9600);


  try {

    objWriter = new PrintWriter (new File(folderPath.getPath()+ "\\WaveformData" + COM + "-" + "Gain: "+ currentGainVal + "-" + maxNumOfScans +"-"+ fileCounter +".txt"));
  }
  catch(FileNotFoundException e) {
    println("NO FILE FOUND:"+ COM);
    exit();
    objWriter = createWriter("C:\\Users\\Public\\WaveformData" + COM + "-" + maxNumOfScans +" "+ fileCounter +".txt");
  }



  for (int numOfScans = 0; numOfScans < maxNumOfScans; numOfScans ++) {
println("HERE");
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
  running = false;
  
}
  }
