package ro.finsiel.eunis;

import static junit.framework.Assert.assertEquals;
import org.junit.Test;

public class VarargsTest {
	
        @Test
	public void test_varargs() {
		String value = varargMethod("param1", "param2");
		assertEquals("test", value);
	}
	
        @Test
	public void test_phrase_string() {
		String value = cmsPhraseMethod("page", "param1");
		assertEquals("test", value);
	}
	
        @Test
	public void test_phrase_int() {
		String value = cmsPhraseMethod("page", 42);
		assertEquals("test", value);
	}
	
        private String cmsPhraseMethod(String idPage, Object... arguments) {
		return "test";
        }

	private String varargMethod(Object... arguments) {
		return "test";
	}
}
