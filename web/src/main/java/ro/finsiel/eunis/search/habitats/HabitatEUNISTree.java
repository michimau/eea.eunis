/*
 * HabitatEUNISTree.java
 *
 * Created on August 23, 2002, 5:46 PM
 */

package ro.finsiel.eunis.search.habitats;


/**
 *
 * @author  root
 */

import java.util.*;
import ro.finsiel.eunis.jrfTables.*;


/**
 * Class used in habitat-eunis-browser.
 * @author finsiel
 */

public class HabitatEUNISTree {

    private int nodeID;

    /**
     * Javascript tree.
     */
    public StringBuffer tree;

    /**
     * Maximum level.
     */
    public int maxlevel;

    /**
     * Level.
     */
    public String level1;
    List coduriL1;
    private String factsheetOpenNode = null;
    private String factsheetIdHabitat = null;

    /**
     * Creates a new instance of HabitatEUNISTree.
     */
    public HabitatEUNISTree() {
        coduriL1 = new Chm62edtHabitatDomain().findWhereOrderBy("LEVEL = 1 AND ID_HABITAT>=1 and ID_HABITAT<10000",
                "EUNIS_HABITAT_CODE");
    }

    /**
     * Iterator for list generated by SELECT * FROM chm62edt_habitat WHERE LEVEL = 1 AND ID_HABITAT>=1 and ID_HABITAT<10000 ORDER BY EUNIS_HABITAT_CODE.
     * @return List of Chm62edtHabitatPersist objects.
     */

    public Iterator getIterator() {
        return coduriL1.iterator();
    }

    /** Generate 'arrayName' tree string beginning with first level.
     * @param arrayName name of tree string
     */

    public void getTree(String arrayName) {
        tree = new StringBuffer();
        nodeID = 0;
        level1 = getTree(arrayName, 1, 0, "");
    }

    /**
     * Generate 'arrayName' tree string beginning with level = 'level' and parent code = 'parentCode'.
     * @param arrayName name of tree string
     * @param level level
     * @param parentCode parent code
     */

    public void getTree(String arrayName, int level, String parentCode) {
        tree = new StringBuffer();
        nodeID = 0;
        level1 = getTree(arrayName, level, 0, parentCode);
    }

    /**
     * Generate 'arrayName' tree string beginning with level = 'level', parent node id = 'parentNodID'
     * and parent code = 'parentCode'.
     * @param arrayName name of tree string
     * @param level level
     * @param parentNodID parent node id
     * @param parentCode parent code
     * @return Tree (Javascript definition of the tree array).
     */

    public String getTree(String arrayName, int level, int parentNodID, String parentCode) {
        String r = null;
        StringBuffer localTree = new StringBuffer();
        StringBuffer childs = null;

        if (level < maxlevel) {
            List lHabitats = null;
            String wildcard = "_";

            if (level == 3) {
                wildcard = "._";
            }
            if (level == 1) {
                lHabitats = new Chm62edtHabitatDomain().findWhereOrderBy(
                        "LEVEL = " + level + " AND ID_HABITAT>=1 and ID_HABITAT<10000", "EUNIS_HABITAT_CODE");
            } else {
                lHabitats = new Chm62edtHabitatDomain().findWhereOrderBy(
                        "LEVEL = " + level + " AND ID_HABITAT>=1 and ID_HABITAT<10000 AND EUNIS_HABITAT_CODE LIKE '" + parentCode
                        + wildcard + "'",
                        "EUNIS_HABITAT_CODE");
            }
            Iterator it = lHabitats.iterator();

            if (it.hasNext()) {
                childs = new StringBuffer();
            }
            while (it.hasNext()) {
                Chm62edtHabitatPersist h = (Chm62edtHabitatPersist) it.next();

                localTree.append(arrayName);
                localTree.append("[");
                localTree.append(nodeID++); // elementId
                localTree.append("]=\"");
                localTree.append(nodeID); // nodeId
                childs.append(nodeID);
                if (it.hasNext()) {
                    childs.append(",");
                }
                localTree.append("|");
                localTree.append(parentNodID);
                // localTree.append("|");
                // localTree.append(h.getHabLevel());
                localTree.append("|");
                String sn = h.getScientificName();

                while (sn.indexOf("\"") != -1) {
                    String aux = sn.substring(0, sn.indexOf("\"")) + "\\$";

                    sn = aux + sn.substring(sn.indexOf("\"") + 1);
                }
                localTree.append(h.getEunisHabitatCode() + " - " + sn.replace('$', '\"'));
                localTree.append("|");
                localTree.append("habitats-code-browser.jsp?habID=" + h.getIdHabitat() + "&openNode=" + nodeID);
                if (factsheetIdHabitat != null && factsheetIdHabitat.equalsIgnoreCase(h.getIdHabitat())) {
                    factsheetOpenNode = new Integer(nodeID).toString();
                    // System.out.println("fact idhab="+factsheetIdHabitat);
                }
                localTree.append("|");
                String nextlevel = this.getTree(arrayName, level + 1, nodeID, h.getEunisHabitatCode());

                localTree.append(nextlevel != null);
                localTree.append("|");
                localTree.append(!it.hasNext());
                localTree.append("|");
                localTree.append(nextlevel);
                localTree.append("|");
                localTree.append(h.getHabLevel());
                localTree.append("\";\n");
            }
            tree.append(localTree);
        }
        if (childs != null) {
            r = childs.toString();
        }
        return r;
    }

    /**
     * Return factsheetOpenNode.
     * @return factsheetOpenNode.
     */
    public String getFactsheetOpenNode() {
        return factsheetOpenNode;
    }

    /**
     * Set factsheetOpenNode.
     * @param factsheetOpenNode tree open node from habitat factsheet
     */
    public void setFactsheetOpenNode(String factsheetOpenNode) {
        this.factsheetOpenNode = factsheetOpenNode;
    }

    /**
     * Return factsheetIdHabitat.
     * @return factsheetIdHabitat.
     */
    public String getFactsheetIdHabitat() {
        return factsheetIdHabitat;
    }

    /**
     * Set factsheetIdHabitat.
     * @param factsheetIdHabitat id habitat from habitat factsheet.
     */

    public void setFactsheetIdHabitat(String factsheetIdHabitat) {
        this.factsheetIdHabitat = factsheetIdHabitat;
    }
}

