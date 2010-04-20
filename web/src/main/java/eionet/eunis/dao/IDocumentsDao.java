package eionet.eunis.dao;

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


/**
 * Helper Dao interface for {@link DocumentsActionBean}.
 * 
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface IDocumentsDao {
	
	/**
	 * Returns list of dublin core elements
	 * @return list
	 */
	List<DcTitleDTO> getDocuments();
	
	/**
	 * Returns content of table DC_CONTRIBUTOR
	 * @param id_dc
	 * @return DcContributorDTO
	 */
	DcContributorDTO getDcContributor(String id);
	
	/**
	 * Returns content of table DC_COVERAGE
	 * @param id_dc
	 * @return DcCoverageDTO
	 */
	DcCoverageDTO getDcCoverage(String id);
	
	/**
	 * Returns content of table DC_CREATOR
	 * @param id_dc
	 * @return DcCreatorDTO
	 */
	DcCreatorDTO getDcCreator(String id);
	
	/**
	 * Returns content of table DC_DATE
	 * @param id_dc
	 * @return DcDateDTO
	 */
	DcDateDTO getDcDate(String id);
	
	/**
	 * Returns content of table DC_DESCRIPTION
	 * @param id_dc
	 * @return DcDescriptionDTO
	 */
	DcDescriptionDTO getDcDescription(String id);
	
	/**
	 * Returns content of table DC_FORMAT
	 * @param id_dc
	 * @return DcFormatDTO
	 */
	DcFormatDTO getDcFormat(String id);
	
	/**
	 * Returns content of table DC_IDENTIFIER
	 * @param id_dc
	 * @return DcIdentifierDTO
	 */
	DcIdentifierDTO getDcIdentifier(String id);
	
	/**
	 * Returns content of table DC_INDEX
	 * @param id_dc
	 * @return DcIndexDTO
	 */
	DcIndexDTO getDcIndex(String id);
	
	/**
	 * Returns content of table DC_LANGUAGE
	 * @param id_dc
	 * @return DcLanguageDTO
	 */
	DcLanguageDTO getDcLanguage(String id);
	
	/**
	 * Returns content of table DC_PUBLISHER
	 * @param id_dc
	 * @return DcPublisherDTO
	 */
	DcPublisherDTO getDcPublisher(String id);
	
	/**
	 * Returns content of table DC_RELATION
	 * @param id_dc
	 * @return DcRelationDTO
	 */
	DcRelationDTO getDcRelation(String id);
	
	/**
	 * Returns content of table DC_RIGHTS
	 * @param id_dc
	 * @return DcRightsDTO
	 */
	DcRightsDTO getDcRights(String id);
	
	/**
	 * Returns content of table DC_SUBJECT
	 * @param id_dc
	 * @return DcSubjectDTO
	 */
	DcSubjectDTO getDcSubject(String id);
	
	/**
	 * Returns content of table DC_TYPE
	 * @param id_dc
	 * @return DcTypeDTO
	 */
	DcTypeDTO getDcType(String id);
	
	/**
	 * Returns content of table DC_TITLE
	 * @param id_dc
	 * @return DcTitleDTO
	 */
	DcTitleDTO getDcTitle(String id);
	
	/**
	 * Returns content of table DC_SOURCE
	 * @param id_dc
	 * @return DcSourceDTO
	 */
	DcSourceDTO getDcSource(String id);
	
	/**
	 * Returns all Dublin Core elements
	 * @return list of DcObjectDTO elements
	 */
	List<DcObjectDTO> getDcObjects();
	
	/**
	 * Returns Dublin Core elements by id
	 * @param id_dc
	 * @return DcObjectDTO element
	 */
	DcObjectDTO getDcObject(String id);
	
	/**
	 * Insert new source
	 * @param title
	 * @param source
	 * @param publisher
	 * @param editor
	 * @param url
	 * @param year
	 * @return ID_DC
	 */
	Integer insertSource(String title, String source, String publisher, String editor, String url, String year) throws Exception;

}