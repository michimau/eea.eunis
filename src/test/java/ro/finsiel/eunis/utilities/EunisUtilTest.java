package ro.finsiel.eunis.utilities;

import ro.finsiel.eunis.utilities.EunisUtil;
import junit.framework.TestCase;

public class EunisUtilTest extends TestCase {

	public void test_encodeelement() {
		assertEquals("&lt;element&gt;", EunisUtil.replaceTagsExport("<element>"));
	}

	public void test_encodelink() {
		assertEquals("&lt;a href=&quot;http://cdr.eionet.europa.eu/search?y=1&amp;z=2&quot;&gt;",
             EunisUtil.replaceTagsExport("<a href=\"http://cdr.eionet.europa.eu/search?y=1&z=2\">"));
	}

	public void test_ampersand() {
		assertEquals("&amp;amp;", EunisUtil.replaceTagsExport("&amp;"));
	}

	// Test HTML tags
	public void test_replaceTags() {
		assertEquals(EunisUtil.replaceTagsExport("<div class='Apostrophs'>"),"&lt;div class=&#039;Apostrophs&#039;&gt;");
		assertEquals(EunisUtil.replaceTagsExport("<div class=\"Quotes\">"),"&lt;div class=&quot;Quotes&quot;&gt;");
	}

	public void test_unicode() {
		assertEquals("—", EunisUtil.replaceTagsExport("—"));
	}

	public void test_plainsqlescape() {
		assertEquals("Fruit & vegetables", EunisUtil.replaceTagsImport("Fruit & vegetables"));
	}
	public void test_sqlescape() {
		assertEquals("@ Joe\\'s", EunisUtil.replaceTagsImport("@ Joe's"));
	}
}
