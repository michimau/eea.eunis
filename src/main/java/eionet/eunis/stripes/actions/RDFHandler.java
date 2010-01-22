package eionet.eunis.stripes.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import ro.finsiel.eunis.utilities.EunisUtil;

import com.hp.hpl.jena.rdf.arp.ALiteral;
import com.hp.hpl.jena.rdf.arp.AResource;
import com.hp.hpl.jena.rdf.arp.StatementHandler;
import com.hp.hpl.jena.vocabulary.RDF;

import eionet.eunis.dto.LinkInfoDTO;
import eionet.eunis.stripes.extensions.LoadException;
import eionet.eunis.util.Constants;


/**
 * 
 * @author Risto Alt, e-mail: <a href="mailto:risto.alt@tieto.com">risto.alt@tieto.com</a>
 *
 */
public class RDFHandler implements StatementHandler, ErrorHandler{
	
	/** */
	private boolean saxErrorSet = false;
	private boolean saxWarningSet = false;
	
	private Logger logger = Logger.getLogger(RDFHandler.class);
	
	private static final String geo_ns = "http://rdf.geospecies.org/ont/geospecies#";
	
	/** */
	private static final String EMPTY_STRING = "";
	
	private LinkInfoDTO dto = null;
	
	private Connection con = null;
	
	private List<String> errors = null;
	
		
	/**
	 * @throws SQLException 
	 * 
	 */
	public RDFHandler(Connection con) throws SQLException{
		this.con = con;
		errors = new ArrayList<String>();
	}
	
	/*
	 *  (non-Javadoc)
	 * @see com.hp.hpl.jena.rdf.arp.StatementHandler#statement(com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource)
	 */
	public void statement(AResource subject, AResource predicate, AResource object){
		
		statement(subject, predicate, object.isAnonymous() ? object.getAnonymousID() : object.getURI(), EMPTY_STRING, false, object.isAnonymous());
	}

	/*
	 *  (non-Javadoc)
	 * @see com.hp.hpl.jena.rdf.arp.StatementHandler#statement(com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.AResource, com.hp.hpl.jena.rdf.arp.ALiteral)
	 */
	public void statement(AResource subject, AResource predicate, ALiteral object){
		
		statement(subject, predicate, object.toString(), object.getLang(), true, false);
	}
	
	/**
	 * 
	 * @param subject
	 * @param predicate
	 * @param object
	 * @param objectLang
	 * @param litObject
	 * @param anonObject
	 */
	private void statement(AResource subject, AResource predicate,
							String object, String objectLang, boolean litObject, boolean anonObject){

		try{
			if(predicate.toString().equals(RDF.type.toString()) && object.equals("http://rdf.geospecies.org/ont/geospecies#SpeciesConcept")){
				if(dto != null){
					String natob_id = getNatureObjectID(dto);
					if(natob_id != null && !natob_id.equals("")){
						insertReport(dto, natob_id);
					}
				}
					
				dto = new LinkInfoDTO();
				dto.setIdentifier(subject.toString());
			}
			if(dto != null){
				if(predicate.toString().equals(geo_ns+"hasCanonicalName"))
					dto.setHasCanonicalName(object);
				
				if(predicate.toString().equals(geo_ns+"hasGenusName"))
					dto.setHasGenusName(object);
				
				if(predicate.toString().equals(geo_ns+"hasScientificNameAuthorship"))
					dto.setHasScientificNameAutorship(object);
				
				if(predicate.toString().equals(geo_ns+"hasGBIFPage"))
					dto.setHasGBIFPage(object);
				
				if(predicate.toString().equals(geo_ns+"hasBioLibPage"))
					dto.setHasBioLibPage(object);
				
				if(predicate.toString().equals(geo_ns+"hasBBCPage"))
					dto.setHasBBCPage(object);
				
				if(predicate.toString().equals(geo_ns+"hasBBCPage"))
					dto.setHasBBCPage(object);
				
				if(predicate.toString().equals(geo_ns+"hasWikipediaArticle"))
					dto.setHasWikipediaArticle(object);
				
				if(predicate.toString().equals(geo_ns+"hasWikispeciesArticle"))
					dto.setHasWikispeciesArticle(object);
			}
			
		}
		catch (Exception e){
			errors.add(e.getMessage());
			throw new LoadException(e.toString(), e);
		}
	}
	
