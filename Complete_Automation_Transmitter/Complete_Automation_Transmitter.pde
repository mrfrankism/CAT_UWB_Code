/*
  the transmitter will be the client so that we can call a clientEvent() once the server/recievers are done recieving data
*/


import processing.net.*;
import java.util.ArrayList;
import processing.serial.*;


Client myClient;
Serial mySerial;
Radio transmitter = new Radio(0); //currently configured to work with just one transmitter sending info to multiple recievers

String ip = "10.107.244.1"; // ip for the client to connect to THIS MUST BE CHECKED BEFORE EVERY RUN!!
int port = 5212; // port number for the client to connect to.


void setup(){

  transmitter.serialOn(true);
  myClient = new Client(this, ip, port);
  
  
  size(200,200);
}



void draw(){
    
background(50);


}
byte [] input = new byte[10];
void clientEvent(Client c){ // called when recieved info from server 
c.readBytesUntil(10, input);
println(input);

  
  if(input[0] == 49){
  if(input[1] == 49){//stop command
  c.write("2");//sends this confirm code to the server
   c.write("9");
   c.write("\n");
   transmitter.stopTransmitting();
   
   
    
  }
  else if(input[1] == 50){//start automated channel impulse response testing
   c.write("2");//sends this confirm code to the server
   c.write("9");
   c.write("\n");
    transmitter.startTransmitting();
    
    println("recieved something");
    
  }
  else if(input[1] == 51){//change gain settings
  println("CHANGING GAIN TO: " + input[2]);
  c.write("2");//sends this confirm code to the server
   c.write("9");
   c.write("\n");
  transmitter.changeGain(input[1]);
  
  }
  }
  for(int i = 0; i < input.length; i++){// clear the input buffer
   input[i] = 0; 
  }
  }




void mousePressed(){
  input = new byte[10];
  myClient = new Client(this, ip, port);
 println(input); 
 
}

    
