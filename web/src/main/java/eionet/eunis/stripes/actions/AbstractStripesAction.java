package eionet.eunis.stripes.actions;


import org.apache.log4j.Logger;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.SimpleMessage;
import net.sourceforge.stripes.controller.AnnotatedClassActionResolver;
import net.sourceforge.stripes.validation.SimpleError;
import ro.finsiel.eunis.WebContentManagement;
import eionet.eunis.stripes.EunisActionBeanContext;
import eionet.eunis.util.Constants;


/**
 * Base class for all Stripes actions.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class AbstractStripesAction implements ActionBean {
	
    protected final static Logger logger = Logger.getLogger(ActionBean.class);
    private EunisActionBeanContext context;
    private String metaDescription;
    private String btrail;
	
    /**
     * @see net.sourceforge.stripes.action.ActionBean#getContext()
     * {@inheritDoc}
     */
    public EunisActionBeanContext getContext() {
        return context;
    }

    /**
     * @see net.sourceforge.stripes.action.ActionBean#setContext(net.sourceforge.stripes.action.ActionBeanContext)
     * {@inheritDoc}
     */
    public void setContext(ActionBeanContext context) {
        this.context = (EunisActionBeanContext) context;
    }
	
    /**
     * @return url action binding.
     */
    public String getUrlBinding() {
        AnnotatedClassActionResolver resolver = new AnnotatedClassActionResolver();

        return resolver.getUrlBinding(this.getClass());
    }
	
    /**
     * @return content manager
     */
    public WebContentManagement getContentManagement() {
        return context.getSessionManager().getWebContent();
    }
	
    /**
     * 
     * @param String exception to handle.
     */
    void handleEunisException(String exception, int severity) {
        logger.error(exception);
        getContext().setSeverity(severity);
        getContext().getMessages().add(new SimpleError(exception));
    }
	
    /**
     * 
     * @param String message
     */
    void showMessage(String msg) {
        getContext().setSeverity(Constants.SEVERITY_INFO);
        getContext().getMessages().add(new SimpleMessage(msg));
    }
	
    /**
     * 
     * @param String message
     */
    void showWarning(String msg) {
        getContext().setSeverity(Constants.SEVERITY_WARNING);
        getContext().getMessages().add(new SimpleMessage(msg));
    }
	
    public String getMetaDescription() {
        return metaDescription;
    }

    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }

    public String getBtrail() {
        return btrail;
    }

    public void setBtrail(String btrail) {
        this.btrail = btrail;
    }
	
}
