package eionet.eunis.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import ro.finsiel.eunis.jrfTables.Chm62edtSpeciesDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtSpeciesPersist;
import eionet.eunis.api.LookupSpeciesResult;
import eionet.eunis.api.SpeciesLookupSearchParam;
import eionet.eunis.dao.ISpeciesDao;
import eionet.eunis.dto.readers.LookupSpeciesReader;

/**
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public class SpeciesDaoImpl extends MySqlBaseDao implements ISpeciesDao {
	
	private static final Logger logger = Logger.getLogger(SpeciesDaoImpl.class);

	public SpeciesDaoImpl() {
	}

	/* (non-Javadoc)
	 * @see eionet.eunis.dao.ISpeciesDao#lookupSpecies(eionet.eunis.api.SpeciesLookupSearchParam)
	 */
	public LookupSpeciesResult lookupSpecies(SpeciesLookupSearchParam speciesLookupSearchParam) {
		String query =  
				" SELECT ID_SPECIES, SCIENTIFIC_NAME, AUTHOR," +
				" levenshtein(LOWER(SCIENTIFIC_NAME), ?) AS DISTANCE, " +
				" levenshtein(LOWER(SUBSTRING_INDEX(SCIENTIFIC_NAME,' ',1)), ?) AS DISTANCE_2 " +
				" FROM chm62edt_species WHERE levenshtein(LOWER(SCIENTIFIC_NAME), ?) < ? " +
				" ORDER BY DISTANCE_2, DISTANCE, SCIENTIFIC_NAME ";
		List<Object> params = new LinkedList<Object>();
		params.add(speciesLookupSearchParam.getSpeciesName());
		params.add(speciesLookupSearchParam.getSpeciesName());
		params.add(speciesLookupSearchParam.getSpeciesName());
		params.add(speciesLookupSearchParam.getMaxLevenshteinDistance());
		try {
			LookupSpeciesReader lookupReader = new LookupSpeciesReader();
			executeQuery(query, params, lookupReader);
			return lookupReader.getLookupSpeciesResult();
		} catch (SQLException e) {
			logger.error("exception in lookupSpecies", e);
			throw new RuntimeException(e);
		}
	}
	
	public void deleteSpecies(Map<String, String> species) throws SQLException {
		Connection con = null;
		Statement st = null;
		Statement st2 = null;
		List<PreparedStatement> statements = new LinkedList<PreparedStatement>();
		
	    try {
	    	con = getConnection();
	    	
	    	st = con.createStatement();
	    	st2 = con.createStatement();
	    	
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?"));
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?"));
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT_LINK=?"));
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_nature_object_attributes WHERE ID_NATURE_OBJECT=?"));
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_tab_page_species WHERE ID_NATURE_OBJECT=?"));
	    	statements.add(con.prepareStatement("DELETE FROM chm62edt_nature_object_picture WHERE ID_OBJECT=? AND NATURE_OBJECT_TYPE='Species'"));
	    	
	    	int counter = 0;
	    	if(species != null){
				for(Iterator<String> it = species.keySet().iterator(); it.hasNext(); ){
					
					String speciesId = it.next();
					String idNatureObject = species.get(speciesId);
					if(idNatureObject == null)
						idNatureObject = getNatObjectId(speciesId);
					
					if(isSynonym(speciesId)){
						st2.addBatch("DELETE FROM chm62edt_species WHERE ID_SPECIES="+speciesId);
						st2.addBatch("DELETE FROM chm62edt_nature_object WHERE ID_NATURE_OBJECT="+idNatureObject);
					} else {
						st2.addBatch("DELETE FROM chm62edt_species WHERE ID_SPECIES="+speciesId+" OR ID_SPECIES_LINK="+speciesId);
						String ids = getSynonymIds(speciesId, idNatureObject);
						st2.addBatch("DELETE FROM chm62edt_nature_object WHERE ID_NATURE_OBJECT IN ("+ids+")");
					}
					
					String idReportAttributesReports = getReportAttributeIds(idNatureObject, con, "SELECT ID_REPORT_ATTRIBUTES FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?");
					String idReportAttributesReportType = getReportAttributeIds(idNatureObject, con, "SELECT ID_REPORT_ATTRIBUTES FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?");
					
					String idReportTypeReports = getReportTypeIds(idNatureObject, con, "SELECT ID_REPORT_TYPE FROM chm62edt_reports WHERE ID_NATURE_OBJECT=?");
					String idReportTypeReportType = getReportTypeIds(idNatureObject, con, "SELECT ID_REPORT_TYPE FROM chm62edt_nature_object_report_type WHERE ID_NATURE_OBJECT=?");

					counter++;
					
					if(idReportAttributesReports != null)
						st.addBatch("DELETE FROM chm62edt_report_attributes WHERE ID_REPORT_ATTRIBUTES IN ("+idReportAttributesReports+")");
					
					if(idReportAttributesReportType != null)
						st.addBatch("DELETE FROM chm62edt_report_attributes WHERE ID_REPORT_ATTRIBUTES IN ("+idReportAttributesReportType+")");
					
					if(idReportTypeReports != null)
						st.addBatch("DELETE FROM chm62edt_report_type WHERE ID_REPORT_TYPE IN ("+idReportTypeReports+")");
					
					if(idReportTypeReportType != null)
						st.addBatch("DELETE FROM chm62edt_report_type WHERE ID_REPORT_TYPE IN ("+idReportTypeReportType+")");
					
					for (PreparedStatement statement : statements) {
						statement.setString(1, idNatureObject);
						statement.addBatch();
					}
					
					if (counter % 10000 == 0){ 
		        		st.executeBatch();
		        		st.clearBatch();
		        		for (PreparedStatement statement : statements) {
		        			statement.executeBatch();
		        			statement.clearParameters();
		        		}
		        		st2.executeBatch();
		        		st2.clearBatch();
		        		System.gc(); 
					}
				}
	    	}
			
			if (!(counter % 10000 == 0)){ 
				st.executeBatch();
				st.clearBatch();
				for (PreparedStatement statement : statements) {
					statement.executeBatch();
					statement.clearParameters();
				}
				st2.executeBatch();
				st2.clearBatch();
        		System.gc(); 
            }
	    	
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    } finally {
	    	con.close();
	    	st.close();
	    	for (PreparedStatement statement : statements) {
	    		if (statement != null) {
	    			statement.close();
	    		}
	    	}
	    	st2.close();
	    }
	}
	
	private String getNatObjectId(String specieId) throws SQLException {
		String query = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_SPECIES WHERE ID_SPECIES = '"+specieId+"'";
		String natId = ExecuteSQL(query);
		return natId;
	}
	
	private boolean isSynonym(String specieId) throws SQLException {
		boolean ret = false;
		String query = "SELECT VALID_NAME FROM CHM62EDT_SPECIES WHERE ID_SPECIES = '"+specieId+"'";
		String synonym = ExecuteSQL(query);
		if(synonym != null && synonym.equals("0"))
			ret = true;
		return ret;
	}
	
	@SuppressWarnings("unchecked")
	private String getSynonymIds(String specieId, String natObId) throws SQLException {
		List<String> synonyms = new ArrayList<String>();
		synonyms.add(natObId);
		List<Chm62edtSpeciesPersist> lstSynonyms = new Chm62edtSpeciesDomain().findWhere( "VALID_NAME = 0 and ID_SPECIES_LINK=" + specieId );
		if ( lstSynonyms.size() > 0 ){
			for ( Chm62edtSpeciesPersist lstSynonym : lstSynonyms ){
				synonyms.add( lstSynonym.getIdNatureObject().toString() );
			}
		}
		String IDs = "";
		for(String id : synonyms ){
			IDs += id;
			IDs += ",";
		}
		IDs = IDs.substring(0, IDs.length() - 1);
		return IDs;
	}
	
	private String getReportAttributeIds(String objectId, Connection con, String query) throws Exception {
	    
	  	String result = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	    	ps = con.prepareStatement(query);
	    	ps.setString(1, objectId);
	    	rs = ps.executeQuery();

	    	while ( rs.next() ) {
	    		String id = rs.getString("ID_REPORT_ATTRIBUTES");
	    		if(id != null && !id.equals("-1") && id.length() > 0){
		    		if(result != null && result.length() > 0)
		    			result += ",";
		    		else
		    			result = "";
		    		result += id;
	    		}
	    	}
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    } finally {
	    	if(ps != null)
	    		ps.close();
	    	if(rs != null)
	    		rs.close();
	    }

	    return result;
	}
	
	private String getReportTypeIds(String objectId, Connection con, String query) throws Exception {
	    
	  	String result = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	    	ps = con.prepareStatement(query);
	    	ps.setString(1, objectId);
	    	rs = ps.executeQuery();

	    	while ( rs.next() ) {
	    		String id = rs.getString("ID_REPORT_TYPE");
	    		if(id != null && !id.equals("-1") && id.length() > 0){
		    		if(result != null && result.length() > 0)
		    			result += ",";
		    		else
		    			result = "";
		    		result += id;
	    		}
	    	}
	    } catch ( Exception e ) {
	    	e.printStackTrace();
	    } finally {
	    	if(ps != null)
	    		ps.close();
	    	if(rs != null)
	    		rs.close();
	    }

	    return result;
	}

}
