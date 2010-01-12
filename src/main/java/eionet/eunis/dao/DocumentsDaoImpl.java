package eionet.eunis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import eionet.eunis.dto.DcObjectDTO;
import eionet.eunis.dto.DcSourceDTO;
import eionet.eunis.dto.DcTitleDTO;
import eionet.eunis.dto.readers.DcObjectDTOReader;
import eionet.eunis.dto.readers.DcTitleDTOReader;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public class DocumentsDaoImpl extends BaseDaoImpl implements IDocumentsDao {

	public DocumentsDaoImpl(SQLUtilities sqlUtilities) {
		super(sqlUtilities);
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDocuments()
	 * {@inheritDoc}
	 */
	public List<DcTitleDTO> getDocuments() {
		
		List<DcTitleDTO> ret = new ArrayList<DcTitleDTO>();

		String query = "SELECT ID_DC, ID_TITLE, TITLE, ALTERNATIVE FROM DC_INDEX LEFT JOIN DC_TITLE USING (ID_DC)";
		List<Object> values = new ArrayList<Object>();
		DcTitleDTOReader rsReader = new DcTitleDTOReader();
		
		try{
			
			getSqlUtils().executeQuery(query, values, rsReader);
			ret = rsReader.getResultList();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return ret;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcTitle(String id)
	 * {@inheritDoc}
	 */
	public DcTitleDTO getDcTitle(String id) {
		
		DcTitleDTO doc = new DcTitleDTO();
		
		String query = "SELECT * FROM DC_TITLE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				doc.setIdDoc(rs.getString("ID_DC"));
				doc.setIdTitle(rs.getString("ID_TITLE"));
				doc.setTitle(rs.getString("TITLE"));
				doc.setAlternative(rs.getString("ALTERNATIVE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return doc;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcSource(String id)
	 * {@inheritDoc}
	 */
	public DcSourceDTO getDcSource(String id) {
		
		DcSourceDTO source = new DcSourceDTO();
		
		String query = "SELECT * FROM DC_SOURCE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				source.setIdDc(rs.getString("ID_DC"));
				source.setIdSource(rs.getString("ID_SOURCE"));
				source.setSource(rs.getString("SOURCE"));
				source.setEditor(rs.getString("EDITOR"));
				source.setJournalTitle(rs.getString("JOURNAL_TITLE"));
				source.setBookTitle(rs.getString("BOOK_TITLE"));
				source.setJournalIssue(rs.getString("JOURNAL_ISSUE"));
				source.setIsbn(rs.getString("ISBN"));
				source.setGeoLevel(rs.getString("GEO_LEVEL"));
				source.setUrl(rs.getString("URL"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return source;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcObjects()
	 * {@inheritDoc}
	 */
	public List<DcObjectDTO> getDcObjects() {
		
		List<DcObjectDTO> ret = new ArrayList<DcObjectDTO>();

		String query = "SELECT ID_DC, TITLE, SOURCE, URL, CONTRIBUTOR, COVERAGE, CREATOR, CREATED, DESCRIPTION, FORMAT, " +
				"IDENTIFIER, LANGUAGE, PUBLISHER, RELATION, RIGHTS, SUBJECT, TYPE " +
				"FROM DC_INDEX " +
				"LEFT JOIN DC_TITLE USING (ID_DC) " +
				"LEFT JOIN DC_SOURCE USING (ID_DC) " +
				"LEFT JOIN DC_CONTRIBUTOR USING (ID_DC) " +
				"LEFT JOIN DC_CREATOR USING (ID_DC) " +
				"LEFT JOIN DC_COVERAGE USING (ID_DC) " +
				"LEFT JOIN DC_DATE USING (ID_DC) " +
				"LEFT JOIN DC_DESCRIPTION USING (ID_DC) " +
				"LEFT JOIN DC_FORMAT USING (ID_DC) " +
				"LEFT JOIN DC_IDENTIFIER USING (ID_DC) " +
				"LEFT JOIN DC_LANGUAGE USING (ID_DC) " +
				"LEFT JOIN DC_PUBLISHER USING (ID_DC) " +
				"LEFT JOIN DC_RELATION USING (ID_DC) " +
				"LEFT JOIN DC_RIGHTS USING (ID_DC) " +
				"LEFT JOIN DC_SUBJECT USING (ID_DC) " +
				"LEFT JOIN DC_TYPE USING (ID_DC)";
		
		List<Object> values = new ArrayList<Object>();
		DcObjectDTOReader rsReader = new DcObjectDTOReader();
		
		try{
			
			getSqlUtils().executeQuery(query, values, rsReader);
			ret = rsReader.getResultList();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return ret;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcObject(String id)
	 * {@inheritDoc}
	 */
	public DcObjectDTO getDcObject(String id) {
		
		DcObjectDTO ret = new DcObjectDTO();

		String query = "SELECT ID_DC, TITLE, SOURCE, URL, CONTRIBUTOR, COVERAGE, CREATOR, CREATED, DESCRIPTION, FORMAT, " +
				"IDENTIFIER, LANGUAGE, PUBLISHER, RELATION, RIGHTS, SUBJECT, TYPE " +
				"FROM DC_INDEX " +
				"LEFT JOIN DC_TITLE USING (ID_DC) " +
				"LEFT JOIN DC_SOURCE USING (ID_DC) " +
				"LEFT JOIN DC_CONTRIBUTOR USING (ID_DC) " +
				"LEFT JOIN DC_CREATOR USING (ID_DC) " +
				"LEFT JOIN DC_COVERAGE USING (ID_DC) " +
				"LEFT JOIN DC_DATE USING (ID_DC) " +
				"LEFT JOIN DC_DESCRIPTION USING (ID_DC) " +
				"LEFT JOIN DC_FORMAT USING (ID_DC) " +
				"LEFT JOIN DC_IDENTIFIER USING (ID_DC) " +
				"LEFT JOIN DC_LANGUAGE USING (ID_DC) " +
				"LEFT JOIN DC_PUBLISHER USING (ID_DC) " +
				"LEFT JOIN DC_RELATION USING (ID_DC) " +
				"LEFT JOIN DC_RIGHTS USING (ID_DC) " +
				"LEFT JOIN DC_SUBJECT USING (ID_DC) " +
				"LEFT JOIN DC_TYPE USING (ID_DC) " +
				"WHERE ID_DC = ?";
		
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				ret.setId(rs.getString("ID_DC"));
				ret.setTitle(rs.getString("TITLE"));
				ret.setSource(rs.getString("SOURCE"));
				ret.setSourceUrl(rs.getString("URL"));
				ret.setContributor(rs.getString("CONTRIBUTOR"));
				ret.setCoverage(rs.getString("COVERAGE"));
				ret.setCreator(rs.getString("CREATOR"));
				ret.setDate(rs.getString("CREATED"));
				ret.setDescription(rs.getString("DESCRIPTION"));
				ret.setFormat(rs.getString("FORMAT"));
				ret.setIdentifier(rs.getString("IDENTIFIER"));
				ret.setLanguage(rs.getString("LANGUAGE"));
				ret.setPublisher(rs.getString("PUBLISHER"));
				ret.setRelation(rs.getString("RELATION"));
				ret.setRights(rs.getString("RIGHTS"));
				ret.setSubject(rs.getString("SUBJECT"));
				ret.setType(rs.getString("TYPE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return ret;
	}

}
