package ro.finsiel.eunis.dataimport.parsers;


import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import ro.finsiel.eunis.utilities.SQLUtilities;


/**
 *
 */
public class ReferencesImportParser extends DefaultHandler {

    private InputStream inputStream;

    private PreparedStatement preparedStatementDcIndexInsert;
    private PreparedStatement preparedStatementDcDateInsert;
    private PreparedStatement preparedStatementDcTitleInsert;
    private PreparedStatement preparedStatementDcPublisherInsert;
    private PreparedStatement preparedStatementDcSourceInsert;

    private PreparedStatement preparedStatementDcDateUpdate;
    private PreparedStatement preparedStatementDcTitleUpdate;
    private PreparedStatement preparedStatementDcPublisherUpdate;
    private PreparedStatement preparedStatementDcSourceUpdate;

    private int counter = 0;

    private String refcd;
    private String author;
    private String date;
    private String title;
    private String abrevTitle;
    private String editor;
    private String journTitle;
    private String bookTitle;
    private String journIssue;
    private String publisher;
    private String isbn;
    private String url;
    private String legalInstCd;

    private Connection con;

    private StringBuffer buf;
    private SQLUtilities sqlUtilities;
    private int maxDcId;
    private HashMap<String, Integer> dcIds;

    private ArrayList<String> xmlRefcds = new ArrayList<String>();

    public ReferencesImportParser(SQLUtilities sqlUtilities) {
        this.sqlUtilities = sqlUtilities;
        this.con = sqlUtilities.getConnection();
        buf = new StringBuffer();
    }

    private void parseDocument() throws SAXException {

        // get a factory
        SAXParserFactory spf = SAXParserFactory.newInstance();

        try {
            // get a new instance of parser
            SAXParser sp = spf.newSAXParser();

            // parse the file and also register this class for call backs
            sp.parse(inputStream, this);

        } catch (SAXException se) {
            se.printStackTrace();
            throw new RuntimeException(se.getMessage(), se);
        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
            throw new RuntimeException(pce.getMessage(), pce);
        } catch (IOException ie) {
            ie.printStackTrace();
            throw new RuntimeException(ie.getMessage(), ie);
        }
    }

    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        buf = new StringBuffer();
    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        buf.append(ch, start, length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        try {
            if (qName.equalsIgnoreCase("Refcd")) {
                refcd = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Author")) {
                author = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Date")) {
                date = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Title")) {
                title = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Abrev_Title")) {
                abrevTitle = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Editor")) {
                editor = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Journtitle")) {
                journTitle = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Booktitle")) {
                bookTitle = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Journissue")) {
                journIssue = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("Publisher")) {
                publisher = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("ISBN")) {
                isbn = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("URL")) {
                url = buf.toString().trim();
            }
            if (qName.equalsIgnoreCase("legal_inst_cd")) {
                legalInstCd = buf.toString().trim();
            }

            if (qName.equalsIgnoreCase("REFERENCES")) {

                Integer dcId = null;

                if (refcd != null && refcd.length() > 0) {
                    dcId = dcIds.get(refcd);
                    xmlRefcds.add(refcd);
                }

                if (dcId == null) {

                    maxDcId++;
                    preparedStatementDcIndexInsert.setInt(1, maxDcId);
                    preparedStatementDcIndexInsert.setString(2, legalInstCd);
                    preparedStatementDcIndexInsert.setString(3, refcd);
                    preparedStatementDcIndexInsert.addBatch();

                    String created = formatYear(date);

                    preparedStatementDcDateInsert.setInt(1, maxDcId);
                    preparedStatementDcDateInsert.setString(2, created);
                    preparedStatementDcDateInsert.addBatch();

                    preparedStatementDcTitleInsert.setInt(1, maxDcId);
                    preparedStatementDcTitleInsert.setString(2, title);
                    preparedStatementDcTitleInsert.setString(3, abrevTitle);
                    preparedStatementDcTitleInsert.addBatch();

                    preparedStatementDcPublisherInsert.setInt(1, maxDcId);
                    preparedStatementDcPublisherInsert.setString(2, publisher);
                    preparedStatementDcPublisherInsert.addBatch();

                    preparedStatementDcSourceInsert.setInt(1, maxDcId);
                    preparedStatementDcSourceInsert.setString(2, author);
                    preparedStatementDcSourceInsert.setString(3, editor);
                    preparedStatementDcSourceInsert.setString(4, journTitle);
                    preparedStatementDcSourceInsert.setString(5, bookTitle);
                    preparedStatementDcSourceInsert.setString(6, journIssue);
                    preparedStatementDcSourceInsert.setString(7, isbn);
                    preparedStatementDcSourceInsert.setString(8, url);
                    preparedStatementDcSourceInsert.addBatch();

                } else {

                    String created = formatYear(date);

                    preparedStatementDcDateUpdate.setString(1, created);
                    preparedStatementDcDateUpdate.setInt(2, dcId.intValue());
                    preparedStatementDcDateUpdate.addBatch();

                    preparedStatementDcTitleUpdate.setString(1, title);
                    preparedStatementDcTitleUpdate.setString(2, abrevTitle);
                    preparedStatementDcTitleUpdate.setInt(3, dcId.intValue());
                    preparedStatementDcTitleUpdate.addBatch();

                    preparedStatementDcPublisherUpdate.setString(1, publisher);
                    preparedStatementDcPublisherUpdate.setInt(2, dcId.intValue());
                    preparedStatementDcPublisherUpdate.addBatch();

                    preparedStatementDcSourceUpdate.setString(1, author);
                    preparedStatementDcSourceUpdate.setString(2, editor);
                    preparedStatementDcSourceUpdate.setString(3, journTitle);
                    preparedStatementDcSourceUpdate.setString(4, bookTitle);
                    preparedStatementDcSourceUpdate.setString(5, journIssue);
                    preparedStatementDcSourceUpdate.setString(6, isbn);
                    preparedStatementDcSourceUpdate.setString(7, url);
                    preparedStatementDcSourceUpdate.setInt(8, dcId.intValue());
                    preparedStatementDcSourceUpdate.addBatch();

                }

                counter++;
                if (counter % 10000 == 0) {
                    preparedStatementDcIndexInsert.executeBatch();
                    preparedStatementDcIndexInsert.clearParameters();

                    preparedStatementDcDateInsert.executeBatch();
                    preparedStatementDcDateInsert.clearParameters();

                    preparedStatementDcTitleInsert.executeBatch();
                    preparedStatementDcTitleInsert.clearParameters();

                    preparedStatementDcPublisherInsert.executeBatch();
                    preparedStatementDcPublisherInsert.clearParameters();

                    preparedStatementDcSourceInsert.executeBatch();
                    preparedStatementDcSourceInsert.clearParameters();

                    preparedStatementDcDateUpdate.executeBatch();
                    preparedStatementDcDateUpdate.clearParameters();

                    preparedStatementDcTitleUpdate.executeBatch();
                    preparedStatementDcTitleUpdate.clearParameters();

                    preparedStatementDcPublisherUpdate.executeBatch();
                    preparedStatementDcPublisherUpdate.clearParameters();

                    preparedStatementDcSourceUpdate.executeBatch();
                    preparedStatementDcSourceUpdate.clearParameters();

                    System.gc();
                }

                refcd = null;
                author = null;
                date = null;
                title = null;
                abrevTitle = null;
                editor = null;
                journTitle = null;
                bookTitle = null;
                journIssue = null;
                publisher = null;
                isbn = null;
                url = null;
                legalInstCd = null;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e.toString(), e);
        }
    }

