-------------------------------------------------General Information-------------------------------------------------------------
Code was written using processing 2.2.1, mainly because of the simplicity of setting up serial communications, and being able to use many of Java's data structures. Commands sent to
the P410 equipment were based on the CAT (Channel Analysis Tool) P410 API commands which can be found at "http://www.timedomain.com/datasheets/320-0305B%20CAT%20API%20Specification.pdf", 
the USB and Serial user guide also details neccessary communication protocols and can be found here "http://www.timedomain.com/datasheets/320-0287E%20Using%20the%20USB%20and%20Serial%20Interfaces.pdf".
 
This code is intended to collect channel impluse response scans and record the scan information so that later MATLAB can be used to futher analyze it. Information on the 
many applications of the P410 can be found on the Time Domain website "www.timedomain.com"

To download or to get more information on Processing go to "www.processing.org"

Questions, concerns or issues can be email to francoab10@gmail.com or opened up on Github
------------------------------------------------------------------------------------------------------------------------------
							******** PENDING TODO: *********
 - Possibly combine the two programs into one to be able to read and directly convert to a CSV file

 - Create a String variable to easily change the conversion from CSV to a simple text file that can be used for other purposes

 - delete un-neccessary commented code that was used for debugging purposes
--------------------------------------------------------------------------------------------------------------------------------------------------
							********* UPDATES: *********
________________________________________________________________As of 07/05/15_____________________________________________________________________________
 - ScanningFrom2recievrs creates a TXT folder and writes the scan information into seperate text files based on how many scans you want in each file. 
   It records each byte recieved through the serial ports and prints them as ascii into the text files, this ascii is completely un-decipherable to a human eye, therefore
   it is neccessary to use the "FromTXTtoCSV" code to convert the byte in the text file to a human readable/understandable CSV file which can be opened in excel. 
 
 - FromTXTtoCSV converts the various text files into readable CSV files. The purpose of this is to be able to open the CSVs in MATLAB and study the information in the files
   using MATLAB.

 - ScanningFrom2recievrs(NOTCOMPLETED) is unfinished code that is being worked on