
import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.Map;
import java.util.ArrayList;
import java.io.PrintWriter;
String [] catfullscanvariables = { 
  "Timestamp, ", "CatFullScanInfo, ", "MessageId, ", "SourceId, ", "Timestamp, ", "ChannelRiseTime, ", "vPeak, ", "LinearSnr, ", "LedIndex, ", "LockspotOffset, ", "ScanStartPs, ", "ScanStopPs, ", "ScanStepBins, ", "ScanFiltering, ", "AntennaId, ", "OperationalMode, ", "NumSamplesTotal, ", "ScanData"
};
String [] catfullscanvariablesOrder = { 
  "Timestamp", "CatFullScanInfo", "MessageId", "SourceId", "Timestamp", "ChannelRiseTime", "vPeak", "LinearSnr", "LedIndex", "LockspotOffset", "ScanStartPs", "ScanStopPs", "ScanStepBins", "ScanFiltering", "AntennaId", "OperationalMode", "NumSamplesTotal"
};
int [] scanData;
String [] files = new String[1];

int numOfScans = 0; //NO NEED TO CHANGE PROGRAM READSSETUP FILE 
FileGetter getDirs;
HashMap<String, Integer> parameters = new HashMap<String, Integer>();
PrintWriter writer;
int firstByte = 0;
int secondByte = 0;
int skipByteCounter = 0;
int messageLength = 0;
int messageId = 0;
int cmdParameter = 0;
int previousLength = 0;
int totalMessageNumber = 0;
int messageIndex = 0;
int scanNumber = 0;
int fileCounter = 0;
InputStream input;
boolean newScan = true;
int counter = 0;
boolean writerExists = false;
int previousScanNumber = 0;
boolean haveFiles = false;
String [] filePaths;
String filePath;
void setup() {
  
   
  selectFolder("Select Folder with TXTs:", "folderSelected");
  

  
}

public void folderSelected(File selection){
  if(selection == null){
   exit(); 
  }
  else {
    haveFiles = true;
    filePath = selection.getPath();
    
    getDirs = new FileGetter();
    filePaths = getDirs.getAllFiles(filePath);
    println(filePaths);
    
   


}
}

void draw() {
//reads two bytes and checks if they are equal to "A5"

if(haveFiles == true){
  
  for(int f = 0; f < filePaths.length; f++){
    
    
    
  try {
    input = new DataInputStream(new BufferedInputStream(new FileInputStream(new File(filePaths[i])), 1024));
    
 
 
 while(input.available() > 0){
  if (readByte() == 165 && readByte() == 165) {
    counter++;
    messageLength = readParameter(2); //reads length of the message
    cmdParameter = readParameter(2);//reads the command response
    messageId = readParameter(2);//reads the message ID
   



    switch(cmdParameter) {
    case 0xF201:
      {
        CATFULLSCANINFO();
        storeScanData();
        writeScanData(f);
        break;
      }
    case 0x2103:
      {
        println("CAT_CONTROL_CONFIRM");
        parameters.put("Status", readParameter(4));
       
        break;
      }
    default :
      {
        println("NO CASE FOUND");
        break;
      }
    }
  } else {
    
    /*firstByte = secondByte; // meant to be a better A5 A5 search algorithm but hasnt been properly tested
    // secondByte = readByte();*/
    skipByteCounter++;
    println("skippin" + skipByteCounter); // prints ammount of bytes skipped mainly tend to be zeros
  }

  if (messageIndex + 1 == totalMessageNumber  && totalMessageNumber != 0) { // to stop recording the previous scan and start recording a new one when the last message has bee recieved for the previous scan
    // reseting variables and adding 1 to the scn numbber which limmits the ammount of scans per text file
    messageIndex = 0;
    totalMessageNumber = 0;
    scanNumber++;
    previousLength = 0;
    newScan = true; //sets newScan to true to print a new line in the text file for the next scan
    if (scanNumber == numOfScans) { // closes the text file when it has reached the desired number of scans
      writer.flush();
      writer.close();
      writerExists = false;
      
    }
  } 
  }
   }
  catch(FileNotFoundException e) {
    println("File not found");
  }
  catch(NullPointerException e){
   println("NULLPOINTER"); 
  }
  catch(IOException e) {
    println("IOException");
  }
  scanNumber = 0;
 }
 exit();
}
}

public void writeScanData(int p) {
  
  
  if (writerExists == false) {
    try {
      String title = filePath+"\\"+files[p].substring(0,files[p].length()-4);
      writer = new PrintWriter (new File(title + ".csv"));
      writerExists = true;
    }
    catch (FileNotFoundException e) {
    }

    for (int i = 0; i < catfullscanvariables.length; i++) {
      writer.print(catfullscanvariables[i]);
    }
    writer.println();
  }

  if (newScan == true) {
    writer.print("141435347102.764, CatFullScanInfo, " + messageId + ", ");
    for (int i = 3; i < catfullscanvariablesOrder.length; i++) {
      writer.print(parameters.get(catfullscanvariablesOrder[i]) + ", ");
    }
    newScan = false;
  }

if (messageIndex + 1 == totalMessageNumber  && totalMessageNumber != 0) {
   for (int i = previousLength; i < scanData.length-2; i++) {//skips the first index because it is a zero used to create the array
    writer.print(scanData[i]+", ");
  }
  writer.println(scanData[scanData.length-1]);
}else{
  for (int i = previousLength; i < scanData.length; i++) {//skips the first index because it is a zero used to create the array
    writer.print(scanData[i]+", ");
  }
}
  previousLength = scanData.length;
  writer.flush();
}


