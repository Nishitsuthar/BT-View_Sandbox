public class stoprecurssion{

public static boolean flag=true;

public static boolean runonce(){

if(flag){

   flag=false;
return true;

  }

else {

   return flag;

  }

}
}