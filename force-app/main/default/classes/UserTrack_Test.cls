@isTest
public class UserTrack_Test {
    
    @isTest @ReadOnly @RemoteAction
    public static void testAuditDetailsForUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='systemadmin@test.org', 
                          EmailEncodingKey='UTF-8', LastName='AdminUser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='systemadmin@test783rhjt.org');
        insert u;
        
        system.runAs(u){
            //Get the details of current user 
            ApexPages.StandardController sc = new ApexPages.StandardController(u);
            UserTrack testUserHistory = new UserTrack(sc);
            
            //Get the full audit details
            UserTrack.wAuditResponse response = UserTrack.getAuditdetails(u.Id, u.Name);
            if(!response.lUserRecordChange.isEmpty())
                system.assertEquals(true, response.lUserRecordChange[0].Display.contains('user '+u.Name));
            if(!response.lUserChanges.isEmpty())
                system.assertEquals(u.Id, response.lUserChanges[0].CreatedById);
            
            test.starttest();
            //Get the limited audit details in case of large data volume
            UserTrack.wAuditResponse limitResponse = UserTrack.getLimitedAuditdetails(u.Id, u.Name);
            test.stoptest();
        }
        
    }
}