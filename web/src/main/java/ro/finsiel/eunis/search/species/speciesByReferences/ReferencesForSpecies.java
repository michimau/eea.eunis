package ro.finsiel.eunis.search.species.speciesByReferences;


import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.SortListString;

import java.util.List;
import java.util.Vector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.DriverManager;


/**
 * Class used to retrieve data displayed in species-references-choice popup.
 * @author finsiel
 */
public class ReferencesForSpecies {
    private Integer relationOpAuthor = null;
    private String author = null;
    private Integer relationOpDate = null;
    private String date = null;
    private String date1 = null;
    private Integer relationOpEditor = null;
    private String editor = null;
    private Integer relationOpTitle = null;
    private String title = null;
    private Integer relationOpPublisher = null;
    private String publisher = null;
    private boolean showInvalidatedSpecies = false;
    String SQL_DRV = "";
    String SQL_URL = "";
    String SQL_USR = "";
    String SQL_PWD = "";
    private Vector results = new Vector();

    /**
     * Constructor (takes form data as input).
     * @param author Author
     * @param relationOpAuthor Relation operator for author
     * @param date Start date
     * @param date1 End date
     * @param relationOpDate Relation operator for date
     * @param title Title
     * @param relationOpTitle Relation operator for title
     * @param publisher Publisher
     * @param relationOpPublisher Relation operator for publisher
     * @param editor Editor
     * @param relationOpEditor Relation operator for editor
     * @param showInvalidatedSpecies Display / Hide invalidated species in results
     * @param SQL_DRV JDBC driver
     * @param SQL_URL JDBC url
     * @param SQL_USR JDBC username
     * @param SQL_PWD JDBC password
     */
    public ReferencesForSpecies(String author,
            Integer relationOpAuthor,
            String date,
            String date1,
            Integer relationOpDate,
            String title,
            Integer relationOpTitle,
            String publisher,
            Integer relationOpPublisher,
            String editor,
            Integer relationOpEditor,
            boolean showInvalidatedSpecies,
            String SQL_DRV,
            String SQL_URL,
            String SQL_USR,
            String SQL_PWD) {

        this.relationOpAuthor = relationOpAuthor;
        this.author = author;
        this.relationOpDate = relationOpDate;
        this.date = date;
        this.date1 = date1;
        this.relationOpEditor = relationOpEditor;
        this.editor = editor;
        this.relationOpTitle = relationOpTitle;
        this.title = title;
        this.relationOpPublisher = relationOpPublisher;
        this.publisher = publisher;
        this.showInvalidatedSpecies = showInvalidatedSpecies;
        this.SQL_DRV = SQL_DRV;
        this.SQL_PWD = SQL_PWD;
        this.SQL_URL = SQL_URL;
        this.SQL_USR = SQL_USR;
    }

    /**
     * Initialize the list of references.
     * @param fromWhere What information to retrieve: author, title, publisher etc.
     * @param useLimit Limit the list of output results
     */
    public void setReferencesList(String fromWhere, boolean useLimit) {

        StringBuffer sql = new StringBuffer();
        // if sql where condition contains another conditions, will be put 'and' before the new condition witch will be
        // attached to the sql where condition
        Vector put_and = new Vector();

        // Normal search
        if (null != author && null != relationOpAuthor) {
            if (!author.trim().equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("D.SOURCE", author, relationOpAuthor));
            }
        }

        if (
                (
                (null != date && !date.trim().equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
                || (null != date1 && !date1.trim().equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
                )
                        && null != relationOpDate
                        ) {

            if (put_and.contains("true")) {
                sql.append(" AND ");
            } else {
                put_and.addElement("true");
            }

            if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
                if (date == null || (date != null && date.trim().equalsIgnoreCase(""))) {
                    sql.append(" E.CREATED <=" + date1 + " ");
                }
                if (date1 == null || (date1 != null && date1.trim().equalsIgnoreCase(""))) {
                    sql.append(" E.CREATED >=" + date + " ");
                }
                if (date != null && date1 != null && !date.trim().equalsIgnoreCase("") && !date1.trim().equalsIgnoreCase("")) {
                    sql.append(" E.CREATED >=" + date + " AND E.CREATED<=" + date1 + " ");
                }
            } else {
                sql.append(Utilities.prepareSQLOperator("E.CREATED", date, relationOpDate));
            }
        }

        if (null != title && null != relationOpTitle) {
            if (!title.trim().equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("F.TITLE", title, relationOpTitle));
            }
        }

