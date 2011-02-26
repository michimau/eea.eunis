package eionet.eunis.stripes.actions;


import org.apache.commons.lang.StringUtils;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * Action bean to handle species-advanced functionality.
 * (included for backward compatibility only)
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species-advanced_new.jsp")
public class SpeciesAdvancedRedirectActionBean extends AbstractStripesAction {
    private String natureobject = "";

    /**
     * Redirect to new advanced species search location
     */
    @DefaultHandler
    public Resolution defaultAction() {
        String url = "/speciesAdvancedSearch"
                + (StringUtils.isEmpty(natureobject) ? "" : "/" + natureobject);

        logger.debug("natureObject" + natureobject);

        return new RedirectResolution(url);
    }

    public String getNatureobject() {
        return natureobject;
    }

    public void setNatureobject(String natureobject) {
        this.natureobject = natureobject;
    }
}
