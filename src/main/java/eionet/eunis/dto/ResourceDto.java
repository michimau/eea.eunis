package eionet.eunis.dto;

import java.io.Serializable;

import org.apache.commons.lang.StringUtils;
import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Transient;

/**
 * Resource dto for rdf exporting.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@Root
public class ResourceDto implements Serializable{

	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	
	private String id;
	@Transient
	private String prefix;

	/**
	 * @return the id
	 */
	@Attribute(name="rdf:resource")
	public String getId() {
		return StringUtils.isBlank(prefix)
			? id
			: prefix + id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the prefix
	 */
	public String getPrefix() {
		return prefix;
	}

	/**
	 * @param prefix the prefix to set
	 */
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

}
