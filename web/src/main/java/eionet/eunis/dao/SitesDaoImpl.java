package eionet.eunis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
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
	
	public void updateCountrySitesFactsheet() throws SQLException {
		Connection con = null;
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		
		try {
	    	con = getSqlUtils().getConnection();
	    	//Empty chm62edt_country_sites_factsheet table before update
	    	ps = con.prepareStatement("DELETE FROM chm62edt_country_sites_factsheet");
	    	ps.executeUpdate();
	    	
	    	ps = con.prepareStatement("SELECT DISTINCT SOURCE_DB FROM CHM62EDT_SITES WHERE SOURCE_DB IS NOT NULL");
	    	rs = ps.executeQuery();
	    	List<String> sources = new ArrayList<String>();
			while(rs.next()){
				String sourceDb = rs.getString("SOURCE_DB");
				if(sourceDb != null)
					sources.add(sourceDb);
			}
				
			ps1 = con.prepareStatement("SELECT DISTINCT AREA_NAME_EN,SURFACE FROM CHM62EDT_COUNTRY WHERE ISO_2L<>'' AND ISO_2L IS NOT NULL AND AREA_NAME_EN IS NOT NULL");
			rs1 = ps1.executeQuery();
			while(rs1.next()){
				String areaName = rs1.getString("AREA_NAME_EN");
				if(areaName == null) areaName = "";
				double surface = rs1.getDouble("SURFACE");
				
				for(Iterator<String> it=sources.iterator(); it.hasNext();){
					String sourceDb = it.next();
									
					//here we calculate no of sites
					String sql = "SELECT Count(DISTINCT C.ID_NATURE_OBJECT) AS cnt "+
				        "FROM CHM62EDT_COUNTRY AS A "+
				        "INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON A.ID_GEOSCOPE = B.ID_GEOSCOPE "+
				        "INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT "+
				        "WHERE A.AREA_NAME_EN = ? AND C.SOURCE_DB = ?";
					
					ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					int noSites = 0;
					while(rs2.next()){
						noSites = rs2.getInt("cnt");
					}
					
					//here we calculate no of species
			        sql = "SELECT COUNT(DISTINCT H.ID_NATURE_OBJECT) AS cnt FROM CHM62EDT_COUNTRY AS E INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON D.ID_GEOSCOPE = E.ID_GEOSCOPE INNER JOIN CHM62EDT_SITES AS C ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT INNER JOIN CHM62EDT_SPECIES AS H ON K.ID_NATURE_OBJECT_LINK = H.ID_NATURE_OBJECT " +
			        		"WHERE E.AREA_NAME_EN = ? AND C.SOURCE_DB = ?";
			        ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					int noSpecies = 0;
					while(rs2.next()){
						noSpecies = rs2.getInt("cnt");
					}
					
					//here we calculate no of habitats
			        sql = "SELECT COUNT(DISTINCT H.ID_NATURE_OBJECT) AS cnt FROM CHM62EDT_COUNTRY AS E INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS D ON D.ID_GEOSCOPE = E.ID_GEOSCOPE INNER JOIN CHM62EDT_SITES AS C ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT INNER JOIN CHM62EDT_HABITAT AS H " +
			        		"ON K.ID_NATURE_OBJECT_LINK = H.ID_NATURE_OBJECT WHERE E.AREA_NAME_EN = ? AND C.SOURCE_DB = ?";
			        ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					int noHabitat = 0;
					while(rs2.next()){
						noHabitat = rs2.getInt("cnt");
					}
					
					//calculate area
			        sql = "SELECT C.AREA AS AREA FROM CHM62EDT_COUNTRY AS A " +
			        "INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON A.ID_GEOSCOPE = B.ID_GEOSCOPE " +
			        "INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
			        "WHERE A.AREA_NAME_EN = ? AND C.SOURCE_DB = ? AND C.AREA IS NOT NULL AND C.AREA>0 " +
			        "GROUP BY C.ID_NATURE_OBJECT";
			        ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					double totalSizePartial = 0;
			        int no = 0;
					while(rs2.next()){
						totalSizePartial = totalSizePartial + rs2.getDouble("AREA");
						no = no + 1;
					}
					
					sql = "SELECT H.OVERLAP AS OVERLAP FROM CHM62EDT_COUNTRY AS A" +
				        " INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON A.ID_GEOSCOPE = B.ID_GEOSCOPE" +
				        " INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT" +
				        " INNER JOIN CHM62EDT_SITES_SITES AS H ON C.ID_SITE = H.ID_SITE" +
				        " INNER JOIN CHM62EDT_SITES AS I ON H.ID_SITE_LINK = I.ID_SITE" +
				        " WHERE A.AREA_NAME_EN = ? AND C.SOURCE_DB =?" +
				        " AND H.OVERLAP>0 AND C.AREA>0 AND I.AREA>0 GROUP BY C.ID_SITE,I.ID_SITE,H.OVERLAP";
					ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					double totalSizeOverlap = 0;
					while(rs2.next()){
						totalSizeOverlap = totalSizeOverlap + rs2.getDouble("OVERLAP");
						no = no + 1;
					}
			        
					double totalSize = totalSizePartial - totalSizeOverlap;
					double avgSize = 0;
					if(no != 0)
						avgSize = totalSize / no;
					
					double noSitesPerKm = 0;
					if(noSites != 0){
						if(surface != 0)
							noSitesPerKm = noSites / surface;
					}
					
					sql = "SELECT COUNT(DISTINCT C.ID_NATURE_OBJECT) AS cnt FROM CHM62EDT_COUNTRY AS A " +
				        "INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON A.ID_GEOSCOPE = B.ID_GEOSCOPE " +
				        "INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
				        "WHERE A.AREA_NAME_EN = ? AND C.SOURCE_DB = ? AND " +
				        "((C.AREA IS NOT NULL AND C.AREA>0) OR (C.LENGTH IS NOT NULL AND C.LENGTH>0))";
					ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					double noSitesWithSurfaceAvailable = 0;
					while(rs2.next()){
						noSitesWithSurfaceAvailable = rs2.getDouble("cnt");
					}
					
					double procent = 0;
					if(noSites != 0)
						procent = (noSitesWithSurfaceAvailable * 100) / noSites;
					
					sql = "SELECT C.AREA AS AREA FROM CHM62EDT_COUNTRY AS A " +
				        "INNER JOIN CHM62EDT_NATURE_OBJECT_GEOSCOPE AS B ON A.ID_GEOSCOPE = B.ID_GEOSCOPE " +
				        "INNER JOIN CHM62EDT_SITES AS C ON B.ID_NATURE_OBJECT = C.ID_NATURE_OBJECT " +
				        "WHERE A.AREA_NAME_EN = ? AND C.SOURCE_DB = ? AND C.AREA IS NOT NULL AND C.AREA>0 " +
				        "GROUP BY C.ID_NATURE_OBJECT";
					ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					rs2 = ps2.executeQuery();
					double sum = 0;
					while(rs2.next()){
						double area = rs2.getDouble("AREA");
						sum = sum + (area - avgSize) * (area - avgSize);
					}
					
					double standardDeviation = 0;
					if(noSites != 0)
						standardDeviation = Math.sqrt(sum / noSites);
					
					sql = "INSERT INTO chm62edt_country_sites_factsheet (AREA_NAME_EN, SOURCE_DB, NUMBER_OF_SITES, NUMBER_OF_SPECIES, " +
							"NUMBER_OF_HABITATS, TOTAL_SIZE, NO_SITES_PER_SQUARE_KM, PROCENT_NO_SITES_WITH_SURFACE_AVAILABLE, AVG_SIZE, STANDARD_DEVIATION) " +
							"VALUES (?,?,?,?,?,?,?,?,?,?)";
					ps2 = con.prepareStatement(sql);
					ps2.setString(1, areaName);
					ps2.setString(2, sourceDb);
					ps2.setInt(3, noSites);
					ps2.setInt(4, noSpecies);
					ps2.setInt(5, noHabitat);
					ps2.setDouble(6, totalSize);
					ps2.setDouble(7, noSitesPerKm);
					ps2.setDouble(8, procent);
					ps2.setDouble(9, avgSize);
					ps2.setDouble(10, standardDeviation);
					ps2.executeUpdate();
				}
			}
	    	
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    	throw new SQLException(e.getMessage(), e); 
	    } finally {
	    	getSqlUtils().closeAll(con, ps, rs);
	    }
	}
	
	public void updateDesignationsTable() throws SQLException {
		Connection con = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement psUpdateDesignation = null;
		
		ResultSet rs = null;
		ResultSet rs2 = null;
	    try {
	    	con = getSqlUtils().getConnection();
	    	
	    	String updateDesignation = "UPDATE CHM62EDT_DESIGNATIONS SET CDDA_SITES='Y', TOTAL_NUMBER=? WHERE ID_DESIGNATION=?";
			psUpdateDesignation = con.prepareStatement(updateDesignation);
	    	
	    	String query = "SELECT ID_DESIGNATION FROM CHM62EDT_DESIGNATIONS WHERE SOURCE_DB = 'CDDA_NATIONAL'";
	    	String query2 = "";
	    	ps = con.prepareStatement(query);
	    	rs = ps.executeQuery();
			while(rs.next()){
				String idDesignation = rs.getString("ID_DESIGNATION");
				if(idDesignation != null && idDesignation.length() > 0){
					query2 = "SELECT COUNT(ID_SITE) AS CNT FROM CHM62EDT_SITES WHERE ID_DESIGNATION=?";
					ps2 = con.prepareStatement(query2);
					ps2.setString(1, idDesignation);
					rs2 = ps2.executeQuery();
					while(rs2.next()){
						int cnt = rs2.getInt("CNT");
						if(cnt > 0){
							psUpdateDesignation.setInt(1, cnt);
							psUpdateDesignation.setString(2, idDesignation);
							psUpdateDesignation.addBatch();
						}
					}
				}
			}
			psUpdateDesignation.executeBatch();
			psUpdateDesignation.clearParameters();
			System.gc();
					
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    	throw new SQLException(e.getMessage(), e); 
	    } finally {
	    	getSqlUtils().closeAll(con, ps, rs);
	    	if(ps2 != null) ps2.close();
	    	if(psUpdateDesignation != null) psUpdateDesignation.close();
	    	if(rs2 != null) rs.close();
	    }
	}

}
