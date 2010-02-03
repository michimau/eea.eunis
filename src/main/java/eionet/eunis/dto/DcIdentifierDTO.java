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
public class DcIdentifierDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDc;
	private String idIdentifier;
	private String identifier;
	
	public String getIdDc() {
		return idDc;
	}
	public void setIdDc(String idDc) {
		this.idDc = idDc;
	}
	public String getIdIdentifier() {
		return idIdentifier;
	}
	public void setIdIdentifier(String idIdentifier) {
		this.idIdentifier = idIdentifier;
	}
	public String getIdentifier() {
		return identifier;
	}
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
}
