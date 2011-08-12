package eionet.eunis.dao;


import java.util.Hashtable;
import java.util.List;

import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.ExternalObjectDTO;
import eionet.eunis.stripes.actions.DocumentsActionBean;


/**
 * Helper Dao interface for {@link DocumentsActionBean}.
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface IExternalObjectsDao {

    /**
     * Returns list of objects with relation=maybesame
     * @return list
     */
    List<ExternalObjectDTO> getMaybeSameObjects();

    /**
     * Updates external object
     */
    void updateExternalObject(String identifier, String val);

    /**
     * return all nature object attributes for given nature object
     * @param id
     * @return Hashtable<String, AttributeDto>
     */
    Hashtable<String, AttributeDto> getNatureObjectAttributes(Integer id);

}
