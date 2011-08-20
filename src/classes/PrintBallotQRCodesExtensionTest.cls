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
private class PrintBallotQRCodesExtensionTest {

	private static final String CONTEST1_NAME = 'Print QR Code Extension Unit Test Contest';

    static testMethod void myUnitTest() {
		// Create two contests, then some ballots tied to them
		Contest__c contest1 = new Contest__c( name = CONTEST1_NAME);
		insert contest1;
		Ballot_Generation__c contest1BG = new Ballot_Generation__c( contest__c = contest1.id, name = '50');
		insert contest1BG;

		PageReference pageRef = Page.PrintBallotQRCodes;
		Test.setCurrentPage( pageRef);
		ApexPages.StandardController controller = new ApexPages.Standardcontroller( contest1);
		PrintBallotQRCodesExtension extension = new PrintBallotQRCodesExtension( controller);
    }
}