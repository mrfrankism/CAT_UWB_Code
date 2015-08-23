import java.lang.String;

public static class FileGetter{
  private String firstPath;
  private String [] allPaths = new String [1];
  


public String [] getAllFiles(String path){
  
  String [] filesInFolder = (new File(path)).list();
  
  for(int h = 0; h < filesInFolder.length; h++){
    if(new File(path +"\\"+filesInFolder[h]).isDirectory()){
     getAllFiles(path+"\\"+filesInFolder[h]); 
    }
    else if(new File(path +"\\"+filesInFolder[h]).isFile() && (filesInFolder[h].substring(filesInFolder[h].indexOf("."))).equals(".txt")){
      
     allPaths = append(allPaths, path+"\\"+filesInFolder[h]); 
    }
    else{
    }
  }
  return allPaths;
}}


