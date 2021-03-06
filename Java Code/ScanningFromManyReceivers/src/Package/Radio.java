package Package;
import java.lang.Thread;
import java.io.File;
import java.io.PrintWriter;

import jssc.*;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class Radio extends Thread {
static private String defaultDir = "C:\\Users\\Public\\set0\\";
private SerialPort port;
private static byte wantedScans = 1;
private static int delay = 2;
private static int startDelay = 5;


	int [] CATCONTROLREQUESTON = { //this is the preset command set by the device to START transmitting/receiving
			  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01
			};
	int [] CATCONTROLREQUESTOFF = { //this is the preset command set by the device to STOP transmitting/receiving
			  0xA5, 0xA5, 0x00, 0x08, 0x20, 0x03, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
			};	
	
	Radio(String com){//creates one object to deal with one device
		try{
		port  = new SerialPort(com); //creates the serial port object
		port.openPort();
		port.setParams(SerialPort.BAUDRATE_9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
		}catch(SerialPortException e ){
			System.out.println(e);
			System.out.println("Com Port: " + com +" not found :(");
		}
		
	}	
	 
 public void run(){ 
	 /*
	  * This thread will start the Transeiver scanning and collect a certain amount
	  * of scans and then stop the radio to conclude communication.
	  */
	 try{
		
		 PrintWriter writer = new PrintWriter(new File(defaultDir + new SimpleDateFormat("hh_mm_ss").format(new Date()) + ".txt"));//changes the file name based on the time when the scan was taken
		 
	 port.writeIntArray(CATCONTROLREQUESTON); // writes the command to start scanning
	 
	 boolean finishedRecording = false; // this insures that even if the buffer is empty we will still record data
	 byte zeroCounter = 0; //this is used to see when one scan ends
	 byte scanNumber = 0; // tracks how many scans have been recorded
	 
	 while(!finishedRecording){
		 while(port.getInputBufferBytesCount() > 0){
			 
			 byte buffer = port.readBytes(1)[0];
			 if(buffer == 0){
				 zeroCounter++;//adds one if the byte is equal to zero
				 
				 if(zeroCounter == 40){//if we've gotten 40 zeros in a row we've completed one scan
					 scanNumber++; // adds one to track what scan we're on
					 zeroCounter = 0;//resets the zeroCounter to get ready for a new scan
					 if(wantedScans == scanNumber){// checks to see if we have the amount of necessary scans
						 writer.flush();
						 writer.close();
						 finishedRecording = true;
					 }else{
						 writer.println(); //writes a blank line to the file to show the start of a new scan
					 }
				 }else{ // if we got a zero but zeroCounter is not at the max write the zero to the file
					 writer.print(buffer);
				 }
				 
			 }else{//if the byte does not equal zero write it to the file
				 writer.print(buffer);
				 zeroCounter = 0; // resets the counter because the chain of zeros has been broken
			 }
			 
		 }
	 }
	 
	 port.writeIntArray(CATCONTROLREQUESTOFF);// Writes the command to stop scanning
	 
	 }catch(Exception e){
		 System.out.println(e);
	 }
	 
	 
 }
public static void setDirectory(String d) {
	 defaultDir = d;
	 
}
public static void setDelay(int d){
	delay = d;
	
}
public static void setNumberOfScans(byte n){
	wantedScans = n;
	
}
public static void setStartDelay(int t){
	startDelay = t;
}
public static int getStartDelay(){
	return startDelay;
}
public static byte getNumberOfScans(){
	return wantedScans;
}
public static int getDelay(){
	return delay;
}
public static String getDirectory(){
	return defaultDir;
}
public static void updateSettingsFile(){
	ScanningFromManyReceivers.log.append("\nWriting to settings file");
	try{
	PrintWriter out = new PrintWriter(new File("C:\\Users\\Public\\settings.txt"));
	out.println(Radio.getDirectory());
	out.println(Radio.getDelay());
	out.println(Radio.getNumberOfScans());
	out.println(Radio.getStartDelay());
	out.flush();
	out.close();
	ScanningFromManyReceivers.log.append("\nDone Writing to file");
}catch(Exception e ){
	ScanningFromManyReceivers.log.append("\nFile Not Found....");
}
}}