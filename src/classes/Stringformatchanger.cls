public class Stringformatchanger {
    public static string addformat(string serialNumber){
        string ReturnLiteid='';
        map<integer,string> addZeromap= new  map<integer,string>();
        addZeromap.put(1,'0' );
        addZeromap.put(2,'00' );
        addZeromap.put(3,'000' );
        addZeromap.put(4,'0000' );
        addZeromap.put(0,'' );
        //81`24`71`17`0
        //4981`0024`0071`0017`00
        list<string> strSerialLst= serialNumber.split('`');
        system.debug('***strSerialLst**'+strSerialLst);
        //5,4,4,4,2
        system.debug('--list size--'+strSerialLst.size());
        if(strSerialLst[0].length() <5){
            integer i=5-strSerialLst[0].length();
            system.debug('--addZeromap.get(i);--'+addZeromap.get(i));
            string Tempstr=addZeromap.get(i);
            string Tempstr2=Tempstr+strSerialLst[0];
            ReturnLiteid+=Tempstr2;
            system.debug('***ReturnLiteid**'+ReturnLiteid);
        }else if(strSerialLst[0].length() ==5){
                ReturnLiteid += strSerialLst[0];
        }


            if(strSerialLst[1].length() < 4){
            integer i=4-strSerialLst[1].length();
              system.debug('--addZeromap.get(i);--'+addZeromap.get(i));
            string Tempstr=addZeromap.get(i);
            string Tempstr2=Tempstr+strSerialLst[1];
            ReturnLiteid+='`'+Tempstr2;
            system.debug('***ReturnLiteid**'+ReturnLiteid);
            
        } if(strSerialLst[2].length() < 4){
            integer i=4-strSerialLst[2].length();
             system.debug('--addZeromap.get(i);--'+addZeromap.get(i));
            string Tempstr=addZeromap.get(i);
            string Tempstr2=Tempstr+strSerialLst[2];
            ReturnLiteid+='`'+Tempstr2;
            system.debug('***ReturnLiteid**'+ReturnLiteid);
        } if(strSerialLst[3].length() < 4){
            integer i=4-strSerialLst[3].length();
             system.debug('--addZeromap.get(i);--'+addZeromap.get(i));
            string Tempstr=addZeromap.get(i);
            string Tempstr2=Tempstr+strSerialLst[3];
            ReturnLiteid+='`'+Tempstr2;
            system.debug('***ReturnLiteid**'+ReturnLiteid);  
        } 
        if(strSerialLst[4].length() < 2){
            integer i=2-strSerialLst[4].length();
             system.debug('--addZeromap.get(i);--'+addZeromap.get(i));
            string Tempstr=addZeromap.get(i);
            string Tempstr2=Tempstr+strSerialLst[4];
            ReturnLiteid+='`'+Tempstr2;
            system.debug('***ReturnLiteid**'+ReturnLiteid);
            
        }  
        
        system.debug('**final*ReturnLiteid**'+ReturnLiteid);
        return ReturnLiteid;
        
        
    }
}