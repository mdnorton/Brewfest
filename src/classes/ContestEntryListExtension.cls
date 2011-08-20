public with sharing class ContestEntryListExtension {

	private final Contest__c contest;
	public List<Contest_Entry__c> entries {get; set;}
	public Integer score { get; set; }

    public ContestEntryListExtension(ApexPages.StandardController controller) {
        this.contest = (Contest__c)controller.getRecord();
        System.debug( 'Contest name is ' + contest.name);
        
        entries = [select Contestant__r.Name, Name
        			 from Contest_Entry__c
        			where contest__c = :contest.id
        			order by Display_Order__c, Contestant__r.Name, Name];
    }

}