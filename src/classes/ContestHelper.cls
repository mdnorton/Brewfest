global class ContestHelper {

	@RemoteAction
	global static BallotResult checkBallotCode( String ballotCode) {
		System.debug( 'ContestHelper.checkBallotCode() was called with [' + ballotcode + ']');
		try {
			Contest_Ballot__c ballot = [select Contest__r.Voting_Closed__c, Contest__c, 
											   (select Contest_Ballot__c from Contest_Votes__r) 
										 from Contest_Ballot__c
										where Name = :ballotCode];
			if ( ballot.Contest__r.Voting_Closed__c == true) {
				return new BallotResult( 'false', 'Voting is Closed for that contest');
			}
			
			if ( ballot.Contest_Votes__r.size() > 0 ) {
				return new BallotResult( 'false', 'That ballot was already used');
			}
			
			return new BallotResult( 'true', 'Ballot is valid');
		} catch ( QueryException qe) {
			return new BallotResult( 'false', 'Ballot is invalid');								
		} catch ( Exception e) {
			return new BallotResult( 'false', e.getMessage());
		} 
	}
	
	global class BallotResult {
		public String valid;
		public String message;
		
		public BallotResult( String v, String m ) {
			this.valid = v;
			this.message = m;
		}
	}
}