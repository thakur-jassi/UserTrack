global class UserTrack{
    
    public UserTrack(ApexPages.StandardController stdController) {
    }
    
    
    
     @ReadOnly @RemoteAction
      global Static wAuditResponse getAuditdetails(String UserId, String Name){
        wAuditResponse oResponse = new wAuditResponse();
        oResponse.lUserRecordChange = new List<SetupAuditTrail>();
        oResponse.lUserChanges = new List<SetupAuditTrail>();
          
        for(SetupAuditTrail userHistory : [Select Action, CreatedDate, CreatedBy.Name, Display, Section from SetupAuditTrail ORDER BY CreatedDate DESC]){
            if(userHistory.Section == 'Manage Users' && userHistory.Display.contains('user '+Name)){
                oResponse.lUserRecordChange.add(userHistory);
            }
            if(userHistory.CreatedById == UserId){
                 oResponse.lUserChanges.add(userHistory);
            }
        }

        return oResponse ;
    }

    @ReadOnly @RemoteAction
    global Static wAuditResponse getLimitedAuditdetails(String UserId, String Name){
        wAuditResponse oResponse = new wAuditResponse();
        oResponse.lUserRecordChange = new List<SetupAuditTrail>();
        oResponse.lUserChanges = new List<SetupAuditTrail>();
        
        for(SetupAuditTrail userHistory : [Select Action, CreatedDate, CreatedBy.Name, Display, Section from SetupAuditTrail ORDER BY CreatedDate DESC LIMIT 100000]){
            if(userHistory.Section == 'Manage Users' && userHistory.Display.contains('user '+Name)){
                oResponse.lUserRecordChange.add(userHistory);
            }
            if(userHistory.CreatedById == UserId){
                oResponse.lUserChanges.add(userHistory);
            }
        }
        
        return oResponse ;
    }
    
    global class wAuditResponse{
        Public List<SetupAuditTrail> lUserRecordChange;
        Public List<SetupAuditTrail> lUserChanges;
    
    }
}