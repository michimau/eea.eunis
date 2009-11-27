package ro.finsiel.eunis.auth;

import ro.finsiel.eunis.auth.EncryptPassword;
import junit.framework.TestCase;

public class EncryptPasswordTest extends TestCase {

	public void test_encrypt() {
        	String value = EncryptPassword.encrypt("passwork");
		assertEquals("05-5809-423F05-19-63-69-0127-69-7D-0C28-2E", value);
	}

	public void test_encryptEmpty() {
        	String value = EncryptPassword.encrypt("");
		assertEquals("-69-0127-69-7D-0C28-2E", value);
	}

	public void test_decrypt() {
        	String value = EncryptPassword.decrypt("05-5809-423F05-19-63-69-0127-69-7D-0C28-2E");
		assertEquals("passwork", value);
	}
}
