// Ballot 2011 Controller 
public class Ballots2011Controller {

    public String votingURL { get; set; }
    public Contest__c contest1 { get; set; }
    public Contest__c contest2 { get; set; }
    public List<Contest_Ballot__c> contest1Ballots { get; set; }
    public List<Contest_Ballot__c> contest2Ballots { get; set; }
    public List<ComboBallot> comboBallots { get; set; }
        
    public Ballots2011Controller() {
        String contest1Id = ApexPages.currentPage().getParameters().get( 'contest1Id');
        String contest2Id = ApexPages.currentPage().getParameters().get( 'contest2Id');
        
        // TODO: Remove hard coding
        //contest1Id = 'a01T000000LApYc';
        //contest2Id = 'a01T000000H8ZBP';
        
        // Load up each contest
        contest1 = [select id, Name, Voting_URL__c, Ballot_Message__c from Contest__c where id = :contest1Id];
        contest1Ballots = [select Id, Name from Contest_Ballot__c where Contest__c = :contest1.id];
        
        contest2 = [select id, Name, Voting_URL__c, Ballot_Message__c from Contest__c where id = :contest2Id];
        contest2Ballots = [select Id, Name from Contest_Ballot__c where Contest__c = :contest2.id];
        
        comboBallots = new List<ComboBallot>();
        Integer maxBallots = contest2Ballots.size();
        if ( contest1Ballots.size() < contest2Ballots.size() ) {
            maxBallots = contest1Ballots.size();
        }
        System.debug( 'maxBallots is ' + maxBallots);
        for ( Integer i = 0 ; i < maxBallots ; i++ ) {
            comboBallots.add( new ComboBallot( contest1Ballots[i].Name, contest2Ballots[i].Name));
        }
        System.debug( 'Total Size of comboBallots is ' + comboBallots.size());
    }

    public class ComboBallot {
        public String ballotCode1 { get; set; }
        public String ballotCode2 { get; set; }
        
        public ComboBallot( String x1, String x2) {
            this.ballotCode1 = x1;
            this.ballotCode2 = x2;
        }
    }
}