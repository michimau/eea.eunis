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
public class LinkInfoDTO implements Serializable {
	
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	private String identifier;
	private String hasCanonicalName;
	private String hasGenusName;
	private String hasScientificNameAutorship;
	private String hasScientificName;
	private String hasGBIFPage;
	private String hasBioLibPage;
	private String hasBBCPage;
	private String hasWikipediaArticle;
	private String hasWikispeciesArticle;
	private String hasBugGuide;
	
	public String getIdentifier() {
		return identifier;
	}
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	public String getHasCanonicalName() {
		return hasCanonicalName;
	}
	public void setHasCanonicalName(String hasCanonicalName) {
		this.hasCanonicalName = hasCanonicalName;
	}
	public String getHasGenusName() {
		return hasGenusName;
	}
	public void setHasGenusName(String hasGenusName) {
		this.hasGenusName = hasGenusName;
	}
	public String getHasScientificNameAutorship() {
		return hasScientificNameAutorship;
	}
	public void setHasScientificNameAutorship(String hasScientificNameAutorship) {
		this.hasScientificNameAutorship = hasScientificNameAutorship;
	}
	public String getHasGBIFPage() {
		return hasGBIFPage;
	}
	public void setHasGBIFPage(String hasGBIFPage) {
		this.hasGBIFPage = hasGBIFPage;
	}
	public String getHasBioLibPage() {
		return hasBioLibPage;
	}
	public void setHasBioLibPage(String hasBioLibPage) {
		this.hasBioLibPage = hasBioLibPage;
	}
	public String getHasBBCPage() {
		return hasBBCPage;
	}
	public void setHasBBCPage(String hasBBCPage) {
		this.hasBBCPage = hasBBCPage;
	}
	public String getHasWikipediaArticle() {
		return hasWikipediaArticle;
	}
	public void setHasWikipediaArticle(String hasWikipediaArticle) {
		this.hasWikipediaArticle = hasWikipediaArticle;
	}
	public String getHasWikispeciesArticle() {
		return hasWikispeciesArticle;
	}
	public void setHasWikispeciesArticle(String hasWikispeciesArticle) {
		this.hasWikispeciesArticle = hasWikispeciesArticle;
	}
	public String getHasBugGuide() {
		return hasBugGuide;
	}
	public void setHasBugGuide(String hasBugGuide) {
		this.hasBugGuide = hasBugGuide;
	}
	public String getHasScientificName() {
		return hasScientificName;
	}
	public void setHasScientificName(String hasScientificName) {
		this.hasScientificName = hasScientificName;
	}
	

}
