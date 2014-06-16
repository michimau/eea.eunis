/*
 * Created on August 26, 2002, 3:32 PM
 */

package ro.finsiel.eunis.factsheet.species;


import ro.finsiel.eunis.search.UniqueVector;

import java.util.*;


/**
 * Color generator for maps used within species factsheet.
 * @author finsiel
 */
public class ThreatColor {

    /**
     * Retrieve colors form map.
     * @param status Vector of status names for which color will be generated (ex. {vulnerable, extinct, threatened etc.})
     * @return Hashtable of status-color mappings (colors are in standard RGB format (RRGGBB)).
     */
    public static Hashtable getColorsForMap(UniqueVector status) {
        return getColorsForMap(status.elements());
    }

    /**
     * This method nuances of colors for given threat status.
     * @param status Vector of status names (NAME column from chm62edt_conservation_status).
     * @return Hashtabke of colors for each threat status (order is preserved).
     */
    private static Hashtable getColorsForMap(Vector status) {
        Hashtable results = new Hashtable();
        // Compute how many black and red shades do we need
        int blackShades = 0;
        int redShades = 0;

        for (int i = 0; i < status.size(); i++) {
            String statusStr = ((String) status.get(i)).toLowerCase();

            if (null != statusStr) {
                if (statusStr.lastIndexOf("extinct") >= 0) {
                    blackShades++;
                } else if (statusStr.lastIndexOf("endangered") >= 0) {
                    redShades++;
                } else if (statusStr.lastIndexOf("vulnerable") >= 0) {
                    redShades++;
                }
            }
        }
        Iterator blacks = getBlackShades(blackShades);
        Iterator reds = getRedShades(redShades);
        Iterator distinctShades = getDistinctShades(status.size() - blackShades - redShades);

        // Now set the colors in proper order
        for (int i = 0; i < status.size(); i++) {
            String result = ((String) status.get(i)).toLowerCase();

            if (null != result) {
                if (result.lastIndexOf("extinct") >= 0) {
                    if (blacks.hasNext()) {
                        results.put(result, blacks.next());
                    }
                } else if (result.lastIndexOf("endangered") >= 0) {
                    if (reds.hasNext()) {
                        results.put(result, reds.next());
                    }
                } else if (result.lastIndexOf("vulnerable") >= 0) {
                    if (reds.hasNext()) {
                        results.put(result, reds.next());
                    }
                } else {
                    if (distinctShades.hasNext()) {
                        results.put(result, distinctShades.next());
                    }
                }
            }
        }
        return results;
    }

    /**
     * Retrieve distinct nuances of grey colors.
     * @param number Number of colors to be generated.
     * @return Interator for list of colors (as hex strings ex. CCCCCC).
     */
    private static Iterator getBlackShades(int number) {
        Vector results = new Vector();

        if (number <= 0) {
            return results.iterator();
        }
        int startCol = 255;
        int endCol = 128;
        int range = endCol - startCol;
        int step = range / number;

        for (int i = 0; i < number; i++) {
            int color = ((endCol - step * i) << 16) + ((endCol - step * i) << 8) + (endCol - step * i);

            results.addElement(Integer.toHexString(color));
        }
        return results.iterator();
    }

    /**
     * Retrieve distinct nuances of red colors.
     * @param number Number of colors to be generated.
     * @return Interator for list of colors (as hex strings ex. FF0000).
     */
    private static Iterator getRedShades(int number) {
        Vector results = new Vector();

        if (number <= 0) {
            return results.iterator();
        }
        int red = 128;
        int increment = 127 / number;

        for (int i = 0; i < number; i++) {
            red += increment;
            results.addElement(Integer.toHexString(red << 16));
        }
        return results.iterator();
    }

    /**
     * Retrieve distinct nuances of color ranging from green to blue.
     * @param number Number of colors to be generated.
     * @return Interator for list of colors (as hex strings ex. FF00AB).
     */
    private static Iterator getDistinctShades(int number) {
        Vector results = new Vector();

        if (number <= 0) {
            return results.iterator();
        }
        int startColor = 0;
        int endColor = 255;
        int range = endColor - startColor;
        int step = range / number;

        for (int i = 0; i < number; i++) {
            int color = ((endColor - step * i) << 8) + (startColor + (step * i));
            String hexColStr = Integer.toHexString(color);

            if (hexColStr.length() < 6) {
                hexColStr = "00" + hexColStr;
            }
            results.addElement(hexColStr);

        }
        return results.iterator();
    }

    /**
     * Test method for this class.
     * @param args Command line args.
     */
    public static void main(String[] args) {
        Vector status = new Vector();

        status.add("Endangered");
        status.add("Endangered");
        status.add("Extinct");
        status.add("Endangered");
        status.add("Lower Risk");
        status.add("Vulnerable");
        status.add("Not threatened");
        status.add("Insufficiently known");
        status.add("Vulnerable");
        Hashtable colors = getColorsForMap(status);
        // System.out.println("colors = " + colors);
    }
}
