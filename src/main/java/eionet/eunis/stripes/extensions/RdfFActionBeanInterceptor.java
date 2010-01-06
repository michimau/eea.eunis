package eionet.eunis.stripes.extensions;

import eionet.eunis.stripes.actions.RdfAware;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.controller.ExecutionContext;
import net.sourceforge.stripes.controller.Interceptor;
import net.sourceforge.stripes.controller.Intercepts;
import net.sourceforge.stripes.controller.LifecycleStage;

/**
 * Interceptor to handle rdf exporting.
 * See {@link RdfAware}.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@Intercepts(LifecycleStage.BindingAndValidation)
public class RdfFActionBeanInterceptor implements Interceptor {
	
	private static final String ACCEPT_RDF_HEADER = "application/rdf+xml";

	public Resolution intercept(ExecutionContext context) throws Exception {
		if(ACCEPT_RDF_HEADER.equals(context.getActionBeanContext().getRequest().getHeader("accept"))
				&& context.getActionBean() instanceof RdfAware) {
			context.setHandler(context.getActionBean().getClass().getDeclaredMethod(RdfAware.RDF_GENERATING_METHOD));
		}
		return context.proceed();
	}

}
