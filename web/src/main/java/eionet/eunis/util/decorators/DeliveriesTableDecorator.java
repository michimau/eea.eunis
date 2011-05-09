package eionet.eunis.util.decorators;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.displaytag.decorator.TableDecorator;

import eionet.sparqlClient.helpers.ResultValue;

/**
 * 
 * @author altnyris
 * 
 */
public class DeliveriesTableDecorator extends TableDecorator {
    
    protected SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    /**
     * 
     * @return String
     * @throws Exception
     */
    public String getTitle() throws Exception {

        Map<String, ResultValue> wm = (Map<String, ResultValue>) getCurrentRowObject();
        if (wm == null) {
            return "";
        } else {
            ResultValue label = (ResultValue) wm.get("label");
            ResultValue envelope = (ResultValue) wm.get("envelope");

            String title = "- no-label -";
            if (label != null && !StringUtils.isBlank(label.getValue())) {
                title = label.getValue();
            }
            if (envelope != null && !StringUtils.isBlank(envelope.getValue())) {
                StringBuffer ret = new StringBuffer();
                ret.append("<a href=\"").append(envelope.getValue()).append("\">");
                ret.append(title);
                ret.append("</a>");
                title = ret.toString();
            }

            return title;
        }
    }

    /**
     * 
     * @return Date
     * @throws Exception
     */
    public Date getReleased() throws Exception {

        Map<String, ResultValue> wm = (Map<String, ResultValue>) getCurrentRowObject();
        if (wm == null) {
            return null;
        } else {
            ResultValue released = (ResultValue) wm.get("released");

            Date ret = null;
            if (released != null && !StringUtils.isBlank(released.getValue())) {
                ret = dateFormat.parse(released.getValue());
            }

            return ret;
        }
    }

    /**
     * 
     * @return String
     * @throws Exception
     */
    public String getCoverage() throws Exception {

        Map<String, ResultValue> wm = (Map<String, ResultValue>) getCurrentRowObject();
        if (wm == null) {
            return "";
        } else {
            ResultValue coverage = (ResultValue) wm.get("coverage");

            StringBuffer ret = new StringBuffer();
            if (coverage != null && coverage.getValue() != null) {
                ret.append(coverage.getValue());
            }

            return ret.toString();
        }
    }

    /**
     * 
     * @return String
     * @throws Exception
     */
    public String getLabel() throws Exception {

        String ret = "";
        Map<String, ResultValue> wm = (Map<String, ResultValue>) getCurrentRowObject();
        if (wm != null) {
            ResultValue label = (ResultValue) wm.get("label");
            if (label != null && label.getValue() != null) {
                ret = label.getValue();
            }
        }
        return ret;
    }
}
