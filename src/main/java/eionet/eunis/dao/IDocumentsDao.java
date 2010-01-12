package eionet.eunis.dao;

import java.util.List;

import eionet.eunis.dto.DcObjectDTO;
import eionet.eunis.dto.DcSourceDTO;
import eionet.eunis.dto.DcTitleDTO;


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

}