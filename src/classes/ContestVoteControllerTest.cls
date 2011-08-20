/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ContestVoteControllerTest {

	private static final String CONTEST_NAME = 'Unit Test Contest';
	private static final String CONTESTANT_NAME = 'Unit Test Contestant';
	private static final String ENTRY_NAME = 'Unit Test Entry';
	private static final String BALLOT_COUNT = '5';
	
	// This will be used in multiple test methods
	static {
		System.debug( 'Setting up data for unit tests');
		Contest__c contest = new Contest__c( name = CONTEST_NAME);
		insert contest;
		Ballot_Generation__c ballotGeneration = new Ballot_Generation__c( contest__c = contest.id, name = BALLOT_COUNT);
		insert ballotGeneration;
		Contestant__c contestant = new Contestant__c( name = CONTESTANT_NAME);
		insert contestant; 
		Contest_Entry__c entry = new Contest_Entry__c( name = ENTRY_NAME, contest__c = contest.id, contestant__c = contestant.id);
		insert entry;
	}
	
	// Test using the happy path
    static testMethod void testPositives() {
    	// Get contest variables
    	Contest__c contest = [select id, name from Contest__c where name = :CONTEST_NAME];
    	List<Contest_Ballot__c> ballots = [select id, name 
    										 from Contest_Ballot__c 
    										where contest__c = :contest.id
    										  and id not in (
    										      select Contest_Ballot__c
    										        from Contest_Vote__c)];
		
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = ballots[0].name;
		pageRef = controller.gotoPage2();
		
		// Make sure we're on the right page.
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVote'));
		
		controller.entryList[0].score = 5;
		pageRef = controller.submit();
		
		// Should be on the last page
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVoteComplete'));
    }
    
    // Test getScores.  This doesn't seem to get called.
    static testMethod void testGetScores() {
    	ContestVoteController controller = new ContestVoteController();
    	List<SelectOption> theOptions = controller.getScores();
    	System.assertEquals( 5, theOptions.size());
    }
    
    // Test all the negative cases
    static testMethod void testNoBallotCode() {
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = '';
		pageRef = controller.gotoPage2();
		
		System.assert( ContestVoteControllerTest.pageContainsMessage( 'Ballot Code is required'));
    }

	// Test using the happy path
    static testMethod void testVotingClosed() {
    	// Get contest variables
    	Contest__c contest = [select id, name, Voting_Closed__c from Contest__c where name = :CONTEST_NAME];
    	List<Contest_Ballot__c> ballots = [select id, name from Contest_Ballot__c where contest__c = :contest.id];
		
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
    	// Set voting closed to true
    	contest.Voting_Closed__c = true;
    	update contest;
    	
		// Fill in ballot id and submit
		controller.ballotCode = ballots[0].name;
		pageRef = controller.gotoPage2();
		
		System.assert( ContestVoteControllerTest.pageContainsMessage( 'Voting is closed for'));

		// Now re-open the voting for other test cases (no telling which order they'll run)
    	contest.Voting_Closed__c = false;
    	update contest;
		
    }
    
    // Test invalid ballot code
    static testMethod void testInvalidBallotCode() {
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = '010101';
		pageRef = controller.gotoPage2();
		
		System.assert( ContestVoteControllerTest.pageContainsMessage( 'Invalid Ballot Code'));
    }

    // Test reset button
    static testMethod void testReset() {
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = '010101';
		pageRef = controller.reset();
		
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVoteGetBallot'));
    }

    // Test goto page 1
    static testMethod void testGotoPage1() {
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = '010101';
		pageRef = controller.gotoPage1();
		
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVoteGetBallot'));
    }

	// Test using the happy path
    static testMethod void testDuplicateBallotCode() {
    	// Get contest variables
    	Contest__c contest = [select id, name from Contest__c where name = :CONTEST_NAME];
    	List<Contest_Ballot__c> ballots = [select id, name 
    										 from Contest_Ballot__c 
    										where contest__c = :contest.id
    										  and id not in (
    										      select Contest_Ballot__c
    										        from Contest_Vote__c)];
		
		// Unit test on vote page 1
    	PageReference pageRef = Page.ContestVoteGetBallot;
    	ContestVoteController controller = new ContestVoteController();
    	
		// Fill in ballot id and submit
		controller.ballotCode = ballots[0].name;
		pageRef = controller.gotoPage2();
		
		// Make sure we're on the right page.
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVote'));
		
		controller.entryList[0].score = 5;
		pageRef = controller.submit();
		
		// Should be on the last page
		System.assert( pageRef.getURL().equalsIgnoreCase( '/apex/ContestVoteComplete'));

		// Now run through again and try to use the same ballot name
		pageRef = Page.ContestVoteGetBallot;

		// Fill in ballot id and submit
		controller.ballotCode = ballots[0].name;
		pageRef = controller.gotoPage2();

		System.assert( ContestVoteControllerTest.pageContainsMessage( 'That ballot has already been used'));
    }
    
    // Utility method to check for specifc page message in apex pages
    private static Boolean pageContainsMessage( String pageMessage) {
		Boolean correctMessageFound = false;

		if ( ApexPages.hasMessages() ) {
			for ( ApexPages.Message msg : ApexPages.getMessages()) {
				if ( msg.getDetail().contains( pageMessage)) {
					correctMessageFound = true;
					break;
				}
			}
		}
		
		return correctMessageFound;
    }

}