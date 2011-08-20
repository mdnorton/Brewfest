public class ContestVoteController {

	public String ballotCode { get; set; }
	public Contest_Ballot__c ballot { get; set; }
    public List<ContestEntry> entryList { get; set; }

	public ContestVoteController() {
		System.debug( 'Inside ContestVoteController constructor');
		this.ballot = new Contest_Ballot__c();
		ballotCode = ApexPages.currentPage().getParameters().get( 'ballotCode');
	}
	
	// Might get here from a QR code
	public PageReference checkParams() {
		System.debug( 'Inside ContestVoteController checkParams()');
		ballotCode = ApexPages.currentPage().getParameters().get( 'ballotCode');
		if ( ballotCode != null && ballotCode.length() > 0) {
			PageReference p = gotoPage2();
			p.setRedirect( true);
			System.debug( 'DEBUG:::PageReference is ' + p.getUrl());
			return p;
		} else {
			return null;
		}
		
	}   
	 
    // Scores
    public List<SelectOption> getScores() {
    	List<SelectOption> options = new List<SelectOption>();
    	for ( Integer i = 1 ; i <= 5 ; i++ ) {
    		String score = '' + i;
    		options.add( new SelectOption( score, score));
    	}
    	return options;
    }
    
    /*
     * Look up Contest based on Ballot code
     * If the ballot code wasn't entered, return with an error.
     * Try to retrieve the Contest info based on ballot code
     */
    public PageReference gotoPage2() {
    	System.debug( 'Inside ContestVoteController.gotoPage2');
    	if ( ballotCode == null || ballotCode.length() == 0 ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Ballot Code is required')); 
   	        return null;
        }
        try {
            this.ballot = [select id, name, contest__c, contest__r.name, contest__r.voting_closed__c
                             from Contest_ballot__c 
                            where name = :ballotCode];
            
            // Check to see if this particular contest is closed
            if ( this.ballot.contest__r.voting_closed__c ) {
	            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Voting is closed for ' + this.ballot.contest__r.name)); 
	            return null;
            }
            
            // Make sure the ballot hasn't already been used
            Integer ballotVoteCount = [select count() from Contest_Vote__c where Contest_Ballot__c = :ballot.id];
            if ( ballotVoteCount > 0 ) {
	            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'That ballot has already been used')); 
	            return null;
            }
            
            // Retrieve the list of entries for this contest
            entryList = new List<ContestEntry>();
            for ( Contest_Entry__c ce : [Select Id, Name, Contestant__r.Name, Contestant__c, Contest__c
										  from Contest_Entry__c
										 where Contest__c = :this.ballot.contest__c
										 order by Display_Order__c, Contestant__r.Name, Name]) {
				entryList.add( new ContestEntry( ce));
			} 
        } catch ( Exception e) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Invalid Ballot Code')); 
            return null;
        }                     
        return Page.ContestVote;
    }

	// Return to page 1
    public PageReference gotoPage1() {
        return Page.ContestVoteGetBallot;
    }

	// Submit the form results
	public PageReference submit() {
        List<Contest_Vote__c> votes = new List<Contest_Vote__c>(); 
        for ( ContestEntry vote : entryList ) {
        	
			if ( vote.score != null ) {
	        	Contest_Vote__c contestVote = new Contest_Vote__c();
	        	contestVote.contest_ballot__c = ballot.id;
	        	contestVote.contest_entry__c = vote.entry.id;
	        	contestVote.score__c = vote.score;
	        	votes.add( contestVote);
			} 
        }
        insert votes;
        return Page.ContestVoteComplete;
	}

	// Reset
    public PageReference reset() {
    	System.debug( 'Reset');
    	ballotCode = '';
        ballot = new Contest_Ballot__c();
        return Page.ContestVoteGetBallot;
    }

	// Inner class to store contest entry and score
	class ContestEntry {
		public Contest_Entry__c entry { get; set; }
		public Integer score { get; set; }
		
		public ContestEntry( Contest_Entry__c e) {
			this.entry = e;
			this.score = 0;
		}
	}
}