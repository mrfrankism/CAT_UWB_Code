/*
  the transmitter will be the client so that we can call a clientEvent() once the server/recievers are done recieving data
*/


import processing.net.*;
import java.util.ArrayList;
import processing.serial.*;

ArrayList<Integer> input = new ArrayList<Integer>();
Client myClient;
Serial mySerial;
Radio transmitter = new Radio(0); //currently configured to work with just one transmitter sending info to multiple recievers

String ip = "10.107.244.1"; // ip for the client to connect to THIS MUST BE CHECKED BEFORE EVERY RUN!!
int port = 5203; // port number for the client to connect to.


void setup(){

  
  myClient = new Client(this, ip, port);
  
  
  size(200,200);
}



void draw(){
    
background(50);


}

void clientEvent(Client c){ // called when recieved info from server 

  input.add(c.read());
  println(input);
  if(input.size() >= 1){
  if(input.get(0) == 49){//stop command
   transmitter.stopTransmitting();
   c.write("9");//sends this confirm code to the server
   
    
  }
  else if(input.get(0) == 50){//start automated channel impulse response testing
    transmitter.startTransmitting();
    println("recieved something");
    c.write("9");
  }
  else if(input.get(0) == 51){//change gain settings
  transmitter.changeGain(input.get(7));
  c.write("9");
  }
  input.clear();//clears the arraylist to get new input after it runs a command
}
}


void mousePressed(){
  
 println(input); 
 
}

    
