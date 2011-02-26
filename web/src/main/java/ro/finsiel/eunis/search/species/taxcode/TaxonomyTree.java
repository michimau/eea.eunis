package ro.finsiel.eunis.search.species.taxcode;


/**
 * User: cromanescu
 * Date: Jan 31, 2006
 * Time: 12:26:16 PM
 */
public class TaxonomyTree {

    /**
     * Whole tree.
     */
    public StringBuffer treeAll;

    /**
     * Insert html spaces
     * @param nr number of spaces
     * @return html fragment
     */
    public static String nbsp(int nr) {
        String ret = "";

        for (int i = 0; i < nr; i++) {
            ret += "&nbsp;&nbsp;&nbsp;";
        }
        return ret;
    }

    /**
     * Retrieve name of a taxonomy
     * @param id taxonomic ID
     * @return Name
     */
    public static String TaxName(Object id) {
        return "SELECT CONCAT('(',LEVEL,')',' ',NAME) FROM CHM62EDT_TAXONOMY WHERE ID_TAXONOMY=" + id.toString();
    }

    /**
     * Count the number of tokens separated by comma.
     * @param str String
     * @return tokens count
     */
    public static int tokensCount(String str) {
        int ret = 0;
        int len = str.length();

        for (int i = 0; i < len; i++) {
            if (str.charAt(i) == ',') {
                ret++;
            }
        }
        return ret;
    }
}