    public void execute(InputStream inputStream) throws Exception {

        this.inputStream = inputStream;

        try {

            dcIds = getDCIds();
            // deleteOldRecords();
            maxDcId = getMaxId("SELECT MAX(ID_DC) FROM DC_INDEX");

            // Insert statements
            String query = "INSERT INTO DC_INDEX (ID_DC, REFERENCE, COMMENT, REFCD) VALUES (?,?,'REFERENCES',?)";

            this.preparedStatementDcIndexInsert = con.prepareStatement(query);

            String queryDcDate = "INSERT INTO DC_DATE (ID_DC, ID_DATE, CREATED) VALUES (?,1,?)";

            this.preparedStatementDcDateInsert = con.prepareStatement(queryDcDate);

            String queryDcTitle = "INSERT INTO DC_TITLE (ID_DC, ID_TITLE, TITLE, ALTERNATIVE) VALUES (?,1,?,?)";

            this.preparedStatementDcTitleInsert = con.prepareStatement(queryDcTitle);

            String queryDcPublisher = "INSERT INTO DC_PUBLISHER (ID_DC, ID_PUBLISHER, PUBLISHER) VALUES (?,1,?)";

            this.preparedStatementDcPublisherInsert = con.prepareStatement(queryDcPublisher);

            String queryDcSource = "INSERT INTO DC_SOURCE (ID_DC, ID_SOURCE, SOURCE, EDITOR, JOURNAL_TITLE, BOOK_TITLE, JOURNAL_ISSUE, ISBN, URL) VALUES (?,1,?,?,?,?,?,?,?)";

            this.preparedStatementDcSourceInsert = con.prepareStatement(queryDcSource);

            // Update statements
            String queryDcDateUpdate = "UPDATE DC_DATE SET CREATED =? WHERE ID_DC = ?";

            this.preparedStatementDcDateUpdate = con.prepareStatement(queryDcDateUpdate);

            String queryDcTitleUpdate = "UPDATE DC_TITLE SET TITLE = ?, ALTERNATIVE = ? WHERE ID_DC = ?";

            this.preparedStatementDcTitleUpdate = con.prepareStatement(queryDcTitleUpdate);

            String queryDcPublisherUpdate = "UPDATE DC_PUBLISHER SET PUBLISHER = ? WHERE ID_DC = ?";

            this.preparedStatementDcPublisherUpdate = con.prepareStatement(queryDcPublisherUpdate);

            String queryDcSourceUpdate = "UPDATE DC_SOURCE SET SOURCE = ?, EDITOR = ?, JOURNAL_TITLE = ?, BOOK_TITLE = ?, JOURNAL_ISSUE = ?, ISBN = ?, URL = ? WHERE ID_DC = ?";

            this.preparedStatementDcSourceUpdate = con.prepareStatement(queryDcSourceUpdate);

            // con.setAutoCommit(false);
            parseDocument();
            if (!(counter % 10000 == 0)) {
                preparedStatementDcIndexInsert.executeBatch();
                preparedStatementDcIndexInsert.clearParameters();

                preparedStatementDcDateInsert.executeBatch();
                preparedStatementDcDateInsert.clearParameters();

                preparedStatementDcTitleInsert.executeBatch();
                preparedStatementDcTitleInsert.clearParameters();

                preparedStatementDcPublisherInsert.executeBatch();
                preparedStatementDcPublisherInsert.clearParameters();

                preparedStatementDcSourceInsert.executeBatch();
                preparedStatementDcSourceInsert.clearParameters();

                preparedStatementDcDateUpdate.executeBatch();
                preparedStatementDcDateUpdate.clearParameters();

                preparedStatementDcTitleUpdate.executeBatch();
                preparedStatementDcTitleUpdate.clearParameters();

                preparedStatementDcPublisherUpdate.executeBatch();
                preparedStatementDcPublisherUpdate.clearParameters();

                preparedStatementDcSourceUpdate.executeBatch();
                preparedStatementDcSourceUpdate.clearParameters();

                System.gc();
            }
            deleteRedundantRecords();
            // con.commit();
        } catch (Exception e) {
            // con.rollback();
            // con.commit();
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (preparedStatementDcIndexInsert != null) {
                preparedStatementDcIndexInsert.close();
            }

            if (preparedStatementDcDateInsert != null) {
                preparedStatementDcDateInsert.close();
            }

            if (preparedStatementDcTitleInsert != null) {
                preparedStatementDcTitleInsert.close();
            }

            if (preparedStatementDcPublisherInsert != null) {
                preparedStatementDcPublisherInsert.close();
            }

            if (preparedStatementDcSourceInsert != null) {
                preparedStatementDcSourceInsert.close();
            }

            if (preparedStatementDcDateUpdate != null) {
                preparedStatementDcDateUpdate.close();
            }

            if (preparedStatementDcTitleUpdate != null) {
                preparedStatementDcTitleUpdate.close();
            }

            if (preparedStatementDcPublisherUpdate != null) {
                preparedStatementDcPublisherUpdate.close();
            }

            if (preparedStatementDcSourceUpdate != null) {
                preparedStatementDcSourceUpdate.close();
            }

            if (con != null) {
                con.close();
            }
        }

    }

