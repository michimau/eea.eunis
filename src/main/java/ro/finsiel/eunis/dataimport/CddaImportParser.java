package ro.finsiel.eunis.dataimport; 

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/** 
 * 
 */ 
public class CddaImportParser extends DefaultHandler { 
        
        private InputStream inputStream;
        private String idSite;
        private String siteName;
        
        private PreparedStatement preparedStatement; 
        private Connection con; 
        
        private StringBuffer buf; 
        private int counter = 0; 
        
        public CddaImportParser(Connection con) {
        	this.con = con;
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
        		if(qName.equalsIgnoreCase("SITE_CODE")) {
        			idSite = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("SITE_NAME")) {
        			siteName = buf.toString().trim();
        			if(idSite != null && siteName != null){
        				preparedStatement.setString(1, siteName);
        				preparedStatement.setString(2, idSite);
        				counter++;
        	        	preparedStatement.addBatch(); 
        	        	if (counter % 10000 == 0){ 
        	        		preparedStatement.executeBatch(); 
        	        		preparedStatement.clearParameters(); 
        	        		System.gc(); 
        	        	}
        	        	idSite = null;
        	        	siteName = null;
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
            	String query = "UPDATE chm62edt_sites SET NAME=? WHERE ID_SITE = ?";
            	this.preparedStatement = con.prepareStatement(query.toString()); 
                //con.setAutoCommit(false); 
                parseDocument(); 
                if (!(counter % 10000 == 0)){ 
                	preparedStatement.executeBatch(); 
                	preparedStatement.clearParameters(); 
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
                if ( preparedStatement != null ) 
                	preparedStatement.close(); 
            } 
        
        } 
} 
