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
public class HabitatFactsheetOtherDTO implements Serializable {
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer dictionaryType;
	private String title;
	private String noElements;
	
	public Integer getDictionaryType() {
		return dictionaryType;
	}
	public void setDictionaryType(Integer dictionaryType) {
		this.dictionaryType = dictionaryType;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNoElements() {
		return noElements;
	}
	public void setNoElements(String noElements) {
		this.noElements = noElements;
	}
	
}
