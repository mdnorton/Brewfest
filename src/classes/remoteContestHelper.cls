global class remoteContestHelper {
	@RemoteAction
	global static BallotResult[] checkBallotCode( String ballotCode) {
		System.debug( 'ContestHelper.checkBallotCode() was called with ' + ballotcode);
		List<BallotResult> results = new List<BallotResult>();
		try {
			Contest_Ballot__c ballot = [select Contest__r.Voting_Closed__c, Contest__c, 
											   (select Contest_Ballot__c from Contest_Votes__r) 
										 from Contest_Ballot__c
										where Name = :ballotCode];
			if ( ballot.Contest__r.Voting_Closed__c == true) {
				results.add( new BallotResult( 'false', 'Voting is Closed for that contest'));
				return results;
			}
			
			if ( ballot.Contest_Votes__r.size() > 0 ) {
				results.add( new BallotResult( 'false', 'That ballot was already used'));
				return results;
			}
			
			results.add( new BallotResult( 'true', 'Ballot is valid'));
			return results;
		} catch ( QueryException qe) {
			results.add( new BallotResult( 'false', 'Ballot is invalid'));
			return results;								
		} catch ( Exception e) {
			results.add( new BallotResult( 'false', e.getMessage()));
			return results;
		} 
	}
	
	global class BallotResult {
		public String isValid;
		public String message;
		
		public BallotResult( String v, String m ) {
			this.isValid = v;
			this.message = m;
		}
	}
}