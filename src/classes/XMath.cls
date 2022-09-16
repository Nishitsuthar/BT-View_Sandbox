public class XMath
{
    public static Integer getRandomInt(Integer maxInt)
    {
        Integer rand = Math.round(Math.random()*100000);
        Integer randMod = Math.mod(rand, maxInt);
        return randMod;
    
    
    }
}