package eionet.eunis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import eionet.eunis.dto.ExternalObjectDTO;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public class ExternalObjectsDaoImpl extends BaseDaoImpl implements IExternalObjectsDao {

	public ExternalObjectsDaoImpl(SQLUtilities sqlUtilities) {
		super(sqlUtilities);
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDocuments()
	 * {@inheritDoc}
	 */
	public List<ExternalObjectDTO> getMaybeSameObjects() {
		
		List<ExternalObjectDTO> ret = new ArrayList<ExternalObjectDTO>();

		//String query = "SELECT CONCAT(S.SCIENTIFIC_NAME, ' ', S.AUTHOR) AS SQL_NAME, S.ID_SPECIES, S.ID_NATURE_OBJECT, E.RESOURCE, E.NAME FROM CHM62EDT_SPECIES S, externalobjects E WHERE E.ID_NATURE_OBJECT = S.ID_NATURE_OBJECT AND RELATION = 'maybesame' ORDER BY E.RESOURCE LIMIT 300";
		String query = "SELECT CONCAT(S.SCIENTIFIC_NAME, ' ', S.AUTHOR) AS SQL_NAME, S.ID_SPECIES, S.ID_NATURE_OBJECT, A1.OBJECT AS IDENTIFIER, A2.OBJECT AS GEO_NAME FROM CHM62EDT_SPECIES S, chm62edt_nature_object_attributes A1, "+
			"chm62edt_nature_object_attributes A2 WHERE A1.ID_NATURE_OBJECT = S.ID_NATURE_OBJECT AND A1.NAME = 'maybeSameSynonym' AND A2.ID_NATURE_OBJECT=A1.ID_NATURE_OBJECT AND A2.NAME = '_geospeciesScientificName' ORDER BY A1.OBJECT LIMIT 300";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				ExternalObjectDTO dto = new ExternalObjectDTO();
				dto.setIdentifier(rs.getString("IDENTIFIER"));
				dto.setName(rs.getString("GEO_NAME"));
				dto.setNameSql(rs.getString("SQL_NAME"));
				dto.setNatureObjectId(rs.getString("ID_NATURE_OBJECT"));
				dto.setSpecieId(rs.getString("ID_SPECIES"));
				ret.add(dto);
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return ret;
	}
	
	public void updateExternalObject(String identifier, String val) {
		if(identifier != null && val != null){
			String query = "UPDATE chm62edt_nature_object_attributes SET NAME=? WHERE OBJECT=? AND NAME = 'maybeSameSynonym'";
			
			Connection con = null;
			PreparedStatement ps = null;
		    try {
		    	con = getSqlUtils().getConnection();
		    	ps = con.prepareStatement(query);
		    	
		    	ps.setString(1, val);
		    	ps.setString(2, identifier);
		    	ps.executeUpdate();
		    	
		    } catch ( Exception e ) {
		    	e.printStackTrace();
		    } finally {
		    	getSqlUtils().closeAll(con, ps, null);
		    }
		}
	}

}
