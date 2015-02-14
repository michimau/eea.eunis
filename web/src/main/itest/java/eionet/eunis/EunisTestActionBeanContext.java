package eionet.eunis;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.stripes.EunisActionBeanContext;

/**
 * Application context used for unit testing.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class EunisTestActionBeanContext extends EunisActionBeanContext {

	private static final SQLUtilities SQL_UTILS;
	
	static {
		SQL_UTILS = new SQLUtilities();
		SQL_UTILS.Init();
	}
	
	
	private Map<String, Object> fakeSession = new HashMap<String, Object>();
	private HttpServletRequest fakeRequest;
	
	
	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#addToSession(java.lang.String, java.lang.Object)
	 * {@inheritDoc}
	 */
	@Override
	public void addToSession(String key, Object value) {
		fakeSession.put(key, value);
	}
	
	

	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#getFromSession(java.lang.String)
	 * {@inheritDoc}
	 */
	@Override
	public Object getFromSession(String key) {
		return fakeSession.get(key);
	}

	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#getSessionManager()
	 * {@inheritDoc}
	 */
	@Override
	public SessionManager getSessionManager() {
		return new SessionManager();
	}

	
	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#removeFromSession(java.lang.String)
	 * {@inheritDoc}
	 */
	@Override
	public void removeFromSession(String key) {
		fakeSession.remove(key);
	}

	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#getSqlUtilities()
	 * {@inheritDoc}
	 */
	@Override
	public SQLUtilities getSqlUtilities() {
		return SQL_UTILS;
	}

	/** 
	 * @see eionet.eunis.stripes.EunisActionBeanContext#getInitParameter(java.lang.String)
	 * {@inheritDoc}
	 */
	@Override
	public String getInitParameter(String key) {
		return "";
	}

	/** 
	 * @see net.sourceforge.stripes.action.ActionBeanContext#getRequest()
	 * {@inheritDoc}
	 */
	@Override
	public HttpServletRequest getRequest() {
		return fakeRequest;
	}

	/**
	 * @param fakeRequest the fakeRequest to set
	 */
	public void setFakeRequest(HttpServletRequest fakeRequest) {
		this.fakeRequest = fakeRequest;
	}

}
