package eionet.eunis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public class SitesDaoImpl extends BaseDaoImpl implements ISitesDao {

	public SitesDaoImpl(SQLUtilities sqlUtilities) {
		super(sqlUtilities);
	}

	/** 
	 * @see eionet.eunis.dao.ISitesDao#deleteSites(Map<String, String> sites)
	 * {@inheritDoc}
	 */
	public void deleteSites(Map<String, String> sites) throws SQLException {
		
		Connection con = null;
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		PreparedStatement ps5 = null;
		PreparedStatement ps6 = null;
		PreparedStatement ps7 = null;
		PreparedStatement ps8 = null;
		PreparedStatement ps9 = null;
		PreparedStatement ps10 = null;
		PreparedStatement ps11 = null;
		PreparedStatement ps12 = null;
		PreparedStatement ps13 = null;
		PreparedStatement ps14 = null;
		PreparedStatement ps15 = null;
		
		ResultSet rs = null;
	    try {
	    	con = getSqlUtils().getConnection();
	    	
	    	String query = "SELECT ID_SITE, ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE SOURCE_DB = 'CDDA_NATIONAL'";
	    	ps = con.prepareStatement(query);
	    	
	    	ps1 = con.prepareStatement("DELETE FROM chm62edt_report_attributes WHERE ID_REPORT_ATTRIBUTES IN "+
	    					"(SELECT ID_REPORT_ATTRIBUTES FROM chm62edt_nature_object_geoscope WHERE ID_NATURE_OBJECT=?)");
	    	
	    	ps2 = con.prepareStatement("DELETE FROM chm62edt_report_attributes WHERE ID_REPORT_ATTRIBUTES IN "+
							"(SELECT ID_REPORT_ATTRIBUTES FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?)");
	    	
	    	ps3 = con.prepareStatement("DELETE FROM chm62edt_report_attributes WHERE ID_REPORT_ATTRIBUTES IN "+
							"(SELECT ID_REPORT_ATTRIBUTES FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?)");
	    	
	    	ps4 = con.prepareStatement("DELETE FROM chm62edt_report_type WHERE ID_REPORT_TYPE IN "+
							"(SELECT ID_REPORT_TYPE FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?)");
	    	
	    	ps5 = con.prepareStatement("DELETE FROM chm62edt_report_type WHERE ID_REPORT_TYPE IN "+
							"(SELECT ID_REPORT_TYPE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?)");
	    	
	    	ps6 = con.prepareStatement("DELETE FROM chm62edt_nature_object_geoscope WHERE ID_NATURE_OBJECT=?");
	    	ps7 = con.prepareStatement("DELETE FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?");
	    	ps8 = con.prepareStatement("DELETE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?");
	    	ps9 = con.prepareStatement("DELETE FROM chm62edt_nature_object_attributes WHERE ID_NATURE_OBJECT=?");
	    	ps10 = con.prepareStatement("DELETE FROM chm62edt_tab_page_sites WHERE ID_NATURE_OBJECT=?");
	    	ps11 = con.prepareStatement("DELETE FROM chm62edt_nature_object WHERE ID_NATURE_OBJECT=?");
	    	
	    	ps12 = con.prepareStatement("DELETE FROM chm62edt_sites_sites WHERE ID_SITE=?");
	    	ps13 = con.prepareStatement("DELETE FROM chm62edt_sites_related_designations WHERE ID_SITE=?");
	    	ps14 = con.prepareStatement("DELETE FROM chm62edt_site_attributes WHERE ID_SITE=?");
	    	ps15 = con.prepareStatement("DELETE FROM chm62edt_sites WHERE ID_SITE=?");
	    		    	
	    	rs = ps.executeQuery();
	    	int counter = 0;
			while(rs.next()){
				String idNatureObject = rs.getString("ID_NATURE_OBJECT");
				String idSite = rs.getString("ID_SITE");
				if(idNatureObject != null && idSite != null){
					if(sites != null && !sites.containsKey(idSite)){
						
						counter++;
						
						ps1.setString(1, idNatureObject);
						ps1.addBatch();
				    	
						ps2.setString(1, idNatureObject);
						ps2.addBatch();
				    	
						ps3.setString(1, idNatureObject);
						ps3.addBatch();
				    	
						ps4.setString(1, idNatureObject);
						ps4.addBatch();
				    	
						ps5.setString(1, idNatureObject);
						ps5.addBatch();
						
						ps6.setString(1, idNatureObject);
						ps6.addBatch();
						
						ps7.setString(1, idNatureObject);
						ps7.addBatch();
						
						ps8.setString(1, idNatureObject);
						ps8.addBatch();
						
						ps9.setString(1, idNatureObject);
						ps9.addBatch();
						
						ps10.setString(1, idNatureObject);
						ps10.addBatch();
						
						ps11.setString(1, idNatureObject);
						ps11.addBatch();
				    	
						ps12.setString(1, idSite);
						ps12.addBatch();
						
						ps13.setString(1, idSite);
						ps13.addBatch();
				    		
						ps14.setString(1, idSite);
						ps14.addBatch();
				    	
						ps15.setString(1, idSite);
						ps15.addBatch();
						
						if (counter % 10000 == 0){ 
        	        		ps1.executeBatch(); 
        	        		ps1.clearParameters();
        	        		ps2.executeBatch(); 
        	        		ps2.clearParameters();
        	        		ps3.executeBatch(); 
        	        		ps3.clearParameters();
        	        		ps4.executeBatch(); 
        	        		ps4.clearParameters();
        	        		ps5.executeBatch(); 
        	        		ps5.clearParameters();
        	        		ps6.executeBatch(); 
        	        		ps6.clearParameters();
        	        		ps7.executeBatch(); 
        	        		ps7.clearParameters();
        	        		ps8.executeBatch(); 
        	        		ps8.clearParameters();
        	        		ps9.executeBatch(); 
        	        		ps9.clearParameters();
        	        		ps10.executeBatch(); 
        	        		ps10.clearParameters();
        	        		ps11.executeBatch(); 
        	        		ps11.clearParameters();
        	        		ps12.executeBatch(); 
        	        		ps12.clearParameters();
        	        		ps13.executeBatch(); 
        	        		ps13.clearParameters();
        	        		ps14.executeBatch(); 
        	        		ps14.clearParameters();
        	        		ps15.executeBatch(); 
        	        		ps15.clearParameters();
        	        		System.gc(); 
        	        	}
					}
				}
			}
			
			if (!(counter % 10000 == 0)){ 
				ps1.executeBatch(); 
        		ps1.clearParameters();
        		ps2.executeBatch(); 
        		ps2.clearParameters();
        		ps3.executeBatch(); 
        		ps3.clearParameters();
        		ps4.executeBatch(); 
        		ps4.clearParameters();
        		ps5.executeBatch(); 
        		ps5.clearParameters();
        		ps6.executeBatch(); 
        		ps6.clearParameters();
        		ps7.executeBatch(); 
        		ps7.clearParameters();
        		ps8.executeBatch(); 
        		ps8.clearParameters();
        		ps9.executeBatch(); 
        		ps9.clearParameters();
        		ps10.executeBatch(); 
        		ps10.clearParameters();
        		ps11.executeBatch(); 
        		ps11.clearParameters();
        		ps12.executeBatch(); 
        		ps12.clearParameters();
        		ps13.executeBatch(); 
        		ps13.clearParameters();
        		ps14.executeBatch(); 
        		ps14.clearParameters();
        		ps15.executeBatch(); 
        		ps15.clearParameters();
        		System.gc(); 
            }
	    	
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    } finally {
	    	getSqlUtils().closeAll(con, ps, rs);
	    	ps1.close();
	    	ps2.close();
	    	ps3.close();
	    	ps4.close();
	    	ps5.close();
	    	ps6.close();
	    	ps7.close();
	    	ps8.close();
	    	ps9.close();
	    	ps10.close();
	    	ps11.close();
	    	ps12.close();
	    	ps13.close();
	    	ps14.close();
	    	ps15.close();
	    }
		
	}

}
