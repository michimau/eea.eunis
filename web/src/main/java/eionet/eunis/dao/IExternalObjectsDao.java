package eionet.eunis.dao;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.ExternalObjectDTO;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.stripes.actions.ReferencesActionBean;

/**
 * Helper Dao interface for {@link ReferencesActionBean}.
 * 
 * @author Risto Alt <a href="mailto:risto.alt@tieto.com">contact</a>
 */
public interface IExternalObjectsDao {

    /**
     * Returns list of objects with relation=maybesame
     * 
     * @return list
     */
    List<ExternalObjectDTO> getMaybeSameObjects();

    /**
     * Updates external object
     */
    void updateExternalObject(String identifier, String val);

    /**
     * return all nature object attributes for given nature object
     * 
     * @param id
     * @return Hashtable<String, AttributeDto>
     */
    Hashtable<String, AttributeDto> getNatureObjectAttributes(Integer id);

    /**
     * return all nature object links for given nature object
     * 
     * @param id
     *            - ID_NATURE_OBJECT
     * @return ArrayList<LinkDTO>
     */
    ArrayList<LinkDTO> getNatureObjectLinks(Integer idNatOb);

}
