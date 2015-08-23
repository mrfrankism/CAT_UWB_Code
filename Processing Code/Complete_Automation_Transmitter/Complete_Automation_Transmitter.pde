/*
  the transmitter will be the client so that we can call a clientEvent() once the server/recievers are done recieving data
 */


import processing.net.*;
import java.util.ArrayList;
import processing.serial.*;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.net.InetAddress;
import java.io.InputStreamReader;
BufferedReader in;
PrintWriter out;
Socket socket;




Serial mySerial;
Radio transmitter = new Radio(0); //currently configured to work with just one transmitter sending info to multiple recievers

byte [] ip = {
  (byte)10, (byte)107, (byte)244, (byte)1
}; // ip for the client to connect to THIS MUST BE CHECKED BEFORE EVERY RUN!!
int port = 5211; // port number for the client to connect to.
boolean connected = false;

void setup() {

  transmitter.serialOn(true);
  size(200, 200);
}
boolean ready = false;


void draw() {

  background(50);


 // called when recieved info from server 
  while (true && ready == true) {
    String input = "";
    try {

      input = in.readLine();
      println(input);
    }
    catch(Exception e) {
      println("No line to be read");
    }
    if (input.equals("11")) {
      out.println("29");//sends this confirm code to the server
      transmitter.stopTransmitting();
      println("Stopping tansmition");
    } else if (input.equals("12")) {//start automated channel impulse response testing
      out.println("29");//sends this confirm code to the server
      transmitter.startTransmitting();
      println("Starting Transmition");
    } else if (input.equals("13")) {//change gain settings
      int gain = 0;
      try { 
        gain = parseInt(in.readLine());
        println(gain);
      }
      catch (Exception e) { 
        println("No gain Value found");
      }
      out.println("29");//sends this confirm code to the server
      transmitter.changeGain(gain);
      println("CHANGING GAIN TO: " + gain);
    }else{
      println("Matches no commands");
    }
    input = "";
  }
}




void mousePressed() {
  try {
    println("Starting client, make sure to start Server");
    println("Hurry to start Server because this will time out and throw an error");
    println("Connecting to ip: " + InetAddress.getByAddress(ip));
    socket = new Socket(InetAddress.getByAddress(ip), port);
    in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    out = new PrintWriter(socket.getOutputStream(), true);
    println("Ready");
    ready = true;
  }
  catch(Exception e ) { 
    println("Client Setup Issues");
  }
}


