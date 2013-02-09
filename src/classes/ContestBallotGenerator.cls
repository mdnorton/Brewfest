public with sharing class ContestBallotGenerator {

	public static final Integer BALLOT_LENGTH = 4;

	public static void generateBallots( Contest__c contest, Integer numberToGenerate ) {
		System.debug( 'Generating ' + numberToGenerate + ' ballots for contest id ' + contest.id);
		List<Contest_Ballot__c> ballots = new List<Contest_Ballot__c>();
		for ( Integer i = 0 ; i < numberToGenerate ; i++ ) {
			String newBallotCode = Util.randomCode( BALLOT_LENGTH);
			ballots.add( new Contest_Ballot__c( contest__c = contest.id, name = newBallotCode, Unique_Ballot_Code__c = newBallotCode)); 
		}
 		
		Database.Saveresult[] results = Database.insert( ballots, false);
		
	}
}