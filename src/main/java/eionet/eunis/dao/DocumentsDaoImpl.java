package eionet.eunis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import eionet.eunis.dto.DcContributorDTO;
import eionet.eunis.dto.DcCoverageDTO;
import eionet.eunis.dto.DcCreatorDTO;
import eionet.eunis.dto.DcDateDTO;
import eionet.eunis.dto.DcDescriptionDTO;
import eionet.eunis.dto.DcFormatDTO;
import eionet.eunis.dto.DcIdentifierDTO;
import eionet.eunis.dto.DcIndexDTO;
import eionet.eunis.dto.DcLanguageDTO;
import eionet.eunis.dto.DcObjectDTO;
import eionet.eunis.dto.DcPublisherDTO;
import eionet.eunis.dto.DcRelationDTO;
import eionet.eunis.dto.DcRightsDTO;
import eionet.eunis.dto.DcSourceDTO;
import eionet.eunis.dto.DcSubjectDTO;
import eionet.eunis.dto.DcTitleDTO;
import eionet.eunis.dto.DcTypeDTO;
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
	 * @see eionet.eunis.dao.IDocumentsDao#getDcContributor(String id)
	 * {@inheritDoc}
	 */
	public DcContributorDTO getDcContributor(String id) {
		
		DcContributorDTO object = null;
		
		String query = "SELECT * FROM DC_CONTRIBUTOR WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcContributorDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdContributor(rs.getString("ID_CONTRIBUTOR"));
				object.setContributor(rs.getString("CONTRIBUTOR"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcCoverage(String id)
	 * {@inheritDoc}
	 */
	public DcCoverageDTO getDcCoverage(String id) {
		
		DcCoverageDTO object = null;
		
		String query = "SELECT * FROM DC_COVERAGE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcCoverageDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdCoverage(rs.getString("ID_COVERAGE"));
				object.setCoverage(rs.getString("COVERAGE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcCreator(String id)
	 * {@inheritDoc}
	 */
	public DcCreatorDTO getDcCreator(String id) {
		
		DcCreatorDTO object = null;
		
		String query = "SELECT * FROM DC_CREATOR WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcCreatorDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdCreator(rs.getString("ID_CREATOR"));
				object.setCreator(rs.getString("CREATOR"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcDate(String id)
	 * {@inheritDoc}
	 */
	public DcDateDTO getDcDate(String id) {
		
		DcDateDTO object = null;
		
		String query = "SELECT * FROM DC_DATE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcDateDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdDate(rs.getString("ID_DATE"));
				object.setAvailable(rs.getString("AVAILABLE"));
				object.setCreated(rs.getString("CREATED"));
				object.setIssued(rs.getString("ISSUED"));
				object.setMdate(rs.getString("MDATE"));
				object.setModified(rs.getString("MODIFIED"));
				object.setValid(rs.getString("VALID"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcDescription(String id)
	 * {@inheritDoc}
	 */
	public DcDescriptionDTO getDcDescription(String id) {
		
		DcDescriptionDTO object = null;
		
		String query = "SELECT * FROM DC_DESCRIPTION WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcDescriptionDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdDescription(rs.getString("ID_DESCRIPTION"));
				object.setDescription(rs.getString("DESCRIPTION"));
				object.setAbstr(rs.getString("ABSTRACT"));
				object.setToc(rs.getString("TOC"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcFormat(String id)
	 * {@inheritDoc}
	 */
	public DcFormatDTO getDcFormat(String id) {
		
		DcFormatDTO object = null;
		
		String query = "SELECT * FROM DC_FORMAT WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcFormatDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdFormat(rs.getString("ID_FORMAT"));
				object.setFormat(rs.getString("FORMAT"));
				object.setExtent(rs.getString("EXTENT"));
				object.setMedium(rs.getString("MEDIUM"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcIdentifier(String id)
	 * {@inheritDoc}
	 */
	public DcIdentifierDTO getDcIdentifier(String id) {
		
		DcIdentifierDTO object = null;
		
		String query = "SELECT * FROM DC_IDENTIFIER WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcIdentifierDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdIdentifier(rs.getString("ID_IDENTIFIER"));
				object.setIdentifier(rs.getString("IDENTIFIER"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcIndex(String id)
	 * {@inheritDoc}
	 */
	public DcIndexDTO getDcIndex(String id) {
		
		DcIndexDTO object = null;
		
		String query = "SELECT * FROM DC_INDEX WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcIndexDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setComment(rs.getString("COMMENT"));
				object.setRefCd(rs.getString("REFCD"));
				object.setReference(rs.getString("REFERENCE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcLanguage(String id)
	 * {@inheritDoc}
	 */
	public DcLanguageDTO getDcLanguage(String id) {
		
		DcLanguageDTO object = null;
		
		String query = "SELECT * FROM DC_LANGUAGE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcLanguageDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdLanguage(rs.getString("ID_LANGUAGE"));
				object.setLanguage(rs.getString("LANGUAGE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcPublisher(String id)
	 * {@inheritDoc}
	 */
	public DcPublisherDTO getDcPublisher(String id) {
		
		DcPublisherDTO object = null;
		
		String query = "SELECT * FROM DC_PUBLISHER WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcPublisherDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdPublisher(rs.getString("ID_PUBLISHER"));
				object.setPublisher(rs.getString("PUBLISHER"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcRelation(String id)
	 * {@inheritDoc}
	 */
	public DcRelationDTO getDcRelation(String id) {
		
		DcRelationDTO object = null;
		
		String query = "SELECT * FROM DC_RELATION WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcRelationDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdRelation(rs.getString("ID_RELATION"));
				object.setRelation(rs.getString("RELATION"));
				object.setHasFormat(rs.getString("HAS_FORMAT"));
				object.setHasPart(rs.getString("HAS_PART"));
				object.setHasVersion(rs.getString("HAS_VERSION"));
				object.setIsFormatOf(rs.getString("IS_FORMAT_OF"));
				object.setIsPartOf(rs.getString("IS_PART_OF"));
				object.setIsReferencedBy(rs.getString("IS_REFERENCED_BY"));
				object.setIsReplacedBy(rs.getString("IS_REPLACED_BY"));
				object.setIsRequiredBy(rs.getString("IS_REQUIRED_BY"));
				object.setIsVersionOf(rs.getString("IS_VERSION_OF"));
				object.setReferences(rs.getString("REFERENCES"));
				object.setRequires(rs.getString("REQUIRES"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcRights(String id)
	 * {@inheritDoc}
	 */
	public DcRightsDTO getDcRights(String id) {
		
		DcRightsDTO object = null;
		
		String query = "SELECT * FROM DC_RIGHTS WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcRightsDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdRights(rs.getString("ID_RIGHTS"));
				object.setRights(rs.getString("RIGHTS"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcSubject(String id)
	 * {@inheritDoc}
	 */
	public DcSubjectDTO getDcSubject(String id) {
		
		DcSubjectDTO object = null;
		
		String query = "SELECT * FROM DC_SUBJECT WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcSubjectDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdSubject(rs.getString("ID_SUBJECT"));
				object.setSubject(rs.getString("SUBJECT"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcType(String id)
	 * {@inheritDoc}
	 */
	public DcTypeDTO getDcType(String id) {
		
		DcTypeDTO object = null;
		
		String query = "SELECT * FROM DC_TYPE WHERE ID_DC = ?";
		Connection con = null;
		PreparedStatement preparedStatement = null;
		ResultSet rs = null;
		
		try{
			
			con = getSqlUtils().getConnection();
			preparedStatement = con.prepareStatement(query);
			preparedStatement.setString(1, id);
			rs = preparedStatement.executeQuery();
			while(rs.next()){
				object = new DcTypeDTO();
				object.setIdDc(rs.getString("ID_DC"));
				object.setIdType(rs.getString("ID_TYPE"));
				object.setType(rs.getString("TYPE"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getSqlUtils().closeAll(con, preparedStatement, rs);
		}
		
		return object;
	}
	
	/** 
	 * @see eionet.eunis.dao.IDocumentsDao#getDcTitle(String id)
	 * {@inheritDoc}
	 */
	public DcTitleDTO getDcTitle(String id) {
		
		DcTitleDTO doc = null;
		
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
				doc = new DcTitleDTO();
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
		
		DcSourceDTO source = null;
		
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
				source = new DcSourceDTO();
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
