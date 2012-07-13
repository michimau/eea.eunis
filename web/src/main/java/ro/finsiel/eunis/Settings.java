package ro.finsiel.eunis;


import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServlet;

import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import eionet.eunis.util.Constants;


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
        SitesSearchUtility.SITES_PER_MAP = Utilities.checkedStringToInt(Settings.getSetting("SITES_PER_MAP"), 300);
        Settings.setSetting("INSTANCE_HOME", servlet.getServletContext().getInitParameter(Constants.APP_HOME_INIT_PARAM));
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
