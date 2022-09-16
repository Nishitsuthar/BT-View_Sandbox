public Class OrderEntryLineWrapper
{
    //
    // Version 2
    //  - New logic for handling recordType
    //  - Change to Constructor signatures
    //  - Removes hasChangeType method
    //  - Changes to handle OEL Record Type
    //
    public String recordType;
    public Decimal lineSequence = 0.0;
    public Order_Entry_Line__c oel {get; set;}
    public Boolean hasErrors {get; set;}
    public String dimensionSearchKey {get; set;}
    public String skuSuffix {get; set;}
    public Id dimensionId {get; set;}
    public String sourceString {get; set;}
    public List<String> validationErrors = new List<String>();
    public Boolean isUpdated;

    
    public OrderEntryLineWrapper(Order_Entry_Line__c oelIn)
    {
        this.oel = oelIn;
        this.hasErrors = false;
        this.isUpdated = false;
        // *** Change to handle OEL Record Type 
        this.recordType = 'IGU_Imperial';
        if (oelIn.Line_Number__c != null)
        {
            this.lineSequence = oelIn.Line_Number__c;
        }
    }
    
    // *** Change to handle OEL Record Type 
    public OrderEntryLineWrapper(Order_Entry_Line__c oelIn, String oelRecordType)
    {
        this.oel = oelIn;
        this.hasErrors = false;
        this.isUpdated = false;
        this.recordType = oelRecordType;
        if (oelIn.Line_Number__c != null)
        {
            this.lineSequence = oelIn.Line_Number__c;
        }
    } 
    
    public OrderEntryLineWrapper(Order_Entry_Line__c oelIn, Integer lineSeq)
    {
        this.oel = oelIn;
        this.hasErrors = false;
        this.lineSequence = lineSeq;
        this.isUpdated = false; 
        this.recordType = 'IGU_Imperial';   
        // *** Change to handle OEL Record Type 
        if (oelIn.Line_Number__c != null)
        {
            this.lineSequence = oelIn.Line_Number__c;
        }
     }
      
    // *** Change to handle OEL Record Type     
    public OrderEntryLineWrapper(Order_Entry_Line__c oelIn, Integer lineSeq, String oelRecordType)
    {
        this.oel = oelIn;
        this.hasErrors = false;
        this.lineSequence = lineSeq;
        this.isUpdated = false;  
        this.recordType = oelRecordType; 
    } 
    
    public void addValidationError(String validationError)
    {
        validationErrors.add(validationError);
        hasErrors = true;
    }
    
}