package ro.finsiel.eunis.search;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class UtilitiesTest {

    /**
     * To <em>not</em> encode the ampersand in the value is probably not a good idea.
     * "&amp;category=Mosses %26 Liverworts" or "&amp;category=Mosses%20%26%20Liverworts"
     * would be more correct.
     */
    @Test
    public void stringParameter() {
        StringBuffer urlString = Utilities.writeURLParameter("category", "Mosses & Liverworts");
        assertEquals("&amp;category=Mosses & Liverworts", urlString.toString());
    }

    /**
     * Check how '+' is handled. This is an old encoding for space ' ', so '+'
     * should be encoded to '%2B'.
     */
    @Test
    public void plusParameter() {
        StringBuffer urlString = Utilities.writeURLParameter("operator", "+");
        assertEquals("&amp;operator=+", urlString.toString());
    }

    @Test
    public void integerURLParameter() {
        StringBuffer urlString = Utilities.writeURLParameter("code", 300);
        assertEquals("&amp;code=300", urlString.toString());
    }

    @Test
    public void multipleStringValues() {
        String[] countries = {"AT", "BE", "BG" };

        StringBuffer urlString = Utilities.writeURLParameter("country", countries);
        assertEquals("&amp;country=AT&amp;country=BE&amp;country=BG", urlString.toString());
    }

    @Test
    public void formatSimpleDecimal() {
        String testString = "-123.3435242";
        String expected = "<span style=\"font-family: 'Courier New', courier; font-size: 95%\">XXXXX-123.34352</span>";

        String result = Utilities.formatArea(testString, 9, 5, "X");
        assertEquals(expected, result);
    }

    @Test
    public void testTrimArray() {
        String[] testArray = {" 1 ", "2 ", null, "4" };
        String[] resultArray;
        String[] expectedArray = {"1", "2", null, "4" };

        resultArray = Utilities.trimArray(testArray);
        for (int i = 0;  i  < resultArray.length; i++) {
            assertEquals(expectedArray[i], resultArray[i]);
        }
    }

    @Test
    public void testFloatAsStringToInt() {
        int result = Utilities.checkedStringToInt("1234.5", 123);
        assertEquals(123, result);
    }

    @Test
    public void testIntAsStringToInt() {
        int result = Utilities.checkedStringToInt("3456", 123);
        assertEquals(3456, result);
    }
    @Test
    public void testHighlightTerm() {
        String test = "my test for replacement. replaces patterns within text";
        test = Utilities.highlightTerm(test, "replace");
        String expected = "my test for <strong>replace</strong>ment. <strong>replace</strong>s patterns within text";
        assertEquals(expected, test);
    }
}
