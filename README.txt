Code for UWB equipment made by Time Domain. Intended for use with P410 equipment. 
------------------------------------------------------------------------------------------------------------------------------

							******PENDING TODO:***********
 - Possibly combine the two programs into one to be able to read and directly convert to a CSV file

 - Create a String variable to easily change the conversion from CSV to a simple text file that can be used for other purposes

 - delete un-neccessary commented code that was used for debugging purposes

----------------------------------------------------------As of 07/05/15----------------------------------------------------------------------------
 - ScanningFrom2recievrs creates a TXT folder and writes the scan information into seperate text files based on how many scans you want in each file. 
   It records each byte recieved through the serial ports and prints them as ascii into the text files, this ascii is completely un-decipherable to a human eye, therefore
   it is neccessary to use the "FromTXTtoCSV" code to convert the byte in the text file to a human readable/understandable CSV file which can be opened in excel. 
 
 - FromTXTtoCSV converts the various text files into readable CSV files. The purpose of this is to be able to open the CSVs in MATLAB and study the information in the files
   using MATLAB.

 - ScanningFrom2recievrs(NOTCOMPLETED) is unfinished code that is being worked on