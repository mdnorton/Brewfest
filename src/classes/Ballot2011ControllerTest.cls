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

private class Ballot2011ControllerTest {

	private static final String CONTEST1_NAME = 'Combo Ballot Unit Test Contest 1';
	private static final String CONTEST2_NAME = 'Combo Ballot Unit Test Contest 2';

    static testMethod void myUnitTest() {
		// Create two contests, then some ballots tied to them
		Contest__c contest1 = new Contest__c( name = CONTEST1_NAME);
		insert contest1;
		Ballot_Generation__c contest1BG = new Ballot_Generation__c( contest__c = contest1.id, name = '5');
		insert contest1BG;

		Contest__c contest2 = new Contest__c( name = CONTEST2_NAME);
		insert contest2;
		Ballot_Generation__c contest2BG = new Ballot_Generation__c( contest__c = contest2.id, name = '10');
		insert contest2BG;
	
		PageReference pageRef = Page.Ballots2011;
		Test.setCurrentPage( pageRef);
		pageRef.getParameters().put( 'contest1Id', contest1.id);
		pageRef.getParameters().put( 'contest2Id', contest2.id);
		
		Ballots2011Controller ctrl = new Ballots2011Controller();
    }
}