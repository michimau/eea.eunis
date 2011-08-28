package eionet.eunis.stripes;


import java.util.Hashtable;
import java.util.Properties;

import net.sourceforge.stripes.action.ActionBeanContext;

import org.apache.log4j.Logger;

import ro.finsiel.eunis.session.SessionManager;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.util.Constants;


/**
 * Eunis application context.
 *
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
public class EunisActionBeanContext extends ActionBeanContext {

    private static SQLUtilities sqlUtil;
    /** Storage of values from eunis.properties file. */
    private static Properties eunisProperties;
    private int severity;
    private static final Logger logger = Logger.getLogger(EunisActionBeanContext.class);

    /**
     * get application property from eunis.properties file.
     *
     * @param key key to fetch.
     * @return
     */
    public String getApplicationProperty(String key) {
        if (eunisProperties == null) {
            try {
                eunisProperties = new Properties();
                eunisProperties.load(getClass().getClassLoader().getResourceAsStream("eunis.properties"));
            } catch (Exception fatal) {
                logger.error(fatal);
                throw new RuntimeException(fatal);
            }
        }
        return eunisProperties.getProperty(key);
    }

    /**
     * Get nature object attribute. All attributes for the nature object are stored in <em>Session scope</em> the
     * first time an attribute is needed. It has the side-effect that a user won't see an attribute update
     * until he closes his browser.
     *
     * @param id - id of nature object
     * @param attr - name of attribute
     * @return String - value of attribute.
     */
    public String getNatObjectAttribute(Integer id, String name) {
        String ret = null;
        if (id != null && name != null) {
            String key = Constants.NAT_OBJECT_ATTRIBUTES_SESSION_KEY + id;
            Hashtable<String, AttributeDto> hash = (Hashtable<String, AttributeDto>) getRequest().getSession().getAttribute(key);
            if (hash != null) {
                AttributeDto attr = hash.get(name);
                if (attr != null) {
                    ret = attr.getValue();
                }
            } else {
                Hashtable<String, AttributeDto> h = DaoFactory.getDaoFactory().getExternalObjectsDao().getNatureObjectAttributes(id);
                getRequest().getSession().setAttribute(key, h);
                if (h != null && h.size() > 0) {
                    AttributeDto attr = h.get(name);
                    if (attr != null) {
                        ret = attr.getValue();
                    }
                }
            }
        }
        return ret;
    }

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
     * @return jdbc user
     */
    public String getJdbcUser() {
        return getInitParameter("JDBC_USR");
    }

    /**
     * @return jdbc password
     */
    public String getJdbcPassword() {
        return getInitParameter("JDBC_PWD");
    }

    /**
     * @return jdbc url
     */
    public String getJdbcUrl() {
        return getInitParameter("JDBC_URL");
    }

    /**
     * @return jdbc driver
     */
    public String getJdbcDriver() {
        return getInitParameter("JDBC_DRV");
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
            sqlUtil.Init(getJdbcDriver(), getJdbcUrl(), getJdbcUser(), getJdbcPassword());
        }
        return sqlUtil;
    }

    public int getSeverity() {
        return severity;
    }

    public void setSeverity(int severity) {
        this.severity = severity;
    }

    public String getDomainName() {
        return getInitParameter("DOMAIN_NAME");
    }

}