    private void deleteRedundantRecords() throws Exception {
        PreparedStatement ps = null;

        try {
            for (Iterator<String> it = dcIds.keySet().iterator(); it.hasNext();) {
                String refCd = it.next();
                Integer dcId = dcIds.get(refCd);

                if (!xmlRefcds.contains(refCd)) {
                    int idDc = dcId.intValue();

                    String sql = "DELETE FROM DC_DATE WHERE ID_DC = ?";

                    ps = con.prepareStatement(sql);
                    ps.setInt(1, idDc);
                    ps.executeUpdate();

                    sql = "DELETE FROM DC_TITLE WHERE ID_DC = ?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, idDc);
                    ps.executeUpdate();

                    sql = "DELETE FROM DC_PUBLISHER WHERE ID_DC = ?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, idDc);
                    ps.executeUpdate();

                    sql = "DELETE FROM DC_SOURCE WHERE ID_DC = ?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, idDc);
                    ps.executeUpdate();

                    ps = con.prepareStatement("DELETE FROM DC_INDEX WHERE ID_DC = ?");
                    ps.setInt(1, idDc);
                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
        }
    }

    private int getMaxId(String query) throws ParseException {
        String maxId = sqlUtilities.ExecuteSQL(query);
        int maxIdInt = 0;

        if (maxId != null && maxId.length() > 0) {
            maxIdInt = new Integer(maxId).intValue();
        }

        return maxIdInt;
    }

    private HashMap<String, Integer> getDCIds() throws Exception {
        HashMap<String, Integer> ret = new HashMap<String, Integer>();

        PreparedStatement stmt = null;
        ResultSet rset = null;

        try {
            String query = "SELECT ID_DC, REFCD FROM DC_INDEX WHERE COMMENT = 'REFERENCES'";

            stmt = con.prepareStatement(query);
            rset = stmt.executeQuery();
            while (rset.next()) {
                int dcId = rset.getInt("ID_DC");
                String refCd = rset.getString("REFCD");

                ret.put(refCd, new Integer(dcId));
            }

        } catch (Exception e) {
            throw new IllegalArgumentException(e.getMessage(), e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (rset != null) {
                rset.close();
            }
        }
        return ret;
    }

    private String formatYear(String input) {
        String ret = null;

        if (input == null || input.length() != 4) {
            return null;
        }

        try {
            int x = Integer.parseInt(input);

            ret = new Integer(x).toString();
        } catch (NumberFormatException nFE) {
            return null;
        }
        return ret;
    }
}
