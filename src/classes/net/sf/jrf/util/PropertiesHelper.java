/*
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
 * Contributor: C.J. Hurst (cjhurst@is.com)
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
package net.sf.jrf.util;


import org.apache.log4j.Category;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Enumeration;
import java.util.MissingResourceException;
import java.util.Properties;
import java.util.ResourceBundle;

/**
 * This class consists of convenience methods for using properties files.
 * It allows for dynamic loading of properties throughout the life
 * of the web application.
 */
public class PropertiesHelper {

  /** Description of the Field */
  public final static Category LOG =
          Category.getInstance(PropertiesHelper.class.getName());

  // Empty constructor
  /**Constructor for the PropertiesHelper object */
  public PropertiesHelper() {
  }

  /**
   * loadProperties is used to retrieve a Properties object consisting of the
   * passed-in filename.  If there are any errors in loading the Properties
   * file, null will be returned.
   *
   * @param filename  Description of the Parameter
   * @return          Properties - The Properties object consisting of all the
   *                      key/value pairs for the file
   */
  public static Properties loadProperties(String filename) {
    if (filename != null) {
      return PropertiesHelper.loadProperties(new File(filename));
    } else {
      return null;
    }
  }

  /**
   * loadProperties is used to retrieve a Properties object consisting of the
   * passed-in file.  If there are any errors in loading the Properties file,
   * null will be returned.
   *
   * @param file  Description of the Parameter
   * @return      Properties - The Properties object consisting of all the
   *                      key/value pairs for the file
   */
  public static Properties loadProperties(File file) {
    Properties result = null;

    // load as a Properties Object
    // handle errors if file not found.
    if (file != null) {
      FileInputStream is = null;
      try {
        // create input stream to read from file
        is = new FileInputStream(file);

        // load the Properties
        result = new Properties();
        result.load(is);
      } catch (FileNotFoundException e) {
        // FileInputStream() - if file not found
        LOG.error(
                "Unable to find/load file: " + file.getPath(),
                e);
        result = null;
      } catch (SecurityException e) {
        // FileInputStream() - if not allowed to read file
        LOG.error(
                "Unable to read file: " + file.getPath(),
                e);
        result = null;
      } catch (IOException e) {
        // Properties().load() - while reading the file
        LOG.error(
                "Error reading file: " + file.getPath(),
                e);
        result = null;
      } finally {
        if (is != null) {
          // have to close the file, to allow file
          // system changing of the file.
          try {
            is.close();
          } catch (IOException e) {
            LOG.error(
                    "Error closing file: " + file.getPath(),
                    e);
          }// catch
        }
      }// finally
    }

    return result;
  }// loadProperties()

  /**
   *  This static method takes information from a resourceBundle and builds
   *  a properties object from the key-value pairs.
   *
   * @param bundleName  Description of the Parameter
   * @return            Properties - populated with information from the resource bundle
   *                       or return null if no bundle is found
   */
  public static Properties getPropertiesForBundle(String bundleName) {
    Properties props = new Properties();
    updatePropertiesForBundle(bundleName, props);
    return props.size() == 0 ? null : props;
  }

  /**
   * Updates or adds to supplied <code>Properties</code> instance.
   *
   * @param bundleName  bundle name.
   * @param props       properties to add.
   */
  public static void updatePropertiesForBundle(String bundleName, Properties props) {
    try {
      ResourceBundle bundle = ResourceBundle.getBundle(bundleName);
      Enumeration enum1 = bundle.getKeys();
      StringBuffer show = new StringBuffer();
      show.append(bundleName + " property values retrieved:\n");
      while (enum1.hasMoreElements()) {
        String key = (String) enum1.nextElement();
        props.put(key, bundle.getString(key));
        show.append("\nKEY: [" + key + "] VALUE: [" + bundle.getString(key) + "]");
      }
      LOG.info(show.toString());
    } catch (MissingResourceException ex) {
      StringBuffer sb = new StringBuffer();
      sb.append("Warning, Properties file not found for bundle ");
      sb.append(bundleName);
      if (bundleName.endsWith(".properties")) {
        sb.append("(probably because you placed '.properties' ");
        sb.append("at the end of the bundle name)");
      }
      LOG.warn(sb.toString());
    }
  }

}// PropertiesHelper
