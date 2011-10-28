package eionet.eunis.util.decorators;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.sparqlClient.helpers.ResultValue;

public class ForeignDataColumnDecorator implements DisplaytagColumnDecorator {

    public Object decorate(Object columnValue, PageContext pageContext, MediaTypeEnum media) throws DecoratorException {
        String ret = "";
        ResultValue value = (ResultValue) columnValue;
        if (value != null) {
            ret = value.getValue();
            if (!value.isLiteral()) {
                ret = "<a href=\"" + ret + "\">" + EunisUtil.threeDots(ret, 45) + "</a>";
            }
        }
        return ret;
    }
}
