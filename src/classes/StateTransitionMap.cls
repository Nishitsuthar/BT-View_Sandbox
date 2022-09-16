public class StateTransitionMap
{  
    //
    // Go-Live version based on Version 2. Changes Made:
    //  - Added 'Cancellation Confirmation Pending' to the allowed state for 'Confirmed'
    //  - Removed a statement added for debugging which was causing random errors.
    //
    // Version 2 - getStatusSelections method added
    //
    // Updated Date         Developer       Project             Tracking Id                                       Requirement                         
    // 23-Aug-2020          Rekha           Project Concrete    CANCELLATION_BUGS_SEP_20        Dont allow cancellations of IGU from partially shipped status
    // 06-Jan-2021 		Rekha    	    SOS Hold Invoice    SOS_HOLD_INVOICE  
          
    public static Map<String, Map<String, String>> allowedStateTransitions = new Map<String, Map<String,String>>
    {
        'Draft' => new Map<String,String>{'Pre-Release Review' => '', 'Hold Requested' => '', 'Cancellation Requested' => '', 'Cancelled' => ''},
        'Pre-Release Review' => new Map<String,String>{'Draft' => '', 'Confirmation Pending' => '', 'Hold Requested' => '', 'Cancellation Requested' => ''},
        'Confirmation Pending' => new Map<String,String>{'Draft' => '','Pre-Release Review' => '', 'Confirmation Requested' => '', 'Hold Requested' => '', 'Cancellation Requested' => '', 'Planned' => ''},
        'Confirmation Requested' => new Map<String,String>{'Draft' => '', 'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Change Confirmed'=>''},
        'Confirmed' => new Map<String,String>{'Draft' => '','Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmation Requested' => '', 'Integration Requested' => '',
            'Hold Requested' => '', 'Cancellation Requested' => '', 'Cancellation Confirmation Pending' => ''},
           
        'Integration Requested' => new Map<String,String>{'Draft' => 'YES', 'Pre-Release Review' => 'YES', 'Confirmation Pending' => 'YES', 'Confirmed' => 'YES', 'Pre-Production' => '', 'Integration Error' => ''},
        'Pre-Production' => new Map<String,String>{'In Production' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '',
            'Change Confirmation Requested' => '', 'Hold Requested' => '', 'Cancellation Requested' => '', 'Cancellation Confirmation Pending' => ''},
        'In Production' => new Map<String,String>{'Partially Shipped' => '', 'Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmation Requested' => '',
            'Hold Requested' => '', 'Cancellation Requested' => '', 'Cancellation Confirmation Pending' => ''},
        'Partially Shipped' => new Map<String,String>{'Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmation Requested' => '', 'Hold Requested' => '',
             'Complete' => ''}, 
                 //Rekha : removed 'Cancellation Requested' => '',; , 'Cancellation Confirmation Pending' => ''  from Partially Shipped:CANCELLATION_BUGS_SEP_20
        'Shipped' => new Map<String,String>{'Complete' => ''},
        'Integration Error' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '', 'Pre-Production' => '',
            'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmed' => '', 'Change Integration Requested' => '',
            'Hold Requested' => '', 'Hold Release Requested' => '', 'Cancellation Requested' => '', 'Cancellation Confirmed' => '', 'Cancellation Integration Requested' => '', 'Draft' => ''},
        'Change Requested' => new Map<String,String>{'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Integration Requested' => '',
            'Hold Requested' => ''},
        'Change Confirmation Pending' => new Map<String,String>{'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Shipped' => '', 'Change Confirmation Requested' => ''},
        'Change Confirmation Required' => new Map<String,String>{'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Shipped' => '', 'Change Confirmation Requested' => ''},
        'Change Confirmation Requested' => new Map<String,String>{'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Shipped' => '',
             'Change Confirmed' => ''},
        'Change Confirmed' => new Map<String,String>{'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '',
            'Change Confirmation Requested' => '', 'Change Confirmation Required' => '', 'Change Integration Requested' => '', 'Hold Requested' => ''},
        'Change Integration Requested' => new Map<String,String>{'Pre-Production' => 'YES', 'In Production' => 'YES', 'Partially Shipped' => 'YES', 'Change Requested' => '', 'Change Confirmation Pending' => 'YES',
            'Change Confirmed' => '', 'Hold Requested' => 'YES'},
        'Hold Requested' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '', 'Pre-Production' => '', 'Change Integration Requested' => '',
            'In Production' => '', 'Partially Shipped' => '', 'Integration Error' => '', 'Change Requested' => '', 'Hold' => ''},
        'Hold' => new Map<String,String>{'Hold Release Requested' => '', 'Cancellation Requested' => ''},
        'Hold Release Requested' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '', 'Change Integration Requested' => '',
            'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmed' => '', 'Hold Requested' => ''},
        'Cancellation Requested' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Cancellation Integration Requested' => '',
            'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Cancellation Confirmation Pending' => '', 'Change Confirmed' => '', 'Hold Requested' => '',
            'Hold' => '', 'Cancellation Confirmation Pending' => ''},
        'Cancellation Confirmation Pending' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '',
            'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmed' => '', 'Hold Requested' => '',
            'Hold' => '', 'Cancellation Confirmation Requested' => '', 'Cancellation Confirmed' => ''},
        'Cancellation Confirmation Requested' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '',
            'Pre-Production' => '', 'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmed' => '', 'Hold Requested' => '',
            'Hold' => '', 'Cancellation Confirmed' => ''},
        'Cancellation Confirmed' => new Map<String,String>{'Pre-Release Review' => '', 'Confirmation Pending' => '', 'Confirmed' => '', 'Integration Requested' => '', 'Pre-Production' => '',
            'In Production' => '', 'Partially Shipped' => '', 'Change Requested' => '', 'Change Confirmation Pending' => '', 'Change Confirmation Required' => '', 'Change Confirmed' => '', 'Hold Requested' => '', 'Hold' => '',
            'Hold Release Requested' => '', 'Cancellation Confirmation Pending' => '', 'Cancellation Confirmation Requested' => '', 'Cancellation Integration Requested' => ''},
        'Cancellation Integration Requested' => new Map<String,String>{'Pre-Release Review' => 'YES', 'Confirmation Pending' => 'YES', 'Confirmed' => 'YES', 'Pre-Production' => '',
            'In Production' => 'YES', 'Partially Shipped' => 'YES', 'Cancelled' => ''},
        'Cancelled' => new Map<String,String>{},
        'Complete' => new Map<String,String>{}        
    };
   
    public static Map<String, Map<String, String>> allowedHWStateTransitions = new Map<String, Map<String,String>>
    {
        'Draft' => new Map<String,String>{'Integration Requested' =>'', 'Cancellation Requested'=>'', 'Hold Requested'=>'', 'Cancelled' => ''},
        'Integration Error' => new Map<String,String>{'Draft'=>'','Confirmation Pending'=>'', 'Confirmed'=>'', 'Integration Requested'=>'', 'Partially Shipped'=>'', 'Change Requested'=>'',
                'Change Confirmation Pending'=>'', 'Change Confirmation Required'=>'', 'Change Confirmed'=>'', 'Change Integration Requested'=>'',
                'Hold Requested'=>'', 'Hold Release Requested'=>'', 'Cancellation Requested'=>'', 'Cancellation Confirmed'=>'', 'Cancellation Integration Requested'=>''},
        'Integration Requested' => new Map<String,String>{'Draft'=>''},
        'Planned' => new Map<String,String>{'Planned' => '', 'Confirmation Requested' => '','Cancellation Requested' => '', 'Hold Requested' => '', 'Change Integration Requested'=>'', 'Cancellation Confirmation Pending' => ''},
        'Change Requested' => new Map<String,String>{'Change Integration Requested' => '','Cancellation Requested' => ''},
        //'Confirmation Pending' => new Map<String,String> {'Confirmation Requested' => '', 'Planned' => '', 'Partially Shipped' => ''},
        'Confirmation Requested' => new Map<String,String>{'Confirmed' => '','Planned' => '','Change Requested' => ''},
        'Confirmed' => new Map<String,String> {'Confirmation Requested' => '', 'Confirmation Pending' => '','Approval to Ship Requested'=>'', 'Planned' => '', 'Cancellation Requested' => '', 'Hold Requested' => ''},
        'Approved-to-Ship' => new Map<String,String> {'Cancellation Requested' => '', 'Hold Requested' => '','Change Confirmation Pending' => '','Changed Requested' => '', 'Cancellation Confirmation Pending' => ''},
        'Approval to Ship Requested' => new Map<String,String> {'Approved-to-Ship'=>'','Confirmed' => '','Planned' => ''},
        'Partially Shipped' => new Map<String,String> {'Hold Requested' => '','Change Requested' => '','Change Integration Requested' => ''},
        'Shipped' => new Map<String,String>{},
        'Cancellation Requested' => new Map<String,String>{'Cancellation Integration Requested' => '','Draft' => '', 'Planned' => '', 'Confirmed' => '', 'Approved to Ship' => '','Change Integration Requested' => '','Cancellation Confirmation Pending' => ''},
        'Cancellation Confirmation Pending' => new Map<String,String>{'Cancellation Confirmation Requested' => '', 'Draft' => '', 'Planned' => '', 'Confirmed' => '', 'Approved to Ship' => ''},
        'Cancellation Confirmation Requested' => new Map<String,String>{'Cancellation Confirmed' => '', 'Draft' => '', 'Planned' => '', 'Confirmed' => '', 'Approved to Ship' => ''},
        'Cancellation Confirmed' => new Map<String,String>{'Cancellation Integration Requested' => '', 'Cancellation Confirmation Pending' => '', 'Draft' => '', 'Planned' => '', 'Confirmed' => '', 'Approved to Ship' => ''},
        'Cancellation Integration Requested' => new Map<String,String>{'Cancellation Confirmed'=> '', 'Draft'=> '', 'Planned'=> '', 'Confirmed'=> '', 'Approved to Ship'=> ''},
        'Cancelled' => new Map<String,String>{'Integration Requested' =>'','Change Integration Requested' =>'','Confirmation Requested' =>''},
       
        'Hold Requested' => new Map<String,String>{'Change Integration Requested' => '', 'Planned' => '', 'Approved to Ship' => '', 'Partially Shipped' => ''},
        'Hold' => new Map<String,String>{'Hold Release Requested' => '', 'Cancellation Requested' => ''},
        'Hold Release Requested' => new Map<String,String>{'Hold' => '','Change Integration Requested' => ''},
        'Change Confirmation Required' => new Map<String,String>{'Change Confirmation Requested' => ''},
        'Change Confirmation Pending' => new Map<String,String>{'Change Confirmation Requested' => ''},
        'Change Confirmation Requested' => new Map<String,String>{'Change Confirmed' => ''},
        'Change Confirmed' => new Map<String,String>{'Change Integration Requested' => ''}
       
    };
   
    public static Map<String, Map<String, String>> allowedSWStateTransitions = new Map<String, Map<String,String>>
    {
        'Draft' => new Map<String,String>{'Integration Requested' => '', 'Cancellation Requested' => '', 'Hold Requested' => '', 'Cancelled' => ''},
        'Integration Requested' => new Map<String,String>{'Draft' => ''},
        'Integration Error' => new Map<String,String>{'Draft' => '', 'Planned' => '', 'Booked' => '', 'Change Requested' => '', 'Change Integration Requested' => '',
            'Hold Requested' => '', 'Hold Release Requested' => '', 'Cancellation Requested' => '', 'Cancellation Confirmed' => '', 'Cancellation Integration Requested' => ''},
        'Planned' => new Map<String,String>{'Cancellation Requested' => '', 'Hold Requested' => '','Booked' => ''},
        'Change Requested' => new Map<String,String>{'Change Integration Requested' => ''},
        'Hold Requested' => new Map<String,String>{'Change Integration Requested' => '', 'Planned' => '', 'Booked' => ''},
        'Hold' => new Map<String,String>{'Hold Release Requested' => '', 'Cancellation Requested' => ''},
        'Hold Release Requested' => new Map<String,String>{'Hold' => '','Change Integration Requested' => ''},   //SOS_HOLD_INVOICE  added Change Integration Requested
        'Booked' => new Map<String,String>{'Planned' => '', 'Hold' => '', 'Cancellation Requested' => '', 'Hold Requested' => '','Invoiced' => ''},//SOS_HOLD_INVOICE
        'Invoiced' => new Map<String,String>{},
        'Cancellation Requested' => new Map<String,String>{'Cancellation Integration Requested' => '','Draft' => '', 'Planned' => '', 'Confirmed' => ''},
        'Cancellation Confirmation Pending' => new Map<String,String>{'Cancellation Confirmation Requested' => '', 'Draft' => '', 'Planned' => '', 'Booked' => ''},
        'Cancellation Confirmation Requested' => new Map<String,String>{'Cancellation Confirmed' => '', 'Draft' => '', 'Planned' => '', 'Booked' => ''},
        'Cancellation Confirmed' => new Map<String,String>{'Cancellation Integration Requested' => '', 'Cancellation Confirmation Pending' => '', 'Draft' => '', 'Planned' => '', 'Booked' => ''},
        'Cancellation Integration Requested' => new Map<String,String>{'Cancellation Confirmed' => '', 'Draft' => '', 'Planned' => '', 'Booked' => ''},
        'Cancelled' => new Map<String,String>{'Integration Requested'=>''}        
    };
           
    public static Map<String,String> statusErrorMsg = new Map<String,String>
    {
        'Draft/Confirmation Pending'=>'Changing Status from \'Draft\' to \'Confirmation Pending\' is not allowed',
        'Draft/Confirmation Requested'=>'Changing Status from \'Draft\' to \'Confirmation Requested\' is not allowed',
        'Draft/Confirmed'=>'Changing Status from \'Draft\' to \'Confirmed\' is not allowed',
        'Draft/Integration Requested'=>'Changing Status from \'Draft\' to \'Integration Requested\' is not allowed',
        'Draft/Pre-Production'=>'Changing Status from \'Draft\' to \'Pre-Production\' is not allowed',
        'Draft/In Production'=>'Changing Status from \'Draft\' to \'In Production\' is not allowed',
        'Draft/Partially Shipped'=>'Changing Status from \'Draft\' to \'Partially Shipped\' is not allowed',
        'Draft/Shipped'=>'Changing Status from \'Draft\' to \'Shipped\' is not allowed',
        'Draft/Cancelled'=>'Changing Status from \'Draft\' to \'Cancelled\' is not allowed',
        'Draft/Integration Error'=>'Changing Status from \'Draft\' to \'Integration Error\' is not allowed',
        'Draft/Change Requested'=>'Changing Status from \'Draft\' to \'Change Requested\' is not allowed',
        'Draft/Change Confirmation Pending'=>'Changing Status from \'Draft\' to \'Change Confirmation Pending\' is not allowed',
        'Draft/Change Confirmation Requested'=>'Changing Status from \'Draft\' to \'Change Confirmation Requested\' is not allowed',
        'Draft/Change Confirmed'=>'Changing Status from \'Draft\' to \'Change Confirmed\' is not allowed',
        'Draft/Change Integration Requested'=>'Changing Status from \'Draft\' to \'Change Integration Requested\' is not allowed',
        'Draft/Hold Requested'=>'Changing Status from \'Draft\' to \'Hold Requested\' is not allowed',
        'Draft/Hold'=>'Changing Status from \'Draft\' to \'Hold\' is not allowed',
        'Draft/Hold Release Requested'=>'Changing Status from \'Draft\' to \'Hold Release Requested\' is not allowed',
        'Draft/Cancellation Requested'=>'Changing Status from \'Draft\' to \'Cancellation Requested\' is not allowed',
        'Draft/Cancellation Confirmation Pending'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Draft/Cancellation Confirmation Requested'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Draft/Cancellation Confirmed'=>'Changing Status from \'Draft\' to \'Cancellation Confirmed\' is not allowed',
        'Draft/Cancellation Integration Requested'=>'Changing Status from \'Draft\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmation Requested/Draft'=>'Changing Status from \'Confirmation Requested\' to \'Draft\' is not allowed',
        'Integration Requested/Draft'=>'Changing Status from \'Integration Requested\' to \'Draft\' is not allowed',
        'Pre-Production/Draft'=>'Changing Status from \'Pre-Production\' to \'Draft\' is not allowed',
        'In Production/Draft'=>'Changing Status from \'In Production\' to \'Draft\' is not allowed',
        'Partially Shipped/Draft'=>'Changing Status from \'Partially Shipped\' to \'Draft\' is not allowed',
        'Shipped/Draft'=>'Changing Status from \'Shipped\' to \'Draft\' is not allowed',
        'Cancelled/Draft'=>'Changing Status from \'Cancelled\' to \'Draft\' is not allowed',
        'Integration Error/Draft'=>'Changing Status from \'Integration Error\' to \'Draft\' is not allowed',
        'Change Requested/Draft'=>'Changing Status from \'Change Requested\' to \'Draft\' is not allowed',
        'Change Confirmation Pending/Draft'=>'Changing Status from \'Change Confirmation Pending\' to \'Draft\' is not allowed',
        'Change Confirmation Requested/Draft'=>'Changing Status from \'Change Confirmation Requested\' to \'Draft\' is not allowed',
        'Change Confirmed/Draft'=>'Changing Status from \'Change Confirmed\' to \'Draft\' is not allowed',
        'Change Integration Requested/Draft'=>'Changing Status from \'Change Integration Requested\' to \'Draft\' is not allowed',
        'Hold Requested/Draft'=>'Changing Status from \'Hold Requested\' to \'Draft\' is not allowed',
        'Hold/Draft'=>'Changing Status from \'Hold\' to \'Draft\' is not allowed',
        'Hold Release Requested/Draft'=>'Changing Status from \'Hold Release Requested\' to \'Draft\' is not allowed',
        'Cancellation Requested/Draft'=>'Changing Status from \'Cancellation Requested\' to \'Draft\' is not allowed',
        'Cancellation Confirmation Pending/Draft'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Draft\' is not allowed',
        'Cancellation Confirmation Requested/Draft'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Draft\' is not allowed',
        'Cancellation Confirmed/Draft'=>'Changing Status from \'Cancellation Confirmed\' to \'Draft\' is not allowed',
        'Cancellation Integration Requested/Draft'=>'Changing Status from \'Cancellation Integration Requested\' to \'Draft\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancelled'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Pending/Change Confirmation Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Change Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Change Integration Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Complete'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Complete\' is not allowed',
        'Cancellation Confirmation Pending/Confirmation Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Pending/Integration Error'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Pending/Shipped'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Shipped\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancelled'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Requested/Change Confirmation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Change Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Complete'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Complete\' is not allowed',
        'Cancellation Confirmation Requested/Confirmation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Requested/Integration Error'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Requested/Shipped'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Shipped\' is not allowed',
        'Cancellation Confirmed/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmed/Cancelled'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmed/Change Confirmation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Confirmation Requested\' is not allowed',
        'Cancellation Confirmed/Change Integration Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmed/Complete'=>'Changing Status from \'Cancellation Confirmed\' to \'Complete\' is not allowed',
        'Cancellation Confirmed/Confirmation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmed/Integration Error'=>'Changing Status from \'Cancellation Confirmed\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmed/Shipped'=>'Changing Status from \'Cancellation Confirmed\' to \'Shipped\' is not allowed',
        'Cancellation Integration Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Integration Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Integration Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Integration Requested/Cancellation Confirmed'=>'Changing Status from \'Cancellation Integration Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Integration Requested/Cancellation Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Integration Requested/Change Confirmation Pending'=>'Changing Status from \'Cancellation Integration Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Cancellation Integration Requested/Change Confirmation Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Cancellation Integration Requested/Change Confirmed'=>'Changing Status from \'Cancellation Integration Requested\' to \'Change Confirmed\' is not allowed',
        'Cancellation Integration Requested/Change Integration Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Integration Requested/Change Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Change Requested\' is not allowed',
        'Cancellation Integration Requested/Complete'=>'Changing Status from \'Cancellation Integration Requested\' to \'Complete\' is not allowed',
        'Cancellation Integration Requested/Confirmation Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Integration Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Integration Requested/Hold Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Hold Requested\' is not allowed',
        'Cancellation Integration Requested/Hold'=>'Changing Status from \'Cancellation Integration Requested\' to \'Hold\' is not allowed',
        'Cancellation Integration Requested/Integration Error'=>'Changing Status from \'Cancellation Integration Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Integration Requested/Integration Requested'=>'Changing Status from \'Cancellation Integration Requested\' to \'Integration Requested\' is not allowed',
        'Cancellation Integration Requested/Shipped'=>'Changing Status from \'Cancellation Integration Requested\' to \'Shipped\' is not allowed',
        'Cancellation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Requested/Cancellation Confirmed'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Requested/Cancelled'=>'Changing Status from \'Cancellation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Requested/Change Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Cancellation Requested/Change Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Requested/Complete'=>'Changing Status from \'Cancellation Requested\' to \'Complete\' is not allowed',
        'Cancellation Requested/Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Requested/Integration Error'=>'Changing Status from \'Cancellation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Requested/Shipped'=>'Changing Status from \'Cancellation Requested\' to \'Shipped\' is not allowed',
        'Cancelled/Cancellation Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancelled/Cancellation Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancelled/Cancellation Confirmed'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmed\' is not allowed',
        'Cancelled/Cancellation Integration Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancelled/Cancellation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Requested\' is not allowed',
        'Cancelled/Change Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Change Confirmation Pending\' is not allowed',
        'Cancelled/Change Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Change Confirmation Requested\' is not allowed',
        'Cancelled/Change Confirmed'=>'Changing Status from \'Cancelled\' to \'Change Confirmed\' is not allowed',
        'Cancelled/Change Integration Requested'=>'Changing Status from \'Cancelled\' to \'Change Integration Requested\' is not allowed',
        'Cancelled/Change Requested'=>'Changing Status from \'Cancelled\' to \'Change Requested\' is not allowed',
        'Cancelled/Complete'=>'Changing Status from \'Cancelled\' to \'Complete\' is not allowed',
        'Cancelled/Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Confirmation Pending\' is not allowed',
        'Cancelled/Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Confirmation Requested\' is not allowed',
        'Cancelled/Confirmed'=>'Changing Status from \'Cancelled\' to \'Confirmed\' is not allowed',
        'Cancelled/Hold Release Requested'=>'Changing Status from \'Cancelled\' to \'Hold Release Requested\' is not allowed',
        'Cancelled/Hold Requested'=>'Changing Status from \'Cancelled\' to \'Hold Requested\' is not allowed',
        'Cancelled/Hold'=>'Changing Status from \'Cancelled\' to \'Hold\' is not allowed',
        'Cancelled/In Production'=>'Changing Status from \'Cancelled\' to \'In Production\' is not allowed',
        'Cancelled/Integration Error'=>'Changing Status from \'Cancelled\' to \'Integration Error\' is not allowed',
        'Cancelled/Integration Requested'=>'Changing Status from \'Cancelled\' to \'Integration Requested\' is not allowed',
        'Cancelled/Pre-Production'=>'Changing Status from \'Cancelled\' to \'Pre-Production\' is not allowed',
        'Cancelled/Pre-Release Review'=>'Changing Status from \'Cancelled\' to \'Pre-Release Review\' is not allowed',
        'Cancelled/Shipped'=>'Changing Status from \'Cancelled\' to \'Shipped\' is not allowed',
        'Cancelled/Partially Shipped'=>'Changing Status from \'Cancelled\' to \'Partially Shipped\' is not allowed',
        'Change Confirmation Pending/Cancellation Confirmation Pending'=>'Changing Status from \'Change Confirmation Pending\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Confirmation Pending/Cancellation Confirmation Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Change Confirmation Pending\' to \'Cancellation Confirmed\' is not allowed',
        'Change Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Cancellation Integration Requested\' is not allowed',
        'Change Confirmation Pending/Cancelled'=>'Changing Status from \'Change Confirmation Pending\' to \'Cancelled\' is not allowed',
        'Change Confirmation Pending/Change Confirmed'=>'Changing Status from \'Change Confirmation Pending\' to \'Change Confirmed\' is not allowed',
        'Change Confirmation Pending/Change Integration Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Change Integration Requested\' is not allowed',
        'Change Confirmation Pending/Complete'=>'Changing Status from \'Change Confirmation Pending\' to \'Complete\' is not allowed',
        'Change Confirmation Pending/Confirmation Pending'=>'Changing Status from \'Change Confirmation Pending\' to \'Confirmation Pending\' is not allowed',
        'Change Confirmation Pending/Confirmation Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Confirmation Requested\' is not allowed',
        'Change Confirmation Pending/Confirmed'=>'Changing Status from \'Change Confirmation Pending\' to \'Confirmed\' is not allowed',
        'Change Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Hold Release Requested\' is not allowed',
        'Change Confirmation Pending/Hold Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Hold Requested\' is not allowed',
        'Change Confirmation Pending/Hold'=>'Changing Status from \'Change Confirmation Pending\' to \'Hold\' is not allowed',
        'Change Confirmation Pending/Integration Error'=>'Changing Status from \'Change Confirmation Pending\' to \'Integration Error\' is not allowed',
        'Change Confirmation Pending/Integration Requested'=>'Changing Status from \'Change Confirmation Pending\' to \'Integration Requested\' is not allowed',
        'Change Confirmation Pending/Pre-Release Review'=>'Changing Status from \'Change Confirmation Pending\' to \'Pre-Release Review\' is not allowed',
        'Change Confirmation Pending/Shipped'=>'Changing Status from \'Change Confirmation Pending\' to \'Shipped\' is not allowed',
        'Change Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Confirmation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Confirmation Requested/Cancellation Confirmed'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Change Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Change Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Change Confirmation Requested/Cancelled'=>'Changing Status from \'Change Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Change Confirmation Requested/Change Integration Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Change Integration Requested\' is not allowed',
        'Change Confirmation Requested/Complete'=>'Changing Status from \'Change Confirmation Requested\' to \'Complete\' is not allowed',
        'Change Confirmation Requested/Confirmation Pending'=>'Changing Status from \'Change Confirmation Requested\' to \'Confirmation Pending\' is not allowed',
        'Change Confirmation Requested/Confirmation Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Confirmation Requested\' is not allowed',
        'Change Confirmation Requested/Confirmed'=>'Changing Status from \'Change Confirmation Requested\' to \'Confirmed\' is not allowed',
        'Change Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Change Confirmation Requested/Hold Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Hold Requested\' is not allowed',
        'Change Confirmation Requested/Hold'=>'Changing Status from \'Change Confirmation Requested\' to \'Hold\' is not allowed',
        'Change Confirmation Requested/Integration Error'=>'Changing Status from \'Change Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Change Confirmation Requested/Integration Requested'=>'Changing Status from \'Change Confirmation Requested\' to \'Integration Requested\' is not allowed',
        'Change Confirmation Requested/Pre-Release Review'=>'Changing Status from \'Change Confirmation Requested\' to \'Pre-Release Review\' is not allowed',
        'Change Confirmation Requested/Shipped'=>'Changing Status from \'Change Confirmation Requested\' to \'Shipped\' is not allowed',
        'Change Confirmed/Cancellation Confirmation Pending'=>'Changing Status from \'Change Confirmed\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Confirmed/Cancellation Confirmation Requested'=>'Changing Status from \'Change Confirmed\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Confirmed/Cancellation Confirmed'=>'Changing Status from \'Change Confirmed\' to \'Cancellation Confirmed\' is not allowed',
        'Change Confirmed/Cancellation Integration Requested'=>'Changing Status from \'Change Confirmed\' to \'Cancellation Integration Requested\' is not allowed',
        'Change Confirmed/Cancelled'=>'Changing Status from \'Change Confirmed\' to \'Cancelled\' is not allowed',
        'Change Confirmed/Complete'=>'Changing Status from \'Change Confirmed\' to \'Complete\' is not allowed',
        'Change Confirmed/Confirmation Pending'=>'Changing Status from \'Change Confirmed\' to \'Confirmation Pending\' is not allowed',
        'Change Confirmed/Confirmation Requested'=>'Changing Status from \'Change Confirmed\' to \'Confirmation Requested\' is not allowed',
        'Change Confirmed/Confirmed'=>'Changing Status from \'Change Confirmed\' to \'Confirmed\' is not allowed',
        'Change Confirmed/Hold Release Requested'=>'Changing Status from \'Change Confirmed\' to \'Hold Release Requested\' is not allowed',
        'Change Confirmed/Hold'=>'Changing Status from \'Change Confirmed\' to \'Hold\' is not allowed',
        'Change Confirmed/Integration Error'=>'Changing Status from \'Change Confirmed\' to \'Integration Error\' is not allowed',
        'Change Confirmed/Integration Requested'=>'Changing Status from \'Change Confirmed\' to \'Integration Requested\' is not allowed',
        'Change Confirmed/Pre-Release Review'=>'Changing Status from \'Change Confirmed\' to \'Pre-Release Review\' is not allowed',
        'Change Confirmed/Shipped'=>'Changing Status from \'Change Confirmed\' to \'Shipped\' is not allowed',
        'Change Integration Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Change Integration Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Integration Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Change Integration Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Integration Requested/Cancellation Confirmed'=>'Changing Status from \'Change Integration Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Change Integration Requested/Cancellation Integration Requested'=>'Changing Status from \'Change Integration Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Change Integration Requested/Cancelled'=>'Changing Status from \'Change Integration Requested\' to \'Cancelled\' is not allowed',
        'Change Integration Requested/Change Confirmation Requested'=>'Changing Status from \'Change Integration Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Change Integration Requested/Complete'=>'Changing Status from \'Change Integration Requested\' to \'Complete\' is not allowed',
        'Change Integration Requested/Confirmation Pending'=>'Changing Status from \'Change Integration Requested\' to \'Confirmation Pending\' is not allowed',
        'Change Integration Requested/Confirmation Requested'=>'Changing Status from \'Change Integration Requested\' to \'Confirmation Requested\' is not allowed',
        'Change Integration Requested/Confirmed'=>'Changing Status from \'Change Integration Requested\' to \'Confirmed\' is not allowed',
        'Change Integration Requested/Hold Release Requested'=>'Changing Status from \'Change Integration Requested\' to \'Hold Release Requested\' is not allowed',
        'Change Integration Requested/Hold'=>'Changing Status from \'Change Integration Requested\' to \'Hold\' is not allowed',
        'Change Integration Requested/Integration Error'=>'Changing Status from \'Change Integration Requested\' to \'Integration Error\' is not allowed',
        'Change Integration Requested/Integration Requested'=>'Changing Status from \'Change Integration Requested\' to \'Integration Requested\' is not allowed',
        'Change Integration Requested/Pre-Release Review'=>'Changing Status from \'Change Integration Requested\' to \'Pre-Release Review\' is not allowed',
        'Change Integration Requested/Shipped'=>'Changing Status from \'Change Integration Requested\' to \'Shipped\' is not allowed',
        'Change Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Requested/Cancellation Confirmed'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Change Requested/Cancellation Integration Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Change Requested/Cancelled'=>'Changing Status from \'Change Requested\' to \'Cancelled\' is not allowed',
        'Change Requested/Change Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Change Requested/Change Confirmed'=>'Changing Status from \'Change Requested\' to \'Change Confirmed\' is not allowed',
        'Change Requested/Complete'=>'Changing Status from \'Change Requested\' to \'Complete\' is not allowed',
        'Change Requested/Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Confirmation Pending\' is not allowed',
        'Change Requested/Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Confirmation Requested\' is not allowed',
        'Change Requested/Confirmed'=>'Changing Status from \'Change Requested\' to \'Confirmed\' is not allowed',
        'Change Requested/Hold Release Requested'=>'Changing Status from \'Change Requested\' to \'Hold Release Requested\' is not allowed',
        'Change Requested/Hold'=>'Changing Status from \'Change Requested\' to \'Hold\' is not allowed',
        'Change Requested/Integration Error'=>'Changing Status from \'Change Requested\' to \'Integration Error\' is not allowed',
        'Change Requested/Integration Requested'=>'Changing Status from \'Change Requested\' to \'Integration Requested\' is not allowed',
        'Change Requested/Pre-Release Review'=>'Changing Status from \'Change Requested\' to \'Pre-Release Review\' is not allowed',
        'Change Requested/Shipped'=>'Changing Status from \'Change Requested\' to \'Shipped\' is not allowed',
        'Complete/Cancellation Confirmation Pending'=>'Changing Status from \'Complete\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Complete/Cancellation Confirmation Requested'=>'Changing Status from \'Complete\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Complete/Cancellation Confirmed'=>'Changing Status from \'Complete\' to \'Cancellation Confirmed\' is not allowed',
        'Complete/Cancellation Integration Requested'=>'Changing Status from \'Complete\' to \'Cancellation Integration Requested\' is not allowed',
        'Complete/Cancellation Requested'=>'Changing Status from \'Complete\' to \'Cancellation Requested\' is not allowed',
        'Complete/Cancelled'=>'Changing Status from \'Complete\' to \'Cancelled\' is not allowed',
        'Complete/Change Confirmation Pending'=>'Changing Status from \'Complete\' to \'Change Confirmation Pending\' is not allowed',
        'Complete/Change Confirmation Requested'=>'Changing Status from \'Complete\' to \'Change Confirmation Requested\' is not allowed',
        'Complete/Change Confirmed'=>'Changing Status from \'Complete\' to \'Change Confirmed\' is not allowed',
        'Complete/Change Integration Requested'=>'Changing Status from \'Complete\' to \'Change Integration Requested\' is not allowed',
        'Complete/Change Requested'=>'Changing Status from \'Complete\' to \'Change Requested\' is not allowed',
        'Complete/Confirmation Pending'=>'Changing Status from \'Complete\' to \'Confirmation Pending\' is not allowed',
        'Complete/Confirmation Requested'=>'Changing Status from \'Complete\' to \'Confirmation Requested\' is not allowed',
        'Complete/Confirmed'=>'Changing Status from \'Complete\' to \'Confirmed\' is not allowed',
        'Complete/Hold Release Requested'=>'Changing Status from \'Complete\' to \'Hold Release Requested\' is not allowed',
        'Complete/Hold Requested'=>'Changing Status from \'Complete\' to \'Hold Requested\' is not allowed',
        'Complete/Hold'=>'Changing Status from \'Complete\' to \'Hold\' is not allowed',
        'Complete/In Production'=>'Changing Status from \'Complete\' to \'In Production\' is not allowed',
        'Complete/Integration Error'=>'Changing Status from \'Complete\' to \'Integration Error\' is not allowed',
        'Complete/Integration Requested'=>'Changing Status from \'Complete\' to \'Integration Requested\' is not allowed',
        'Complete/Pre-Production'=>'Changing Status from \'Complete\' to \'Pre-Production\' is not allowed',
        'Complete/Pre-Release Review'=>'Changing Status from \'Complete\' to \'Pre-Release Review\' is not allowed',
        'Complete/Shipped'=>'Changing Status from \'Complete\' to \'Shipped\' is not allowed',
        'Complete/Partially Shipped'=>'Changing Status from \'Complete\' to \'Partially Shipped\' is not allowed',
        'Confirmation Pending/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmation Pending/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmation Pending/Cancelled'=>'Changing Status from \'Confirmation Pending\' to \'Cancelled\' is not allowed',
        'Confirmation Pending/Change Confirmation Pending'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmation Pending/Change Confirmation Requested'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmation Requested\' is not allowed',
        'Confirmation Pending/Change Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmed\' is not allowed',
        'Confirmation Pending/Change Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Change Integration Requested\' is not allowed',
        'Confirmation Pending/Change Requested'=>'Changing Status from \'Confirmation Pending\' to \'Change Requested\' is not allowed',
        'Confirmation Pending/Complete'=>'Changing Status from \'Confirmation Pending\' to \'Complete\' is not allowed',
        'Confirmation Pending/Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Confirmed\' is not allowed. You must first request confirmation.',
        'Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Confirmation Pending\' to \'Hold Release Requested\' is not allowed',
        'Confirmation Pending/Hold'=>'Changing Status from \'Confirmation Pending\' to \'Hold\' is not allowed',
        'Confirmation Pending/In Production'=>'Changing Status from \'Confirmation Pending\' to \'In Production\' is not allowed',
        'Confirmation Pending/Integration Error'=>'Changing Status from \'Confirmation Pending\' to \'Integration Error\' is not allowed',
        'Confirmation Pending/Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Integration Requested\' is not allowed',
        'Confirmation Pending/Pre-Production'=>'Changing Status from \'Confirmation Pending\' to \'Pre-Production\' is not allowed',
        'Confirmation Pending/Shipped'=>'Changing Status from \'Confirmation Pending\' to \'Shipped\' is not allowed',
        'Confirmation Pending/Partially Shipped'=>'Changing Status from \'Confirmation Pending\' to \'Partially Shipped\' is not allowed',
        'Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmation Requested/Cancellation Confirmed'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Confirmation Requested/Cancelled'=>'Changing Status from \'Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Confirmation Requested/Change Confirmation Pending'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmation Requested/Change Confirmation Requested'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Confirmation Requested/Change Confirmed'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmed\' is not allowed',
        'Confirmation Requested/Change Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Change Integration Requested\' is not allowed',
        'Confirmation Requested/Change Requested'=>'Changing Status from \'Confirmation Requested\' to \'Change Requested\' is not allowed',
        'Confirmation Requested/Complete'=>'Changing Status from \'Confirmation Requested\' to \'Complete\' is not allowed',
        'Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Confirmation Requested/Hold Requested'=>'Changing Status from \'Confirmation Requested\' to \'Hold Requested\' is not allowed',
        'Confirmation Requested/Hold'=>'Changing Status from \'Confirmation Requested\' to \'Hold\' is not allowed',
        'Confirmation Requested/In Production'=>'Changing Status from \'Confirmation Requested\' to \'In Production\' is not allowed',
        'Confirmation Requested/Integration Error'=>'Changing Status from \'Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Confirmation Requested/Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Integration Requested\' is not allowed',
        'Confirmation Requested/Pre-Production'=>'Changing Status from \'Confirmation Requested\' to \'Pre-Production\' is not allowed',
        'Confirmation Requested/Shipped'=>'Changing Status from \'Confirmation Requested\' to \'Shipped\' is not allowed',
        'Confirmation Requested/Partially Shipped'=>'Changing Status from \'Confirmation Requested\' to \'Partially Shipped\' is not allowed',
        'Confirmed/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmed/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmed/Cancellation Confirmed'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmed/Cancellation Integration Requested'=>'Changing Status from \'Confirmed\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmed/Cancelled'=>'Changing Status from \'Confirmed\' to \'Cancelled\' is not allowed',
        'Confirmed/Change Confirmation Pending'=>'Changing Status from \'Confirmed\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmed/Change Confirmation Requested'=>'Changing Status from \'Confirmed\' to \'Change Confirmation Requested\' is not allowed',
        'Confirmed/Change Confirmed'=>'Changing Status from \'Confirmed\' to \'Change Confirmed\' is not allowed',
        'Confirmed/Change Integration Requested'=>'Changing Status from \'Confirmed\' to \'Change Integration Requested\' is not allowed',
        'Confirmed/Change Requested'=>'Changing Status from \'Confirmed\' to \'Change Requested\' is not allowed',
        'Confirmed/Complete'=>'Changing Status from \'Confirmed\' to \'Complete\' is not allowed',
        'Confirmed/Hold Release Requested'=>'Changing Status from \'Confirmed\' to \'Hold Release Requested\' is not allowed',
        'Confirmed/Hold'=>'Changing Status from \'Confirmed\' to \'Hold\' is not allowed',
        'Confirmed/In Production'=>'Changing Status from \'Confirmed\' to \'In Production\' is not allowed',
        'Confirmed/Integration Error'=>'Changing Status from \'Confirmed\' to \'Integration Error\' is not allowed',
        'Confirmed/Pre-Production'=>'Changing Status from \'Confirmed\' to \'Pre-Production\' is not allowed',
        'Confirmed/Shipped'=>'Changing Status from \'Confirmed\' to \'Shipped\' is not allowed',
        'Confirmed/Partially Shipped'=>'Changing Status from \'Confirmed\' to \'Partially Shipped\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Release Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Release Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Release Requested/Cancellation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Requested\' is not allowed',
        'Hold Release Requested/Cancelled'=>'Changing Status from \'Hold Release Requested\' to \'Cancelled\' is not allowed',
        'Hold Release Requested/Change Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Hold Release Requested/Change Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Change Integration Requested\' is not allowed',
        'Hold Release Requested/Complete'=>'Changing Status from \'Hold Release Requested\' to \'Complete\' is not allowed',
        'Hold Release Requested/Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Confirmation Requested\' is not allowed',
        'Hold Release Requested/Hold'=>'Changing Status from \'Hold Release Requested\' to \'Hold\' is not allowed',
        'Hold Release Requested/Integration Error'=>'Changing Status from \'Hold Release Requested\' to \'Integration Error\' is not allowed',
        'Hold Release Requested/Shipped'=>'Changing Status from \'Hold Release Requested\' to \'Shipped\' is not allowed',
        'Hold Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Requested/Cancellation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Requested\' is not allowed',
        'Hold Requested/Cancelled'=>'Changing Status from \'Hold Requested\' to \'Cancelled\' is not allowed',
        'Hold Requested/Change Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Hold Requested/Change Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Hold Requested/Change Confirmed'=>'Changing Status from \'Hold Requested\' to \'Change Confirmed\' is not allowed',
        'Hold Requested/Change Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Change Integration Requested\' is not allowed',
        'Hold Requested/Complete'=>'Changing Status from \'Hold Requested\' to \'Complete\' is not allowed',
        'Hold Requested/Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Confirmation Requested\' is not allowed',
        'Hold Requested/Hold Release Requested'=>'Changing Status from \'Hold Requested\' to \'Hold Release Requested\' is not allowed',
        'Hold Requested/Shipped'=>'Changing Status from \'Hold Requested\' to \'Shipped\' is not allowed',
        'Hold/Cancellation Confirmation Pending'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold/Cancellation Confirmation Requested'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold/Cancellation Confirmed'=>'Changing Status from \'Hold\' to \'Cancellation Confirmed\' is not allowed',
        'Hold/Cancellation Integration Requested'=>'Changing Status from \'Hold\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold/Cancelled'=>'Changing Status from \'Hold\' to \'Cancelled\' is not allowed',
        'Hold/Change Confirmation Pending'=>'Changing Status from \'Hold\' to \'Change Confirmation Pending\' is not allowed',
        'Hold/Change Confirmation Requested'=>'Changing Status from \'Hold\' to \'Change Confirmation Requested\' is not allowed',
        'Hold/Change Confirmed'=>'Changing Status from \'Hold\' to \'Change Confirmed\' is not allowed',
        'Hold/Change Integration Requested'=>'Changing Status from \'Hold\' to \'Change Integration Requested\' is not allowed',
        'Hold/Change Requested'=>'Changing Status from \'Hold\' to \'Change Requested\' is not allowed',
        'Hold/Complete'=>'Changing Status from \'Hold\' to \'Complete\' is not allowed',
        'Hold/Confirmation Pending'=>'Changing Status from \'Hold\' to \'Confirmation Pending\' is not allowed',
        'Hold/Confirmation Requested'=>'Changing Status from \'Hold\' to \'Confirmation Requested\' is not allowed',
        'Hold/Confirmed'=>'Changing Status from \'Hold\' to \'Confirmed\' is not allowed',
        'Hold/Hold Requested'=>'Changing Status from \'Hold\' to \'Hold Requested\' is not allowed',
        'Hold/In Production'=>'Changing Status from \'Hold\' to \'In Production\' is not allowed',
        'Hold/Integration Error'=>'Changing Status from \'Hold\' to \'Integration Error\' is not allowed',
        'Hold/Integration Requested'=>'Changing Status from \'Hold\' to \'Integration Requested\' is not allowed',
        'Hold/Pre-Production'=>'Changing Status from \'Hold\' to \'Pre-Production\' is not allowed',
        'Hold/Pre-Release Review'=>'Changing Status from \'Hold\' to \'Pre-Release Review\' is not allowed',
        'Hold/Shipped'=>'Changing Status from \'Hold\' to \'Shipped\' is not allowed',
        'Hold/Partially Shipped'=>'Changing Status from \'Hold\' to \'Partially Shipped\' is not allowed',
        'In Production/Cancellation Confirmation Pending'=>'Changing Status from \'In Production\' to \'Cancellation Confirmation Pending\' is not allowed',
        'In Production/Cancellation Confirmation Requested'=>'Changing Status from \'In Production\' to \'Cancellation Confirmation Requested\' is not allowed',
        'In Production/Cancellation Confirmed'=>'Changing Status from \'In Production\' to \'Cancellation Confirmed\' is not allowed',
        'In Production/Cancellation Integration Requested'=>'Changing Status from \'In Production\' to \'Cancellation Integration Requested\' is not allowed',
        'In Production/Cancelled'=>'Changing Status from \'In Production\' to \'Cancelled\' is not allowed',
        'In Production/Change Confirmed'=>'Changing Status from \'In Production\' to \'Change Confirmed\' is not allowed',
        'In Production/Change Integration Requested'=>'Changing Status from \'In Production\' to \'Change Integration Requested\' is not allowed',
        'In Production/Complete'=>'Changing Status from \'In Production\' to \'Complete\' is not allowed',
        'In Production/Confirmation Pending'=>'Changing Status from \'In Production\' to \'Confirmation Pending\' is not allowed',
        'In Production/Confirmation Requested'=>'Changing Status from \'In Production\' to \'Confirmation Requested\' is not allowed',
        'In Production/Confirmed'=>'Changing Status from \'In Production\' to \'Confirmed\' is not allowed',
        'In Production/Hold Release Requested'=>'Changing Status from \'In Production\' to \'Hold Release Requested\' is not allowed',
        'In Production/Hold'=>'Changing Status from \'In Production\' to \'Hold\' is not allowed',
        'In Production/Integration Error'=>'Changing Status from \'In Production\' to \'Integration Error\' is not allowed',
        'In Production/Integration Requested'=>'Changing Status from \'In Production\' to \'Integration Requested\' is not allowed',
        'In Production/Pre-Production'=>'Changing Status from \'In Production\' to \'Pre-Production\' is not allowed',
        'In Production/Pre-Release Review'=>'Changing Status from \'In Production\' to \'Pre-Release Review\' is not allowed',
        'Integration Error/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Error\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Integration Error/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Integration Error/Cancelled'=>'Changing Status from \'Integration Error\' to \'Cancelled\' is not allowed',
        'Integration Error/Change Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Change Confirmation Requested\' is not allowed',
        'Integration Error/Complete'=>'Changing Status from \'Integration Error\' to \'Complete\' is not allowed',
        'Integration Error/Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Confirmation Requested\' is not allowed',
        'Integration Error/Hold'=>'Changing Status from \'Integration Error\' to \'Hold\' is not allowed',
        'Integration Error/Shipped'=>'Changing Status from \'Integration Error\' to \'Shipped\' is not allowed',
        'Integration Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Integration Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Integration Requested/Cancellation Confirmed'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Integration Requested/Cancellation Integration Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Integration Requested/Cancellation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Requested\' is not allowed',
        'Integration Requested/Cancelled'=>'Changing Status from \'Integration Requested\' to \'Cancelled\' is not allowed',
        'Integration Requested/Change Confirmation Pending'=>'Changing Status from \'Integration Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Integration Requested/Change Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Change Confirmation Requested\' is not allowed',
        'Integration Requested/Change Confirmed'=>'Changing Status from \'Integration Requested\' to \'Change Confirmed\' is not allowed',
        'Integration Requested/Change Integration Requested'=>'Changing Status from \'Integration Requested\' to \'Change Integration Requested\' is not allowed',
        'Integration Requested/Change Requested'=>'Changing Status from \'Integration Requested\' to \'Change Requested\' is not allowed',
        'Integration Requested/Complete'=>'Changing Status from \'Integration Requested\' to \'Complete\' is not allowed',
        'Integration Requested/Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Confirmation Requested\' is not allowed',
        'Integration Requested/Hold Release Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Release Requested\' is not allowed',
        'Integration Requested/Hold Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Requested\' is not allowed',
        'Integration Requested/Hold'=>'Changing Status from \'Integration Requested\' to \'Hold\' is not allowed',
        'Integration Requested/In Production'=>'Changing Status from \'Integration Requested\' to \'In Production\' is not allowed',
        'Integration Requested/Shipped'=>'Changing Status from \'Integration Requested\' to \'Shipped\' is not allowed',
        'Integration Requested/Partially Shipped'=>'Changing Status from \'Integration Requested\' to \'Partially Shipped\' is not allowed',
        'Pre-Production/Cancellation Confirmation Pending'=>'Changing Status from \'Pre-Production\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Pre-Production/Cancellation Confirmation Requested'=>'Changing Status from \'Pre-Production\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Pre-Production/Cancellation Confirmed'=>'Changing Status from \'Pre-Production\' to \'Cancellation Confirmed\' is not allowed',
        'Pre-Production/Cancellation Integration Requested'=>'Changing Status from \'Pre-Production\' to \'Cancellation Integration Requested\' is not allowed',
        'Pre-Production/Cancelled'=>'Changing Status from \'Pre-Production\' to \'Cancelled\' is not allowed',
        'Pre-Production/Change Confirmed'=>'Changing Status from \'Pre-Production\' to \'Change Confirmed\' is not allowed',
        'Pre-Production/Change Integration Requested'=>'Changing Status from \'Pre-Production\' to \'Change Integration Requested\' is not allowed',
        'Pre-Production/Complete'=>'Changing Status from \'Pre-Production\' to \'Complete\' is not allowed',
        'Pre-Production/Confirmation Pending'=>'Changing Status from \'Pre-Production\' to \'Confirmation Pending\' is not allowed',
        'Pre-Production/Confirmation Requested'=>'Changing Status from \'Pre-Production\' to \'Confirmation Requested\' is not allowed',
        'Pre-Production/Confirmed'=>'Changing Status from \'Pre-Production\' to \'Confirmed\' is not allowed',
        'Pre-Production/Hold Release Requested'=>'Changing Status from \'Pre-Production\' to \'Hold Release Requested\' is not allowed',
        'Pre-Production/Hold'=>'Changing Status from \'Pre-Production\' to \'Hold\' is not allowed',
        'Pre-Production/Integration Error'=>'Changing Status from \'Pre-Production\' to \'Integration Error\' is not allowed',
        'Pre-Production/Integration Requested'=>'Changing Status from \'Pre-Production\' to \'Integration Requested\' is not allowed',
        'Pre-Production/Pre-Release Review'=>'Changing Status from \'Pre-Production\' to \'Pre-Release Review\' is not allowed',
        'Pre-Production/Shipped'=>'Changing Status from \'Pre-Production\' to \'Shipped\' is not allowed',
        'Pre-Production/Partially Shipped'=>'Changing Status from \'Pre-Production\' to \'Partially Shipped\' is not allowed',
        'Pre-Release Review/Cancellation Confirmation Pending'=>'Changing Status from \'Pre-Release Review\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Pre-Release Review/Cancellation Confirmation Requested'=>'Changing Status from \'Pre-Release Review\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Pre-Release Review/Cancellation Confirmed'=>'Changing Status from \'Pre-Release Review\' to \'Cancellation Confirmed\' is not allowed',
        'Pre-Release Review/Cancellation Integration Requested'=>'Changing Status from \'Pre-Release Review\' to \'Cancellation Integration Requested\' is not allowed',
        'Pre-Release Review/Cancelled'=>'Changing Status from \'Pre-Release Review\' to \'Cancelled\' is not allowed',
        'Pre-Release Review/Change Confirmation Pending'=>'Changing Status from \'Pre-Release Review\' to \'Change Confirmation Pending\' is not allowed',
        'Pre-Release Review/Change Confirmation Requested'=>'Changing Status from \'Pre-Release Review\' to \'Change Confirmation Requested\' is not allowed',
        'Pre-Release Review/Change Confirmed'=>'Changing Status from \'Pre-Release Review\' to \'Change Confirmed\' is not allowed',
        'Pre-Release Review/Change Integration Requested'=>'Changing Status from \'Pre-Release Review\' to \'Change Integration Requested\' is not allowed',
        'Pre-Release Review/Change Requested'=>'Changing Status from \'Pre-Release Review\' to \'Change Requested\' is not allowed',
        'Pre-Release Review/Complete'=>'Changing Status from \'Pre-Release Review\' to \'Complete\' is not allowed',
        'Pre-Release Review/Confirmed'=>'Changing Status from \'Pre-Release Review\' to \'Confirmed\' is not allowed',
        'Pre-Release Review/Hold Release Requested'=>'Changing Status from \'Pre-Release Review\' to \'Hold Release Requested\' is not allowed',
        'Pre-Release Review/Hold'=>'Changing Status from \'Pre-Release Review\' to \'Hold\' is not allowed',
        'Pre-Release Review/In Production'=>'Changing Status from \'Pre-Release Review\' to \'In Production\' is not allowed',
        'Pre-Release Review/Integration Error'=>'Changing Status from \'Pre-Release Review\' to \'Integration Error\' is not allowed',
        'Pre-Release Review/Pre-Production'=>'Changing Status from \'Pre-Release Review\' to \'Pre-Production\' is not allowed',
        'Pre-Release Review/Shipped'=>'Changing Status from \'Pre-Release Review\' to \'Shipped\' is not allowed',
        'Pre-Release Review/Partially Shipped'=>'Changing Status from \'Pre-Release Review\' to \'Partially Shipped\' is not allowed',
        'Shipped/Cancellation Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Shipped/Cancellation Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Shipped/Cancellation Confirmed'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmed\' is not allowed',
        'Shipped/Cancellation Integration Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Integration Requested\' is not allowed',
        'Shipped/Cancellation Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Requested\' is not allowed',
        'Shipped/Cancelled'=>'Changing Status from \'Shipped\' to \'Cancelled\' is not allowed',
        'Shipped/Change Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Change Confirmation Pending\' is not allowed',
        'Shipped/Change Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Change Confirmation Requested\' is not allowed',
        'Shipped/Change Confirmed'=>'Changing Status from \'Shipped\' to \'Change Confirmed\' is not allowed',
        'Shipped/Change Integration Requested'=>'Changing Status from \'Shipped\' to \'Change Integration Requested\' is not allowed',
        'Shipped/Change Requested'=>'Changing Status from \'Shipped\' to \'Change Requested\' is not allowed',
        'Shipped/Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Confirmation Pending\' is not allowed',
        'Shipped/Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Confirmation Requested\' is not allowed',
        'Shipped/Confirmed'=>'Changing Status from \'Shipped\' to \'Confirmed\' is not allowed',
        'Shipped/Hold Release Requested'=>'Changing Status from \'Shipped\' to \'Hold Release Requested\' is not allowed',
        'Shipped/Hold Requested'=>'Changing Status from \'Shipped\' to \'Hold Requested\' is not allowed',
        'Shipped/Hold'=>'Changing Status from \'Shipped\' to \'Hold\' is not allowed',
        'Shipped/In Production'=>'Changing Status from \'Shipped\' to \'In Production\' is not allowed',
        'Shipped/Integration Error'=>'Changing Status from \'Shipped\' to \'Integration Error\' is not allowed',
        'Shipped/Integration Requested'=>'Changing Status from \'Shipped\' to \'Integration Requested\' is not allowed',
        'Shipped/Pre-Production'=>'Changing Status from \'Shipped\' to \'Pre-Production\' is not allowed',
        'Shipped/Pre-Release Review'=>'Changing Status from \'Shipped\' to \'Pre-Release Review\' is not allowed',
        'Shipped/Partially Shipped'=>'Changing Status from \'Shipped\' to \'Partially Shipped\' is not allowed',
        'Partially Shipped/Cancellation Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Requested\' is not allowed',//Rekha: Dont allow cancellations from partially shipped status CANCELLATION_BUGS_SEP_20    
        'Partially Shipped/Cancellation Confirmation Pending'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Partially Shipped/Cancellation Confirmation Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Partially Shipped/Cancellation Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmed\' is not allowed',
        'Partially Shipped/Cancellation Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Integration Requested\' is not allowed',
        'Partially Shipped/Cancelled'=>'Changing Status from \'Partially Shipped\' to \'Cancelled\' is not allowed',
        'Partially Shipped/Change Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Change Confirmed\' is not allowed',
        'Partially Shipped/Change Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Change Integration Requested\' is not allowed',
        'Partially Shipped/Confirmation Pending'=>'Changing Status from \'Partially Shipped\' to \'Confirmation Pending\' is not allowed',
        'Partially Shipped/Confirmation Requested'=>'Changing Status from \'Partially Shipped\' to \'Confirmation Requested\' is not allowed',
        'Partially Shipped/Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Confirmed\' is not allowed',
        'Partially Shipped/Hold Release Requested'=>'Changing Status from \'Partially Shipped\' to \'Hold Release Requested\' is not allowed',
        'Partially Shipped/Hold'=>'Changing Status from \'Partially Shipped\' to \'Hold\' is not allowed',
        'Partially Shipped/In Production'=>'Changing Status from \'Partially Shipped\' to \'In Production\' is not allowed',
        'Partially Shipped/Integration Error'=>'Changing Status from \'Partially Shipped\' to \'Integration Error\' is not allowed',
        'Partially Shipped/Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Integration Requested\' is not allowed',
        'Partially Shipped/Pre-Production'=>'Changing Status from \'Partially Shipped\' to \'Pre-Production\' is not allowed',
        'Partially Shipped/Pre-Release Review'=>'Changing Status from \'Partially Shipped\' to \'Pre-Release Review\' is not allowed',
        'Cancellation Integration Requested/Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Confirmed'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/In Production'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Pre-Production'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Pre-Release Review'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Partially Shipped'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Cancellation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Change Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Change Confirmed'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Hold Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/In Production'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Pre-Production'=>'Status change not allowed; Oracle integration in progress.',
        'Change Integration Requested/Partially Shipped'=>'Status change not allowed; Oracle integration in progress.',
        'Integration Requested/Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Integration Requested/Confirmed'=>'Status change not allowed; Oracle integration in progress.',
        'Integration Requested/Pre-Release Review'=>'Status change not allowed; Oracle integration in progress.'
    };
    public static Map<String,String> statusHWErrorMsg = new Map<String,String>{
        'Draft/Integration Error'=>'Changing Status from \'Draft\' to \'Confirmation Pending\' is not allowed',
        'Draft/Planned'=>'Changing Status from \'Draft\' to \'Planned\' is not allowed',
        'Draft/Change Requested'=>'Changing Status from \'Draft\' to \'Change Requested\' is not allowed',
        'Draft/Confirmation Pending'=>'Changing Status from \'Draft\' to \'Confirmation Pending\' is not allowed',
        'Draft/Confirmation Requested'=>'Changing Status from \'Draft\' to \'Confirmation Requested\' is not allowed',
        'Draft/Confirmed'=>'Changing Status from \'Draft\' to \'Confirmed\' is not allowed',
        'Draft/Approved-to-Ship'=>'Changing Status from \'Draft\' to \'Approved-to-Ship\' is not allowed',
        'Draft/Partially Shipped'=>'Changing Status from \'Draft\' to \'Partially Shipped\' is not allowed',
        'Draft/Shipped'=>'Changing Status from \'Draft\' to \'Shipped\' is not allowed',
        'Draft/Cancellation Confirmation Pending'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Draft/Cancellation Confirmation Requested'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Draft/Cancellation Confirmed'=>'Changing Status from \'Draft\' to \'Cancellation Confirmed\' is not allowed',
        'Draft/Cancellation Integration Requested'=>'Changing Status from \'Draft\' to \'Cancellation Integration Requested\' is not allowed',
        'Draft/Cancelled'=>'Changing Status from \'Draft\' to \'Cancelled\' is not allowed',
        'Draft/Hold'=>'Changing Status from \'Draft\' to \'Hold\' is not allowed',
        'Draft/Hold Release Requested'=>'Changing Status from \'Draft\' to \'Hold Release Requested\' is not allowed',
        'Integration Requested/Integration Error'=>'Changing Status from \'Integration Requested\' to \'Integration Error\' is not allowed',
        'Integration Requested/Planned'=>'Changing Status from \'Integration Requested\' to \'Planned\' is not allowed',
        'Integration Requested/Change Requested'=>'Changing Status from \'Integration Requested\' to \'Change Requested\' is not allowed',
        'Integration Requested/Confirmation Pending'=>'Changing Status from \'Integration Requested\' to \'Confirmation Pending\' is not allowed',
        'Integration Requested/Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Confirmation Requested\' is not allowed',
        'Integration Requested/Confirmed'=>'Changing Status from \'Integration Requested\' to \'Confirmed\' is not allowed',
        'Integration Requested/Approved-to-Ship'=>'Changing Status from \'Integration Requested\' to \'Approved-to-Ship\' is not allowed',
        'Integration Requested/Partially Shipped'=>'Changing Status from \'Integration Requested\' to \'Partially Shipped\' is not allowed',
        'Integration Requested/Shipped'=>'Changing Status from \'Integration Requested\' to \'Shipped\' is not allowed',
        'Integration Requested/Cancellation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Requested\' is not allowed',
        'Integration Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Integration Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Integration Requested/Cancellation Confirmed'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Integration Requested/Cancellation Integration Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Integration Requested/Cancelled'=>'Changing Status from \'Integration Requested\' to \'Cancelled\' is not allowed',
        'Integration Requested/Hold Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Requested\' is not allowed',
        'Integration Requested/Hold'=>'Changing Status from \'Integration Requested\' to \'Hold\' is not allowed',
        'Integration Requested/Hold Release Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Release Requested\' is not allowed',
        'Integration Error/Planned'=>'Changing Status from \'Integration Error\' to \'Planned\' is not allowed',
        'Integration Error/Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Confirmation Requested\' is not allowed',
        'Integration Error/Approved-to-Ship'=>'Changing Status from \'Integration Error\' to \'Approved-to-Ship\' is not allowed',
        'Integration Error/Shipped'=>'Changing Status from \'Integration Error\' to \'Shipped\' is not allowed',
        'Integration Error/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Error\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Integration Error/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Planned/Draft'=>'Changing Status from \'Planned\' to \'Draft\' is not allowed',
        'Planned/Integration Requested'=>'Changing Status from \'Planned\' to \'Integration Requested\' is not allowed',
        'Planned/Integration Error'=>'Changing Status from \'Planned\' to \'Integration Error\' is not allowed',
        'Planned/Change Requested'=>'Changing Status from \'Planned\' to \'Change Requested\' is not allowed',
        'Planned/Confirmation Pending'=>'Changing Status from \'Planned\' to \'Confirmation Pending\' is not allowed',
        'Planned/Confirmed'=>'Changing Status from \'Planned\' to \'Confirmed\' is not allowed',
        'Planned/Approved-to-Ship'=>'Changing Status from \'Planned\' to \'Approved-to-Ship\' is not allowed',
        'Planned/Partially Shipped'=>'Changing Status from \'Planned\' to \'Partially Shipped\' is not allowed',
        'Planned/Shipped'=>'Changing Status from \'Planned\' to \'Shipped\' is not allowed',
        'Planned/Cancellation Confirmation Pending'=>'Changing Status from \'Planned\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Planned/Cancellation Confirmation Requested'=>'Changing Status from \'Planned\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Planned/Cancellation Confirmed'=>'Changing Status from \'Planned\' to \'Cancellation Confirmed\' is not allowed',
        'Planned/Cancellation Integration Requested'=>'Changing Status from \'Planned\' to \'Cancellation Integration Requested\' is not allowed',
        'Planned/Cancelled'=>'Changing Status from \'Planned\' to \'Cancelled\' is not allowed',
        'Planned/Hold'=>'Changing Status from \'Planned\' to \'Hold\' is not allowed',
        'Planned/Hold Release Requested'=>'Changing Status from \'Planned\' to \'Hold Release Requested\' is not allowed',
        'Planned/Change Confirmation Pending'=>'Changing Status from \'Planned\' to \'Change Confirmation Pending\' is not allowed',
        'Planned/Change Confirmation Required'=>'Changing Status from \'Planned\' to \'Change Confirmation Required\' is not allowed',
        'Planned/Change Confirmed'=>'Changing Status from \'Planned\' to \'Change Confirmed\' is not allowed',
        'Planned/Change Integration Requested'=>'Changing Status from \'Planned\' to \'Change Integration Requested\' is not allowed',
        'Change Requested/Draft'=>'Changing Status from \'Change Requested\' to \'Draft\' is not allowed',
        'Change Requested/Integration Requested'=>'Changing Status from \'Change Requested\' to \'Integration Requested\' is not allowed',
        'Change Requested/Integration Error'=>'Changing Status from \'Change Requested\' to \'Integration Error\' is not allowed',
        'Change Requested/Planned'=>'Changing Status from \'Change Requested\' to \'Planned\' is not allowed',
        'Change Requested/Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Confirmation Pending\' is not allowed',
        'Change Requested/Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Confirmation Requested\' is not allowed',
        'Change Requested/Confirmed'=>'Changing Status from \'Change Requested\' to \'Confirmed\' is not allowed',
        'Change Requested/Approved-to-Ship'=>'Changing Status from \'Change Requested\' to \'Approved-to-Ship\' is not allowed',
        'Change Requested/Partially Shipped'=>'Changing Status from \'Change Requested\' to \'Partially Shipped\' is not allowed',
        'Change Requested/Shipped'=>'Changing Status from \'Change Requested\' to \'Shipped\' is not allowed',
        'Change Requested/Cancellation Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Requested\' is not allowed',
        'Change Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Requested/Cancellation Confirmed'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Change Requested/Change Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Change Requested/Change Confirmation Required'=>'Changing Status from \'Change Requested\' to \'Change Confirmation Required\' is not allowed',
        'Change Requested/Change Confirmed'=>'Changing Status from \'Change Requested\' to \'Change Confirmed\' is not allowed',
        'Change Requested/Change Integration Requested'=>'Changing Status from \'Change Requested\' to \'Change Integration Requested\' is not allowed',
        'Confirmation Pending/Draft'=>'Changing Status from \'Confirmation Pending\' to \'Draft\' is not allowed',
        'Confirmation Pending/Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Integration Requested\' is not allowed',
        'Confirmation Pending/Integration Error'=>'Changing Status from \'Confirmation Pending\' to \'Integration Error\' is not allowed',
        'Confirmation Pending/Change Requested'=>'Changing Status from \'Confirmation Pending\' to \'Change Requested\' is not allowed',
        'Confirmation Pending/Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Confirmed\' is not allowed',
        'Confirmation Pending/Approved-to-Ship'=>'Changing Status from \'Confirmation Pending\' to \'Approved-to-Ship\' is not allowed',
        'Confirmation Pending/Shipped'=>'Changing Status from \'Confirmation Pending\' to \'Shipped\' is not allowed',
        'Confirmation Pending/Cancellation Requested'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Requested\' is not allowed',
        'Confirmation Pending/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmation Pending/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmation Pending/Cancelled'=>'Changing Status from \'Confirmation Pending\' to \'Cancelled\' is not allowed',
        'Confirmation Pending/Hold Requested'=>'Changing Status from \'Confirmation Pending\' to \'Hold Requested\' is not allowed',
        'Confirmation Pending/Hold'=>'Changing Status from \'Confirmation Pending\' to \'Hold\' is not allowed',
        'Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Confirmation Pending\' to \'Hold Release Requested\' is not allowed',
        'Confirmation Pending/Change Confirmation Pending'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmation Pending/Change Confirmation Required'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmation Required\' is not allowed',
        'Confirmation Pending/Change Confirmed'=>'Changing Status from \'Confirmation Pending\' to \'Change Confirmed\' is not allowed',
        'Confirmation Pending/Change Integration Requested'=>'Changing Status from \'Confirmation Pending\' to \'Change Integration Requested\' is not allowed',
        'Confirmation Requested/Draft'=>'Changing Status from \'Confirmation Requested\' to \'Draft\' is not allowed',
        'Confirmation Requested/Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Integration Requested\' is not allowed',
        'Confirmation Requested/Integration Error'=>'Changing Status from \'Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Confirmation Requested/Planned'=>'Changing Status from \'Confirmation Requested\' to \'Planned\' is not allowed',
        'Confirmation Requested/Change Requested'=>'Changing Status from \'Confirmation Requested\' to \'Change Requested\' is not allowed',
        'Confirmation Requested/Approved-to-Ship'=>'Changing Status from \'Confirmation Requested\' to \'Approved-to-Ship\' is not allowed',
        'Confirmation Requested/Partially Shipped'=>'Changing Status from \'Confirmation Requested\' to \'Partially Shipped\' is not allowed',
        'Confirmation Requested/Shipped'=>'Changing Status from \'Confirmation Requested\' to \'Shipped\' is not allowed',
        'Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmation Requested/Cancellation Confirmed'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmation Requested/Cancelled'=>'Changing Status from \'Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Confirmation Requested/Hold Requested'=>'Changing Status from \'Confirmation Requested\' to \'Hold Requested\' is not allowed',
        'Confirmation Requested/Hold'=>'Changing Status from \'Confirmation Requested\' to \'Hold\' is not allowed',
        'Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Confirmation Requested/Change Confirmation Pending'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmation Requested/Change Confirmation Required'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmation Required\' is not allowed',
        'Confirmation Requested/Change Confirmed'=>'Changing Status from \'Confirmation Requested\' to \'Change Confirmed\' is not allowed',
        'Confirmation Requested/Change Integration Requested'=>'Changing Status from \'Confirmation Requested\' to \'Change Integration Requested\' is not allowed',
        'Confirmed/Draft'=>'Changing Status from \'Confirmed\' to \'Draft\' is not allowed',
        'Confirmed/Integration Requested'=>'Changing Status from \'Confirmed\' to \'Integration Requested\' is not allowed',
        'Confirmed/Integration Error'=>'Changing Status from \'Confirmed\' to \'Integration Error\' is not allowed',
        'Confirmed/Change Requested'=>'Changing Status from \'Confirmed\' to \'Change Requested\' is not allowed',
        'Confirmed/Partially Shipped'=>'Changing Status from \'Confirmed\' to \'Partially Shipped\' is not allowed',
        'Confirmed/Shipped'=>'Changing Status from \'Confirmed\' to \'Shipped\' is not allowed',
        'Confirmed/Cancellation Confirmation Pending'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Confirmed/Cancellation Confirmation Requested'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Confirmed/Cancellation Confirmed'=>'Changing Status from \'Confirmed\' to \'Cancellation Confirmed\' is not allowed',
        'Confirmed/Cancellation Integration Requested'=>'Changing Status from \'Confirmed\' to \'Cancellation Integration Requested\' is not allowed',
        'Confirmed/Cancelled'=>'Changing Status from \'Confirmed\' to \'Cancelled\' is not allowed',
        'Confirmed/Hold'=>'Changing Status from \'Confirmed\' to \'Hold\' is not allowed',
        'Confirmed/Hold Release Requested'=>'Changing Status from \'Confirmed\' to \'Hold Release Requested\' is not allowed',
        'Confirmed/Change Confirmation Pending'=>'Changing Status from \'Confirmed\' to \'Change Confirmation Pending\' is not allowed',
        'Confirmed/Change Confirmation Required'=>'Changing Status from \'Confirmed\' to \'Change Confirmation Required\' is not allowed',
        'Confirmed/Change Confirmed'=>'Changing Status from \'Confirmed\' to \'Change Confirmed\' is not allowed',
        'Confirmed/Change Integration Requested'=>'Changing Status from \'Confirmed\' to \'Change Integration Requested\' is not allowed',
        'Approved-to-Ship/Draft'=>'Changing Status from \'Approved-to-Ship\' to \'Draft\' is not allowed',
        'Approved-to-Ship/Integration Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Integration Requested\' is not allowed',
        'Approved-to-Ship/Integration Error'=>'Changing Status from \'Approved-to-Ship\' to \'Integration Error\' is not allowed',
        'Approved-to-Ship/Planned'=>'Changing Status from \'Approved-to-Ship\' to \'Planned\' is not allowed',
        'Approved-to-Ship/Change Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Change Requested\' is not allowed',
        'Approved-to-Ship/Confirmation Pending'=>'Changing Status from \'Approved-to-Ship\' to \'Confirmation Pending\' is not allowed',
        'Approved-to-Ship/Confirmation Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Confirmation Requested\' is not allowed',
        'Approved-to-Ship/Confirmed'=>'Changing Status from \'Approved-to-Ship\' to \'Confirmed\' is not allowed',
        'Approved-to-Ship/Partially Shipped'=>'Changing Status from \'Approved-to-Ship\' to \'Partially Shipped\' is not allowed',
        'Approved-to-Ship/Shipped'=>'Changing Status from \'Approved-to-Ship\' to \'Shipped\' is not allowed',
        'Approved-to-Ship/Cancellation Confirmation Pending'=>'Changing Status from \'Approved-to-Ship\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Approved-to-Ship/Cancellation Confirmation Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Approved-to-Ship/Cancellation Confirmed'=>'Changing Status from \'Approved-to-Ship\' to \'Cancellation Confirmed\' is not allowed',
        'Approved-to-Ship/Cancellation Integration Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Cancellation Integration Requested\' is not allowed',
        'Approved-to-Ship/Cancelled'=>'Changing Status from \'Approved-to-Ship\' to \'Cancelled\' is not allowed',
        'Approved-to-Ship/Hold'=>'Changing Status from \'Approved-to-Ship\' to \'Hold\' is not allowed',
        'Approved-to-Ship/Hold Release Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Hold Release Requested\' is not allowed',
        'Approved-to-Ship/Change Confirmation Pending'=>'Changing Status from \'Approved-to-Ship\' to \'Change Confirmation Pending\' is not allowed',
        'Approved-to-Ship/Change Confirmation Required'=>'Changing Status from \'Approved-to-Ship\' to \'Change Confirmation Required\' is not allowed',
        'Approved-to-Ship/Change Confirmed'=>'Changing Status from \'Approved-to-Ship\' to \'Change Confirmed\' is not allowed',
        'Approved-to-Ship/Change Integration Requested'=>'Changing Status from \'Approved-to-Ship\' to \'Change Integration Requested\' is not allowed',
        'Partially Shipped/Draft'=>'Changing Status from \'Partially Shipped\' to \'Draft\' is not allowed',
        'Partially Shipped/Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Integration Requested\' is not allowed',
        'Partially Shipped/Integration Error'=>'Changing Status from \'Partially Shipped\' to \'Integration Error\' is not allowed',
        'Partially Shipped/Planned'=>'Changing Status from \'Partially Shipped\' to \'Planned\' is not allowed',
        'Partially Shipped/Change Requested'=>'Changing Status from \'Partially Shipped\' to \'Change Requested\' is not allowed',
        'Partially Shipped/Confirmation Pending'=>'Changing Status from \'Partially Shipped\' to \'Confirmation Pending\' is not allowed',
        'Partially Shipped/Confirmation Requested'=>'Changing Status from \'Partially Shipped\' to \'Confirmation Requested\' is not allowed',
        'Partially Shipped/Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Confirmed\' is not allowed',
        'Partially Shipped/Approved-to-Ship'=>'Changing Status from \'Partially Shipped\' to \'Approved-to-Ship\' is not allowed',
        'Partially Shipped/Shipped'=>'Changing Status from \'Partially Shipped\' to \'Shipped\' is not allowed',
        'Partially Shipped/Cancellation Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Requested\' is not allowed',
        'Partially Shipped/Cancellation Confirmation Pending'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Partially Shipped/Cancellation Confirmation Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Partially Shipped/Cancellation Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Confirmed\' is not allowed',
        'Partially Shipped/Cancellation Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Cancellation Integration Requested\' is not allowed',
        'Partially Shipped/Cancelled'=>'Changing Status from \'Partially Shipped\' to \'Cancelled\' is not allowed',
        'Partially Shipped/Hold'=>'Changing Status from \'Partially Shipped\' to \'Hold\' is not allowed',
        'Partially Shipped/Hold Release Requested'=>'Changing Status from \'Partially Shipped\' to \'Hold Release Requested\' is not allowed',
        'Partially Shipped/Change Confirmation Pending'=>'Changing Status from \'Partially Shipped\' to \'Change Confirmation Pending\' is not allowed',
        'Partially Shipped/Change Confirmation Required'=>'Changing Status from \'Partially Shipped\' to \'Change Confirmation Required\' is not allowed',
        'Partially Shipped/Change Confirmed'=>'Changing Status from \'Partially Shipped\' to \'Change Confirmed\' is not allowed',
        'Partially Shipped/Change Integration Requested'=>'Changing Status from \'Partially Shipped\' to \'Change Integration Requested\' is not allowed',
        'Shipped/Draft'=>'Changing Status from \'Shipped\' to \'Draft\' is not allowed',
        'Shipped/Integration Requested'=>'Changing Status from \'Shipped\' to \'Integration Requested\' is not allowed',
        'Shipped/Integration Error'=>'Changing Status from \'Shipped\' to \'Integration Error\' is not allowed',
        'Shipped/Planned'=>'Changing Status from \'Shipped\' to \'Planned\' is not allowed',
        'Shipped/Change Requested'=>'Changing Status from \'Shipped\' to \'Change Requested\' is not allowed',
        'Shipped/Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Confirmation Pending\' is not allowed',
        'Shipped/Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Confirmation Requested\' is not allowed',
        'Shipped/Confirmed'=>'Changing Status from \'Shipped\' to \'Confirmed\' is not allowed',
        'Shipped/Approved-to-Ship'=>'Changing Status from \'Shipped\' to \'Approved-to-Ship\' is not allowed',
        'Shipped/Partially Shipped'=>'Changing Status from \'Shipped\' to \'Partially Shipped\' is not allowed',
        'Shipped/Cancellation Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Requested\' is not allowed',
        'Shipped/Cancellation Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Shipped/Cancellation Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Shipped/Cancellation Confirmed'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmed\' is not allowed',
        'Shipped/Cancellation Integration Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Integration Requested\' is not allowed',
        'Shipped/Cancelled'=>'Changing Status from \'Shipped\' to \'Cancelled\' is not allowed',
        'Shipped/Hold Requested'=>'Changing Status from \'Shipped\' to \'Hold Requested\' is not allowed',
        'Shipped/Hold'=>'Changing Status from \'Shipped\' to \'Hold\' is not allowed',
        'Shipped/Hold Release Requested'=>'Changing Status from \'Shipped\' to \'Hold Release Requested\' is not allowed',
        'Shipped/Change Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Change Confirmation Pending\' is not allowed',
        'Shipped/Change Confirmation Required'=>'Changing Status from \'Shipped\' to \'Change Confirmation Required\' is not allowed',
        'Shipped/Change Confirmed'=>'Changing Status from \'Shipped\' to \'Change Confirmed\' is not allowed',
        'Shipped/Change Integration Requested'=>'Changing Status from \'Shipped\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Requested/Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Integration Requested\' is not allowed',
        'Cancellation Requested/Integration Error'=>'Changing Status from \'Cancellation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Requested/Change Requested'=>'Changing Status from \'Cancellation Requested\' to \'Change Requested\' is not allowed',
        'Cancellation Requested/Confirmation Pending'=>'Changing Status from \'Cancellation Requested\' to \'Confirmation Pending\' is not allowed',
        'Cancellation Requested/Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Requested/Partially Shipped'=>'Changing Status from \'Cancellation Requested\' to \'Partially Shipped\' is not allowed',
        'Cancellation Requested/Shipped'=>'Changing Status from \'Cancellation Requested\' to \'Shipped\' is not allowed',
        'Cancellation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Requested/Cancellation Confirmed'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Requested/Cancelled'=>'Changing Status from \'Cancellation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Requested/Hold Requested'=>'Changing Status from \'Cancellation Requested\' to \'Hold Requested\' is not allowed',
        'Cancellation Requested/Hold'=>'Changing Status from \'Cancellation Requested\' to \'Hold\' is not allowed',
        'Cancellation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Requested/Change Confirmation Pending'=>'Changing Status from \'Cancellation Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Cancellation Requested/Change Confirmation Required'=>'Changing Status from \'Cancellation Requested\' to \'Change Confirmation Required\' is not allowed',
        'Cancellation Requested/Change Confirmed'=>'Changing Status from \'Cancellation Requested\' to \'Change Confirmed\' is not allowed',
        'Cancellation Requested/Change Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Integration Requested'=>'Changing Status from \'Shipped\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Integration Error'=>'Changing Status from \'Shipped\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Pending/Change Requested'=>'Changing Status from \'Shipped\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmation Pending/Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Pending/Confirmation Requested'=>'Changing Status from \'Shipped\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Partially Shipped'=>'Changing Status from \'Shipped\' to \'Partially Shipped\' is not allowed',
        'Cancellation Confirmation Pending/Shipped'=>'Changing Status from \'Shipped\' to \'Shipped\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Shipped\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Shipped\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancelled'=>'Changing Status from \'Shipped\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Pending/Hold Requested'=>'Changing Status from \'Shipped\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmation Pending/Hold'=>'Changing Status from \'Shipped\' to \'Hold\' is not allowed',
        'Cancellation Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Shipped\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Pending/Change Confirmation Pending'=>'Changing Status from \'Shipped\' to \'Change Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Pending/Change Confirmation Required'=>'Changing Status from \'Shipped\' to \'Change Confirmation Required\' is not allowed',
        'Cancellation Confirmation Pending/Change Confirmed'=>'Changing Status from \'Shipped\' to \'Change Confirmed\' is not allowed',
        'Cancellation Confirmation Pending/Change Integration Requested'=>'Changing Status from \'Shipped\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Integration Error'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Requested/Change Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmation Requested/Confirmation Pending'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Requested/Confirmation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Partially Shipped'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Partially Shipped\' is not allowed',
        'Cancellation Confirmation Requested/Shipped'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Shipped\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancelled'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Requested/Hold Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmation Requested/Hold'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold\' is not allowed',
        'Cancellation Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Requested/Change Confirmation Pending'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Requested/Change Confirmation Required'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Confirmation Required\' is not allowed',
        'Cancellation Confirmation Requested/Change Confirmed'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Confirmed\' is not allowed',
        'Cancellation Confirmation Requested/Change Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Confirmed/Integration Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmed/Integration Error'=>'Changing Status from \'Cancellation Confirmed\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmed/Change Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmed/Confirmation Pending'=>'Changing Status from \'Cancellation Confirmed\' to \'Confirmation Pending\' is not allowed',
        'Cancellation Confirmed/Confirmation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Confirmation Requested\' is not allowed',
        'Cancellation Confirmed/Partially Shipped'=>'Changing Status from \'Cancellation Confirmed\' to \'Partially Shipped\' is not allowed',
        'Cancellation Confirmed/Shipped'=>'Changing Status from \'Cancellation Confirmed\' to \'Shipped\' is not allowed',
        'Cancellation Confirmed/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmed/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Confirmed/Cancelled'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmed/Hold Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmed/Hold'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold\' is not allowed',
        'Cancellation Confirmed/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmed/Change Confirmation Pending'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Confirmation Pending\' is not allowed',
        'Cancellation Confirmed/Change Confirmation Required'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Confirmation Required\' is not allowed',
        'Cancellation Confirmed/Change Confirmed'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Confirmed\' is not allowed',
        'Cancellation Confirmed/Change Integration Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Integration Requested\' is not allowed',    
        'Cancelled/Draft'=>'Changing Status from \'Cancelled\' to \'Draft\' is not allowed',
        //'Cancelled/Integration Requested'=>'Changing Status from \'Cancelled\' to \'Integration Requested\' is not allowed',
        'Cancelled/Integration Error'=>'Changing Status from \'Cancelled\' to \'Integration Error\' is not allowed',
        'Cancelled/Planned'=>'Changing Status from \'Cancelled\' to \'Planned\' is not allowed',
        'Cancelled/Change Requested'=>'Changing Status from \'Cancelled\' to \'Change Requested\' is not allowed',
        'Cancelled/Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Confirmation Pending\' is not allowed',
        'Cancelled/Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Confirmation Requested\' is not allowed',
        'Cancelled/Confirmed'=>'Changing Status from \'Cancelled\' to \'Confirmed\' is not allowed',
        'Cancelled/Approved-to-Ship'=>'Changing Status from \'Cancelled\' to \'Approved-to-Ship\' is not allowed',
        'Cancelled/Partially Shipped'=>'Changing Status from \'Cancelled\' to \'Partially Shipped\' is not allowed',
        'Cancelled/Shipped'=>'Changing Status from \'Cancelled\' to \'Shipped\' is not allowed',
        'Cancelled/Cancellation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Requested\' is not allowed',
        'Cancelled/Cancellation Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancelled/Cancellation Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancelled/Cancellation Confirmed'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmed\' is not allowed',
        'Cancelled/Cancellation Integration Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancelled/Hold Requested'=>'Changing Status from \'Cancelled\' to \'Hold Requested\' is not allowed',
        'Cancelled/Hold'=>'Changing Status from \'Cancelled\' to \'Hold\' is not allowed',
        'Cancelled/Hold Release Requested'=>'Changing Status from \'Cancelled\' to \'Hold Release Requested\' is not allowed',
        'Cancelled/Change Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Change Confirmation Pending\' is not allowed',
        'Cancelled/Change Confirmation Required'=>'Changing Status from \'Cancelled\' to \'Change Confirmation Required\' is not allowed',
        'Cancelled/Change Confirmed'=>'Changing Status from \'Cancelled\' to \'Change Confirmed\' is not allowed',
        'Cancelled/Change Integration Requested'=>'Changing Status from \'Cancelled\' to \'Change Integration Requested\' is not allowed',
        'Hold Requested/Draft'=>'Changing Status from \'Hold Requested\' to \'Draft\' is not allowed',
        'Hold Requested/Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Integration Requested\' is not allowed',
        'Hold Requested/Integration Error'=>'Changing Status from \'Hold Requested\' to \'Integration Error\' is not allowed',
        'Hold Requested/Change Requested'=>'Changing Status from \'Hold Requested\' to \'Change Requested\' is not allowed',
        'Hold Requested/Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Confirmation Pending\' is not allowed',
        'Hold Requested/Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Confirmation Requested\' is not allowed',
        'Hold Requested/Confirmed'=>'Changing Status from \'Hold Requested\' to \'Confirmed\' is not allowed',
        'Hold Requested/Shipped'=>'Changing Status from \'Hold Requested\' to \'Shipped\' is not allowed',
        'Hold Requested/Cancellation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Requested\' is not allowed',
        'Hold Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Requested/Cancelled'=>'Changing Status from \'Hold Requested\' to \'Cancelled\' is not allowed',
        'Hold Requested/Hold'=>'Changing Status from \'Hold Requested\' to \'Hold\' is not allowed',
        'Hold Requested/Hold Release Requested'=>'Changing Status from \'Hold Requested\' to \'Hold Release Requested\' is not allowed',
        'Hold Requested/Change Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Hold Requested/Change Confirmation Required'=>'Changing Status from \'Hold Requested\' to \'Change Confirmation Required\' is not allowed',
        'Hold Requested/Change Confirmed'=>'Changing Status from \'Hold Requested\' to \'Change Confirmed\' is not allowed',
        'Hold/Draft'=>'Changing Status from \'Hold\' to \'Draft\' is not allowed',
        'Hold/Integration Requested'=>'Changing Status from \'Hold\' to \'Integration Requested\' is not allowed',
        'Hold/Integration Error'=>'Changing Status from \'Hold\' to \'Integration Error\' is not allowed',
        'Hold/Planned'=>'Changing Status from \'Hold\' to \'Planned\' is not allowed',
        'Hold/Change Requested'=>'Changing Status from \'Hold\' to \'Change Requested\' is not allowed',
        'Hold/Confirmation Pending'=>'Changing Status from \'Hold\' to \'Confirmation Pending\' is not allowed',
        'Hold/Confirmation Requested'=>'Changing Status from \'Hold\' to \'Confirmation Requested\' is not allowed',
        'Hold/Confirmed'=>'Changing Status from \'Hold\' to \'Confirmed\' is not allowed',
        'Hold/Approved-to-Ship'=>'Changing Status from \'Hold\' to \'Approved-to-Ship\' is not allowed',
        'Hold/Partially Shipped'=>'Changing Status from \'Hold\' to \'Partially Shipped\' is not allowed',
        'Hold/Shipped'=>'Changing Status from \'Hold\' to \'Shipped\' is not allowed',
        'Hold/Cancellation Confirmation Pending'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold/Cancellation Confirmation Requested'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold/Cancellation Confirmed'=>'Changing Status from \'Hold\' to \'Cancellation Confirmed\' is not allowed',
        'Hold/Cancellation Integration Requested'=>'Changing Status from \'Hold\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold/Cancelled'=>'Changing Status from \'Hold\' to \'Cancelled\' is not allowed',
        'Hold/Hold Requested'=>'Changing Status from \'Hold\' to \'Hold Requested\' is not allowed',
        'Hold/Change Confirmation Pending'=>'Changing Status from \'Hold\' to \'Change Confirmation Pending\' is not allowed',
        'Hold/Change Confirmation Required'=>'Changing Status from \'Hold\' to \'Change Confirmation Required\' is not allowed',
        'Hold/Change Confirmed'=>'Changing Status from \'Hold\' to \'Change Confirmed\' is not allowed',
        'Hold/Change Integration Requested'=>'Changing Status from \'Hold\' to \'Change Integration Requested\' is not allowed',
        'Hold Release Requested/Draft'=>'Changing Status from \'Hold Release Requested\' to \'Draft\' is not allowed',
        'Hold Release Requested/Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Integration Requested\' is not allowed',
        'Hold Release Requested/Integration Error'=>'Changing Status from \'Hold Release Requested\' to \'Integration Error\' is not allowed',
        'Hold Release Requested/Planned'=>'Changing Status from \'Hold Release Requested\' to \'Planned\' is not allowed',
        'Hold Release Requested/Change Requested'=>'Changing Status from \'Hold Release Requested\' to \'Change Requested\' is not allowed',
        'Hold Release Requested/Confirmation Pending'=>'Changing Status from \'Hold Release Requested\' to \'Confirmation Pending\' is not allowed',
        'Hold Release Requested/Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Confirmation Requested\' is not allowed',
        'Hold Release Requested/Confirmed'=>'Changing Status from \'Hold Release Requested\' to \'Confirmed\' is not allowed',
        'Hold Release Requested/Approved-to-Ship'=>'Changing Status from \'Hold Release Requested\' to \'Approved-to-Ship\' is not allowed',
        'Hold Release Requested/Partially Shipped'=>'Changing Status from \'Hold Release Requested\' to \'Partially Shipped\' is not allowed',
        'Hold Release Requested/Shipped'=>'Changing Status from \'Hold Release Requested\' to \'Shipped\' is not allowed',
        'Hold Release Requested/Cancellation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Requested\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Release Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Release Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Release Requested/Cancelled'=>'Changing Status from \'Hold Release Requested\' to \'Cancelled\' is not allowed',
        'Hold Release Requested/Hold Requested'=>'Changing Status from \'Hold Release Requested\' to \'Hold Requested\' is not allowed',
        'Hold Release Requested/Change Confirmation Pending'=>'Changing Status from \'Hold Release Requested\' to \'Change Confirmation Pending\' is not allowed',
        'Hold Release Requested/Change Confirmation Required'=>'Changing Status from \'Hold Release Requested\' to \'Change Confirmation Required\' is not allowed',
        'Hold Release Requested/Change Confirmed'=>'Changing Status from \'Hold Release Requested\' to \'Change Confirmed\' is not allowed',
        'Hold Release Requested/Change Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Change Integration Requested\' is not allowed',
        'Cancellation Integration Requested/Integration Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Integration Error'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Confirmation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Partially Shipped'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Shipped'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Confirmation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancelled'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold Release Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Confirmation Required'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Confirmed'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Integration Requested'=>'Status change not allowed; Oracle integration in progress.'
    };
    public static Map<String,String> statusSWErrorMsg = new Map<String,String>{
        'Draft/Integration Error'=>'Changing Status from \'Draft\' to \'Integration Error\' is not allowed',
        'Draft/Planned'=>'Changing Status from \'Draft\' to \'Planned\' is not allowed',
        'Draft/Change Requested'=>'Changing Status from \'Draft\' to \'Change Requested\' is not allowed',
        'Draft/Cancellation Confirmation Pending'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Draft/Cancellation Confirmation Requested'=>'Changing Status from \'Draft\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Draft/Cancellation Confirmed'=>'Changing Status from \'Draft\' to \'Cancellation Confirmed\' is not allowed',
        'Draft/Cancellation Integration Requested'=>'Changing Status from \'Draft\' to \'Cancellation Integration Requested\' is not allowed',
        'Draft/Cancelled'=>'Changing Status from \'Draft\' to \'Cancelled\' is not allowed',
        'Draft/Hold'=>'Changing Status from \'Draft\' to \'Hold\' is not allowed',
        'Draft/Hold Release Requested'=>'Changing Status from \'Draft\' to \'Hold Release Requested\' is not allowed',
        'Draft/Booked'=>'Changing Status from \'Draft\' to \'Booked\' is not allowed',
        'Draft/Invoiced'=>'Changing Status from \'Draft\' to \'Invoiced\' is not allowed',
        'Integration Requested/Integration Error'=>'Changing Status from \'Integration Requested\' to \'Integration Error\' is not allowed',
        'Integration Requested/Planned'=>'Changing Status from \'Integration Requested\' to \'Planned\' is not allowed',
        'Integration Requested/Change Requested'=>'Changing Status from \'Integration Requested\' to \'Change Requested\' is not allowed',
        'Integration Requested/Cancellation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Requested\' is not allowed',
        'Integration Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Integration Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Integration Requested/Cancelled'=>'Changing Status from \'Integration Requested\' to \'Cancelled\' is not allowed',
        'Integration Requested/Hold Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Requested\' is not allowed',
        'Integration Requested/Hold'=>'Changing Status from \'Integration Requested\' to \'Hold\' is not allowed',
        'Integration Requested/Hold Release Requested'=>'Changing Status from \'Integration Requested\' to \'Hold Release Requested\' is not allowed',
        'Integration Requested/Booked'=>'Changing Status from \'Integration Requested\' to \'Booked\' is not allowed',
        'Integration Requested/Invoiced'=>'Changing Status from \'Integration Requested\' to \'Invoiced\' is not allowed',
        'Integration Error/Integration Requested'=>'Changing Status from \'Integration Error\' to \'Integration Requested\' is not allowed',
        'Integration Error/Integration Error'=>'Changing Status from \'Integration Error\' to \'Integration Error\' is not allowed',
        'Integration Error/Cancellation Confirmation Pending'=>'Changing Status from \'Integration Error\' to \'ICancellation Confirmation Pending\' is not allowed',
        'Integration Error/Cancellation Confirmation Requested'=>'Changing Status from \'Integration Error\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Integration Error/Cancelled'=>'Changing Status from \'Integration Error\' to \'Cancelled\' is not allowed',
        'Integration Error/Hold'=>'Changing Status from \'Integration Error\' to \'Hold\' is not allowed',
        'Integration Error/Invoiced'=>'Changing Status from \'Integration Error\' to \'Invoiced\' is not allowed',
        'Planned/Draft'=>'Changing Status from \'Planned\' to \'Draft\' is not allowed',
        'Planned/Integration Requested'=>'Changing Status from \'Planned\' to \'Integration Requested\' is not allowed',
        'Planned/Integration Error'=>'Changing Status from \'Planned\' to \'Integration Error\' is not allowed',
        'Planned/Change Requested'=>'Changing Status from \'Planned\' to \'Change Requested\' is not allowed',
        'Planned/Cancellation Confirmation Pending'=>'Changing Status from \'Planned\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Planned/Cancellation Confirmation Requested'=>'Changing Status from \'Planned\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Planned/Cancellation Confirmed'=>'Changing Status from \'Planned\' to \'Cancellation Confirmed\' is not allowed',
        'Planned/Cancellation Integration Requested'=>'Changing Status from \'Planned\' to \'Cancellation Integration Requested\' is not allowed',
        'Planned/Cancelled'=>'Changing Status from \'Planned\' to \'Cancelled\' is not allowed',
        'Planned/Hold'=>'Changing Status from \'Planned\' to \'Hold\' is not allowed',
        'Planned/Hold Release Requested'=>'Changing Status from \'Planned\' to \'Hold Release Requested\' is not allowed',
        'Planned/Booked'=>'Changing Status from \'Planned\' to \'Booked\' is not allowed',
        'Planned/Invoiced'=>'Changing Status from \'Planned\' to \'Invoiced\' is not allowed',
        'Change Requested/Draft'=>'Changing Status from \'Change Requested\' to \'Draft\' is not allowed',
        'Change Requested/Integration Requested'=>'Changing Status from \'Change Requested\' to \'Integration Requested\' is not allowed',
        'Change Requested/Integration Error'=>'Changing Status from \'Change Requested\' to \'Integration Error\' is not allowed',
        'Change Requested/Planned'=>'Changing Status from \'Change Requested\' to \'Planned\' is not allowed',
        'Change Requested/Cancellation Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Requested\' is not allowed',
        'Change Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Change Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Change Requested/Cancellation Confirmed'=>'Changing Status from \'Change Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Change Requested/Cancelled'=>'Changing Status from \'Change Requested\' to \'Cancelled\' is not allowed',
        'Change Requested/Hold Requested'=>'Changing Status from \'Change Requested\' to \'Hold Requested\' is not allowed',
        'Change Requested/Hold'=>'Changing Status from \'Change Requested\' to \'Hold\' is not allowed',
        'Change Requested/Hold Release Requested'=>'Changing Status from \'Change Requested\' to \'Hold Release Requested\' is not allowed',
        'Change Requested/Booked'=>'Changing Status from \'Change Requested\' to \'Booked\' is not allowed',
        'Change Requested/Invoiced'=>'Changing Status from \'Change Requested\' to \'Invoiced\' is not allowed',
        'Hold Requested/Draft'=>'Changing Status from \'Hold Requested\' to \'Draft\' is not allowed',
        'Hold Requested/Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Integration Requested\' is not allowed',
        'Hold Requested/Integration Error'=>'Changing Status from \'Hold Requested\' to \'Integration Error\' is not allowed',
        'Hold Requested/Planned'=>'Changing Status from \'Hold Requested\' to \'Planned\' is not allowed',
        'Hold Requested/Change Requested'=>'Changing Status from \'Hold Requested\' to \'Change Requested\' is not allowed',
        'Hold Requested/Cancellation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Requested\' is not allowed',
        'Hold Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Requested/Cancelled'=>'Changing Status from \'Hold Requested\' to \'Cancelled\' is not allowed',
        'Hold Requested/Hold'=>'Changing Status from \'Hold Requested\' to \'Hold\' is not allowed',
        'Hold Requested/Hold Release Requested'=>'Changing Status from \'Hold Requested\' to \'Hold Release Requested\' is not allowed',
        'Hold/Draft'=>'Changing Status from \'Hold\' to \'Draft\' is not allowed',
        'Hold/Integration Requested'=>'Changing Status from \'Hold\' to \'Integration Requested\' is not allowed',
        'Hold/Integration Error'=>'Changing Status from \'Hold\' to \'Integration Error\' is not allowed',
        'Hold/Planned'=>'Changing Status from \'Hold\' to \'Planned\' is not allowed',
        'Hold/Change Requested'=>'Changing Status from \'Hold\' to \'Change Requested\' is not allowed',
        'Hold/Cancellation Confirmation Pending'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold/Cancellation Confirmation Requested'=>'Changing Status from \'Hold\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold/Cancellation Confirmed'=>'Changing Status from \'Hold\' to \'Cancellation Confirmed\' is not allowed',
        'Hold/Cancellation Integration Requested'=>'Changing Status from \'Hold\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold/Cancelled'=>'Changing Status from \'Hold\' to \'Cancelled\' is not allowed',
        'Hold/Hold Requested'=>'Changing Status from \'Hold\' to \'Hold Requested\' is not allowed',
        'Hold/Booked'=>'Changing Status from \'Hold\' to \'Booked\' is not allowed',
        'Hold/Invoiced'=>'Changing Status from \'Hold\' to \'Invoiced\' is not allowed',
        'Hold Release Requested/Draft'=>'Changing Status from \'Hold Release Requested\' to \'Draft\' is not allowed',
        'Hold Release Requested/Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Integration Requested\' is not allowed',
        'Hold Release Requested/Integration Error'=>'Changing Status from \'Hold Release Requested\' to \'Integration Error\' is not allowed',
        'Hold Release Requested/Planned'=>'Changing Status from \'Hold Release Requested\' to \'Planned\' is not allowed',
        'Hold Release Requested/Change Requested'=>'Changing Status from \'Hold Release Requested\' to \'Change Requested\' is not allowed',
        'Hold Release Requested/Cancellation Requested'=>'Changing Status from \'Hold Release Requested\' to \'DrCancellation Requestedaft\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Hold Release Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Hold Release Requested/Cancellation Confirmed'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Hold Release Requested/Cancellation Integration Requested'=>'Changing Status from \'Hold Release Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Hold Release Requested/Cancelled'=>'Changing Status from \'Hold Release Requested\' to \'Cancelled\' is not allowed',
        'Hold Release Requested/Hold Requested'=>'Changing Status from \'Hold Release Requested\' to \'Hold Requested\' is not allowed',
        'Hold Release Requested/Booked'=>'Changing Status from \'Hold Release Requested\' to \'Booked\' is not allowed',
        'Hold Release Requested/Invoiced'=>'Changing Status from \'Hold Release Requested\' to \'Invoiced\' is not allowed',
        'Booked/Draft'=>'Changing Status from \'Booked\' to \'Draft\' is not allowed',
        'Booked/Integration Requested'=>'Changing Status from \'Booked\' to \'Integration Requested\' is not allowed',
        'Booked/Integration Error'=>'Changing Status from \'Booked\' to \'Integration Error\' is not allowed',
        'Booked/Change Requested'=>'Changing Status from \'Booked\' to \'Change Requested\' is not allowed',
        'Booked/Cancellation Confirmation Pending'=>'Changing Status from \'Booked\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Booked/Cancellation Confirmation Requested'=>'Changing Status from \'Booked\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Booked/Cancellation Confirmed'=>'Changing Status from \'Booked\' to \'Cancellation Confirmed\' is not allowed',
        'Booked/Cancellation Integration Requested'=>'Changing Status from \'Booked\' to \'Cancellation Integration Requested\' is not allowed',
        'Booked/Cancelled'=>'Changing Status from \'Booked\' to \'Cancelled\' is not allowed',
        'Booked/Hold'=>'Changing Status from \'Booked\' to \'Hold\' is not allowed',
        'Booked/Hold Release Requested'=>'Changing Status from \'Booked\' to \'Hold Release Requested\' is not allowed',
        'Booked/Invoiced'=>'Changing Status from \'Booked\' to \'Invoiced\' is not allowed',
        'Invoiced/Draft'=>'Changing Status from \'Invoiced\' to \'Draft\' is not allowed',
        'Invoiced/Integration Requested'=>'Changing Status from \'Invoiced\' to \'Integration Requested\' is not allowed',
        'Invoiced/Integration Error'=>'Changing Status from \'Invoiced\' to \'Integration Error\' is not allowed',
        'Invoiced/Planned'=>'Changing Status from \'Invoiced\' to \'Planned\' is not allowed',
        'Invoiced/Change Requested'=>'Changing Status from \'Invoiced\' to \'Change Requested\' is not allowed',
        'Invoiced/Cancellation Requested'=>'Changing Status from \'Invoiced\' to \'Cancellation Requested\' is not allowed',
        'Invoiced/Cancellation Confirmation Pending'=>'Changing Status from \'Invoiced\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Invoiced/Cancellation Confirmation Requested'=>'Changing Status from \'Invoiced\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Invoiced/Cancellation Confirmed'=>'Changing Status from \'Invoiced\' to \'Cancellation Confirmed\' is not allowed',
        'Invoiced/Cancellation Integration Requested'=>'Changing Status from \'Invoiced\' to \'Cancellation Integration Requested\' is not allowed',
        'Invoiced/Cancelled'=>'Changing Status from \'Invoiced\' to \'Cancelled\' is not allowed',
        'Invoiced/Hold Requested'=>'Changing Status from \'Invoiced\' to \'Hold Requested\' is not allowed',
        'Invoiced/Hold'=>'Changing Status from \'Invoiced\' to \'Hold\' is not allowed',
        'Invoiced/Hold Release Requested'=>'Changing Status from \'Invoiced\' to \'Hold Release Requested\' is not allowed',
        'Invoiced/Booked'=>'Changing Status from \'Invoiced\' to \'Booked\' is not allowed',
        'Cancellation Requested/Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Integration Requested\' is not allowed',
        'Cancellation Requested/Integration Error'=>'Changing Status from \'Cancellation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Requested/Change Requested'=>'Changing Status from \'Cancellation Requested\' to \'Change Requested\' is not allowed',
        'Cancellation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Requested/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Requested/Cancellation Confirmed'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Requested/Cancelled'=>'Changing Status from \'Cancellation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Requested/Hold Requested'=>'Changing Status from \'Cancellation Requested\' to \'Hold Requested\' is not allowed',
        'Cancellation Requested/Hold'=>'Changing Status from \'Cancellation Requested\' to \'Hold\' is not allowed',
        'Cancellation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Requested/Booked'=>'Changing Status from \'Cancellation Requested\' to \'Booked\' is not allowed',
        'Cancellation Requested/Invoiced'=>'Changing Status from \'Cancellation Requested\' to \'Invoiced\' is not allowed',
        'Cancellation Confirmation Pending/Integration Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Integration Error'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Pending/Change Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Confirmed'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Confirmed\' is not allowed',
        'Cancellation Confirmation Pending/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Pending/Cancelled'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Pending/Hold Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmation Pending/Hold'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Hold\' is not allowed',
        'Cancellation Confirmation Pending/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Pending/Invoiced'=>'Changing Status from \'Cancellation Confirmation Pending\' to \'Invoiced\' is not allowed',
        'Cancellation Confirmation Requested/Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Integration Error'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmation Requested/Change Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Confirmation Pending'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancellation Confirmation Requested/Cancellation Integration Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancellation Confirmation Requested/Cancelled'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmation Requested/Hold'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold\' is not allowed',
        'Cancellation Confirmation Requested/Hold Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmation Requested/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmation Requested/Invoiced'=>'Changing Status from \'Cancellation Confirmation Requested\' to \'Invoiced\' is not allowed',
        'Cancellation Confirmed/Integration Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Integration Requested\' is not allowed',
        'Cancellation Confirmed/Integration Error'=>'Changing Status from \'Cancellation Confirmed\' to \'Integration Error\' is not allowed',
        'Cancellation Confirmed/Change Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Change Requested\' is not allowed',
        'Cancellation Confirmed/Cancellation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancellation Requested\' is not allowed',
        'Cancellation Confirmed/Cancellation Confirmation Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancellation Confirmed/Cancelled'=>'Changing Status from \'Cancellation Confirmed\' to \'Cancelled\' is not allowed',
        'Cancellation Confirmed/Hold Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold Requested\' is not allowed',
        'Cancellation Confirmed/Hold'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold\' is not allowed',
        'Cancellation Confirmed/Hold Release Requested'=>'Changing Status from \'Cancellation Confirmed\' to \'Hold Release Requested\' is not allowed',
        'Cancellation Confirmed/Invoiced'=>'Changing Status from \'Cancellation Confirmed\' to \'Invoiced\' is not allowed',    
        'Cancelled/Draft'=>'Changing Status from \'Cancelled\' to \'Draft\' is not allowed',
        'Cancelled/Integration Requested'=>'Changing Status from \'Cancelled\' to \'Integration Requested\' is not allowed',
        'Cancelled/Integration Error'=>'Changing Status from \'Cancelled\' to \'Integration Error\' is not allowed',
        'Cancelled/Planned'=>'Changing Status from \'Cancelled\' to \'Planned\' is not allowed',
        'Cancelled/Change Requested'=>'Changing Status from \'Cancelled\' to \'Change Requested\' is not allowed',
        'Cancelled/Cancellation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Requested\' is not allowed',
        'Cancelled/Cancellation Confirmation Pending'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Pending\' is not allowed',
        'Cancelled/Cancellation Confirmation Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmation Requested\' is not allowed',
        'Cancelled/Cancellation Confirmed'=>'Changing Status from \'Cancelled\' to \'Cancellation Confirmed\' is not allowed',
        'Cancelled/Cancellation Integration Requested'=>'Changing Status from \'Cancelled\' to \'Cancellation Integration Requested\' is not allowed',
        'Cancelled/Hold Requested'=>'Changing Status from \'Cancelled\' to \'Hold Requested\' is not allowed',
        'Cancelled/Hold'=>'Changing Status from \'Cancelled\' to \'Hold\' is not allowed',
        'Cancelled/Hold Release Requested'=>'Changing Status from \'Cancelled\' to \'Hold Release Requested\' is not allowed',
        'Cancelled/Booked'=>'Changing Status from \'Cancelled\' to \'Booked\' is not allowed',
        'Cancelled/Invoiced'=>'Changing Status from \'Cancelled\' to \'Invoiced\' is not allowed',
        'Cancellation Integration Requested/Integration Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Integration Error'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Change Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Confirmation Pending'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancellation Confirmation Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Cancelled'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Hold Release Requested'=>'Status change not allowed; Oracle integration in progress.',
        'Cancellation Integration Requested/Invoiced'=>'Status change not allowed; Oracle integration in progress.'
    };
   
    /*static public String checkStatusChange(String oldStatus, String newStatus, String integrationStatus)
    {
        String returnError;
        System.debug('oldStatus = ' + oldStatus);
        System.debug('newStatus = ' + newStatus);
        System.debug('integrationStatus = ' + integrationStatus);
       
        String msgKey = oldStatus + '/' + newStatus;
        System.debug('msgKey = '+msgKey);
        String errMsg = StateTransitionMap.statusErrorMsg.get(msgKey);
        System.debug('ErrMsg = ' + errMsg);    
        if(allowedStateTransitions.get(oldStatus).containsKey(newStatus))
        {
            if(allowedStateTransitions.get(oldStatus).get(newStatus) == '')
            {
                return 'OK';
            }
            else
            {
                if(integrationStatus == 'Requested' || integrationStatus == 'Change Requested' || integrationStatus == 'Complete')
                {
                    return 'OK';
                }
            }
        }
        if (statusErrorMsg.get(msgKey) != null)
        {
            returnError = statusErrorMsg.get(msgKey);
        }
        else
        {
            returnError = '** Changing Status from \'' + oldStatus + '\'to \'' + newStatus + '\' is not allowed.';
        }

        System.debug(returnError);
        return  returnError;
    }*/
   
    /*public static List<String> getValidStates(String currentState)
    {
        List<String> retList = new List<String>();
        retList.add(currentState);
        for (String validState : allowedStateTransitions.get(currentState).keySet())
        {
            retList.add(validState);
        }
        return retList;    
    }*/
   
    // Added by ENP - START
    static public String checkStatusChange(String oldStatus, String newStatus, String integrationStatus, String recordType)
    {
        String returnError;
        System.debug('oldStatus = ' + oldStatus);
        System.debug('newStatus = ' + newStatus);
        System.debug('integrationStatus = ' + integrationStatus);        
        String msgKey = oldStatus + '/' + newStatus;
        System.debug('msgKey = '+msgKey);      
        //IGU
        if(recordType.contains('IGU')){
            String errMsg = StateTransitionMap.statusErrorMsg.get(msgKey);
            System.debug('ErrMsg = ' + errMsg);
            if(allowedStateTransitions.get(oldStatus).containsKey(newStatus))
            {
                if(allowedStateTransitions.get(oldStatus).get(newStatus) == '')
                {
                    return 'OK';
                }
                else
                {
                    if(integrationStatus == 'Requested' || integrationStatus == 'Change Requested' || integrationStatus == 'Complete')
                    {
                        return 'OK';
                    }
                }
            }
            if (statusErrorMsg.get(msgKey) != null)
            {
                returnError = statusErrorMsg.get(msgKey);
            }
            else
            {
                returnError = '** Changing Status from \'' + oldStatus + '\'to \'' + newStatus + '\' is not allowed.';
            }

            System.debug(returnError);
        }
        //Control Hardware
        else if(recordType.containsIgnoreCase(Label.CSS_Hardware)){
            String errMsg = StateTransitionMap.statusHWErrorMsg.get(msgKey);
            System.debug('ErrMsg = ' + errMsg);
            if(allowedHWStateTransitions.containsKey(oldStatus) && allowedHWStateTransitions.get(oldStatus).containsKey(newStatus))
            {
                if(allowedHWStateTransitions.get(oldStatus).get(newStatus) == '')
                {
                    return 'OK';
                }
                else
                {
                    if(integrationStatus == 'Requested' || integrationStatus == 'Change Requested' || integrationStatus == 'Complete')
                    {
                        return 'OK';
                    }
                }
            }
            if (statusHWErrorMsg.get(msgKey) != null)
            {
                returnError = statusHWErrorMsg.get(msgKey);
            }
            else
            {
                returnError = '** Changing Status from \'' + oldStatus + '\'to \'' + newStatus + '\' is not allowed.';
            }

            System.debug(returnError);          
        }
        //Software and Service
        else if(recordType.containsIgnoreCase(Label.CSS_Software)){
            String errMsg = StateTransitionMap.statusSWErrorMsg.get(msgKey);
            System.debug('ErrMsg = ' + errMsg);
            if(allowedSWStateTransitions.get(oldStatus).containsKey(newStatus))
            {
                if(allowedSWStateTransitions.get(oldStatus).get(newStatus) == '')
                {
                    return 'OK';
                }
                else
                {
                    if(integrationStatus == 'Requested' || integrationStatus == 'Change Requested' || integrationStatus == 'Complete')
                    {
                        return 'OK';
                    }
                }
            }
            if (statusSWErrorMsg.get(msgKey) != null)
            {
                returnError = statusSWErrorMsg.get(msgKey);
            }
            else
            {
                returnError = '** Changing Status from \'' + oldStatus + '\'to \'' + newStatus + '\' is not allowed.';
            }

            System.debug(returnError);          
        }
        return  returnError;
    }  
   
    public static List<String> getValidStates(String currentState, String recordType)
    {
        List<String> retList = new List<String>();
        retList.add(currentState);
        if(recordType.containsIgnoreCase('IGU')){
            for (String validState : allowedStateTransitions.get(currentState).keySet())
            {
                retList.add(validState);
            }
        }
        //Software and Service
        else if(recordType.containsIgnoreCase(Label.CSS_Software)){
            for (String validState : allowedSWStateTransitions.get(currentState).keySet())
            {
                retList.add(validState);
            }
        }
        //Control HardWare
        else if(recordType.containsIgnoreCase(Label.CSS_Hardware)){
            for (String validState : allowedHWStateTransitions.get(currentState).keySet())
            {
                retList.add(validState);
            }
        }
        return retList;    
    }
    // Added by ENP - END

    static public List<SelectOption> getOERStatusSelections(String currentStatus, String recordTypeName){  
        List<SelectOption> statusSelections = new List<SelectOption>();
         Map<String, List<String>> iGUReleaseSelectMap = new Map<String, List<String>>  
        {
            'Draft' => new List<String>{'Draft', 'Pre-Release Review', 'Cancelled'},
            'Pre-Release Review' => new List<String>{'Pre-Release Review', 'Confirmation Pending','Draft', 'Cancelled'},
            'Confirmation Pending' => new List<String>{'Confirmation Pending', 'Confirmation Requested', 'Draft','Pre-Release Review', 'Cancelled'},
            'Confirmation Requested' => new List<String>{'Confirmation Requested', 'Confirmed', 'Draft', 'Pre-Release Review', 'Confirmation Pending'},
            //'Confirmation Requested' => new List<String>{'Confirmation Requested', 'Integration Requested', 'Draft', 'Pre-Release Review', 'Confirmation Pending'},
            'Confirmed' => new List<String>{'Confirmed', 'Integration Requested', 'Draft','Pre-Release Review','Cancelled'},
            'Integration Requested' => new List<String>{'Integration Requested', 'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed'},
            'Pre-Production' => new List<String>{'Pre-Production', 'Change Requested',  'Hold Requested', 'Cancellation Requested'},
            'In Production' => new List<String>{'In Production', 'Change Requested', 'Hold Requested', 'Cancellation Requested'},
            'Partially Shipped' => new List<String>{'Partially Shipped', 'Change Requested', 'Hold Requested'
                },//CANCELLATION_BUGS_SEP_20
            'Shipped' => new List<String>{'Shipped', 'Complete'},
            'Integration Error' => new List<String>{'Integration Error','Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Pre-Production',
                'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Change Integration Requested',
                'Hold Requested', 'Hold Release Requested', 'Cancellation Requested', 'Cancellation Confirmed', 'Cancellation Integration Requested'},
            'Change Requested' => new List<String>{'Change Requested','Partially Shipped','Change Integration Requested', 'Hold Requested', 'Cancellation Requested'},
            'Change Confirmation Pending' => new List<String>{'Change Confirmation Pending', 'In Production', 'Partially Shipped', 'Shipped', 'Change Confirmation Requested'},
            'Change Confirmation Required' => new List<String>{'Change Confirmation Required', 'Change Confirmation Requested', 'Pre-Production', 'In Production', 'Partially Shipped', 'Shipped'},
            'Change Confirmation Requested' => new List<String>{'Change Confirmation Requested','Change Confirmed','Pre-Production', 'In Production', 'Partially Shipped', 'Shipped'},
            'Change Confirmed' => new List<String>{'Change Confirmed', 'Change Integration Requested', 'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required',
                'Change Confirmation Requested', 'Change Confirmation Required', 'Hold Requested'},
            'Change Integration Requested' => new List<String>{'Change Integration Requested', 'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending',
                'Change Confirmed', 'Hold Requested'},
            'Hold Requested' => new List<String>{'Hold Requested', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Pre-Production', 'Change Integration Requested',
                'In Production', 'Partially Shipped', 'Integration Error', 'Change Requested', 'Hold'},
            'Hold' => new List<String>{'Hold Release Requested', 'Cancellation Requested'},
            'Hold Release Requested' => new List<String>{'Hold Release Requested', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Change Integration Requested',
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Hold Requested'},
            'Cancellation Requested' => new List<String>{'Cancellation Requested','Cancellation Confirmation Pending','Cancellation Integration Requested','Pre-Release Review', 'Confirmation Pending', 'Confirmed',  
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmed', 'Hold Requested',
                'Hold'},
            'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested',
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Hold Requested',
                'Hold'},
            'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Cancellation Confirmed', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested',
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Hold Requested',
                'Hold'},  
            'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed','Cancellation Integration Requested', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Pre-Production',
                'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Hold Requested', 'Hold',
                'Hold Release Requested', 'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested'},
            'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested', 'In Production', 'Partially Shipped', 'Cancellation Confirmed'},
            'Cancelled' => new List<String>{'Cancelled'},
            'Complete' => new List<String>{'Complete'}
        };    
        // Added by ENP - START
        Map<String, List<String>> cSSHWReleaseSelectMap = new Map<String, List<String>>  
        {
            // JV - 20180912 Replaced following with code with below
            /*
            'Draft' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Integration Requested' => new List<String>{'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Planned' => new List<String>{'Integration Requested', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Confirmation Requested' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Confirmation Pending' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested','Confirmed','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Confirmed' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Approved-to-Ship','Partially Shipped','Shipped','Cancelled'},
            'Approved-to-Ship' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Partially Shipped','Shipped','Cancelled'},
            'Partially Shipped' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Shipped','Cancelled'},
            'Shipped' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Cancelled'},
            'Cancelled' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending','Confirmed','Approved-to-Ship','Partially Shipped','Shipped'}
            */
            // with...
            'Draft' => new List<String>{'Draft', 'Integration Requested','Cancelled'},
            'Integration Requested' => new List<String>{'Integration Requested'},
            'Integration Error' => new List<String>{'Draft','Integration Error', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Partially Shipped', 'Change Requested',
                'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Change Integration Requested',
                'Hold Requested', 'Hold Release Requested', 'Cancellation Requested', 'Cancellation Confirmed', 'Cancellation Integration Requested'},
            'Planned' => new List<String>{'Planned', 'Confirmation Requested','Cancellation Requested'},
            'Change Requested' => new List<String>{'Change Requested', 'Change Integration Requested'},
             'Change Integration Requested' => new List<String>{'Change Integration Requested'},
            //'Confirmation Pending' => new List<String>{'Confirmation Pending', 'Confirmation Requested', 'Planned', 'Partially Shipped'},
            'Confirmation Requested' => new List<String>{'Confirmation Requested', 'Confirmed','Planned'},
            'Confirmed' => new List<String>{'Confirmed','Approval to Ship Requested','Planned'},
            'Approval to Ship Requested' => new List<String>{'Approval to Ship Requested'},
            'Approved-to-Ship' => new List<String>{'Approved-to-Ship', 'Cancellation Requested', 'Hold Requested'},
            'Change Confirmation Pending' => new List<String>{'Change Confirmation Pending','Change Confirmation Requested'},
            'Change Confirmation Requested' => new List<String>{'Change Confirmation Requested','Change Confirmed'},
            'Change Confirmed' => new List<String>{'Change Confirmed', 'Change Integration Requested'},
            'Partially Shipped' => new List<String>{'Partially Shipped', 'Change Integration Requested'},
            'Shipped' => new List<String>{'Shipped'},
            'Cancellation Requested' => new List<String>{'Cancellation Requested','Cancellation Integration Requested'}, 
            'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested'},
            'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Cancellation Confirmed'},
            'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed', 'Cancellation Integration Requested'}, 
            'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested'},
            'Cancelled' => new List<String>{'Cancelled'},
            'Hold Requested' => new List<String>{'Hold Requested'},
            'Hold' => new List<String>{'Hold Release Requested'},
            'Hold Release Requested' => new List<String>{'Hold Release Requested', 'Hold'}
           
           
        };
       
        Map<String, List<String>> cSSSWReleaseSelectMap = new Map<String, List<String>>  
        {
            // JV - 20180912 Replaced following with code with below
            /*
            'Draft' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Booked', 'Invoiced', 'Cancelled'},
            'Integration Requested' => new List<String>{'Planned', 'Booked', 'Invoiced', 'Cancelled'},
            'Planned' => new List<String>{'Integration Requested','Booked', 'Invoiced', 'Cancelled'},
            'Booked' => new List<String>{'Integration Requested', 'Planned', 'Invoiced', 'Cancelled'},
            'Invoiced' => new List<String>{'Integration Requested', 'Planned', 'Booked', 'Cancelled'},
            'Cancelled' => new List<String>{'Cancelled'}
            */
            // with..
            'Draft' => new List<String>{'Draft', 'Integration Requested',  'Cancelled'},
            'Integration Requested' => new List<String>{'Integration Requested', 'Draft'},
            'Integration Error' => new List<String>{'Integration Error', 'Draft', 'Planned', 'Booked', 'Change Requested', 'Change Integration Requested',
                'Hold Requested', 'Hold Release Requested', 'Cancellation Requested', 'Cancellation Confirmed', 'Cancellation Integration Requested'},
            'Planned' => new List<String>{'Planned', 'Cancellation Requested', 'Hold Requested'},
            'Change Requested' => new List<String>{'Change Requested', 'Change Integration Requested'},
            'Hold Requested' => new List<String>{'Hold Requested', 'Hold', 'Change Integration Requested', 'Planned', 'Booked'},////SOS_HOLD_INVOICE added Hold
            'Hold' => new List<String>{'Hold', 'Hold Release Requested'},//SOS_HOLD_INVOICE
            'Hold Release Requested' => new List<String>{'Hold Release Requested', 'Change Integration Requested'},//SOS_HOLD_INVOICE
            'Change Integration Requested' => new List<String>{'Change Integration Requested'},//SOS_HOLD_INVOICE
            'Booked' => new List<String>{'Booked', 'Planned', 'Cancellation Requested', 'Hold Requested'},
            'Invoiced' => new List<String>{'Invoiced'},
            'Cancellation Requested' => new List<String>{'Cancellation Requested', 'Cancellation Integration Requested'},
            'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Draft', 'Planned', 'Booked'},
            'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Booked'},
            'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed', 'Cancellation Integration Requested', 'Cancellation Confirmation Pending', 'Draft', 'Planned', 'Booked'},
            'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Booked'},
            'Cancelled' => new List<String>{'Cancelled'}
        };
       
        if (recordTypeName == Label.CSS_Hardware){
            for (String str : cSSHWReleaseSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }
        }
        else if(recordTypeName == Label.CSS_Software){
            for (String str : cSSSWReleaseSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }          
        }
        else if(recordTypeName == 'IGU'){
            for (String str : iGUReleaseSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }
        }
        // Added by ENP - END
        return statusSelections;      
    }


    static public List<SelectOption> getOELStatusSelections(String currentStatus, String recordTypeName)
    {  
        List<SelectOption> statusSelections = new List<SelectOption>();
       
       
        Map<String, List<String>> cSSSWLineSelectMap = new Map<String, List<String>>
        {
       
        // JV - 20180912 Replaced following with code with below
        /*
       
        'Draft' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Booked', 'Invoiced', 'Confirmed', 'Cancelled'},
        'Integration Requested' => new List<String>{'Planned', 'Booked', 'Invoiced', 'Confirmed', 'Cancelled'},
        'Planned' => new List<String>{'Integration Requested', 'Booked', 'Invoiced', 'Confirmed', 'Cancelled'},
        'Booked' => new List<String>{'Integration Requested', 'Planned', 'Invoiced', 'Confirmed', 'Cancelled'},
        'Invoiced' => new List<String>{'Integration Requested', 'Planned', 'Booked', 'Confirmed', 'Cancelled'},
        'Confirmed' => new List<String>{'Integration Requested', 'Planned', 'Booked', 'Invoiced', 'Cancelled'},
        'Cancelled' => new List<String>{'Integration Requested', 'Planned', 'Booked', 'Invoiced', 'Confirmed'}
        */
        // with...  
        'Draft' => new List<String>{'Draft'},
        'Integration Requested' => new List<String>{'Integration Requested', 'Draft'},
        'Integration Error' => new List<String>{'Integration Error', 'Draft', 'Planned', 'Booked', 'Change Requested', 'Change Integration Requested',
            'Hold Requested', 'Hold Release Requested', 'Cancellation Requested', 'Cancellation Confirmed', 'Cancellation Integration Requested'},
        'Planned' => new List<String>{'Planned', 'Cancellation Requested', 'Hold Requested'},
        'Change Requested' => new List<String>{'Change Requested', 'Change Integration Requested'},
        'Hold Requested' => new List<String>{'Hold Requested', 'Change Integration Requested', 'Planned', 'Booked'},
        'Hold' => new List<String>{'Hold Release Requested'}, //SOS_HOLD_INVOICE
        'Hold Release Requested' => new List<String>{'Hold Release Requested', 'Hold'},
        'Booked' => new List<String>{'Booked', 'Planned', 'Cancellation Requested', 'Hold Requested'},
        'Invoiced' => new List<String>{'Invoiced'},
        'Cancellation Requested' => new List<String>{'Cancellation Requested', 'Draft', 'Planned', 'Confirmed'},
        'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Draft', 'Planned', 'Booked'},
        'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Booked'},
        'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed', 'Cancellation Integration Requested', 'Cancellation Confirmation Pending', 'Draft', 'Planned', 'Booked'},
        'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Booked'},
        'Cancelled' => new List<String>{'Cancelled'}
           
        };
       
        Map<String, List<String>> cSSHWLineSelectMap = new Map<String, List<String>>
        {
       
            // JV - 20180912 Replaced following with code with below
            /*
       
            'Draft' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Integration Requested' => new List<String>{'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Planned' => new List<String>{'Integration Requested', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Confirmation Requested' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Confirmation Pending' => new List<String>{'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Confirmed' => new List<String>{'Integration Requested', 'Planned','Confirmation Requested', 'Confirmation Pending', 'Approved-to-Ship', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Approved-to-Ship' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Partially Shipped', 'Shipped', 'Cancelled'},
            'Partially Shipped' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Shipped', 'Cancelled'},
            'Shipped' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Cancelled'},
            'Cancelled' => new List<String>{'Draft', 'Integration Requested', 'Planned', 'Confirmation Requested', 'Confirmation Pending', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped', 'Shipped'}
            */
            // with...
            'Draft' => new List<String>{'Draft'},
            'Integration Requested' => new List<String>{'Integration Requested'},
            'Integration Error' => new List<String>{'Integration Error','Draft','Confirmation Pending', 'Confirmed', 'Integration Requested', 'Partially Shipped', 'Change Requested',
                'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Change Integration Requested',
                'Hold Requested', 'Hold Release Requested', 'Cancellation Requested', 'Cancellation Confirmed', 'Cancellation Integration Requested'},
            'Planned' => new List<String>{'Planned', 'Confirmation Requested','Cancellation Requested'},
            'Change Requested' => new List<String>{'Change Requested'},
            'Change Integration Requested' => new List<String>{'Change Integration Requested'},
            'Confirmation Pending' => new List<String>{'Confirmation Pending', 'Confirmation Requested', 'Planned', 'Partially Shipped'},
            'Confirmation Requested' => new List<String>{'Confirmation Requested', 'Confirmed', 'Confirmation Pending'},
            'Confirmed' => new List<String>{'Confirmed'},
            'Approval to Ship Requested' => new List<String>{'Approval to Ship Requested'},
            'Approved-to-Ship' => new List<String>{'Approved-to-Ship', 'Cancellation Requested', 'Hold Requested'},
            'Partially Shipped' => new List<String>{'Partially Shipped', 'Hold Requested'},//CANCELLATION_BUGS_SEP_20
            'Shipped' => new List<String>{'Shipped'},
            'Change Confirmation Pending' => new List<String>{'Change Confirmation Pending'},
            'Cancellation Requested' => new List<String>{'Cancellation Requested','Draft', 'Planned', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped'},
            'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Cancellation Confirmation Requested', 'Draft', 'Planned', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped'},
            'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped'},
            'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed', 'Cancellation Integration Requested', 'Cancellation Confirmation Pending', 'Draft', 'Planned', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped'},
            'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested', 'Cancellation Confirmed', 'Draft', 'Planned', 'Confirmed', 'Approved-to-Ship', 'Partially Shipped'},
            'Cancelled' => new List<String>{'Cancelled'},
            'Hold Requested' => new List<String>{'Hold Requested', 'Change Integration Requested', 'Planned', 'Approved-to-Ship', 'Partially Shipped'},
            'Hold' => new List<String>{'Hold Release Requested', 'Cancellation Requested'},
            'Hold Release Requested' => new List<String>{'Hold Release Requested', 'Hold'},
            'Change Confirmation Requested' => new List<String>{'Change Confirmation Requested'},
            'Change Confirmed' => new List<String>{'Change Confirmed'}
        };
       
        Map<String, List<String>> iGULineSelectMap = new Map<String, List<String>>
        {
            'Draft' => new List<String>{'Draft', 'Pre-Release Review', 'Hold Requested', 'Cancellation Requested'},
            'Pre-Release Review' => new List<String>{'Pre-Release Review', 'Confirmation Pending', 'Draft', 'Hold Requested', 'Cancellation Requested'},
            'Confirmation Pending' => new List<String>{'Confirmation Pending'},
            'Confirmation Requested' => new List<String>{'Confirmation Requested'},
            'Confirmed' => new List<String>{'Confirmed', 'Draft','Pre-Release Review', 'Confirmation Pending', 'Hold Requested', 'Cancellation Requested'},
            'Integration Requested' => new List<String>{'Integration Requested'},
            'Pre-Production' => new List<String>{'Pre-Production', 'Hold Requested', 'Cancellation Requested'},
            'In Production' => new List<String>{'In Production', 'Hold Requested', 'Cancellation Requested'},
            'Partially Shipped' => new List<String>{'Partially Shipped', 'Hold Requestd', 'Complete'},//CANCELLATION_BUGS_SEP_20
            'Shipped' => new List<String>{'Shipped','Complete'},
            'Integration Error' => new List<String>{'Integration Error', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Pre-Production',
                'In Production', 'Partially Shipped', 'Hold Requested', 'Hold Release Requested', 'Cancellation Requested'},
            'Change Requested' => new List<String>{'Change Requested'},
            'Change Confirmation Pending' => new List<String>{'Change Confirmation Pending'},
            'Change Confirmation Required' => new List<String>{'Change Confirmation Required'},
            'Change Confirmation Requested' => new List<String>{'Change Confirmation Requested'},
            'Change Confirmed' => new List<String>{'Change Confirmed'},
            'Change Integration Requested' => new List<String>{'Change Integration Requested'},
            'Hold Requested' => new List<String>{'Hold Requested', 'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested', 'Pre-Production', 'Change Integration Requested',
                'In Production', 'Partially Shipped'},
            'Hold' => new List<String>{'Hold', 'Hold Release Requested', 'Cancellation Requested'},
            'Hold Release Requested' => new List<String>{'Hold Release Requested'},
            'Cancellation Requested' => new List<String>{'Cancellation Requested',  'Cancellation Integration Requested','Pre-Release Review', 'Confirmation Pending', 'Confirmed',
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested'},
            'Cancellation Confirmation Pending' => new List<String>{'Cancellation Confirmation Pending', 'Pre-Release Review', 'Confirmation Pending',
                'Pre-Production', 'In Production', 'Partially Shipped', 'Change Requested', 'Change Confirmation Pending', 'Change Confirmation Required', 'Change Confirmed', 'Hold Requested'},
            'Cancellation Confirmation Requested' => new List<String>{'Cancellation Confirmation Requested', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Integration Requested',
                'Pre-Production', 'In Production', 'Partially Shipped'},
            'Cancellation Confirmed' => new List<String>{'Cancellation Confirmed', 'Draft', 'Pre-Release Review', 'Confirmation Pending', 'Confirmed', 'Pre-Production',
                'In Production', 'Partially Shipped'},
            'Cancellation Integration Requested' => new List<String>{'Cancellation Integration Requested'},
            'Cancelled' => new List<String>{'Cancelled'},
            'Complete' => new List<String>{'Complete'}
        };
       
        if (recordTypeName == Label.CSS_Hardware){
            for (String str : cSSHWLineSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }
        }
        else if(recordTypeName == Label.CSS_Software){
            for (String str : cSSSWLineSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }          
        }
        else if(recordTypeName.contains('IGU')){
            for (String str : iGULineSelectMap.get(currentStatus)){
                statusSelections.add(new SelectOption(str,str));
            }
        }
        return statusSelections;      
    }
}