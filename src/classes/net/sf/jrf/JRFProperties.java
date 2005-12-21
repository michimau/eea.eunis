/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations under
 * the License.
 *
 * The Original Code is jRelationalFramework.
 *
 * The Initial Developer of the Original Code is is.com.
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
 * Contributor: ____________________________________
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License (the "GPL") or the GNU Lesser General
 * Public license (the "LGPL"), in which case the provisions of the GPL or
 * LGPL are applicable instead of those above.  If you wish to allow use of
 * your version of this file only under the terms of either the GPL or LGPL
 * and not to allow others to use your version of this file under the MPL,
 * indicate your decision by deleting the provisions above and replace them
 * with the notice and other provisions required by either the GPL or LGPL
 * License.  If you do not delete the provisions above, a recipient may use
 * your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf;

import net.sf.jrf.exceptions.ConfigurationException;
import net.sf.jrf.util.PropertiesHelper;
import org.apache.log4j.Category;

import java.util.Properties;

/**
 *  This class manages the properties file for the jRelationalFramework.
 *  <p> The location of the properties file can be set with the
 *  <code>-DjrfPropertiesFile=</code> JVM argument.  Otherwise, the default
 *  is assumed to be <code>jrf.properties</code> somewhere in the root of one
 *  of the directories (or jars) in the classpath.
 *  Useful methods are provided for finding values and converting values from
 *  the properties file. In addition, methods are provided for reconciling values
 *  from external properties instances to the JRF properties.
 *  If a properties value is not found in the external properties instance,
 *  the value will be sought in JRF properties.
 */
public class JRFProperties {

  private static Properties s_properties = null;
  /** See java.util.ResourceBundle */
  private final static String DEFAULT_BUNDLE_NAME = "jrf";
  private static boolean s_bundleNotFound = false;
  private final static Category LOG =
          Category.getInstance(JRFProperties.class.getName());

  private static String bundleName = DEFAULT_BUNDLE_NAME;

  /**
   * Check the jrfPropertiesFile system property (set with a jvm argument of
   * <code>-DjrfPropertiesFile=abc</code> -- The ".properties" file suffix is
   * assumed).  If there is no property with that name, we assume the
   * properties file is named <code>jrf.properties</code> and is in the root
   * of one of the directories (or jars) in the classpath.
   */
  public static void initialize() {
    bundleName = System.getProperty("jrfPropertiesFile");
    if (bundleName != null) {
      int index = bundleName.indexOf(".properties");
      if (index > 0) {
        bundleName = bundleName.substring(0, index);
      }
    } else {
      bundleName = DEFAULT_BUNDLE_NAME;
    }
    JRFProperties.initialize(bundleName);
  }// initialize()

  // Assure we have a properties instance.
  private static void checkProperties() {
    if (s_properties == null) {
      JRFProperties.initialize();
    }
  }

  /**
   * Return JRF properies instance.
   *
   * @return   JRF <code>Properties</code> instance.
   */
  public static Properties getProperties() {
    checkProperties();
    if (s_bundleNotFound) {
      throw new ConfigurationException(
              "Unable to access default JRF properties instance of [" +
              bundleName + ".properties]. Check class path, jar file or war file.");
    }
    return s_properties;
  }

  /**
   * Initializes JRF properties from a bundle name.
   * To use this method, there must be a <i>bundleName</i>.properties file
   * somewhere in the classpath.  Note that understanding how
   * java.util.ResourceBundle works will help in understanding how this
   * works.
   *
   * @param bundleName  name of the bundle.
   * @see               java.util.ResourceBundle
   */
  public static synchronized void initialize(String bundleName) {
    // if we've alrady been here and not found the properties file bundle,
    // then don't look for it again.
    if (s_bundleNotFound) {
      return;
    }
    s_properties = PropertiesHelper.getPropertiesForBundle(bundleName);
    if (s_properties == null) {
      s_bundleNotFound = true;
      LOG.warn("net.sf.jrf.JRFProperties could not find the "
              + bundleName + ".properties file.  This may be by design.");
      return;
    } else {
      LOG.info(
              "JRFProperties initialized with resource bundle named '"
              + bundleName + "'");
    }
  }


  /**
   * Initializes JRF properties using a <code>Properties</code> instance.
   *
   * @param properties  <code>Properties</code> instance to use.
   */
  public static synchronized void initialize(Properties properties) {
    s_properties = properties;
  }// initialize(aProperties)


  /**
   * Returns the string property from JRF properties,
   *  assuring to return <code>null</code>
   *  if property was found but value was an empty string.
   *
   * @param key  key to use to look for property.
   * @return     property value or <code>null</code> if not found or if found
   *  but contains an empty string.
   */
  public static String getProperty(String key) {
    return getStringProperty(key);
  }

