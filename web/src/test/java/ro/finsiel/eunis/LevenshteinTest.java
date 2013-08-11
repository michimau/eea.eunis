package ro.finsiel.eunis;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import org.junit.Test;
import org.junit.BeforeClass;

import eionet.eunis.test.DbHelper;
import ro.finsiel.eunis.utilities.SQLUtilities;


/**
 * Test that the levenshtein function is installed and works.
 */
public class LevenshteinTest {

    private static SQLUtilities sqlUtils;

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        sqlUtils = DbHelper.getSqlUtilities();
    }

    @Test
    public void sameCaseInsensitive() throws Exception {
        String result = sqlUtils.ExecuteSQL("SELECT levenshtein('Levenshtein','lEVENSHTEIN') AS score");
        assertEquals("0", result);
    }

    @Test
    public void oneAdditionalLetter() throws Exception {
        String result = sqlUtils.ExecuteSQL("SELECT levenshtein('Levenshtein','Levenstein') AS score");
        assertEquals("1", result);
    }

    /**
     * Test the support for 'ń'. If the Levenshtein function is installed with
     * collation latin_swedish_ci, then the 'ń' in a string produces a warning
     * and the row is discarded. 'Ń' doesn't exist in ISO-8869-1 nor Windows-1252.
     */
    @Test
    public void accentAcuteOverNArg1() throws Exception {
        String result = sqlUtils.ExecuteSQL("SELECT levenshtein('Leveńshteiń','Levenhstein') AS score");
        assertEquals("2", result);
    }

    @Test
    public void accentAcuteOverNArg2() throws Exception {
        String result = sqlUtils.ExecuteSQL("SELECT levenshtein('Levenshtein','Leveńhsteiń') AS score");
        assertEquals("2", result);
    }
}