public void storeScanData() {
  if (messageIndex == 0) {//start of a new message
    scanData = new int [1];
  }
  for (int i = 0; i < parameters.get ("Number of Samples"); i++) {
    scanData = append(scanData, readWaveformData());
  }
  //println(scanData);
}



public int readWaveformData() { //reads 4 bytes and concatinates them into an int
  try {
    int[] buffer = new int[4];
    int output = 0;
    for (int i =0; i < buffer.length; i++) {
      buffer[i] = input.read();
    }
    output = buffer[0];
    for (int i = 1; i < buffer.length; i++) {
      output = (output << 8) | buffer[i];
    }
    if (output == -1) {
      }
    
    return output;
  }
  catch(FileNotFoundException e) {
    println("Not Found");
  }
  catch(IOException e) {
    println("IOEXCEPTIO");
  }
  return -1;
}

public int readByte() { //returns an byte of information stored as an int
  try {
    return input.read();
  }
  catch(FileNotFoundException e) {
    println("Not Found");
  }
  catch(IOException e) {
    println("IOEXCEPTIO");
  }
  return -1;
}

public int readParameter(int len) { //reads up to 4 bytes at a time used to read paramaters passed from the radio
  try {
    int [] buffer = new int[len];
    int output = 0;
    for (int i =0; i < buffer.length; i++) {
      buffer[i] = input.read();
    }
    for (int i = 0; i < buffer.length; i++) {
      
      output = (output << 8) | buffer[i];
    }
    
    return output;
  }
  catch(FileNotFoundException e) {
    println("Not Found");
  }
  catch(IOException e) {
    println("IOEXCEPTIO");
  }
  return -1;
}

public void CATFULLSCANINFO() { // used to store the various information recieved from the equipment ***this can probably be simpliefied with an array and a for loop adding to the todo list***

  //println("CAT_FULL_SCAN_INFO");

  parameters.put("SourceId", readParameter(4));
  // println( "Source ID:" + parameters.get("Source ID"));

  parameters.put("Timestamp", readParameter(4));
  // println( "Timestamp: " + parameters.get("Timestamp"));

  parameters.put("ChannelRiseTime", readParameter(2));
  // println( "Channel Rise: " + parameters.get("Channel Rise"));

  parameters.put("vPeak", readParameter(2));
  // println( "Vpeak: " + parameters.get("Vpeak"));

  parameters.put("LinearSnr", readParameter(4));
  //  println( "Linear Scan SNR: " + parameters.get("Linear Scan SNR"));

  parameters.put("LedIndex", readParameter(4));
  // println( "Leading Edge Offset: " + parameters.get("Leading Edge Offset"));

  parameters.put("LockspotOffset", readParameter(4));
  //  println( "Lock Spot Offset: " + parameters.get("Lock Spot Offset"));

  parameters.put("ScanStartPs", readParameter(4));
  //println( "Scan Start: " + parameters.get("Scan Start"));

  parameters.put("ScanStopPs", readParameter(4));
  // println( "Scan Stop: " + parameters.get("Scan Stop"));

  parameters.put("ScanStepBins", readParameter(2));
  // println( "Scan Step: " + parameters.get("Scan Step"));

  readParameter(2);// used to skip two reserved bytes
  parameters.put("ScanFiltering", 0); //placeholder for scan filtering, IT IS IMPORTANT TO NOTE THAT THE LOG FILE LOGS THIS BUT THE API MENTIONS IT AS RESERVED BYTES THEREFORE IT IS CODED TO A DEFAULT 0


  parameters.put("AntennaId", readParameter(1));
  // println( "Antenna Id: " + parameters.get("Antenna Id"));

  parameters.put("OperationalMode", readParameter(1));
  //println( "Operation Mode: " + parameters.get("Operation Mode"));


  parameters.put("Number of Samples", readParameter(2));
  // println( "Number of Samples: " + parameters.get("Number of Samples"));

  parameters.put("NumSamplesTotal", readParameter(4));
  //println( "Number of Samples in Scan: " + parameters.get("Number of Samples in Scan"));

  messageIndex = readParameter(2); // not needed in the csv to write the message index or total message but it is needed for the program to run properly
  // parameters.put("Message Index", readParameter(2));
  //messageIndex = parameters.get("Message Index");
  // println( "Message Index: " + parameters.get("Message Index"));

  totalMessageNumber = readParameter(2);
  //parameters.put("Total Number of Messages", readParameter(2));
  //totalMessageNumber = parameters.get("Total Number of Messages");
  // println( "Total Number of Messages: " + parameters.get("Total Number of Messages"));

  //make code to check for data consistincy by checking indexes and matching them with total message counts


  /* THIS CODE IS MEANT TO MAKE THE SIZE OF THE ARRAY LIST MORE VERSATILE DOESNT WORK CURRENTLY
   if(scanData.size() + parameters.get("Number of Samples")) != scanData.size()){
   scanData.ensureCapacity(scanData.size() + parameters.get("Number of Samples"));
   println(scanData.size() + parameters.get("Number of Samples"));
   }
   
   if(scanData.length < parameters.get("Number of Samples in Scan")){
   scanData = expand(scanData, scanData.length + parameters.get("Number of Samples in Scan"));
   }
   */
}


