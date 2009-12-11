package eionet.eunis;

import java.util.HashMap;
import java.util.Map;

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
	
	
	private static final String SQL_DRIVER_NAME = "org.gjt.mm.mysql.Driver";
	private static final String SQL_DRIVER_URL = "jdbc:mysql://localhost/eunis?autoReconnect=true&amp;useUnicode=true&amp;characterEncoding=utf8";
	private static final String SQL_DRIVER_USERNAME = "eunisuser";
	private static final String SQL_DRIVER_PASSWORD = "password";

	private static final SQLUtilities SQL_UTILS;
	
	static {
		SQL_UTILS = new SQLUtilities();
		SQL_UTILS.Init(SQL_DRIVER_NAME, SQL_DRIVER_URL, SQL_DRIVER_USERNAME, SQL_DRIVER_PASSWORD);
	}
	
	
	private Map<String, Object> fakeSession = new HashMap<String, Object>();
	
	
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
	
	

}
