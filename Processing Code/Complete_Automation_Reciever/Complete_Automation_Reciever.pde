/*

 This code is going to automate the process of recording scans 
 from a p410 uwb device at different transmit gain settings
 
 Set up a client and a server one will be the transmitter and the other will be the reciever
 
 will need two programs one to run the reciever and the other to run the transmitter
 
 */
import processing.serial.*;
import processing.net.*;
Client client;
Server myServer;
Serial serial;

File folderPath;


//Radio [] recievers = new Radio[(serial.list()).length];
//String [] serialList = serial.list();
Radio [] recievers = new Radio[1];//use this line to manually set the amount of recievers there are MAKE SURE TO UNCOMMENT THE ONE ABOVE^^^
String [] serialList= { "COM4"}; //use this to manually set which comports to use



int scansWanted = 2;
int [] transmitGainValues = {
  15, 30, 45, 60
};
int port = 5212;

int x = 0;
boolean serverRunning = false;
String dir = "C:\\Users\\Public\\TXTs";
Thread [] threads = new Thread[(serial.list()).length];

void setup() {
  for (int i = 0; i < recievers.length; i++) {
    recievers[i] = new Radio(serialList[i], scansWanted);
    println(recievers.length);
  }

  int y = 0;
  while (new File (dir + "\\set" + y).exists()) {
    y++;
  }
  dir = dir + "\\set" +  y;
  folderPath = new File(dir);
  folderPath.mkdirs();
}
boolean finished = false;
int delay;
boolean start = false;
void draw() { 
  if (serverRunning && start && delay < millis() && !finished ) {
    for (int r = 0; r < transmitGainValues.length; r++) {

      myServer.write("1"); //"address for the transmitter"
      myServer.write("3");//command to change gain values
      myServer .write(transmitGainValues[r]);//data
      myServer.write("\n");//close statement
      waitForConfirm();
println("HERE");
myServer.write("1");
      myServer.write("2"); //command to start scans 
      myServer.write("\n");
      //waitForConfirm();

      for (int i = 0; i < recievers.length; i++) { 
        recievers[i].setCurrentGain(transmitGainValues[r]);
        threads[i] = new Thread(recievers[i]);
        threads[i].start();
      }
      int d = 0;
      for (int i = 0; i < recievers.length; i++) { 
        while(threads[i].isAlive() == true){ d++;
      } //delay to wait for the last scan to finish
      //println( "Variable d: " +d);
      }
        
      myServer.write("1");//command to stop transmitter
      myServer.write("1");
      myServer.write("\n");
      //waitForConfirm();
    }
    (new Converter(dir)).convert();
    finished = true;
  }
  
}

public void waitForConfirm() {
  
  
  while(client == null) client = myServer.available();
  
  byte [] confirmBuffer = new byte[5];
  client.readBytesUntil(10, confirmBuffer);
  if(confirmBuffer[0] == 50){
   if(confirmBuffer[1] == 57) {
     println("confirm Recieved!"); 
   }
  }
 for( int i = 0; i < confirmBuffer.length; i++) confirmBuffer[i] = 0;
}

void mousePressed() {
  if (serverRunning) {
    serverRunning = false;
    myServer.stop();
    myServer = null;
  } else {
    serverRunning = true;
    myServer = new Server(this, port);
    client = new Client(this, myServer.ip(), port);
    println(myServer.ip());
  }
}

void keyPressed() {
  if (keyCode == ENTER) {
    start = true;
    delay = 3000 + millis();
    println("delay: " +delay+ "   current: " + millis());
  }
}

