package eionet.eunis.dto;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

/**
 * DTO class to export legalReferences to RDF.
 * 
 * @author alex
 *
 * <a href="mailto:aleks21@gmail.com">contact<a>
 */
@Root(strict = false, name = "hasLegalReference")
public class LegalReferenceDTO implements Serializable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("unused")
	@Attribute(name = "rdf:parseType")
	private static final String attribute =  "Resource";
	
	@Element(required = false, name="rdf:value")
	private ResourceDto idDc;
	
	@Element(required = false, name = "annex")
	private String annex;
	
	@Element(required = false, name = "priority")
	private int priority;
	
	@Element(required = false, name = "comment")
	private String comment;
	
	public LegalReferenceDTO(int idDc, String annex, int priority, String comment) {
		this.idDc = new ResourceDto(idDc + "", "http://eunis.eea.europa.eu/documents/");
		this.annex = annex;
		this.priority = priority;
		this.comment = comment;
	}
	
	public String getAnnex() {
		return annex;
	}
	public void setAnnex(String annex) {
		this.annex = annex;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public ResourceDto getIdDc() {
		return idDc;
	}
	public void setIdDc(ResourceDto idDc) {
		this.idDc = idDc;
	}
	

}
