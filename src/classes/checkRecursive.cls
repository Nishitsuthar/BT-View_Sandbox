public Class checkRecursive{
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
    private static boolean runOnceSDTrack= true;
    public static boolean runOnceSDTrack(){
    if(runOnceSDTrack){
     runOnceSDTrack=false;
     return true;
    }else{
        return runOnceSDTrack;
    }
    }
}