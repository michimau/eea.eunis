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
public class DcTitleDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String idDoc;
	private String idTitle;
	private String title;
	private String alternative;
	
	public String getIdDoc() {
		return idDoc;
	}
	
	public void setIdDoc(String idDoc) {
		this.idDoc = idDoc;
	}
	
	public String getIdTitle() {
		return idTitle;
	}

	public void setIdTitle(String idTitle) {
		this.idTitle = idTitle;
	}

	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}

	public String getAlternative() {
		return alternative;
	}

	public void setAlternative(String alternative) {
		this.alternative = alternative;
	}
	
}
