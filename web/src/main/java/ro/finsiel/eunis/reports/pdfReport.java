/*
 * pdfReport.java
 *
 * Created on August 22, 2002, 12:48 PM
 */

package ro.finsiel.eunis.reports;


import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;

import java.awt.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.Serializable;
import java.util.Vector;


/**
 * pdf report, low level report writer.
 */
public class pdfReport implements Serializable {
    private Paragraph HEADER;
    private Paragraph FOOTER;
    private String PATH = "webapps/eunis/temp/";
    private Document document;
    private PdfWriter writer;

    /**
     * Creates a new instance of pdfReport.
     */
    public pdfReport() {}

    /**
     * Initialization.
     * @param filename Filename to write report to.
     */
    public void init(String filename) {

        File pdfFile = new File(filename);

        try {
            document = new Document(PageSize.A4, 40, 5, 10, 15); // A4, Portrait
            // create writer
            writer = PdfWriter.getInstance(document,
                    new FileOutputStream(pdfFile));
            document.addAuthor("EUNIS database application");
            document.addSubject("Europen Nature Information System Report");
            HeaderFooter header = new HeaderFooter(HEADER, false);

            header.setBorder(Rectangle.NO_BORDER);
            HeaderFooter footer = new HeaderFooter(FOOTER, false);

            document.setHeader(header);
            document.setFooter(footer);
            document.open();
        } catch (Exception de) {
            System.err.println(de.getMessage());
        }
    }

    /**
     * Build an pdf table.
     * @param columns no of columns
     * @param headers header names
     * @return table object
     */
    public Table buildTable(int columns, Vector headers) {
        // headers[0] - table title
        // headers[1]...headers[columns+1] - Column titles
        Table table = null;

        try {
            table = new Table(columns);
            table.setBorderWidth(1);
            table.setDefaultCellBorderWidth(1);
            table.setBorderColor(new Color(0, 0, 0));
            table.setCellpadding(2);
            table.setCellspacing(0);
            table.setCellsFitPage(true);

            // writing headers - table title first
            Cell cell = new Cell(
                    new Phrase((String) headers.get(0),
                    FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD)));

            cell.setHeader(true);
            cell.setColspan(columns);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setBackgroundColor(new Color(0xC0, 0xC0, 0xC0));
            table.addCell(cell);
            // writing column headers
            for (int i = 1; i < columns + 1; i++) {
                cell = new Cell(
                        new Phrase((String) headers.get(i),
                        FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD)));
                table.addCell(cell);
            }
            table.endHeaders(); // this will enable the table header to appear on next pages
            // finished writing table headers
        } catch (Exception ex) { // BadElementException DocumentException
            ex.printStackTrace();
        }
        return table;
    }

    /**
     * Fix table spanning multiple pages.
     * @param value Table
     * @return true if must rebuild last row
     */
    public boolean fixTable(Table value) {
        // this function fixes the white space that appears when a cell is forced
        // to fit the page
        try {
            if (!writer.fitsPage(value)) {
                value.deleteLastRow();
                document.add(value);
                document.newPage();
                return true; // must re-build last row
            } else {
                return false;
            }
        } catch (DocumentException de) {
            System.err.println(de.getMessage());
            return false;
        }
    }

    /**
     * Write text.
     * @param value Text
     */
    public void writeln(String value) {
        try {
            document.add(new Paragraph(value));
        } catch (DocumentException de) {
            System.err.println(de.getMessage());
        }
    }

    /**
     * Write text and add new line.
     * @param value Text
     * @param font Font
     */
    public void writeln(String value, Font font) {
        try {
            document.add(new Paragraph(value, font));
        } catch (DocumentException de) {
            System.err.println(de.getMessage());
        }
    }

    /**
     * Add image to report.
     * @param value image
     */
    public void addImage(Image value) {
        try {
            document.add(value);
        } catch (DocumentException de) {
            System.err.println(de.getMessage());
        }
    }

    /**
     * Add table to report.
     * @param value table
     */
    public void addTable(Table value) {
        try {
            document.add(value);
        } catch (DocumentException de) {
            System.err.println(de.getMessage());
        }
    }

    /**
     * Add header.
     * @param value header
     */
    public void setHeader(Paragraph value) {
        HEADER = value;
    }

    /**
     * Add footer.
     * @param value footer
     */
    public void setFooter(Paragraph value) {
        FOOTER = value;
    }

    /**
     * Set output path.
     * @param value absolute path
     */
    public void setPath(String value) {
        PATH = value;
    }

    /**
     * Get path.
     * @return absolute path
     */
    public String getPath() {
        return PATH;
    }

    /**
     * Close report document.
     */
    public void close() {
        document.close();
    }

    /**
     * Access internal document object.
     * @return Document layer
     */
    public Document getDocument() {
        return document;
    }
}
