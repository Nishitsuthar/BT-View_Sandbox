public class AddressLines
{
    public String name {get; set;}
    public String street1 {get; set;}
    public String street2 {get; set;}
    public String street3 {get; set;}
    public String city {get; set;}
    public String stateProvince {get; set;}
    public String postalCode {get; set;}
    public String country {get; set;}
    
    public AddressLines(String name, Address addr)
    {system.debug('addr--'+addr);
     
        this.name = name;
     if(addr.Street !=null){
        List<String> street = addr.Street.split('\r\n');
        system.debug('street--'+street);
        this.street1 = street[0];
    
        if (street.size() == 2)
        {
            this.street2 = street[1];
        }
        if (street.size() == 3)
        {
            this.street3 = street[2];
        }
    }
        this.city = addr.city;
        this.stateProvince = addr.State;
        this.postalCode = addr.PostalCode;
        this.country = addr.Country;
    }
    
    public AddressLines(){}
    
        
}