        if (null != editor && null != relationOpEditor) {
            if (!editor.trim().equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("D.EDITOR", editor, relationOpEditor));
            }
        }

        if (null != publisher && null != relationOpPublisher) {
            if (!publisher.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("G.PUBLISHER", publisher, relationOpPublisher));
            }
        }

        Vector resultList = returnReferences(sql.toString(), fromWhere);

        if (useLimit) {
            if (resultList.size() > 0) {
                if (Utilities.MAX_POPUP_RESULTS < resultList.size()) {
                    for (int i = 0; i < resultList.size(); i++) {
                        results.addElement(resultList.get(i));
                    }
                } else {
                    results = resultList;
                }
            }
        } else {
            results = resultList;
        }

        SortListString sorter = new SortListString();

        results = sorter.sort(results, false);
    }

    /**
     * Retrieve the list of references.
     * @return List of results
     */
    public List getReferencesList() {
        return results;
    }

    private Vector returnReferences(String sql, String fromWhere) {
        Vector results = new Vector();
        boolean[] objectIsNotNull = { false, false, false, false, false};
        String SQL = "";
        String SQL_REFERENCES = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            if (fromWhere.equalsIgnoreCase("author")) {
                SQL_REFERENCES = "SELECT DISTINCT D.SOURCE ";
            }
            if (fromWhere.equalsIgnoreCase("date")) {
                SQL_REFERENCES = "SELECT DISTINCT E.CREATED ";
            }
            if (fromWhere.equalsIgnoreCase("title")) {
                SQL_REFERENCES = "SELECT DISTINCT F.TITLE ";
            }
            if (fromWhere.equalsIgnoreCase("editor")) {
                SQL_REFERENCES = "SELECT DISTINCT D.EDITOR ";
            }
            if (fromWhere.equalsIgnoreCase("publisher")) {
                SQL_REFERENCES = "SELECT DISTINCT G.PUBLISHER ";
            }

            SQL_REFERENCES += "FROM DC_INDEX A ";

            // on put join with DC_SOURCE for example because in where condition will have condition by source or editor
            // (fields from this table)

            if (null != author && null != relationOpAuthor) {
                if (!author.equalsIgnoreCase("")) {
                    SQL_REFERENCES += "INNER JOIN DC_SOURCE D ON A.ID_DC = D.ID_DC ";
                    objectIsNotNull[0] = true;
                }
            }

            if (
                    (
                    (null != date && !date.equalsIgnoreCase(""))
                    || (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
                    )
                            && null != relationOpDate
                            ) {
                SQL_REFERENCES += "INNER JOIN DC_DATE E ON A.ID_DC = E.ID_DC ";
                objectIsNotNull[1] = true;
            }

            if (null != editor && null != relationOpEditor) {
                if (!editor.equalsIgnoreCase("") && !objectIsNotNull[0]) {
                    SQL_REFERENCES += "INNER JOIN DC_SOURCE D ON A.ID_DC = D.ID_DC ";
                    objectIsNotNull[2] = true;
                }
            }

            if (null != title && null != relationOpTitle) {
                if (!title.equalsIgnoreCase("")) {
                    SQL_REFERENCES += "INNER JOIN DC_TITLE F ON A.ID_DC = F.ID_DC ";
                    objectIsNotNull[3] = true;
                }
            }

            if (null != publisher && null != relationOpPublisher) {
                if (!publisher.equalsIgnoreCase("")) {
                    SQL_REFERENCES += "INNER JOIN DC_PUBLISHER G ON A.ID_DC = G.ID_DC ";
                    objectIsNotNull[4] = true;
                }
            }

            // on put join with DC_EDITOR for example because editor field will be appear in select line
            if (fromWhere.equalsIgnoreCase("author") && !objectIsNotNull[0] && !objectIsNotNull[2]) {
                SQL_REFERENCES += "INNER JOIN DC_SOURCE D ON A.ID_DC = D.ID_DC ";
            }
            if (fromWhere.equalsIgnoreCase("date") && !objectIsNotNull[1]) {

                SQL_REFERENCES += "INNER JOIN DC_DATE E ON A.ID_DC = E.ID_DC ";
            }
            if (fromWhere.equalsIgnoreCase("title") && !objectIsNotNull[3]) {
                SQL_REFERENCES += "INNER JOIN DC_TITLE F ON A.ID_DC = F.ID_DC ";
            }
            if (fromWhere.equalsIgnoreCase("editor") && !objectIsNotNull[0] && !objectIsNotNull[2]) {
                SQL_REFERENCES += "INNER JOIN DC_SOURCE D ON A.ID_DC = D.ID_DC ";
            }
            if (fromWhere.equalsIgnoreCase("publisher") && !objectIsNotNull[4]) {
                SQL_REFERENCES += "INNER JOIN DC_PUBLISHER G ON A.ID_DC = G.ID_DC ";
            }

            SQL = SQL_REFERENCES;

            SQL += "INNER JOIN CHM62EDT_NATURE_OBJECT B ON A.ID_DC=B.ID_DC "
                    + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT ";

            SQL += "WHERE 1=1 ";

            SQL += Utilities.showEUNISInvalidatedSpecies(" AND H.VALID_NAME", showInvalidatedSpecies);

            if (sql.length() > 0) {
                SQL += " AND ";
            }

            SQL += sql;

            SQL += "UNION ";

            SQL += SQL_REFERENCES;

            SQL += "INNER JOIN CHM62EDT_REPORTS B ON A.ID_DC=B.ID_DC "
                    + "INNER JOIN CHM62EDT_REPORT_TYPE K ON B.ID_REPORT_TYPE = K.ID_REPORT_TYPE "
                    + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT ";

            SQL += "WHERE 1=1 ";

            SQL += Utilities.showEUNISInvalidatedSpecies(" AND H.VALID_NAME", showInvalidatedSpecies);

            if (sql.length() > 0) {
                SQL += " AND ";
            }

            SQL += sql;

            SQL += " AND K.LOOKUP_TYPE IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS',"
                    + "'SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND') ";

            SQL += " UNION ";

            SQL += SQL_REFERENCES;

            SQL += "INNER JOIN CHM62EDT_TAXONOMY B ON A.ID_DC=B.ID_DC "
                    + "INNER JOIN CHM62EDT_SPECIES H ON B.ID_TAXONOMY = H.ID_TAXONOMY ";

            SQL += "WHERE 1=1 ";

            SQL += Utilities.showEUNISInvalidatedSpecies(" AND H.VALID_NAME", showInvalidatedSpecies);

            if (sql.length() > 0) {
                SQL += " AND ";
            }

            SQL += sql;
            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery(SQL);
            while (rs.next()) {
                if (!fromWhere.equalsIgnoreCase("date")) {
                    if (rs.getString(1) != null) {
                        results.addElement(rs.getString(1));
                    }
                } else {
                    if (rs.getString(1) != null && rs.getLong(1) != 0) {
                        results.addElement(new Long(rs.getLong(1)).toString());
                    }
                }
            }
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }
}
