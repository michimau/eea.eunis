package eionet.eunis.util.decorators;


import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dto.ReferenceDTO;


/**
 *
 * @author altnyris
 *
 */
public class ReferencesTableDecorator extends TableDecorator {

    /**
     *
     * @return String
     */
    public String getRefTitle() {

        StringBuilder ret = new StringBuilder();
        ReferenceDTO doc = (ReferenceDTO) getCurrentRowObject();

        ret.append("<a href='references/").append(doc.getIdRef()).append("'>");
        if (doc.getTitle() != null && !doc.getTitle().equals("")) {
            ret.append(EunisUtil.replaceTags(doc.getTitle(), true, true));
        } else {
            ret.append("-no-title-");
        }
        ret.append("</a>");

        return ret.toString();
    }

    /**
     *
     * @return String
     */
    public String getRefYear() {

        ReferenceDTO doc = (ReferenceDTO) getCurrentRowObject();
        String ret = doc.getYear();
        if (ret != null && ret.length() > 4) {
            ret = doc.getYear().substring(0, 4);
        }
        return ret;
    }

}