	private String getNatureObjectID(LinkInfoDTO dto) throws SQLException {
		String natob_id = null;
		
		String sciName = dto.getHasCanonicalName();
		String author = dto.getHasScientificNameAutorship();
		
		if(sciName != null && author != null){
			String query = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE SCIENTIFIC_NAME='"+EunisUtil.replaceTagsImport(sciName)+"' AND AUTHOR='"+EunisUtil.replaceTagsImport(author)+"'";
			
			PreparedStatement ps = null;
		    ResultSet rs = null;

		    try {
		    	ps = con.prepareStatement(query);
		    	rs = ps.executeQuery();
		    	if(rs.next()){
		    		natob_id = rs.getString(1);
		    	}
		    } catch ( Exception e ) {
		    	e.printStackTrace();
		    	errors.add(e.getMessage());
		    } finally {
		    	if(ps != null)
		    		ps.close();
	    		if(rs != null)
	    			rs.close();
		    }
		}
		
		return natob_id;
	}
	
	private void insertReport(LinkInfoDTO dto, String natob_id) throws SQLException {
		
    	insertReportAttribute(Constants.GEOSPECIES_IDENTIFIER, dto.getIdentifier(), natob_id);
    	
    	if(dto.getHasGBIFPage() != null && !dto.getHasGBIFPage().equals("")){
    		insertReportAttribute(Constants.GBIF_PAGE, dto.getHasGBIFPage(), natob_id);
    	}
    	
    	if(dto.getHasBioLibPage() != null && !dto.getHasBioLibPage().equals("")){
    		insertReportAttribute(Constants.BIOLIB_PAGE, dto.getHasBioLibPage(), natob_id);
    	}
    	
    	if(dto.getHasBBCPage() != null && !dto.getHasBBCPage().equals("")){
    		insertReportAttribute(Constants.BBC_PAGE, dto.getHasBBCPage(), natob_id);
    	}
    	
    	if(dto.getHasWikipediaArticle() != null && !dto.getHasWikipediaArticle().equals("")){
    		insertReportAttribute(Constants.WIKIPEDIA_ARTICLE, dto.getHasWikipediaArticle(), natob_id);
    	}
    	
    	if(dto.getHasWikispeciesArticle() != null && !dto.getHasWikispeciesArticle().equals("")){
    		insertReportAttribute(Constants.WIKISPECIES_ARTICLE, dto.getHasWikispeciesArticle(), natob_id);
    	}

	}
	
	private void insertReportAttribute(String name, String value, String natob_id) throws SQLException {
		
		String query = "INSERT INTO CHM62EDT_REPORT_ATTRIBUTES (ID_REPORT_ATTRIBUTES, NAME, TYPE, VALUE) VALUES (?,?,?,?)";
			
		PreparedStatement ps = null;
	    try {
	    	ps = con.prepareStatement(query);
	    	
	    	ps.setString(1, natob_id);
	    	ps.setString(2, name);
	    	ps.setString(3, "TEXT");
	    	ps.setString(4, EunisUtil.replaceTagsImport(value));
	    	ps.executeUpdate();
	    	
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    	errors.add(e.getMessage());
	    } finally {
	    	if(ps != null)
	    		ps.close();
	    }		
	}
	
	/**
	 * 
	 * @throws SQLException
	 */
	protected void endOfFile() throws SQLException{
		
		if(dto != null){
			String natob_id = getNatureObjectID(dto);
			if(natob_id != null && !natob_id.equals("")){
				insertReport(dto, natob_id);
			}
		}		
		
	}
	
	/*
     * (non-Javadoc)
     * @see org.xml.sax.ErrorHandler#error(org.xml.sax.SAXParseException)
     */
	public void error(SAXParseException e) throws SAXException {

		if (!saxErrorSet){
			errors.add(e.getMessage());
			logger.warn("SAX error encountered: " + e.toString(), e);			
			saxErrorSet = true;
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#warning(org.xml.sax.SAXParseException)
	 */
	public void warning(SAXParseException e) throws SAXException {
		
		if (!saxWarningSet){
			logger.warn("SAX warning encountered: " + e.toString(), e);
			errors.add(e.getMessage());
			saxWarningSet = true;
		}
	}

	/*
	 * (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#fatalError(org.xml.sax.SAXParseException)
	 */
	public void fatalError(SAXParseException e) throws SAXException {
		throw new LoadException(e.toString(), e);
	}
	
	/**
	 * @return the saxError
	 */
	public List<String> getErrors() {
		return errors;
	}
}
