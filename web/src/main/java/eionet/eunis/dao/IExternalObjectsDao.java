package eionet.eunis.dao;


import java.util.List;

import eionet.eunis.dto.ExternalObjectDTO;


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

}
