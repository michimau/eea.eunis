package ro.finsiel.eunis.dataimport; 

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
public class HabitatImportParser extends DefaultHandler { 
        
        private InputStream inputStream;
        
        private PreparedStatement preparedStatementDcIndex;
        private PreparedStatement preparedStatementDcSource;
        private PreparedStatement preparedStatementHabitat;
        private PreparedStatement preparedStatementHabitatDescription;
        private PreparedStatement preparedStatementNatureObject;
        
        private int maxDcIdInt = 0;
        private int maxNoIdInt = 0;
    	private int maxHabitatIdInt = 0;
    	
        private int counter = 0;
        
        private String eunisCode;
        private String level;
        private String name;
        private String description;
        private String source;
        
        private Connection con; 
        
        private StringBuffer buf; 
        private SQLUtilities sqlUtilities;
        
        private HashMap<String, Integer> sources;
        
        public HabitatImportParser(SQLUtilities sqlUtilities) {
        	this.sqlUtilities = sqlUtilities;
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
        		if(qName.equalsIgnoreCase("EUNIS_x0020_code")) {
        			eunisCode = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Level")) {
        			level = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("EUNIS_x0020_name")) {
        			name = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Description")) {
        			description = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Source")) {
        			source = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("EUNIS_x0020_habitats_x0020_complete_x0020_with_x0020_descriptions")) {
        			int dcId = 0;
        			if(source != null && sources != null){ 
        				if(!sources.containsKey(source)){
		        			maxDcIdInt++;
		        			dcId = maxDcIdInt;
		        			preparedStatementDcIndex.setInt(1, dcId);
		        			preparedStatementDcIndex.addBatch();
		        			
		        			preparedStatementDcSource.setInt(1, dcId);
		        			preparedStatementDcSource.setString(2, source);
		        			preparedStatementDcSource.addBatch();
		        			
		        			sources.put(source, new Integer(dcId));
        				} else {
        					dcId = sources.get(source).intValue();
        				}
        			}
        			
        			maxHabitatIdInt++;
        			maxNoIdInt++;
        			preparedStatementHabitat.setInt(1, maxHabitatIdInt);
        			preparedStatementHabitat.setInt(2, maxNoIdInt);
        			preparedStatementHabitat.setString(3, name);
        			preparedStatementHabitat.setString(4, name);
        			preparedStatementHabitat.setString(5, eunisCode);
        			preparedStatementHabitat.setString(6, level);
        			preparedStatementHabitat.addBatch();
        			
        			preparedStatementHabitatDescription.setInt(1, maxHabitatIdInt);
        			preparedStatementHabitatDescription.setString(2, description);
        			preparedStatementHabitatDescription.setInt(3, dcId);
        			preparedStatementHabitatDescription.addBatch();
        			
        			preparedStatementNatureObject.setInt(1, maxNoIdInt);
        			preparedStatementNatureObject.setInt(2, dcId);
        			preparedStatementNatureObject.setString(3, new Integer(maxHabitatIdInt).toString());
        			preparedStatementNatureObject.addBatch();
        			
        			counter++;
        	        if (counter % 10000 == 0){ 
        	        	preparedStatementDcIndex.executeBatch();
        	        	preparedStatementDcIndex.clearParameters(); 
        	        	
        	        	preparedStatementDcSource.executeBatch(); 
                    	preparedStatementDcSource.clearParameters();
                    	
                    	preparedStatementHabitat.executeBatch(); 
                    	preparedStatementHabitat.clearParameters(); 
                    	
                    	preparedStatementHabitatDescription.executeBatch(); 
                    	preparedStatementHabitatDescription.clearParameters(); 
                    	
                    	preparedStatementNatureObject.executeBatch(); 
                    	preparedStatementNatureObject.clearParameters();
                    	
        	        	System.gc(); 
        	        }
        		} 
        	} 
        	catch (SQLException e){ 
        		throw new RuntimeException(e.toString(), e); 
        	} 
        } 
        
        public void execute(InputStream inputStream) throws Exception {
                
            this.inputStream = inputStream;
            
            try {
            	
            	deleteOldRecords();
            	sources = getSources();
            	
            	maxDcIdInt = getMaxId("SELECT MAX(ID_DC) FROM DC_INDEX");
            	maxNoIdInt = getMaxId("SELECT MAX(ID_NATURE_OBJECT) FROM CHM62EDT_NATURE_OBJECT");
            	maxHabitatIdInt = getMaxId("SELECT MAX(ID_HABITAT) FROM CHM62EDT_HABITAT");
            	
            	String queryDcIndex = "INSERT INTO DC_INDEX (ID_DC, COMMENT, REFCD, REFERENCE) VALUES (?,'HABITAT_GLOSSARY',0,-1)";
            	this.preparedStatementDcIndex = con.prepareStatement(queryDcIndex);
            	
            	String queryDcSource = "INSERT INTO DC_SOURCE (ID_DC, ID_SOURCE, SOURCE) VALUES (?,1,?)";
            	this.preparedStatementDcSource = con.prepareStatement(queryDcSource);
            	
            	String queryHabitat = "INSERT INTO CHM62EDT_HABITAT (ID_HABITAT, ID_NATURE_OBJECT, SCIENTIFIC_NAME, DESCRIPTION, EUNIS_HABITAT_CODE, PRIORITY, LEVEL) VALUES (?,?,?,?,?,0,?)";
            	this.preparedStatementHabitat = con.prepareStatement(queryHabitat);
            	
            	String queryHabitatDesc = "INSERT INTO CHM62EDT_HABITAT_DESCRIPTION (ID_HABITAT, ID_LANGUAGE, DESCRIPTION, ID_DC) VALUES (?,25,?,?)";
            	this.preparedStatementHabitatDescription = con.prepareStatement(queryHabitatDesc);
            	
            	String queryNatureObject = "INSERT INTO CHM62EDT_NATURE_OBJECT (ID_NATURE_OBJECT, ID_DC, ORIGINAL_CODE, TYPE) VALUES (?,?,?,'HABITAT')";
            	this.preparedStatementNatureObject = con.prepareStatement(queryNatureObject);
            	
                //con.setAutoCommit(false); 
                parseDocument();
                if (!(counter % 10000 == 0)){ 
                	preparedStatementDcIndex.executeBatch(); 
                	preparedStatementDcIndex.clearParameters();
                	
                	preparedStatementDcSource.executeBatch(); 
                	preparedStatementDcSource.clearParameters();
                	
                	preparedStatementHabitat.executeBatch(); 
                	preparedStatementHabitat.clearParameters();
                	
                	preparedStatementHabitatDescription.executeBatch(); 
                	preparedStatementHabitatDescription.clearParameters(); 
                	
                	preparedStatementNatureObject.executeBatch(); 
                	preparedStatementNatureObject.clearParameters();
                	
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
                if(preparedStatementDcIndex != null) 
                	preparedStatementDcIndex.close();
                
                if(preparedStatementDcSource != null) 
                	preparedStatementDcSource.close();
                
                if(preparedStatementHabitat != null) 
                	preparedStatementHabitat.close();
                
                if(preparedStatementNatureObject != null) 
                	preparedStatementNatureObject.close();
                
                if(con != null) 
                	con.close(); 
            } 
        
        }
        
        private int getMaxId(String query) throws ParseException {
        	String maxId = sqlUtilities.ExecuteSQL(query);
        	int maxIdInt = 0;
        	if(maxId != null && maxId.length()>0)
        		maxIdInt = new Integer(maxId).intValue();
        	
        	return maxIdInt;
        }
        
        private void deleteOldRecords() throws Exception {
        	PreparedStatement ps = null;
        	try{
        		String query = "DELETE FROM CHM62EDT_NATURE_OBJECT WHERE TYPE = 'HABITAT'";
        		ps = con.prepareStatement(query);
        		ps.executeUpdate();
        		
        		query = "DELETE FROM CHM62EDT_HABITAT WHERE ID_HABITAT != -1";
        		ps = con.prepareStatement(query);
        		ps.executeUpdate();
        		
        		query = "DELETE FROM CHM62EDT_HABITAT_DESCRIPTION";
        		ps = con.prepareStatement(query);
        		ps.executeUpdate();
        		
        	} catch(Exception e) { 
                throw new IllegalArgumentException(e.getMessage(), e); 
            } finally { 
            	if(ps != null) 
            		ps.close();
            }
        }
        
        private HashMap<String, Integer> getSources() throws Exception {
        	HashMap<String, Integer> ret = new HashMap<String, Integer>();
        	
        	PreparedStatement stmt = null;
    		ResultSet rset = null;
        	try{
        		String query = "SELECT ID_DC, SOURCE FROM DC_SOURCE";
        		stmt = con.prepareStatement(query);
        		rset = stmt.executeQuery();
        		while(rset.next()){
        			int idDc = rset.getInt("ID_DC");
        			String source = rset.getString("SOURCE");
        			
        			ret.put(source, new Integer(idDc));
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
