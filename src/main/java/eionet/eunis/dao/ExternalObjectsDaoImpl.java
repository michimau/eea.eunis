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

		String query = "SELECT CONCAT(S.SCIENTIFIC_NAME, ' ', S.AUTHOR) AS SQL_NAME, S.ID_SPECIES, S.ID_NATURE_OBJECT, E.RESOURCE, E.NAME FROM CHM62EDT_SPECIES S, externalobjects E WHERE E.ID_NATURE_OBJECT = S.ID_NATURE_OBJECT AND RELATION = 'maybesame'";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				ExternalObjectDTO dto = new ExternalObjectDTO();
				dto.setIdentifier(rs.getString("RESOURCE"));
				dto.setName(rs.getString("NAME"));
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
			String query = "UPDATE externalobjects SET RELATION=? WHERE RESOURCE=? AND RELATION = 'maybesame'";
			
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
