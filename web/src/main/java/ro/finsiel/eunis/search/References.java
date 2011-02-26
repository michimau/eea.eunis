package ro.finsiel.eunis.search;


import java.util.Vector;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.DriverManager;


/**
 * Data factory for main references search popup helper (header).
 * @author finsiel
 */
public class References {
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

    private String SQL_DRV = "";
    private String SQL_URL = "";
    private String SQL_USR = "";
    private String SQL_PWD = "";

    private Vector results = new Vector();

    /**
     * Creates a new References object.
     * @param author Author
     * @param relationOpAuthor Relation operator for author.
     * @param date Date [min]
     * @param date1 Date max.
     * @param relationOpDate Relation operator for date.
     * @param title Title.
     * @param relationOpTitle Relation operator for title.
     * @param publisher Publisher.
     * @param relationOpPublisher Relation operator for publisher.
     * @param editor Editor.
     * @param relationOpEditor Relation operator for editor.
     * @param SQL_DRV JDBC driver.
     * @param SQL_URL JDBC url.
     * @param SQL_USR JDBC user.
     * @param SQL_PWD JDBC password.
     */
    public References(String author,
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
        this.SQL_DRV = SQL_DRV;
        this.SQL_PWD = SQL_PWD;
        this.SQL_URL = SQL_URL;
        this.SQL_USR = SQL_USR;
    }

    /**
     * Setter for referenced data.
     * @param fromWhere Where we come from (author, title, year etc.).
     * @param useLimit Limit the results output.
     */
    public void setReferencesList(String fromWhere, boolean useLimit) {

        StringBuffer sql = new StringBuffer();
        // if sql where condition contains another conditions, will be put 'and' before the new condition witch will be
        // attached to the sql where condition
        Vector put_and = new Vector();

        // Normal search
        if (null != author && null != relationOpAuthor) {
            if (!author.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("SOURCE", author, relationOpAuthor));
            }
        }

        if (
                (
                (null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
                || (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
                )
                        && null != relationOpDate
                        ) {

            if (put_and.contains("true")) {
                sql.append(" AND ");
            } else {
                put_and.addElement("true");
            }

            if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
                if (date == null || (date != null && date.equalsIgnoreCase(""))) {
                    sql.append(" CREATED <=" + date1 + " ");
                }
                if (date1 == null || (date1 != null && date1.equalsIgnoreCase(""))) {
                    sql.append(" CREATED >=" + date + " ");
                }
                if (date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase("")) {
                    sql.append(" CREATED >=" + date + " AND CREATED<=" + date1 + " ");
                }
            } else {
                sql.append(Utilities.prepareSQLOperator("CREATED", date, relationOpDate));
            }
        }

        if (null != title && null != relationOpTitle) {
            if (!title.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("TITLE", title, relationOpTitle));
            }
        }

        if (null != editor && null != relationOpEditor) {
            if (!editor.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("EDITOR", editor, relationOpEditor));
            }
        }

        if (null != publisher && null != relationOpPublisher) {
            if (!publisher.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareSQLOperator("PUBLISHER", publisher, relationOpPublisher));
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

        ro.finsiel.eunis.search.SortListString sorter = new ro.finsiel.eunis.search.SortListString();

        results = sorter.sort(results, false);
    }

    /**
     * Retrieve references list.
     * @return Results to be displayed.
     */
    public List getReferencesList() {
        return results;
    }

    private Vector returnReferences(String sql, String fromWhere) {
        Vector results = new Vector();
        String SQL_REFERENCES;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            SQL_REFERENCES = "SELECT DISTINCT ";

            if (fromWhere.equalsIgnoreCase("author")) {
                SQL_REFERENCES += " `DC_SOURCE`.`SOURCE`";
            }
            if (fromWhere.equalsIgnoreCase("date")) {
                SQL_REFERENCES += " CONCAT(`DC_DATE`.`CREATED`)";
            }
            if (fromWhere.equalsIgnoreCase("title")) {
                SQL_REFERENCES += " `DC_TITLE`.`TITLE`";
            }
            if (fromWhere.equalsIgnoreCase("editor")) {
                SQL_REFERENCES += " `DC_SOURCE`.`EDITOR`";
            }
            if (fromWhere.equalsIgnoreCase("publisher")) {
                SQL_REFERENCES += " `DC_PUBLISHER`.`PUBLISHER`";
            }

            SQL_REFERENCES += " FROM  `DC_INDEX`";
            SQL_REFERENCES += " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
            SQL_REFERENCES += " INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
            SQL_REFERENCES += " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
            SQL_REFERENCES += " INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
            // !!added to get only references with species and habitats
            SQL_REFERENCES += " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`DC_INDEX`.`ID_DC` = `CHM62EDT_NATURE_OBJECT`.`ID_DC`)";
            SQL_REFERENCES += " WHERE `DC_INDEX`.`COMMENT` = 'REFERENCES'";
            SQL_REFERENCES += " AND `DC_DATE`.`CREATED` > 1000";

            if (sql.length() > 0) {
                SQL_REFERENCES += " AND " + sql;
            }

            // System.out.println( "SQL_REFERENCES = " + SQL_REFERENCES );
            ps = con.prepareStatement(SQL_REFERENCES);
            rs = ps.executeQuery(SQL_REFERENCES);

            while (rs.next()) {
                if (rs.getString(1) != null) {
                    results.addElement(rs.getString(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (Exception ex) {}
            }
            ;
            if (rs != null) {
                try {
                    ps.close();
                } catch (Exception ex) {}
            }
            ;
            if (rs != null) {
                try {
                    con.close();
                } catch (Exception ex) {}
            }
            ;
        }

        return results;
    }
}
