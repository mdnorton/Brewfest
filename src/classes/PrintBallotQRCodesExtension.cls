public class PrintBallotQRCodesExtension {

    public Contest__c contest { get; set; }
    public List<Contest_Ballot__c> ballots { get; set; }
    public List<Set<String>> allBallots { get; set; }
    
    private static final Integer DEFAULT_ROW_SIZE = 6;
    private Integer rowSize { get; set;}
    
    public PrintBallotQRCodesExtension(ApexPages.StandardController controller) {
        this.contest = (Contest__c)controller.getRecord();
        this.contest = [select id, Name, Voting_URL__c, Ballot_Message__c
                          from Contest__c
                         where id = :contest.id];
        
		// Allow an override of the row size
        try {
        	rowSize = Integer.valueOf( ApexPages.currentPage().getParameters().get( 'rowSize'));
        } catch ( Exception e ) {
        	// I really don't care how I got here
        	rowSize = DEFAULT_ROW_SIZE;
        }
        
        // Build List of Sets of Ballots ;)
        allBallots = new List<Set<String>>();
        Set<String> row = new Set<String>();
        Integer ROW_SIZE = 8;    // TODO: Move this up
        for ( Contest_Ballot__c ballot : [select Id, Name from Contest_Ballot__c where contest__c = :contest.id] ) {
            if ( row.size() >= rowSize ) {
                allBallots.add( row);
                row = new Set<String>();
            }
            row.add( ballot.Name);
        }    
    }
}