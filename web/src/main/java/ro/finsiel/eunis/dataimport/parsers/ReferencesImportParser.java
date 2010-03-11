package ro.finsiel.eunis.dataimport.parsers; 

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

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
public class ReferencesImportParser extends DefaultHandler { 
        
        private InputStream inputStream;
        
        private PreparedStatement preparedStatementDcIndex;
        private PreparedStatement preparedStatementDcDate;
        private PreparedStatement preparedStatementDcTitle;
        private PreparedStatement preparedStatementDcPublisher;
        private PreparedStatement preparedStatementDcSource;
        
        private int counter = 0;
        
        private String refcd;
        private String author;
        private String date;
        private String title;
        private String abrevTitle;
        private String editor;
        private String journTitle;
        private String bookTitle;
        private String journIssue;
        private String publisher;
        private String isbn;
        private String url;
        private String legalInstCd;
        
        private Connection con; 
        
        private StringBuffer buf; 
        private SQLUtilities sqlUtilities;
        private int maxDcId;
        
        public ReferencesImportParser(SQLUtilities sqlUtilities) {
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
        		if(qName.equalsIgnoreCase("Refcd")) {
        			refcd = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Author")) {
        			author = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Date")) {
        			date = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Title")) {
        			title = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Abrev_Title")) {
        			abrevTitle = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Editor")) {
        			editor = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Journtitle")) {
        			journTitle = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Booktitle")) {
        			bookTitle = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Journissue")) {
        			journIssue = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Publisher")) {
        			publisher = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("ISBN")) {
        			isbn = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("URL")) {
        			url = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("legal_inst_cd")) {
        			legalInstCd = buf.toString().trim();
        		}
        		
        		if(qName.equalsIgnoreCase("REFERENCES")) {
        			
        			maxDcId++;
        			preparedStatementDcIndex.setInt(1, maxDcId);
        			preparedStatementDcIndex.setString(2, legalInstCd);
        			preparedStatementDcIndex.setString(3, refcd);
        			preparedStatementDcIndex.addBatch();
        			
        			String created = formatYear(date);
        			preparedStatementDcDate.setInt(1, maxDcId);
        			preparedStatementDcDate.setString(2, created);
        			preparedStatementDcDate.addBatch();
        			
        			preparedStatementDcTitle.setInt(1, maxDcId);
        			preparedStatementDcTitle.setString(2, title);
        			preparedStatementDcTitle.setString(3, abrevTitle);
        			preparedStatementDcTitle.addBatch();
        			
        			preparedStatementDcPublisher.setInt(1, maxDcId);
        			preparedStatementDcPublisher.setString(2, publisher);
        			preparedStatementDcPublisher.addBatch();
        			
        			preparedStatementDcSource.setInt(1, maxDcId);
        			preparedStatementDcSource.setString(2, author);
        			preparedStatementDcSource.setString(3, editor);
        			preparedStatementDcSource.setString(4, journTitle);
        			preparedStatementDcSource.setString(5, bookTitle);
        			preparedStatementDcSource.setString(6, journIssue);
        			preparedStatementDcSource.setString(7, isbn);
        			preparedStatementDcSource.setString(8, url);
        			preparedStatementDcSource.addBatch();
        			
        			counter++;
        	        if (counter % 10000 == 0){
        	        	preparedStatementDcIndex.executeBatch(); 
                    	preparedStatementDcIndex.clearParameters();
                    	
                    	preparedStatementDcDate.executeBatch(); 
                    	preparedStatementDcDate.clearParameters();
                    	
                    	preparedStatementDcTitle.executeBatch(); 
                    	preparedStatementDcTitle.clearParameters();
                    	
                    	preparedStatementDcPublisher.executeBatch(); 
                    	preparedStatementDcPublisher.clearParameters();
                    	
                    	preparedStatementDcSource.executeBatch(); 
                    	preparedStatementDcSource.clearParameters();
                    	
        	        	System.gc(); 
        	        }
        	        
        	        refcd = null;
        	        author = null;
        	        date = null;
        	        title = null;
        	        abrevTitle = null;
        	        editor = null;
        	        journTitle = null;
        	        bookTitle = null;
        	        journIssue = null;
        	        publisher = null;
        	        isbn = null;
        	        url = null;
        	        legalInstCd = null;
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
            	maxDcId = getMaxId("SELECT MAX(ID_DC) FROM DC_INDEX");
            	
            	String query = "INSERT INTO DC_INDEX (ID_DC, REFERENCE, COMMENT, REFCD) VALUES (?,?,'REFERENCES',?)";
            	this.preparedStatementDcIndex = con.prepareStatement(query);
            	
            	String queryDcDate = "INSERT INTO DC_DATE (ID_DC, ID_DATE, CREATED) VALUES (?,1,?)";
            	this.preparedStatementDcDate = con.prepareStatement(queryDcDate);
            	
            	String queryDcTitle = "INSERT INTO DC_TITLE (ID_DC, ID_TITLE, TITLE, ALTERNATIVE) VALUES (?,1,?,?)";
            	this.preparedStatementDcTitle = con.prepareStatement(queryDcTitle);
            	
            	String queryDcPublisher = "INSERT INTO DC_PUBLISHER (ID_DC, ID_PUBLISHER, PUBLISHER) VALUES (?,1,?)";
            	this.preparedStatementDcPublisher = con.prepareStatement(queryDcPublisher);
            	
            	String queryDcSource = "INSERT INTO DC_SOURCE (ID_DC, ID_SOURCE, SOURCE, EDITOR, JOURNAL_TITLE, BOOK_TITLE, JOURNAL_ISSUE, ISBN, URL) VALUES (?,1,?,?,?,?,?,?,?)";
            	this.preparedStatementDcSource = con.prepareStatement(queryDcSource);
            	            	
                //con.setAutoCommit(false); 
                parseDocument();
                if (!(counter % 10000 == 0)){
                	preparedStatementDcIndex.executeBatch(); 
                	preparedStatementDcIndex.clearParameters();
                	
                	preparedStatementDcDate.executeBatch(); 
                	preparedStatementDcDate.clearParameters();
                	
                	preparedStatementDcTitle.executeBatch(); 
                	preparedStatementDcTitle.clearParameters();
                	
                	preparedStatementDcPublisher.executeBatch(); 
                	preparedStatementDcPublisher.clearParameters();
                	
                	preparedStatementDcSource.executeBatch(); 
                	preparedStatementDcSource.clearParameters();
                
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
                
                if(preparedStatementDcDate != null) 
                	preparedStatementDcDate.close();
                
                if(preparedStatementDcTitle != null) 
                	preparedStatementDcTitle.close();
                
                if(preparedStatementDcPublisher != null) 
                	preparedStatementDcPublisher.close();
                
                if(preparedStatementDcSource != null) 
                	preparedStatementDcSource.close();
                
                if(con != null) 
                	con.close(); 
            } 
        
        }
        
        private void deleteOldRecords() throws Exception {
        	PreparedStatement ps = null;
        	PreparedStatement ps2 = null;
        	ResultSet rset = null;
        	try{
        		String query = "SELECT ID_DC FROM DC_INDEX WHERE COMMENT = 'REFERENCES'";
        		ps = con.prepareStatement(query);
        		rset = ps.executeQuery();
	    		while(rset.next()){
	    			int idDc = rset.getInt("ID_DC");
	    			
	    			String sql = "DELETE FROM DC_DATE WHERE ID_DC = ?";
	    			ps2 = con.prepareStatement(sql);
	    			ps2.setInt(1,idDc);
	    			ps2.executeUpdate();
	    			
	    			sql = "DELETE FROM DC_TITLE WHERE ID_DC = ?";
	    			ps2 = con.prepareStatement(sql);
	    			ps2.setInt(1,idDc);
	    			ps2.executeUpdate();
	    			
	    			sql = "DELETE FROM DC_PUBLISHER WHERE ID_DC = ?";
	    			ps2 = con.prepareStatement(sql);
	    			ps2.setInt(1,idDc);
	    			ps2.executeUpdate();
	    			
	    			sql = "DELETE FROM DC_SOURCE WHERE ID_DC = ?";
	    			ps2 = con.prepareStatement(sql);
	    			ps2.setInt(1,idDc);
	    			ps2.executeUpdate();
	    		}
	    		
	    		ps2 = con.prepareStatement("DELETE FROM DC_INDEX WHERE COMMENT = 'REFERENCES'");
	    		ps2.executeUpdate();
        		
        	} catch(Exception e) { 
                throw new IllegalArgumentException(e.getMessage(), e); 
            } finally { 
            	if(rset != null) 
            		rset.close();
            	
            	if(ps != null) 
            		ps.close();
            	
            	if(ps2 != null) 
            		ps2.close();
            }
        }
        
        private int getMaxId(String query) throws ParseException {
        	String maxId = sqlUtilities.ExecuteSQL(query);
        	int maxIdInt = 0;
        	if(maxId != null && maxId.length()>0)
        		maxIdInt = new Integer(maxId).intValue();
        	
        	return maxIdInt;
        }
        
        private String formatYear(String input) {
        	String ret = null;
        	if(input == null || input.length() != 4)
        		return null;
        	
        	try {
        		int x = Integer.parseInt(input);
        		ret = new Integer(x).toString();
        	} catch(NumberFormatException nFE) {
        		return null;
        	}
        	return ret;
        }
} 
