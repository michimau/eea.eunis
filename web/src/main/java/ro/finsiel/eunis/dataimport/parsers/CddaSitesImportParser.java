package ro.finsiel.eunis.dataimport.parsers; 

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

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
public class CddaSitesImportParser extends DefaultHandler { 
        
        private InputStream inputStream;
        
        private PreparedStatement preparedStatementNatObject;
        private PreparedStatement preparedStatementSites;
        private PreparedStatement preparedStatementSitesUpdate;
        private PreparedStatement preparedStatementNatObjectGeoscope;
        
        private int counter = 0;
        
        private String siteNatureObjectId;
        
        private String siteCode;
        private String siteCodeNat;
        private String desigAbbr;
        private String iso3;
        private String siteName;
        private String siteArea;
        private String iucncat;
        private String nuts;
        private String year;
        private String chngYear;
        private String lat;
        private String latNs;
        private String latDeg;
        private String latMin;
        private String latSec;
        private String lon;
        private String lonEw;
        private String lonDeg;
        private String lonMin;
        private String lonSec;
        private boolean newSite = false;
        
        private Connection con; 
        
        private StringBuffer buf; 
        private SQLUtilities sqlUtilities;
        private HashMap<String, Integer> geoscopeIds;
        private HashMap<String, Integer> geoscopeIdsSites;
        private HashMap<String, String> natObjectIds;
        private int maxNoIdInt = 0;
        
        private Map<String, String> sites;
        
        public CddaSitesImportParser(SQLUtilities sqlUtilities) {
        	this.sqlUtilities = sqlUtilities;
        	this.con = sqlUtilities.getConnection();
        	buf = new StringBuffer();
        	sites = new HashMap<String, String>();
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
        			siteCode = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("SITE_CODE_NAT")) {
        			siteCodeNat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("DESIG_ABBR")) {
        			desigAbbr = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("ISO3")) {
        			iso3 = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("SITE_NAME")) {
        			siteName = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("SITE_AREA")) {
        			siteArea = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("IUCNCAT")) {
        			iucncat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("NUTS")) {
        			nuts = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("YEAR")) {
        			year = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("Last_leg_chng_year")) {
        			chngYear = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("LAT")) {
        			lat = buf.toString().trim();
        		}
        		if(qName.equalsIgnoreCase("LON")) {
        			lon = buf.toString().trim();
        		}
        		
