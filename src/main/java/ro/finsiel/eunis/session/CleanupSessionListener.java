package ro.finsiel.eunis.session;

import ro.finsiel.eunis.Settings;
import ro.finsiel.eunis.search.Utilities;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionListener;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Date;

/**
 * This class is used to clean up the files created in temporary directoy,
 * during a session's life. These files are the PDF, CSV reports
 * @author  finsiel
 */
public class CleanupSessionListener implements HttpSessionListener {
  /** Creates a new instance of CleanupSessionListener. */
  public CleanupSessionListener() {}

  /**
   * Method called by the container when the session is created.
   * @param httpSessionEvent Event with information about the session
   */
  public void sessionCreated(javax.servlet.http.HttpSessionEvent httpSessionEvent) {}

  /**
   * Method called by container when the session is expired. It contains the cleanup procedure
   * for the session's temporary files.
   * @param httpSessionEvent Event with information about the session
   */
  public void sessionDestroyed(javax.servlet.http.HttpSessionEvent httpSessionEvent)
  {
    HttpSession session = httpSessionEvent.getSession();
    String TEMP_PATH = session.getServletContext().getInitParameter( "INSTANCE_HOME" );
    TEMP_PATH += Settings.getSetting("TEMP_DIR");
    String sessionID = session.getId();

    File tempDir = new File(TEMP_PATH);
    File[] files = tempDir.listFiles();
    if (null != files)
    {
      // Test each file from array if contains the session id in its name
      // and delete it does and if it's not an directory
      for (int i = 0; i < files.length; i++)
      {
        File aFile = files[i];
        if ((aFile.getName().lastIndexOf(sessionID) >= 0) && aFile.isFile())
        {
          aFile.delete();
        }
      }
    }
    tempDir = new File(TEMP_PATH + "/no-cache/");
    files = tempDir.listFiles();
    if (null != files)
    {
      // Test each file from array if contains the session id in its name
      // and delete it does and if it's not an directory
      for (int i = 0; i < files.length; i++)
      {
        File aFile = files[i];
        if ((aFile.getName().lastIndexOf(sessionID) >= 0) && aFile.isFile())
        {
          aFile.delete();
        }
      }
    }

    // Clear the tables used for advanced and combined search...
    //System.out.println("Clearing temporary tables...");

    String sqlDrv = session.getServletContext().getInitParameter( "JDBC_DRV" );
    String sqlUrl = session.getServletContext().getInitParameter( "JDBC_URL" );
    String sqlUsr = session.getServletContext().getInitParameter( "JDBC_USR" );
    String sqlPwd = session.getServletContext().getInitParameter( "JDBC_PWD" );
    if (!sqlDrv.equalsIgnoreCase("") && !sqlUrl.equalsIgnoreCase("") && !sqlUrl.equalsIgnoreCase("") &&
            !sqlUsr.equalsIgnoreCase(""))
    {
      Utilities.ClearSessionData(httpSessionEvent.getSession().getId(), sqlDrv, sqlUrl, sqlUsr, sqlPwd);
    }
    else
    {
      System.out.println("CleanupSessionListener::sessionDestroyed(...) - Warning: database connection info incorrect. Temp tables not cleaned.");
    }

    // log the session expiration within database
    // log the login process to database
    String JDBC_DRV = session.getServletContext().getInitParameter( "JDBC_DRV" );
    String JDBC_URL = session.getServletContext().getInitParameter( "JDBC_URL" );
    String JDBC_USR = session.getServletContext().getInitParameter( "JDBC_USR" );
    String JDBC_PWD = session.getServletContext().getInitParameter( "JDBC_PWD" );
    long longTime = new Date().getTime();
    Connection conn = null;
    try
    {
      Class.forName(JDBC_DRV);
      conn = DriverManager.getConnection(JDBC_URL, JDBC_USR, JDBC_PWD);
      //System.out.println("Updating EUNIS_SESSION_LOG table.");
      PreparedStatement ps = conn.prepareStatement("UPDATE EUNIS_SESSION_LOG SET START=START, END=? WHERE ID_SESSION=?");
      // Check MySQL manual (START=START because MySQL updates *only* first occurring timestamp *if* the value differs)
      ps.setTimestamp(1, new java.sql.Timestamp(longTime));
      ps.setString(2, sessionID);
      ps.executeUpdate();
      ps.close();
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    finally
    {
      if ( conn != null )
      {
        try
        {
          conn.close();
        }
        catch ( Exception e )
        {
        }
      }
    }
  }
}
