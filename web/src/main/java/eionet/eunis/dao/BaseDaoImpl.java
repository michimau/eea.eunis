package eionet.eunis.dao;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * Base class for all Dao implementations.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class BaseDaoImpl {

	private SQLUtilities sqlUtils;

	public BaseDaoImpl(SQLUtilities sqlUtils) {
		this.sqlUtils = sqlUtils;
	}

	/**
	 * @return the sqlUtils
	 */
	public SQLUtilities getSqlUtils() {
		return sqlUtils;
	}
}
