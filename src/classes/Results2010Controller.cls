public class Results2010Controller {

    // Get contests, entries, and contestants
    public List<Contest__c> getContests() {
        List<Contest__c> contests = [select id, name, 
                                            ( select Name, Contestant__r.Name, Average_Score__c, Total_Score__c, Vote_Count__c
                                                from Contest_Entries__r
                                               order by Average_Score__c desc
                                               limit 3) 
                                       from Contest__c
                                      where Voting_Closed__c = true
                                      order by name];
        return contests;         
    }
    
   
}