        		if(qName.equalsIgnoreCase("CDDA_v8_sites")) {
        			
        			siteNatureObjectId = natObjectIds.get(siteCode);
        			if(siteNatureObjectId == null || siteNatureObjectId.length() == 0){
        				newSite = true;
        				maxNoIdInt++;
        				siteNatureObjectId = new Integer(maxNoIdInt).toString();
        			} else {
        				newSite = false;
        			}
        			
        			if(siteCode != null && siteName != null)
        				sites.put(siteCode, siteName);
        			
        			Integer geoscopeId = 0;
        			if(desigAbbr != null && desigAbbr.length() > 0){
	        			geoscopeId = geoscopeIds.get(desigAbbr);
	        			if(geoscopeId == null)
	        				geoscopeId = 0;
        			}
        			
        			calculateLatitudeParams();
        			calculateLongitudeParams();
        			
        			if(!newSite){
	        			preparedStatementSitesUpdate.setString(1, siteCodeNat);
	        			preparedStatementSitesUpdate.setString(2, desigAbbr);
	        			preparedStatementSitesUpdate.setString(3, siteName);
	        			preparedStatementSitesUpdate.setString(4, siteArea);
	        			preparedStatementSitesUpdate.setString(5, iucncat);
	        			preparedStatementSitesUpdate.setString(6, nuts);
	        			preparedStatementSitesUpdate.setString(7, year);
	        			preparedStatementSitesUpdate.setString(8, chngYear);
	        			preparedStatementSitesUpdate.setString(9, lat);
	        			preparedStatementSitesUpdate.setString(10, latNs);
	        			preparedStatementSitesUpdate.setString(11, latDeg);
	        			preparedStatementSitesUpdate.setString(12, latMin);
	        			preparedStatementSitesUpdate.setString(13, latSec);
	        			preparedStatementSitesUpdate.setString(14, lon);
	        			preparedStatementSitesUpdate.setString(15, lonEw);
	        			preparedStatementSitesUpdate.setString(16, lonDeg);
	        			preparedStatementSitesUpdate.setString(17, lonMin);
	        			preparedStatementSitesUpdate.setString(18, lonSec);
	        			preparedStatementSitesUpdate.setInt(19, geoscopeId);
	        			preparedStatementSitesUpdate.setString(20, siteCode);
	        			preparedStatementSitesUpdate.addBatch();
        			} else {
	        			preparedStatementNatObject.setString(1, siteNatureObjectId);
	        			preparedStatementNatObject.setString(2, siteCode);
	        			preparedStatementNatObject.addBatch();
	        			
	        			preparedStatementSites.setString(1, siteCode);
	        			preparedStatementSites.setString(2, siteCodeNat);
	        			preparedStatementSites.setString(3, desigAbbr);
	        			preparedStatementSites.setString(4, siteName);
	        			preparedStatementSites.setString(5, siteArea);
	        			preparedStatementSites.setString(6, iucncat);
	        			preparedStatementSites.setString(7, nuts);
	        			preparedStatementSites.setString(8, year);
	        			preparedStatementSites.setString(9, chngYear);
	        			preparedStatementSites.setString(10, lat);
	        			preparedStatementSites.setString(11, latNs);
	        			preparedStatementSites.setString(12, latDeg);
	        			preparedStatementSites.setString(13, latMin);
	        			preparedStatementSites.setString(14, latSec);
	        			preparedStatementSites.setString(15, lon);
	        			preparedStatementSites.setString(16, lonEw);
	        			preparedStatementSites.setString(17, lonDeg);
	        			preparedStatementSites.setString(18, lonMin);
	        			preparedStatementSites.setString(19, lonSec);
	        			preparedStatementSites.setInt(20, geoscopeId);
	        			preparedStatementSites.setString(21, siteNatureObjectId);
	        			preparedStatementSites.addBatch();
        			}
        			
        			Integer geoscopeIdSites = -1;
        			if(iso3 != null && iso3.length() > 0){
        				geoscopeIdSites = geoscopeIdsSites.get(iso3);
	        			if(geoscopeIdSites == null)
	        				geoscopeIdSites = -1;
        			}
        			
        			preparedStatementNatObjectGeoscope.setInt(1, geoscopeIdSites);
        			preparedStatementNatObjectGeoscope.setString(2, siteNatureObjectId);
        			preparedStatementNatObjectGeoscope.addBatch();
        			
        			counter++;
        	        if (counter % 10000 == 0){
        	        	preparedStatementNatObject.executeBatch(); 
        	        	preparedStatementNatObject.clearParameters();
        	        	
        	        	preparedStatementSites.executeBatch(); 
        	        	preparedStatementSites.clearParameters();
        	        	
        	        	preparedStatementSitesUpdate.executeBatch(); 
        	        	preparedStatementSitesUpdate.clearParameters();
        	        	
        	        	preparedStatementNatObjectGeoscope.executeBatch(); 
        	        	preparedStatementNatObjectGeoscope.clearParameters();
        	        	
        	        	System.gc(); 
        	        }
        	        
        	        siteCode = null;
        	        siteCodeNat = null;
        	        desigAbbr = null;
        	        iso3 = null;
        	        siteName = null;
        	        siteArea = null;
        	        iucncat = null;
        	        nuts = null;
        	        year = null;
        	        chngYear = null;
        	        lat = null;
        	        lon = null;
        		} 
        	} 
        	catch (Exception e){ 
        		throw new RuntimeException(e.toString(), e); 
        	} 
        } 
        
        public Map<String,String> execute(InputStream inputStream) throws Exception {
                
            this.inputStream = inputStream;
            
            try {
            	
            	con.setAutoCommit(false); 
            	
            	deleteOldGeoscopeRecords();
            	
            	maxNoIdInt = getMaxId("SELECT MAX(ID_NATURE_OBJECT) FROM CHM62EDT_NATURE_OBJECT");
            	natObjectIds = getNatObjectIds();
            	geoscopeIds = getGeoscopeIds();
            	geoscopeIdsSites = getGeoscopeIdsSites();
            	
            	String queryNatObject = "INSERT INTO chm62edt_nature_object (ID_NATURE_OBJECT, ORIGINAL_CODE, ID_DC, TYPE) VALUES (?,?, -1, 'CDDA_NATIONAL_SITES')";
            	this.preparedStatementNatObject = con.prepareStatement(queryNatObject);
            	
            	String querySites = "INSERT INTO chm62edt_sites (ID_SITE, NATIONAL_CODE, ID_DESIGNATION, " +
            			"NAME, AREA, IUCNAT, NUTS, DESIGNATION_DATE, UPDATE_DATE, " +
            			"LATITUDE, LAT_NS, LAT_DEG, LAT_MIN, LAT_SEC, LONGITUDE, LONG_EW, LONG_DEG, LONG_MIN, LONG_SEC, " +
            			"SOURCE_DB, ID_GEOSCOPE, ID_NATURE_OBJECT) " +
            			"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'CDDA_NATIONAL',?,?)";
            	this.preparedStatementSites = con.prepareStatement(querySites);
            	
            	String querySitesUpdate = "UPDATE chm62edt_sites SET NATIONAL_CODE=?, ID_DESIGNATION=?, " +
						"NAME=?, AREA=?, IUCNAT=?, NUTS=?, DESIGNATION_DATE=?, UPDATE_DATE=?, " +
						"LATITUDE=?, LAT_NS=?, LAT_DEG=?, LAT_MIN=?, LAT_SEC=?, LONGITUDE=?, LONG_EW=?, " +
						"LONG_DEG=?, LONG_MIN=?, LONG_SEC=?, SOURCE_DB='CDDA_NATIONAL', ID_GEOSCOPE=? " +
						"WHERE ID_SITE = ?";
            	this.preparedStatementSitesUpdate = con.prepareStatement(querySitesUpdate);
            	
            	String queryNatObjectGeoscope = "INSERT INTO chm62edt_nature_object_geoscope (ID_GEOSCOPE, " +
            			"ID_NATURE_OBJECT, ID_NATURE_OBJECT_LINK, ID_DC, ID_REPORT_ATTRIBUTES) VALUES (?,?, -1, -1, -1)";
            	this.preparedStatementNatObjectGeoscope = con.prepareStatement(queryNatObjectGeoscope);
            	            	            	
                parseDocument();
                if (!(counter % 10000 == 0)){
                	preparedStatementNatObject.executeBatch(); 
                	preparedStatementNatObject.clearParameters();
                	
                	preparedStatementSites.executeBatch(); 
                	preparedStatementSites.clearParameters();
                	
                	preparedStatementSitesUpdate.executeBatch(); 
                	preparedStatementSitesUpdate.clearParameters();
                	
                	preparedStatementNatObjectGeoscope.executeBatch(); 
    	        	preparedStatementNatObjectGeoscope.clearParameters();
    	        	                
                	System.gc(); 
                } 
                con.commit(); 
            } 
            catch ( Exception e ) 
            { 
                con.rollback(); 
                con.commit(); 
                throw new IllegalArgumentException(e.getMessage(), e); 
            } 
            finally 
            { 
                if(preparedStatementNatObject != null) 
                	preparedStatementNatObject.close();
                
                if(preparedStatementSites != null) 
                	preparedStatementSites.close();
                
                if(preparedStatementSitesUpdate != null) 
                	preparedStatementSitesUpdate.close();
                
                if(preparedStatementNatObjectGeoscope != null) 
                	preparedStatementNatObjectGeoscope.close();
                                
                if(con != null) 
                	con.close(); 
            }
            
            return sites;
        
        }
        
        private HashMap<String, String> getNatObjectIds() throws Exception {
        	HashMap<String, String> ret = new HashMap<String, String>();
	    	
	    	PreparedStatement stmt = null;
			ResultSet rset = null;
	    	try{
	    		String query = "SELECT ID_SITE, ID_NATURE_OBJECT FROM chm62edt_sites WHERE SOURCE_DB = 'CDDA_NATIONAL'";
	    		stmt = con.prepareStatement(query);
	    		rset = stmt.executeQuery();
	    		while(rset.next()){
	    			String idSite = rset.getString("ID_SITE");
	    			String idNatOb = rset.getString("ID_NATURE_OBJECT");
    				ret.put(idSite, idNatOb);
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
        
        private int getMaxId(String query) throws ParseException {
        	String maxId = sqlUtilities.ExecuteSQL(query);
        	int maxIdInt = 0;
        	if(maxId != null && maxId.length()>0)
        		maxIdInt = new Integer(maxId).intValue();
        	
        	return maxIdInt;
        }
        
        private void deleteOldGeoscopeRecords() throws Exception {
    		PreparedStatement ps = null;
    	    try {
    	    	ps = con.prepareStatement("DELETE G FROM chm62edt_nature_object_geoscope AS G, chm62edt_sites AS S WHERE G.ID_NATURE_OBJECT=S.ID_NATURE_OBJECT AND S.SOURCE_DB = 'CDDA_NATIONAL'");
				ps.executeUpdate();
    	    } catch ( Exception e ) {
    	    	e.printStackTrace();
    	    } finally {
    	    	if(ps != null) ps.close();
    	    }
        }
        
        private HashMap<String, Integer> getGeoscopeIds() throws Exception {
	    	HashMap<String, Integer> ret = new HashMap<String, Integer>();
	    	
	    	PreparedStatement stmt = null;
			ResultSet rset = null;
	    	try{
	    		String query = "SELECT ID_GEOSCOPE, ID_DESIGNATION FROM chm62edt_designations";
	    		stmt = con.prepareStatement(query);
	    		rset = stmt.executeQuery();
	    		while(rset.next()){
	    			int idGeoscope = rset.getInt("ID_GEOSCOPE");
	    			String idDesig = rset.getString("ID_DESIGNATION");
    				ret.put(idDesig, new Integer(idGeoscope));
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
        
        private HashMap<String, Integer> getGeoscopeIdsSites() throws Exception {
	    	HashMap<String, Integer> ret = new HashMap<String, Integer>();
	    	
	    	PreparedStatement stmt = null;
			ResultSet rset = null;
	    	try{
	    		String query = "SELECT ID_GEOSCOPE, ISO_3L FROM chm62edt_country";
	    		stmt = con.prepareStatement(query);
	    		rset = stmt.executeQuery();
	    		while(rset.next()){
	    			int idGeoscope = rset.getInt("ID_GEOSCOPE");
	    			String iso3L = rset.getString("ISO_3L");
    				ret.put(iso3L, new Integer(idGeoscope));
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
        
        private void calculateLatitudeParams(){
        	latNs = "S";
			latDeg = "";
			latMin = "";
			latSec = "";
			
			if(lat != null && lat.length() > 0){
				//calculate LAT_NS
				double lat_num = new Double(lat).doubleValue();
				if(!lat.contains("."))
					lat = new Double(lat_num).toString();
				if(lat_num > 0)
					latNs = "N";
				
				//calculate LAT_DEG
				int index = lat.indexOf(".");
    			if(index != -1){
    				latDeg = lat.substring(0, index);
    				String rest = lat.substring(index+1, lat.length());
    				
    				//calculate LAT_MIN
    				if(rest != null && rest.length() > 0){
    					rest = "0."+rest;
    					double d = new Double(rest).doubleValue();
    					double min = d * 60;
    					String minString = new Double(min).toString();
    					int indexMin = minString.indexOf(".");
    					if(indexMin != -1){
            				latMin = minString.substring(0, indexMin);
            				String restMin = minString.substring(indexMin+1, minString.length());
            				
            				//calculate LAT_SEC
            				if(restMin != null && restMin.length() > 0){
            					restMin = "0."+restMin;
            					double dsec = new Double(restMin).doubleValue();
            					double sec = dsec * 60;
            					String secString = new Double(sec).toString();
            					int indexSec = secString.indexOf(".");
            					if(indexSec != -1){
                    				latSec = secString.substring(0, indexSec);
            					} else {
            						latSec = secString;
            					}
            				}
    					} else {
    						latMin = minString;
    					}
    				}
    			} else {
    				latDeg = lat;
    			}
			}
        }
        
        private void calculateLongitudeParams(){
        	lonEw = "W";
			lonDeg = "";
			lonMin = "";
			lonSec = "";
			
			if(lon != null && lon.length() > 0){
				
				//calculate LON_EW
				double lon_num = new Double(lon).doubleValue();
				if(!lon.contains("."))
					lon = new Double(lon_num).toString();
				if(lon_num > 0)
					lonEw = "E";
				
				//calculate LON_DEG
				int index = lon.indexOf(".");
    			if(index != -1){
    				lonDeg = lon.substring(0, index);
    				String rest = lon.substring(index+1, lon.length());
    				
    				//calculate LON_MIN
    				if(rest != null && rest.length() > 0){
    					rest = "0."+rest;
    					double d = new Double(rest).doubleValue();
    					double min = d * 60;
    					String minString = new Double(min).toString();
    					int indexMin = minString.indexOf(".");
    					if(indexMin != -1){
            				lonMin = minString.substring(0, indexMin);
            				String restMin = minString.substring(indexMin+1, minString.length());
            				
            				//calculate LON_SEC
            				if(restMin != null && restMin.length() > 0){
            					restMin = "0."+restMin;
            					double dsec = new Double(restMin).doubleValue();
            					double sec = dsec * 60;
            					String secString = new Double(sec).toString();
            					int indexSec = secString.indexOf(".");
            					if(indexSec != -1){
                    				lonSec = secString.substring(0, indexSec);
            					} else {
            						lonSec = secString;
            					}
            				}
    					} else {
    						lonMin = minString;
    					}
    				}
    			} else {
    				lonDeg = lon;
    			}
			}
        }
} 
