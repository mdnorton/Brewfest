/* 
 * Util
 * General Utilities
 */
public abstract class Util {
    
    //private static final String ALL_CHARACTERS = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';        // Notice no zero, 1, I, or letter O
    private static final String ALL_CHARACTERS = '23456789';        // Notice no zero, 1, I, or letter O
    private static final Integer AC_LENGTH = ALL_CHARACTERS.length();
    private static final Integer NUMBER_OF_TESTS = 100;

    /*
     * randomCode
     * Return a string of random characters
     */
    public static String randomCode( Integer len) {
        String randomCode = '';
        
        for ( Integer i = 0 ; i < len ; i++ ) {
            randomCode += Util.randomCharacter();
        }
        return randomCode;
    }

    /*
     * randomCharacter
     * Return a random character from the ALL_CHARACTERS array
     */
    public static String randomCharacter() {
        Integer randomIndex = Math.Mod( Math.Round( Math.random() * AC_LENGTH), AC_LENGTH);
        return ALL_CHARACTERS.substring( randomIndex, randomIndex + 1);
    
    }
    
    /*
     * testRandomCode
     * Test the random code generator
     */
    static TestMethod void testRandomCode() {
        Integer codeLength = ContestBallotGenerator.BALLOT_LENGTH;
        String code = Util.randomCode( codeLength);
        System.assert( code.length() == codeLength);
        System.assert(true);
    }
    
    /*
     * testRandomCharacter
     * Test the random character generator
     */
    static TestMethod void testRandomCharacter() {
        String character = Util.randomCharacter();
        System.assert( character.length() == 1);
    }

    /*
     * testRandomocity
     * Make sure the random character generator is scattering the characters enough
     */
    static TestMethod void testRandomocity() {
        // Build a map with all the characters
        Integer[] statsList = new Integer[AC_LENGTH];
        for ( Integer i = 0 ; i < AC_LENGTH ; i++ ) {
            statsList[i] = 0;
        }
        
        // Run tests and collect the stats
        Integer testCount = AC_LENGTH * NUMBER_OF_TESTS;
        for ( Integer i = 0 ; i < testCount ; i++ ) {
            String c = Util.randomCharacter();
            statsList[ (Integer) ALL_CHARACTERS.indexOf( c)]++;
        }

        Integer lowPoint = NUMBER_OF_TESTS - (Integer) ( NUMBER_OF_TESTS / 5);
        Integer highPoint = NUMBER_OF_TESTS + (Integer) ( NUMBER_OF_TESTS / 5);
        String output = 'Results: (' + lowPoint + '/' + highPoint + ')\n';
        Integer blips = 0;
        for ( Integer i = 0 ; i < ALL_CHARACTERS.length() ; i++ ) {
            output += ALL_CHARACTERS.substring( i, i+1) + ' ' + statsList[i] + ' ';
            if ( statsList[i] < lowPoint || statsList[i] > highPoint ) {
                output += '*';
                blips += 1;
            }
            output += '\n';
        }
        output += 'Blips: ' + blips;
        System.debug( LoggingLevel.INFO, output);
        System.assert( blips < 5);
    }   
    
}