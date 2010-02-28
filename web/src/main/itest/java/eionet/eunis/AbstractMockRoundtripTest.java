package eionet.eunis;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.stripes.controller.DispatcherServlet;
import net.sourceforge.stripes.controller.StripesFilter;
import net.sourceforge.stripes.mock.MockRoundtrip;
import net.sourceforge.stripes.mock.MockServletContext;
import junit.framework.TestCase;

/**
 * Base class for all MockRoundtrip based integration tests.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public abstract class AbstractMockRoundtripTest extends TestCase {

	protected MockServletContext context;
	protected MockRoundtrip roundtrip;

	public void setUp(){
		context = new MockServletContext("test");
		// Add the Stripes Filter
		Map<String,String> filterParams = new HashMap<String,String>();
		filterParams.put("ActionResolver.Packages", "eionet.eunis.stripes.actions");
		filterParams.put("Extension.Packages", "eionet.eunis.stripes.extensions");
		filterParams.put("ActionBeanContext.Class", "eionet.eunis.stripes.EunisActionBeanContext");
		context.addFilter(StripesFilter.class, "StripesFilter", filterParams);
		// Add the Stripes Dispatcher
		context.addInitParameter("JDBC_DRV", "org.gjt.mm.mysql.Driver");
		context.addInitParameter("JDBC_URL", "jdbc:mysql://localhost/eunis?autoReconnect=true&amp;useUnicode=true&amp;characterEncoding=utf8");
		context.addInitParameter("JDBC_PWD", "password");
		context.addInitParameter("JDBC_USR", "eunisuser");
		context.setServlet(DispatcherServlet.class, "StripesDispatcher", null);
		roundtrip = new MockRoundtrip(context, getMockRoundtripUrl());
	}
	
	public void tearDown() {
		context = null;
		roundtrip = null;
	}
	
	protected abstract String getMockRoundtripUrl();
}
