import processing.serial.*;


int [] CATCONTROLREQUESTON = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01
};
int [] CATCONTROLREQUESTOFF = {
  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};
int [] CATSETCONFIGREQUEST = {//message is 72 bytes long without preamble
  0xA5, 0xA5, 
  0x00, 0x48, //length
  0x20, 0x01, //command
  0x00, 0x01, //message id
  0x00, 0x00, 0x00, 0x65, //node id
  0x01, //transmitMode
  0x00, //antenna mode
  0x00, //code channel defalut 0
  0x20, // gain what we are going to change 
  0x00, //power up mode
  0x20, //unused
  0x20, 0x20, //unused 
  0x00, 0x00, 0x00, 0x00, //number of packets sent before pausing 
  0x00, 0x00, // how many words to transmit 
  0x00, 0x00, //delay between packets
  0x20, 0x20, //unused
  0x07, //acq index
  0x01, //auto thresholding 
  0x11, 0x11, 0x11, 0x11, //manual thresholding  
  0x20, 0x20, 0x20, 0x20, //rx filter
  0x20, 0x20, 0x20, 0x20, //acq pri
  0x20, 0x20, 0x20, 0x20, //acq preamble length
  0x20, //unused
  0x01, //auto integration
  0x20, //data integration index
  0x02, //data type BER 
  0x20, 0x20, 0x20, 0x20, //payload pri
  0x20, 0x20, 0x20, 0x20, //payload duration
  0xff, 0xff, 0xff, 0x14, // scan start -20
  0x00, 0x00, 0x00, 0x50, //scan stop 80
  0x00, 0x20, //step bin size 
  0x01, //scan integration index 
  0x20, 
  0x20, 0x20, 
  0x20, 
  0x00 //persist yes
};

public class Radio {

  private String COM;
  private Serial objSerial;
  private byte [] input;

  Radio(int index) {//uses an index to select which comport to use
    try {
      COM = objSerial.list()[index];
    }   
    catch(ArrayIndexOutOfBoundsException e) {
      println("Radio not connected!!");
    }
  }

  Radio(String com) {//uses a String to select which comport to use
    COM = com;
  }   
  
  public void serialOn(boolean o){
   if (o == true) objSerial = new Serial(new Complete_Automation_Transmitter(), COM, 9600);
   
  }

  public void startTransmitting() {
    for (int i = 0; i < CATCONTROLREQUESTON.length; i++) {
      objSerial.write(CATCONTROLREQUESTON[i]);
    }     
  }

  public void stopTransmitting() {
   
    for (int i = 0; i < CATCONTROLREQUESTOFF.length; i++) {
      objSerial.write(CATCONTROLREQUESTOFF[i]);
    } 
    
  }

  public void changeGain(int g) {
 
    CATSETCONFIGREQUEST [15] = g; //sets the gain in the API structure
    for (int i = 0; i < CATSETCONFIGREQUEST.length; i++) { //writes the new gain to the transmitter
      objSerial.write(CATSETCONFIGREQUEST[i]);
      
      
    }
    
  }
}

