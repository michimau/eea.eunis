package eionet.eunis.dto;

import java.io.Serializable;

import org.simpleframework.xml.Root;

/**
 * Document dto object.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@Root
public class DcLanguageDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDc;
	private String idLanguage;
	private String language;
	
	public String getIdDc() {
		return idDc;
	}
	public void setIdDc(String idDc) {
		this.idDc = idDc;
	}
	public String getIdLanguage() {
		return idLanguage;
	}
	public void setIdLanguage(String idLanguage) {
		this.idLanguage = idLanguage;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
}
