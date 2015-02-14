/**
 *
 */
package eionet.eunis.rdf;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.util.Properties;
import java.util.ResourceBundle;

import eionet.rdfexport.RDFExportService;
import eionet.rdfexport.RDFExportServiceImpl;
import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * @author Risto Alt
 *
 */
public class RdfExporter {

    /**
     * main method.
     *
     * @param args - Command line arguments
     */
    public static void main(String... args) {
        if (args.length == 0) {
            System.out.println("Missing argument what to import!");
            System.out.println("Usage: rdfExporter [table] [identifier]");
        } else {
            String table = null;
            String identifier = null;

            int i = 0;
            for (String arg : args) {
                if (i == 0) {
                    table = arg;
                } else if (i == 1) {
                    identifier = arg;
                }
                i++;
            }

            Connection con = null;
            FileOutputStream fos = null;
            try {
                ResourceBundle props = ResourceBundle.getBundle("rdfexport");
                String dir = props.getString("files.dest.dir");

                File file = new File(dir, table + ".rdf");
                fos = new FileOutputStream(file);

                con = ro.finsiel.eunis.utilities.TheOneConnectionPool.getConnection();
                Properties properties = new Properties();
                properties.load(RdfExporter.class.getClassLoader().getResourceAsStream("rdfexport.properties"));
                RDFExportService rdfExportService = new RDFExportServiceImpl(fos, con, properties);
                rdfExportService.exportTable(table, identifier);

                con.close();
                fos.close();

                System.out.println("Successfully exported to: " + dir + "/" + table + ".rdf");
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                SQLUtilities.closeAll(con, null, null);
                if(fos!=null){
                    try {
                        fos.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
