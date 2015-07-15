/*

  This code is going to automate the process of recording scans 
  from a p410 uwb device at different transmit gain settings
  
  Set up a client and a server one will be the transmitter and the other will be the reciever
  
  will need two programs one to run the reciever and the other to run the transmitter
  
*/
import processing.serial.*;
import processing.net.*;
Server myServer;
Serial serial;


Radio [] recievers = new Radio[(serial.list()).length];
int scansWanted = 15;
int [] transmitGainValues = {15, 30, 45, 60};
int port = 5203;

int x = 0;
boolean serverRunning = false;

void setup(){
    for (int i = 0; i < recievers.length; i++) {
    recievers[i] = new Radio(serial.list()[i], scansWanted);
  }
  
  
}

void draw(){ 
    if(serverRunning){
    if(running == true){
   myServer.write("2"); //command to start scans 
   waitForConfirm();
  
 }
}

public void waitForConfirm(){
  Client client = myServer.available();
 if(client != null && client.read() == 57){
   println("confirm recieved!!");
 }else println("NO CONFIRM RECIEVED");
  
}

void mousePressed(){
  if(serverRunning){
   serverRunning = false;
  myServer.stop();
 myServer = null; 
  }else{
    serverRunning = true;
    myServer = new Server(this, port);
    println(myServer.ip());
  }
  
}
boolean running = true;
void keyPressed(){
 if(key == ENTER){ }
  
  
}

