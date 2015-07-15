import processing.serial.*;


int [] CATCONTROLREQUESTON = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01
};
int [] CATCONTROLREQUESTOFF = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};
int [] CATSETCONFIGREQUEST = {//message is 72 bytes long without preamble
0xA5, 0xA5,
0x00, 0x48,
0x20, 0x01, 
0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 
0x20, //transmit Gain (what we are going to change)
0x20, 
0x20, 
0x20, 
0x20, 
0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 
0x20, 0x20, 
0x20, 0x20, 
0x20, 
0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 
0x20, 
0x20,
0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 
0x20, 0x20, 
0x20,
0x20, 
0x20, 0x20, 
0x20, 
0x20
};

public class Radio{
  
 private String COM;
 private Serial objSerial;
 private byte [] input;
 
 Radio(int index){//uses an index to select which comport to use
  COM = objSerial.list()[index];  
 }   
 
  Radio(String com){//uses a String to select which comport to use
  COM = com;
 }   
 
  public void startTransmitting(){
    objSerial = new Serial(new Complete_Automation_Transmitter(), COM, 9600);
    input = new byte[8];
    boolean messageDone = false;
for(int i = 0; i < CATCONTROLREQUESTON.length; i++){
    objSerial.write(CATCONTROLREQUESTON[i]);
   } 
   while(messageDone == false){// code to recieve errors frrom the p410 device
    while(objSerial.available() > 8){
     objSerial.readBytes(input);
     messageDone = true;
     println(input);//DDEBUUGG
    }
   }
   messageDone = false;
   objSerial.stop();
  }
  
  public void stopTransmitting(){
    objSerial = new Serial(new Complete_Automation_Transmitter(), COM, 9600);
   for(int i = 0; i < CATCONTROLREQUESTOFF.length; i++){
    objSerial.write(CATCONTROLREQUESTOFF[i]);
   } 
   objSerial.stop();
  }
  
  public void changeGain(int g){
     CATSETCONFIGREQUEST [13] = g; //sets the gain in the API structure
  for(int i = 0; i < CATSETCONFIGREQUEST.length; i++){ //writes the new gain to the transmitter
    objSerial.write(CATSETCONFIGREQUEST[i]);
   } 
  }
  
}
