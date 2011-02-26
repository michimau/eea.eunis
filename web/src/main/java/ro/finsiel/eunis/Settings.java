package ro.finsiel.eunis;


import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.Utilities;

import javax.servlet.http.HttpServlet;
import java.util.Hashtable;
import java.util.Enumeration;


/**
 * Application global settings read from web.xml when each session is initialized.
 * @author finsiel
 */
public class Settings {
    private static Hashtable settings = new Hashtable();
    private static boolean loaded = false;

    /**
     * Get an application setting.
     * @param name Value is one listed as parameters in web.xml.
     * @return Value of setting or empty string if values does not exist (additionally with an warning message).
     */
    public static String getSetting(String name) {
        String ret = "";

        if (null == name) {
            System.out.println(
                    "Settings::getSetting(" + name
                    + ") - Warning: Parameter was null. Returning empty string.");
        } else {
            if (settings.containsKey(name)) {
                ret = (String) settings.get(name);
            } else {
                System.out.println(
                        "Settings::getSetting(" + name
                        + ") - Warning: Value not found in settings object. Returning empty string.");
                if (!loaded) {
                    System.out.println(
                            "Settings::getSetting(" + name
                            + ") - Warning: Settings not loaded. Load settings before using this method.");
                }
            }
        }
        return ret;
    }

    /**
     * Add a new parameter in the settings object.
     * @param name Name of the parameter. If <code>null</code> is not added (but warning message is generated)
     * @param value Value of the parameter. If <code>null</code> is not added (but warning message is generated)
     */
    public static void setSetting(String name, String value) {
        if (null == name || null == value) {
            if (null != name
                    && (name.equalsIgnoreCase("PROXY_URL")
                            || name.equalsIgnoreCase("PROXY_PORT"))) {
                System.out.println(
                        "Settings::setSetting(" + name + ", " + value
                        + ") - Warning: null parameters. Not using proxy.");
            } else {
                System.out.println(
                        "Settings::setSetting(" + name + ", " + value
                        + ") - Warning: null parameters. Value not loaded.");
            }
            return;
        }
        settings.put(name, value);
    }

    /**
     * Overrids <code>toString()</code> method of the <code>Object</code> object.
     * @return a string representation of the object.
     * @see java.lang.Object#toString
     */
    public String toString() {
        return settings.toString();
    }

    /**
     * Load the settings from application context when it is initialized (application).
     * @param servlet Servlet used to retrieve the application context.
     */
    public static void loadSettings(HttpServlet servlet) {
        if (null == servlet) {
            return;
        }
        // System.out.println("Session initialization. Loading values from web.xml");
        Enumeration en = servlet.getServletContext().getInitParameterNames();

        while (en.hasMoreElements()) {
            String param = (String) en.nextElement();

            Settings.setSetting(param,
                    servlet.getServletContext().getInitParameter(param));
            // System.out.println(param  + " = " + servlet.getServletContext().getInitParameter(param));
        }
        SitesSearchUtility.SITES_PER_MAP = Utilities.checkedStringToInt(
                Settings.getSetting("SITES_PER_MAP"), 300);
        Settings.setSetting("INSTANCE_HOME",
                servlet.getServletContext().getRealPath("/"));
        // Initialize the global settings of Settings object from web.xml
        // Settings.setSetting("DOMAIN_NAME", servlet.getServletContext().getInitParameter("DOMAIN_NAME"));
        // Settings.setSetting("PAGE_TITLE", servlet.getServletContext().getInitParameter("PAGE_TITLE"));
        // Settings.setSetting("EMAIL_FEEDBACK", servlet.getServletContext().getInitParameter("EMAIL_FEEDBACK"));
        //
        // Settings.setSetting("NEWS_URL", servlet.getServletContext().getInitParameter("NEWS_URL"));
        // Settings.setSetting("TEMP_DIR", servlet.getServletContext().getInitParameter("TEMP_DIR"));
        // Settings.setSetting("UPLOAD_DIR_FILES", servlet.getServletContext().getInitParameter("UPLOAD_DIR_FILES"));
        // Settings.setSetting("UPLOAD_DIR_PICTURES_SPECIES", servlet.getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES"));
        // Settings.setSetting("UPLOAD_DIR_PICTURES_HABITATS", servlet.getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_HABITATS"));
        // Settings.setSetting("UPLOAD_DIR_PICTURES_SITES", servlet.getServletContext().getInitParameter("UPLOAD_DIR_PICTURES_SITES"));
        // Settings.setSetting("UPLOAD_FILE_MAX_SIZE", servlet.getServletContext().getInitParameter("UPLOAD_FILE_MAX_SIZE"));
        // Settings.setSetting("LAST_UPDATE", servlet.getServletContext().getInitParameter("LAST_UPDATE"));
        // Settings.setSetting("APP_VERSION", servlet.getServletContext().getInitParameter("APP_VERSION"));
        // Settings.setSetting("JDBC_DRV", servlet.getServletContext().getInitParameter("JDBC_DRV"));
        // Settings.setSetting("JDBC_URL", servlet.getServletContext().getInitParameter("JDBC_URL"));
        // Settings.setSetting("JDBC_USR", servlet.getServletContext().getInitParameter("JDBC_USR"));
        // Settings.setSetting("JDBC_PWD", servlet.getServletContext().getInitParameter("JDBC_PWD"));
        // Settings.setSetting("MAP_URL", servlet.getServletContext().getInitParameter("MAP_URL"));
        // Settings.setSetting("EEA_MAP_SERVER", servlet.getServletContext().getInitParameter("EEA_MAP_SERVER"));
        // Settings.setSetting("EEA_MAP_SERVER_EXTENSION", servlet.getServletContext().getInitParameter("EEA_MAP_SERVER_EXTENSION"));
        // Settings.setSetting("PROXY_URL", servlet.getServletContext().getInitParameter("PROXY_URL"));
        // Settings.setSetting("PROXY_PORT", servlet.getServletContext().getInitParameter("PROXY_PORT"));
        // Settings.setSetting("BUG", servlet.getServletContext().getInitParameter("bug"));
        // Settings.setSetting("TOMCAT_HOME", servlet.getServletContext().getInitParameter("TOMCAT_HOME"));
        loaded = true;
    }

    /**
     * Test method for this class.
     * @param args Command line arguments. Currently none accepted.
     */
    public static void main(String[] args) {
        setSetting("x", "y");
        setSetting(null, "a");
        setSetting("b", null);
        setSetting("a", "1");
        setSetting("a", "2");
        System.out.println("getSetting(null) = " + getSetting(null));
        System.out.println("getSetting(a) = " + getSetting("a"));
        System.out.println("settings.toString() = " + settings.toString());
    }
}
