public class MyScoreController {

	public String[] SCORES = new String[] { '1', '2', '3', '4', '5' };
	public String[] getScores() {
		return SCORES;
	}
	
	public Integer getNumScore() {
		if ( score != null && score > '0' ) {
			return Integer.valueOf( score);
		} else {
			return 0;
		}
	}
	
    public String uiScore { get; set; }
    public String score { get; private set; }
    public String message { get; set; }

    public PageReference onScore() {
        message = 'Score set to ' + uiScore;
        score = uiScore;
        return null;
    }


    public PageReference onReset() {
        message = 'Score reset';
        score = null;
        return null;
    }
    
    public Boolean getCompareScore( String x, String y ) {
    	if ( x <= y) {
    		return true;
    	} else {
    		return false;
    	}
    }


}