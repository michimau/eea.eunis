package ro.finsiel.eunis.utilities;

import static junit.framework.Assert.assertEquals;
import org.junit.Before;
import org.junit.Test;

/**
 * 
 * @author Jaanus Heinlaid, e-mail: <a href="mailto:jaanus.heinlaid@tietoenator.com">jaanus.heinlaid@tietoenator.com</a>
 *
 */
public class UnicodeEscapesTest {
    
    /** */
    private UnicodeEscapes unicodeEscapes = null;

    @Before
    public void instanciateTestClass() throws Exception {
        unicodeEscapes = new UnicodeEscapes();
    }

    /*
     * Test method for 'eionet.util.UnicodeEscapes.isXHTMLEntity(String)'
     */
    @Test
    public void testIsXHTMLEntity() {
        
        assertEquals(true, unicodeEscapes.isXHTMLEntity("&euro;"));
        assertEquals(false, unicodeEscapes.isXHTMLEntity("&euro"));
        assertEquals(false, unicodeEscapes.isXHTMLEntity("euro;"));
        assertEquals(false, unicodeEscapes.isXHTMLEntity("&;"));
    }

}
