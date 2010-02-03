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
public class DcDescriptionDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDc;
	private String idDescription;
	private String description;
	private String toc;
	private String abstr;
	
	public String getIdDc() {
		return idDc;
	}
	public void setIdDc(String idDc) {
		this.idDc = idDc;
	}
	public String getIdDescription() {
		return idDescription;
	}
	public void setIdDescription(String idDescription) {
		this.idDescription = idDescription;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getToc() {
		return toc;
	}
	public void setToc(String toc) {
		this.toc = toc;
	}
	public String getAbstr() {
		return abstr;
	}
	public void setAbstr(String abstr) {
		this.abstr = abstr;
	}
}
