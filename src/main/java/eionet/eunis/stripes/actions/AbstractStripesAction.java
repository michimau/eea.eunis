package eionet.eunis.stripes.actions;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.controller.AnnotatedClassActionResolver;
import ro.finsiel.eunis.WebContentManagement;
import eionet.eunis.stripes.EunisActionBeanContext;

/**
 * Base class for all Stripes actions.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class AbstractStripesAction implements ActionBean {
	
	private EunisActionBeanContext context;
	
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
	

}
