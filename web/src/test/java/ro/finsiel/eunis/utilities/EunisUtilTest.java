package ro.finsiel.eunis.utilities;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

import java.util.Date;

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
        assertEquals("&lt;div class=&#039;Apostrophs&#039;&gt;",EunisUtil.replaceTagsExport("<div class='Apostrophs'>"));
        assertEquals("&lt;div class=&quot;Quotes&quot;&gt;",EunisUtil.replaceTagsExport("<div class=\"Quotes\">"));
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

    @Test
    public void test_replace(){
        assertEquals("AABBBAA", EunisUtil.replace("AABBBBBBAA", "BB", "B"));
        assertEquals("ABABAA",EunisUtil.replace("AABBAABBAA","AB",""));
        assertEquals("",EunisUtil.replace("AAAA","AAAA",""));
        assertEquals("",EunisUtil.replace("","A","BBBB"));
        // this one never ended because of bug
        assertEquals("AA BB",EunisUtil.replace("AA BB","","A"));
    }

    @Test
    public void test_replaceBrackets(){
        assertEquals("abc", EunisUtil.replaceBrackets("abc"));
        assertEquals("abc[", EunisUtil.replaceBrackets("abc{"));
        assertEquals("[][][]", EunisUtil.replaceBrackets("{}{}{}"));
        assertEquals("[][][]", EunisUtil.replaceBrackets("{}[]{}"));
        assertEquals("", EunisUtil.replaceBrackets(null));
    }

    @Test
    public void test_mysqlEscapes(){
        assertEquals("AABBBAA", EunisUtil.mysqlEscapes("AABBBAA"));
        assertEquals("AA''BBBAA", EunisUtil.mysqlEscapes("AA'BBBAA"));
        assertEquals("''AABBBAA''", EunisUtil.mysqlEscapes("'AABBBAA'"));
        assertEquals("Populus nigra cv. ''Plantierensis''", EunisUtil.mysqlEscapes("Populus nigra cv. 'Plantierensis'"));
    }
}
