package ro.finsiel.eunis.utilities;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class EunisUtilTest {

    @Test
    public void test_encodeelement() {
        assertEquals("&lt;element&gt;", EunisUtil.replaceTagsExport("<element>"));
    }

    @Test
    public void test_encodelink() {
        assertEquals("&lt;a href=&quot;http://cdr.eionet.europa.eu/search?y=1&amp;z=2&quot;&gt;",
             EunisUtil.replaceTagsExport("<a href=\"http://cdr.eionet.europa.eu/search?y=1&z=2\">"));
    }

    @Test
    public void test_ampersand() {
        assertEquals("&amp;amp;", EunisUtil.replaceTagsExport("&amp;"));
    }

    // Test HTML tags
    @Test
    public void test_replaceTags() {
        assertEquals(EunisUtil.replaceTagsExport("<div class='Apostrophs'>"),"&lt;div class=&#039;Apostrophs&#039;&gt;");
        assertEquals(EunisUtil.replaceTagsExport("<div class=\"Quotes\">"),"&lt;div class=&quot;Quotes&quot;&gt;");
    }

    @Test
    public void test_unicode() {
        assertEquals("—", EunisUtil.replaceTagsExport("—"));
    }

    @Test
    public void test_plainsqlescape() {
        assertEquals("Fruit & vegetables", EunisUtil.replaceTagsImport("Fruit & vegetables"));
    }

    @Test
    public void test_sqlescape() {
        assertEquals("@ Joe\\'s", EunisUtil.replaceTagsImport("@ Joe's"));
    }
}
