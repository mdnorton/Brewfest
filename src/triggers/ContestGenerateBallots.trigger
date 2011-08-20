trigger ContestGenerateBallots on Ballot_Generation__c (before insert) {
    
    for ( Ballot_Generation__c generator : Trigger.new ) {
        Contest__c contest = new Contest__c( id = generator.contest__c);
        Integer numberToGenerate = Integer.valueOf( generator.name);
        ContestBallotGenerator.generateBallots( contest, numberToGenerate);
    }
}