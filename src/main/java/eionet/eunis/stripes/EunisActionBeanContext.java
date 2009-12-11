package eionet.eunis.stripes;

import eionet.eunis.dao.ISpeciesFactsheetDao;
import eionet.eunis.dao.SpeciesFactsheetDaoImpl;
import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;
import net.sourceforge.stripes.action.ActionBeanContext;

/**
 * Eunis application context.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class EunisActionBeanContext extends ActionBeanContext {

	private static SQLUtilities sqlUtil;
	
	/**
	 * Gets an object from session.
	 * 
	 * @param key
	 * @return
	 */
	public Object getFromSession(String key) {
		return getRequest().getSession().getAttribute(key);
	}
	/**
	 * Add an object to session.
	 * 
	 * @param key
	 * @param value
	 */
	public void addToSession(String key, Object value) {
		getRequest().getSession().setAttribute(key, value);
	}
	
	/**
	 * Removes object from session.
	 * 
	 * @param key
	 */
	public void removeFromSession(String key) {
		getRequest().getSession().removeAttribute(key);
	}
	

	/**
	 * Gets application init parameter.
	 * 
	 * @param key
	 * @return
	 */
	public String getInitParameter(String key) {
		return getServletContext().getInitParameter(key);
	}
	
	/**
	 * @return session manager
	 */
	public SessionManager getSessionManager() {
		SessionManager result = (SessionManager) getFromSession("SessionManager");
		if (result == null) {
			result = new SessionManager();
			addToSession("SessionManager", result);
		}
		return result;
	}

	/**
	 * @return sql utils
	 */
	public SQLUtilities getSqlUtilities() {
		if (sqlUtil == null) {
			sqlUtil = new SQLUtilities();
			sqlUtil.Init(
					getServletContext().getInitParameter("JDBC_DRV"),
					getServletContext().getInitParameter("JDBC_URL"),
					getServletContext().getInitParameter("JDBC_USR"),
					getServletContext().getInitParameter("JDBC_PWD"));
		} 
		return sqlUtil;
	}
	
	/**
	 * @return factsheet helper dao
	 */
	public ISpeciesFactsheetDao getSpeciesFactsheetDao(){
		return new SpeciesFactsheetDaoImpl(getSqlUtilities());
	}
	
}
