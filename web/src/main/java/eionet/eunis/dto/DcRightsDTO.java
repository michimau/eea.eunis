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
public class DcRightsDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDc;
	private String idRights;
	private String rights;
	
	public String getIdDc() {
		return idDc;
	}
	public void setIdDc(String idDc) {
		this.idDc = idDc;
	}
	public String getIdRights() {
		return idRights;
	}
	public void setIdRights(String idRights) {
		this.idRights = idRights;
	}
	public String getRights() {
		return rights;
	}
	public void setRights(String rights) {
		this.rights = rights;
	}
}
