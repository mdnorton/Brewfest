/*
 * Class: MobileAppController
 */
public with sharing class MobileAppController {

	public String ballotCode { get; set; }
	public List<Id> entryIds { get; set; }
	public Map<Id,Contest_Entry__c> entryMap { get; set; }
	
	// Pointers
	public Id thisEntry { get; set; }
	public Id lastEntry { get; set; }
	public Id nextEntry { get; set; }

	// Where am i?
	private enum VotingStage { GET_BALLOT_CODE, VOTING, REVIEW_VOTES, FINAL_PAGE }
	private VotingStage stage;
	
	
			
	// For Debugging Only
	public String params { get; set; }
	public String debugOutput { get; set; }
	
	public MobileAppController() {
		
		// DEBUG: Only for debugging
		getParams();
		
		// TODO: Get the Ballot Code (skip for now)
		whereAmI();
		
		if ( stage == VotingStage.GET_BALLOT_CODE ) {
			// Get ballot code
		} else if ( stage == VotingStage.VOTING ) {
			// Voting
		} else if ( stage == VotingStage.REVIEW_VOTES ) {
			// Show the Results
		} else if ( stage == VotingStage.FINAL_PAGE ) {
			// Show the thank you page and link back to start over
		} else {
			// Must be lost
		}

		loadVotes();
		
	}
	
	private void getParams() {
		// Get params
		params = 'Page parameters: ';
		for ( String s : ApexPages.currentPage().getParameters().keySet()) {
			params += s + '=' + ApexPages.currentPage().getParameters().get( s) + ', ';
		}
	}
	
	// TODO: Figure this guy out based on parameters
	private void whereAmI() {
		this.stage = VotingStage.VOTING;
	}

	private void loadVotes() {
		// TODO: Replace this to use the actual ballot code
		entryIds = new List<Id>();
		entryMap = new Map<Id,Contest_Entry__c>();
		for ( Contest_Entry__c entry : [select Id, Name, Contest__r.Name, Contestant__r.Name, Display_Order__c 
										  from Contest_Entry__c 
										 order by Display_Order__c]) {
			entryIds.add( entry.Id);
			entryMap.put( entry.Id, entry);
		 }
		thisEntry = entryIds[0];
		lastEntry = null;
		nextEntry = entryIds[1];
	}
	
	public PageReference onNext() {
		// Check end of list
		if ( thisEntry == entryIds[ entryIds.size() -1]) {
			System.debug( 'Show results page');
			return new PageReference( '/apex/MobileReview');
		} 

		System.debug( 'entryIds is ' + entryIds);
		for ( Integer i = 0 ; i < entryIds.size() ; i++ ) {
			System.debug( 'thisEntry is ' + thisEntry);
			if ( thisEntry == entryIds[i]) {
				thisEntry = entryIds[i+1];
				break;
			}
		}

		return new PageReference( '/apex/MobileApp?entryId=' + thisEntry);

	}
}