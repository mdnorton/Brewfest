public with sharing class MobileWizController {
	public String ballotCode { get; set; }

	public Contest_Ballot__c ballot { get; private set; }
	public List<ContestEntry> entries { get; set; }
	public String getEntryCount() {
		if ( entries != null && entries.size() > 0 ) {
			return '' + entries.size();
		} else {
			return '0';
		}
	}

	public MobileWizController() {
		ballotCode = ApexPages.currentPage().getParameters().get( 'ballotCode');
		System.debug( 'Ballot code is [' + ballotCode + ']');
		
		ballot = [select Id, Name, Contest__c from Contest_Ballot__c where Name = :ballotCode];
		entries = new List<ContestEntry>();
		
		Integer i = 0;	// Need this for the paging
		for ( Contest_Entry__c entry : [select Name, Contestant__r.Name, Contest__r.Name, Image_URL__c
										  from Contest_Entry__c
										 where Contest__c = :ballot.Contest__c
										 order by Display_Order__c] ) {
		 	entries.add( new ContestEntry( entry, ++i));
		 }

	}

	public PageReference onSubmit() {
		// TODO: All the submission stuff here
		System.debug( 'Ballot Code is [' + ballotCode + ']');
		return new PageReference( '/apex/MobileWiz');
	}
	
	public class ContestEntry {
		public Contest_Entry__c entry { get; set; }
		public Integer points { get; set; }
		public Integer sortOrder { get; set; }
		
		public ContestEntry( Contest_Entry__c e, Integer o) {
			this.entry = e;
			this.points = 0;
			this.sortOrder = o;
		}
		
	}
}