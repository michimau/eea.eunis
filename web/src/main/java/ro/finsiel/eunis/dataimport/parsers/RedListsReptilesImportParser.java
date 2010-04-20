package ro.finsiel.eunis.dataimport.parsers; 

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import ro.finsiel.eunis.utilities.SQLUtilities;

/** 
 * 
 */ 
public class RedListsReptilesImportParser extends DefaultHandler { 
        
        private InputStream inputStream;
        
        private PreparedStatement preparedStatementReportType;
        private PreparedStatement preparedStatementReport;
        private PreparedStatement preparedStatementReportAttributes;
        
        private int counter = 0;
        private int maxReportTypeId = 0;
        private int maxReportAttributesId = 0;
        
        private String genus;
        private String species;
        private String euCat;
        private String eu25Cat;
        private String notes;
        private String rationale;
        private String trend;
        private String range;
        private String population;
        private String habitat;
        private String threats;
        private String conservationMeasures;
        private String assessors;
        
        private Connection con; 
        
        private StringBuffer buf;
        private SQLUtilities sqlUtilities;
        private HashMap<String, String> conservationStatuses;
        private int euGeoscopeId = 0;
        private int eu25GeoscopeId = 0;
        private Integer idDC;
        
        public RedListsReptilesImportParser(SQLUtilities sqlUtilities, Integer id_dc) {
        	this.sqlUtilities = sqlUtilities;
        	this.idDC = id_dc;
        	this.con = sqlUtilities.getConnection();
        	buf = new StringBuffer();
        } 
        
        private void parseDocument() throws SAXException { 
                
            //get a factory 
            SAXParserFactory spf = SAXParserFactory.newInstance(); 
            try { 
            	//get a new instance of parser 
            	SAXParser sp = spf.newSAXParser(); 
            	//parse the file and also register this class for call backs 
            	sp.parse(inputStream, this);
            	
            }catch(SAXException se) { 
                    se.printStackTrace(); 
                    throw new RuntimeException(se.getMessage(), se); 
            }catch(ParserConfigurationException pce) { 
                    pce.printStackTrace(); 
                    throw new RuntimeException(pce.getMessage(), pce); 
            }catch (IOException ie) { 
                    ie.printStackTrace(); 
                    throw new RuntimeException(ie.getMessage(), ie); 
            } 
        } 
        
