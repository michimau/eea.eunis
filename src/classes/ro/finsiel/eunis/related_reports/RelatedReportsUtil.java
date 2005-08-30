package ro.finsiel.eunis.related_reports;

import ro.finsiel.eunis.jrfTables.EunisRelatedReportsDomain;
import ro.finsiel.eunis.jrfTables.EunisRelatedReportsPersist;

import java.util.List;
import java.util.Vector;
import java.io.File;

/**
 * This class provides functionality used in related-reports*.jsp files.
 * @author finsiel
 */
public class RelatedReportsUtil {

  /**
   * List all the files reports from database.
   * @return List of files.
   */
  public static List listAllReports() {
    return listReports(null);
  }

  /**
   * List only the approved reports from database.
   * @return List of files.
   */
  public static List listApprovedReports() {
    return listReports("APPROVED=1");
  }

  /**
   * List only the pending reports from database which awaits to be approved.
   * @return List of EunisRelatedReportsPerist objects.
   */
  public static List listPendingReports() {
    return listReports("APPROVED=0");
  }

  /**
   * List reports recorded in database, based on the SQL WHERE condition.
   * @param str Where condition for SQL (i.e. APPROVED=1 or APPROVED=0 etc). If str is <code>null</code>,
   * all records from table are returned.
   * @return A list of EunisRelatedReportsPersist objects for documents uploaded on the server.
   */
  public static List listReports(String str) {
    List results = new Vector();
    try {
      if (null != str) {
        results = new EunisRelatedReportsDomain().findWhere(str);
      } else {
        results = new EunisRelatedReportsDomain().findAll();
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return results;
  }

  /**
   * This method deletes uploaded files from server. Files are deleted physically from disk and from database also.
   * @param filenames List of String objects with name of the files.
   * @param uploadDir The directory from the server where files are stored (ex. $TOMCAT_HOME + ${UPLOAD_DIR_FILES}).
   */
  public static void deleteFiles(String[] filenames, String uploadDir) {
    for (int i = 0; i < filenames.length; i++) {
      File file = new File(filenames[i]);
      try {
        // Try to remove it first from database
        List files = new EunisRelatedReportsDomain().findWhere("FILE_NAME='" + filenames[i] + "'");
        if (files.size() > 0) {
          EunisRelatedReportsPersist rowObject = (EunisRelatedReportsPersist) files.get(0);
          file = new File(uploadDir + filenames[i]);
          new EunisRelatedReportsDomain().delete(rowObject);// Delete from database
          if (file.exists()) {
            // Remove the file physically from disk.
            file.delete();
          } else {
            System.out.println(RelatedReportsUtil.class.getName() + "::deleteFiles() - Warning: Trying to delete invalid file:" + file.getAbsolutePath());
          }
        } else {
          // File not found in database so we exit abnormally from this method.
          throw new Exception("RelatedReportsUtil::deleteFiles(...) : Unable to delete file.");
        }
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
  }

  /**
   * Approve a list of files.
   * @param filenames The list of files to be set approved on the database.
   */
  public static void approveFiles(String[] filenames) {
    for (int i = 0; i < filenames.length; i++) {
      try {
        // Try to find it in database
        List files = new EunisRelatedReportsDomain().findWhere("FILE_NAME='" + filenames[i] + "'");
        if (files.size() > 0) {
          EunisRelatedReportsPersist rowObject = (EunisRelatedReportsPersist) files.get(0);
          rowObject.setApproved(new Integer(1));
          new EunisRelatedReportsDomain().save(rowObject);// Save it back to database
        } else {
          // File not found in database so we exit abnormally from this method.
          throw new Exception();
        }
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
  }
}