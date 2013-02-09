public with sharing class MobileWizardController {

	public String moveRightAction { get; set; }
	public String moveLeftAction { get; set; }
	
	public String ballotCode { get; set; }
	
	public Datetime getNow() {
		return Datetime.now();
	}
	
	public PageReference checkSetup() {
		String bc = ApexPages.currentPage().getParameters().get( 'ballotCode');
		if ( bc == null || bc.length() == 0 ) {
			return new PageReference( '/apex/MobileWizard1');
		}
		return null;
	}

	public MobileWizardController() {
		System.debug( 'The Wizard Constructor was called');
		
		String bc = ApexPages.currentPage().getParameters().get( 'ballotCode');
		if ( bc == null || bc.length() == 0 ) {
			System.debug( 'Ballot Code Not Provided');
			ApexPages.AddMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Could not get ballot code'));
			return;
		}
	}
	
	public PageReference onValidateBallotCode() {
		System.debug( 'Ballot Code is ' + ballotCode);
		return new PageReference( '/apex/MobileWizard2?ballotCode=' + ballotCode);
	}
	
	public PageReference onSubmit() {
		System.debug( 'Submitting scores and navigating to page 4');
		return new PageReference( '/apex/MobileWizard4');
	}
	
	public PageReference onRestart() {
		return new PageReference( '/apex/MobileWizard1');
	}

}