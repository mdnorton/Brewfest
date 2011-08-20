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
private class Results2010ControllerTest {

    static testMethod void Results2020Test() {
		PageReference pageRef = Page.Results2010;
		Results2010Controller controller = new Results2010Controller();
		
		Test.startTest();
		Integer closedContestCount = [select count() from Contest__c where voting_closed__c = true]; 
		List<Contest__c> contests = controller.getContests();
		Test.stopTest();

		System.assertEquals( closedContestCount, contests.size());
		

    }
}