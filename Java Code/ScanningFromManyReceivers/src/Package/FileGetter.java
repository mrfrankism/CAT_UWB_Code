package Package;
import java.io.File;
import java.util.ArrayList;
public class FileGetter{

  private ArrayList<String> allPaths = new ArrayList<String>(0);
  String [] collectedPaths;


public String [] getAllFiles(String path){
  
  String [] filesInFolder = (new File(path)).list();
  
  for(int h = 0; h < filesInFolder.length; h++){
    if(new File(path +"\\"+filesInFolder[h]).isDirectory()){
     getAllFiles(path+"\\"+filesInFolder[h]); 
    }
    else if(new File(path +"\\"+filesInFolder[h]).isFile() && (filesInFolder[h].substring(filesInFolder[h].indexOf("."))).equals(".txt")){
      
     allPaths.add(path+"\\"+filesInFolder[h]); 
    }
    else{
    }
  }
  collectedPaths = new String[allPaths.size()];
   allPaths.toArray(collectedPaths);//converts the array list of sirectories into a string array to return properly
   return collectedPaths;
}}