        public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        	buf = new StringBuffer();
        } 

        public void characters(char[] ch, int start, int length) throws SAXException { 
        	buf.append(ch,start,length); 
        } 
        
        public void endElement(String uri, String localName, String qName) throws SAXException { 
        	try{ 
        		if(qName.equalsIgnoreCase("Genus")) {
        			genus = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Species")) {
        			species = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Europe_rl_category")) {
        			euCat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("EU_rl_category")) {
        			eu25Cat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Notes")) {
        			notes = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("rl_rationale")) {
        			rationale = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("range")) {
        			range = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("population")) {
        			population = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("rl_trend")) {
        			trend = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("habitat")) {
        			habitat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("threats_info")) {
        			threats = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("cons_measures")) {
        			conservationMeasures = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Assessors")) {
        			assessors = buf.toString().trim();
        		}
        		
        		if(qName.equalsIgnoreCase("European_Reptiles_Red_List_Nov09_rev")) {
        			
        			String genusSpecies = "";
        			if(genus != null && species != null)
        				genusSpecies  = genus + " " +species;
        			
        			String natObId = getNatureObjectId(genusSpecies);
        			String euCSid = conservationStatuses.get(euCat);
        			String euGeoId = new Integer(euGeoscopeId).toString();
        			
        			String eu25CSid = conservationStatuses.get(eu25Cat);
        			String eu25GeoId = new Integer(eu25GeoscopeId).toString();
        			
        			boolean newThreat = false;
        			
        			if(natObId != null && euCSid != null && idDC != null && euGeoId != null && !euGeoId.equals("0")){
        					
    					newThreat = true;
    					
    					maxReportTypeId++;
    					maxReportAttributesId++;
	        			preparedStatementReportType.setInt(1, maxReportTypeId);
	        			preparedStatementReportType.setString(2, euCSid);
	        			preparedStatementReportType.addBatch();
	        			
	        			preparedStatementReport.setString(1, natObId);
	        			preparedStatementReport.setInt(2, idDC.intValue());
	        			preparedStatementReport.setString(3, euGeoId);
	        			preparedStatementReport.setInt(4, maxReportTypeId);
	        			preparedStatementReport.setInt(5, maxReportAttributesId);
	        			preparedStatementReport.addBatch();
	        			
	        			counter++;
        			}
        			
        			if(natObId != null && eu25CSid != null && idDC != null && eu25GeoId != null && !eu25GeoId.equals("0")){
        					
    					maxReportTypeId++;
    					
    					if(!newThreat)
    						maxReportAttributesId++;
    					newThreat = true;
    						
	        			preparedStatementReportType.setInt(1, maxReportTypeId);
	        			preparedStatementReportType.setString(2, eu25CSid);
	        			preparedStatementReportType.addBatch();
	        			
	        			preparedStatementReport.setString(1, natObId);
	        			preparedStatementReport.setInt(2, idDC.intValue());
	        			preparedStatementReport.setString(3, eu25GeoId);
	        			preparedStatementReport.setInt(4, maxReportTypeId);
	        			preparedStatementReport.setInt(5, maxReportAttributesId);
	        			preparedStatementReport.addBatch();
	        			
	        			counter++;
        			}
        			
        			if(newThreat){
        				preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_NOTES");
	        			preparedStatementReportAttributes.setString(3, notes);
	        			preparedStatementReportAttributes.addBatch();
        				
        				preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_RATIONALE");
	        			preparedStatementReportAttributes.setString(3, rationale);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_RANGE");
	        			preparedStatementReportAttributes.setString(3, range);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_POPULATION");
	        			preparedStatementReportAttributes.setString(3, population);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_TREND");
	        			preparedStatementReportAttributes.setString(3, trend);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_HABITAT");
	        			preparedStatementReportAttributes.setString(3, habitat);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_THREATS");
	        			preparedStatementReportAttributes.setString(3, threats);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_CONSERVATION_MEASURES");
	        			preparedStatementReportAttributes.setString(3, conservationMeasures);
	        			preparedStatementReportAttributes.addBatch();
	        			
	        			preparedStatementReportAttributes.setInt(1, maxReportAttributesId);
	        			preparedStatementReportAttributes.setString(2, "EUROPEAN_RED_LIST_ASSESSORS");
	        			preparedStatementReportAttributes.setString(3, assessors);
	        			preparedStatementReportAttributes.addBatch();
        			}
		        			
        	        if (counter != 0 && counter % 3000 == 0){
        	        	preparedStatementReportType.executeBatch(); 
        	        	preparedStatementReportType.clearParameters();
        	        	
        	        	preparedStatementReport.executeBatch(); 
                    	preparedStatementReport.clearParameters();
                    	
                    	preparedStatementReportAttributes.executeBatch(); 
                    	preparedStatementReportAttributes.clearParameters();
                    	
        	        	System.gc(); 
        	        }
        	        
        	        genus = null;
        	        species = null;
        	        euCat = null;
        	        eu25Cat = null;
        	        notes = null;
        	        rationale = null;
        	        range = null;
        	        population = null;
        	        trend = null;
        	        habitat = null;
        	        threats = null;
        	        conservationMeasures = null;
        	        assessors = null;
        		} 
        	} catch (Exception e){ 
        		throw new RuntimeException(e.toString(), e); 
        	} 
        } 
        
        public void execute(InputStream inputStream) throws Exception {
                
            this.inputStream = inputStream;
            
            try {
            	
            	conservationStatuses = getConservationStatuses();
            	maxReportTypeId = getId("SELECT MAX(ID_REPORT_TYPE) FROM CHM62EDT_REPORT_TYPE");
            	maxReportAttributesId = getId("SELECT MAX(ID_REPORT_ATTRIBUTES) FROM CHM62EDT_REPORT_ATTRIBUTES");
            	euGeoscopeId = getId("SELECT ID_GEOSCOPE FROM CHM62EDT_COUNTRY WHERE EUNIS_AREA_CODE = 'EU'");
                eu25GeoscopeId = getId("SELECT ID_GEOSCOPE FROM CHM62EDT_COUNTRY WHERE EUNIS_AREA_CODE = 'E25'");
            	
            	String queryReportType = "INSERT INTO CHM62EDT_REPORT_TYPE (ID_REPORT_TYPE, ID_LOOKUP, LOOKUP_TYPE) VALUES (?,?,'CONSERVATION_STATUS')";
            	this.preparedStatementReportType = con.prepareStatement(queryReportType);
            	
            	String queryReport = "INSERT INTO CHM62EDT_REPORTS (ID_NATURE_OBJECT, ID_DC, ID_GEOSCOPE, ID_GEOSCOPE_LINK, ID_REPORT_TYPE, ID_REPORT_ATTRIBUTES) VALUES (?,?,?,-1,?,?)";
            	this.preparedStatementReport = con.prepareStatement(queryReport);
            	
            	String queryReportAttributes = "INSERT INTO CHM62EDT_REPORT_ATTRIBUTES (ID_REPORT_ATTRIBUTES, NAME, TYPE, VALUE) VALUES (?,?,'TEXT',?)";
            	this.preparedStatementReportAttributes = con.prepareStatement(queryReportAttributes);
            	            	
                //con.setAutoCommit(false); 
                parseDocument();
                if (!(counter % 3000 == 0)){
                	preparedStatementReportType.executeBatch(); 
                	preparedStatementReportType.clearParameters();
                	
                	preparedStatementReport.executeBatch(); 
                	preparedStatementReport.clearParameters();
                	
                	preparedStatementReportAttributes.executeBatch(); 
                	preparedStatementReportAttributes.clearParameters();
                
                	System.gc(); 
                } 
                //con.commit(); 
            } 
            catch ( Exception e ) 
            { 
                //con.rollback(); 
                //con.commit(); 
                throw new IllegalArgumentException(e.getMessage(), e); 
            } 
            finally 
            { 
                if(preparedStatementReportType != null) 
                	preparedStatementReportType.close();
                
                if(preparedStatementReport != null) 
                	preparedStatementReport.close();
                
                if(preparedStatementReportAttributes != null) 
                	preparedStatementReportAttributes.close();
                
                if(con != null) 
                	con.close(); 
            } 
        
        }
        
        private int getId(String query) throws ParseException {
        	String maxId = sqlUtilities.ExecuteSQL(query);
        	int maxIdInt = 0;
        	if(maxId != null && maxId.length()>0)
        		maxIdInt = new Integer(maxId).intValue();
        	
        	return maxIdInt;
        }
        
        private HashMap<String, String> getConservationStatuses() throws Exception {
	    	HashMap<String, String> ret = new HashMap<String, String>();
	    	
	    	PreparedStatement stmt = null;
			ResultSet rset = null;
	    	try{
	    		String query = "SELECT ID_CONSERVATION_STATUS, CODE FROM CHM62EDT_CONSERVATION_STATUS";
	    		stmt = con.prepareStatement(query);
	    		rset = stmt.executeQuery();
	    		while(rset.next()){
	    			String code = rset.getString("CODE");
	    			String idCs = rset.getString("ID_CONSERVATION_STATUS");
	    			ret.put(code, idCs);
	    		}        		
	    		
	    	} catch(Exception e) { 
	            throw new IllegalArgumentException(e.getMessage(), e); 
	        } finally { 
	        	if(stmt != null) 
	        		stmt.close();
	        	if(rset != null) 
	        		rset.close();
	        }        	
	        return ret;
	    }
        
        private String getNatureObjectId(String name) throws Exception {
        	String ret = null;
        	
        	PreparedStatement stmt = null;
			ResultSet rset = null;
	    	try{
	    		String query = "SELECT ID_NATURE_OBJECT FROM chm62edt_species WHERE SCIENTIFIC_NAME = ?";
	    		stmt = con.prepareStatement(query);
	    		stmt.setString(1, name);
	    		rset = stmt.executeQuery();
	    		while(rset.next()){
	    			ret = rset.getString("ID_NATURE_OBJECT");
	    		}      		
	    		
	    	} catch(Exception e) { 
	            throw new IllegalArgumentException(e.getMessage(), e); 
	        } finally { 
	        	if(stmt != null) 
	        		stmt.close();
	        	if(rset != null) 
	        		rset.close();
	        }
	        return ret;
        }
} 
