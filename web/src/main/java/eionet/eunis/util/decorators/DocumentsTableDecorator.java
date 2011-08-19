package eionet.eunis.util.decorators;


import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dto.DocumentDTO;


/**
 *
 * @author altnyris
 *
 */
public class DocumentsTableDecorator extends TableDecorator {

    /**
     *
     * @return String
     */
    public String getDocTitle() {

        StringBuilder ret = new StringBuilder();
        DocumentDTO doc = (DocumentDTO) getCurrentRowObject();

        ret.append("<a href='documents/").append(doc.getIdDoc()).append("'>");
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
    public String getDocYear() {

        DocumentDTO doc = (DocumentDTO) getCurrentRowObject();
        String ret = doc.getYear();
        if (ret != null && ret.length() > 4) {
            ret = doc.getYear().substring(0, 4);
        }
        return ret;
    }

}
