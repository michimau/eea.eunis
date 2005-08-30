package ro.finsiel.eunis.backtrail;

import java.util.Vector;
import java.util.StringTokenizer;

/**
 * This class offers utilities for support in backtrail construction / representation.
 * An backtrail string is composed as follows:<br />
 * NAME#URL,NAME2#URL2,NAME3#URL3.<br />
 * This corresponds to the folowing backtrail:
 * NAME <> NAME2 <> NAME3 ...each having their corresponding URL...URL/URL2/URL3.
 * @author finsiel
 */
public class BacktrailUtil {
  private static final String BK_DELIMITER = ",";
  private static final String URL_DELIMITER = "#";

  /**
   * Get the backtrail from string (order of objects is preserved).
   * @param backtrail String containing the backtrail.
   * @return Vector of BacktrailObjects (in order they must appear).
   */
  public static Vector parseBacktrailString(String backtrail) {
    Vector res = new Vector();
    if (null == backtrail) return res;
    StringTokenizer btTokenizer = new StringTokenizer(backtrail, BK_DELIMITER);
    // Parse the entire backtrail and extract each component of the backtrail
    while (btTokenizer.hasMoreElements()) {
      String btObject = (String) btTokenizer.nextElement();
      StringTokenizer urlTokenizer = new StringTokenizer(btObject, URL_DELIMITER);
      BacktrailObject backtrailObject = new BacktrailObject();
      if (urlTokenizer.hasMoreElements()) backtrailObject.setName((String) urlTokenizer.nextElement());
      if (urlTokenizer.hasMoreElements()) backtrailObject.setUrl((String) urlTokenizer.nextElement());
      res.addElement(backtrailObject);
    }
    return res;
  }

  /**
   * Test method.
   * @param args Command line arguments.
   */
  public static void main(String[] args) {
    String testBacktrail = "NAME0#,NAME1#URL1,NAME2#URL2,NAME3,NAME4";
    Vector backtrail = BacktrailUtil.parseBacktrailString(testBacktrail);
    for (int i = 0; i < backtrail.size(); i++) {
      BacktrailObject backtrailObject = (BacktrailObject) backtrail.elementAt(i);
      backtrailObject.setCssStyle("style='color: #FFFFFF; text-decoration: none;'");
      //System.out.println(backtrailObject.toURLString());
    }
  }
}
