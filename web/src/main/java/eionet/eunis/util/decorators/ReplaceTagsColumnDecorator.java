package eionet.eunis.util.decorators;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

import ro.finsiel.eunis.utilities.EunisUtil;


public class ReplaceTagsColumnDecorator implements DisplaytagColumnDecorator {

    public Object decorate(Object columnValue, PageContext pageContext, MediaTypeEnum media) throws DecoratorException {
        String value = (String) columnValue;
        if (value != null && value.length() > 0) {
            value = EunisUtil.replaceTags(value, true, true);
        }
        return value;
    }
}