  /**
   * Returns the string property from JRF properties,
   *  assuring to return <code>null</code>
   *  if property was found but value was an empty string.
   *
   * @param key  key to use to look for property.
   * @return     property value or <code>null</code> if not found or if found
   *  but contains an empty string.
   */
  public static String getStringProperty(String key) {
    checkProperties();
    return getStringProperty(s_properties, key);
  }

  /**
   * Returns the string property, using the default value if
   *  the property was not found or found with an empty string.
   *
   * @param key           key to use to look for property.
   * @param defaultValue  Description of the Parameter
   * @return              property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static String getProperty(String key, String defaultValue) {
    return getStringProperty(key, defaultValue);
  }

  /**
   * Returns the string property from JRF Properties, returning the default value if
   *  the property was not found or found with an empty string.
   *
   * @param key           key to use to look for property.
   * @param defaultValue  default value to use.
   * @return              property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static String getStringProperty(String key, String defaultValue) {
    checkProperties();
    return getStringProperty(s_properties, key, defaultValue);
  }

  /**
   * Returns the required string property from JRF Properties, throwing a
   * <code>ConfigurationException</code> if value is not found.
   *
   * @param key                      key to use to look for property.
   * @param errorMsg                 Description of the Parameter
   * @return                         property value associated with key.
   * @throws ConfigurationException  if value was not found.
   */
  public static String getRequiredStringProperty(String key, String errorMsg) {
    checkProperties();
    return getRequiredStringProperty(s_properties, key, errorMsg);
  }

  /**
   * Returns the required string property from supplied properties parameter, throwing a
   * <code>ConfigurationException</code> if value is not found.
   *
   * @param p                        <code>Properties</code> instance to search.
   * @param key                      key to use to look for property.
   * @param errorMsg                 Description of the Parameter
   * @return                         property value associated with key.
   * @throws ConfigurationException  if value was not found.
   */
  public static String getRequiredStringProperty(Properties p, String key, String errorMsg) {
    String result = getStringProperty(p, key);
    if (result == null) {
      throw new ConfigurationException("Required value for " + key + " not found. " + errorMsg);
    }
    return result;
  }

  /**
   * Returns the string property, using the default value if
   *  the property was not found or found with an empty string.
   *
   * @param p             <code>Properties</code> instance to search.
   * @param key           key to use to look for property.
   * @param defaultValue  default value to use.
   * @return              property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static String getStringProperty(Properties p, String key, String defaultValue) {
    String result = getStringProperty(p, key);
    return result == null ? defaultValue : result;
  }

  /**
   * Returns the string property, by first search the parameter properties followed
   * by a search of JRF properties for the value.  If the value is not found in either
   * properties instance, the default value will be used.
   *
   * @param p             <code>Properties</code> instance to search first before JRF properties.
   * @param key           key to use to look for property.
   * @param defaultValue  default value to use, which may be <code>null</code>.
   * @return              property value associated with key.
   */
  public static String resolveStringProperty(Properties p, String key, String defaultValue) {
    String result = getStringProperty(p, key);
    if (result == null) {
      return getStringProperty(s_properties, key, defaultValue);
    }
    return result;
  }

  /**
   * Returns the string property, by first search the parameter properties followed
   * by a search of JRF properties for the value.  If the value is not found,
   *  a <code>ConfigurationException</code> will be thrown.
   *
   * @param p                        <code>Properties</code> instance to search first before JRF properties.
   * @param key                      key to use to look for property.
   * @param errorMsg                 Description of the Parameter
   * @return                         property value associated with key.
   * @throws ConfigurationException  if value was not found.
   */
  public static String resolveRequiredStringProperty(Properties p, String key, String errorMsg) {
    String result = getStringProperty(p, key);
    if (result == null) {
      return getRequiredStringProperty(s_properties, key, errorMsg);
    }
    return result;
  }

  /**
   * Returns the string property, using the default value if
   *  the property was not found or found with an empty string.
   *
   * @param p    <code>Properties</code> instance to search.
   * @param key  key to use to look for property.
   * @return     property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static String getStringProperty(Properties p, String key) {
    if (p == null) {
      return null;
    }
    String result = p.getProperty(key);
    if (result != null && result.length() > 0) {
      return result;
    }
    return null;
  }

  /**
   * Using JRF properties, returns <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES".
   *
   * @param key  key to use for the search.
   * @return     <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES". <code>false</code>
   * otherwise.
   */
  public static boolean propertyIsTrue(String key) {
    checkProperties();
    return getBooleanProperty(s_properties, key, false);
  }

  /**
   * Using JRF properties, returns <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES" or the
   * default boolean value supplied otherwise.
   *
   * @param defaultValue  default value to use.
   * @param aString       Description of the Parameter
   * @return              <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES". Return <code>defaultValue</code>
   * otherwise.
   */
  public static boolean getBooleanProperty(String aString, boolean defaultValue) {
    checkProperties();
    return getBooleanProperty(s_properties, aString, defaultValue);
  }


