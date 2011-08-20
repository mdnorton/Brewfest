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
private class ContestEntryListTest {

	private static final String CONTEST_NAME = 'Entry List Unit Test Contest';
	private static final String CONTESTANT_NAME = 'Entry List Unit Test Contestant';
	private static final String ENTRY_NAME = 'Entry List Unit Test Entry';

	// This will be used in multiple test methods
	static {
		System.debug( 'Setting up data for unit tests');
		Contest__c contest = new Contest__c( name = CONTEST_NAME);
		insert contest;
		Contestant__c contestant = new Contestant__c( name = CONTESTANT_NAME);
		insert contestant; 
		Contest_Entry__c entry = new Contest_Entry__c( name = ENTRY_NAME, contest__c = contest.id, contestant__c = contestant.id);
		insert entry;
	}
	
    static testMethod void myUnitTest() {
		PageReference pageRef = Page.ContestEntryList;
		Test.setCurrentPage( pageRef);
		Contest__c contest = [select id, name, ballot_message__c from Contest__c where name = :CONTEST_NAME limit 1];
		ApexPages.StandardController controller = new ApexPages.Standardcontroller( contest);
		ContestEntryListExtension extension = new ContestEntryListExtension( controller);
		System.assert( extension.entries.size() > 0);
		
    }
}