  /**
   * Returns <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES" or the
   * default boolean value supplied otherwise.
   *
   * @param p             <code>Properties</code> instance to search.
   * @param key           key to use for the search.
   * @param defaultValue  default value to use (ignored if <code>null</code>)
   * @return              <code>true</code> if the property exists and the
   * value is a case-insensitive "TRUE" or "YES". Return <code>defaultValue</code>
   * otherwise.
   */
  public static boolean getBooleanProperty(Properties p, String key, boolean defaultValue) {
    return parseBooleanProperty(p.getProperty(key), defaultValue);
  }

  /**
   * Returns the boolean property, by first searching the parameter properties followed
   * by a search of JRF properties.  If the value is not found,
   * the default value will be used.
   *
   * @param p             <code>Properties</code> instance to search first before JRF properties.
   * @param key           key to use to look for property.
   * @param defaultValue  default value to use.
   * @return              property value associated with key.
   */
  public static boolean resolveBooleanProperty(Properties p, String key, boolean defaultValue) {
    String result = getStringProperty(p, key);
    if (result != null) {
      return parseBooleanProperty(result, defaultValue);
    }
    return getBooleanProperty(s_properties, key, defaultValue);
  }

  /**
   * Parses a boolean value, returning <code>true</code> if value is not <code>null</code> and
   * value is a case-insensitive "TRUE" or "YES".  If the default value is not <code>null</code>,
   * it will be used. Otherwise failures will result in a <code>false</code> return.
   *
   * @param value         value to examine, which may be <code>null</code>
   * @param defaultValue  default value to use, which may also be <code>null</code>.
   * @return              result or processing supplied value or the default value if processing fails.
   */
  public static boolean parseBooleanProperty(String value, boolean defaultValue) {
    if (value != null) {
      if (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("yes")) {
        return true;
      }
      if (value.equalsIgnoreCase("false") || value.equalsIgnoreCase("no")) {
        return false;
      }
    }
    return defaultValue;
  }

  /**
   * Returns the int property, using the default value if
   *  the property was not found or found with an empty string.
   *
   * @param key           key to use to look for property.
   * @param defaultValue  Description of the Parameter
   * @return              property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static int getIntProperty(String key, int defaultValue) {
    checkProperties();
    return getIntProperty(s_properties, key, defaultValue);
  }

  /**
   * Returns the int property, using the default value if
   *  the property was not found or found with an empty string.
   *
   * @param p             <code>Properties</code> instance to use.
   * @param key           key to use to look for property.
   * @param defaultValue  Description of the Parameter
   * @return              property value or default value if key was not found or found
   *  containing an empty string.
   */
  public static int getIntProperty(Properties p, String key, int defaultValue) {
    String value = p.getProperty(key);
    if (value == null) {
      return defaultValue;
    }
    return parseIntProperty(key, value, defaultValue);
  }

  /**
   * Returns the int property, by first searching the parameter properties followed
   * by a search of JRF properties.  If the value is not found in either <code>Properties</code>
   * instance, the default value will be used.
   *
   * @param p             <code>Properties</code> instance to search first before JRF properties.
   * @param key           key to use to look for property.
   * @param defaultValue  default value to use.
   * @return              property value associated with key.
   */
  public static int resolveIntProperty(Properties p, String key, int defaultValue) {
    String result = getStringProperty(p, key);
    if (result != null) {
      return parseIntProperty(key, result, defaultValue);
    }
    return getIntProperty(s_properties, key, defaultValue);
  }

  /**
   * Parses the supplied int value from a <code>Properties</code> instance.
   *
   * @param key           property key used for error logging only.
   * @param value         value to parse.
   * @param defaultValue  default value to use if parse fails.
   * @return              value parsed or default value if parse fails.
   */
  public static int parseIntProperty(String key, String value, int defaultValue) {
    try {
      return java.lang.Integer.parseInt(value);
    } catch (NumberFormatException ne) {
      LOG.info("Property under " + key + ",[" + value + "], is not a number. Using default value of "
              + defaultValue + ".");
      return defaultValue;
    }
  }

  /**
   * Return the DatabasePolicy instance.  Be warned that if this database
   * policy object has instance variables and you are in a multi-threaded
   * environment, that this instance may need to be synchronized or else
   * this will need to return a clone of the database policy.
   *
   * @return       a value of type 'DatabasePolicy'
   * @deprecated   no longer supported.
   * @see          net.sf.jrf.sql.DataSourceProperties
   */
  public static DatabasePolicy getDatabasePolicy() {
    throw new RuntimeException("This method is no longer supported; See net.sf.jrf.sql.DataSourceProperties");
  }// getDatabasePolicy()


}// JRFProperties



