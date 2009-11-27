package ro.finsiel.eunis.reports;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;

import java.io.PrintWriter;
import java.io.OutputStreamWriter;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Properties;

/**
 * XML report writer.
 * <result>
 * <row>
 * <cell>col01</cell>
 * <cell>col02</cell>
 * </row>
 * <row>
 * <cell>col11</cell>
 * <cell>col12</cell>
 * </row>
 * </result>
 */
public class XMLReport {
  /**
   * Sets the number of results retrieved at one query, and write at once in PDF file.
   */
  protected static final int RESULTS_PER_PAGE = 1000;
  // TSV generator dependent fields
  /**
   * Directory where file will be written.
   */
  protected static String BASE_FILENAME = "webapps/eunis/temp/";
  /**
   * EOL - END OF LINE \r\n.
   */
  protected static final String EOL = "\r\n";
  /**
   * Basic I/O data stream constructed around the file object.
   */
  protected PrintWriter fileStream = null;
  /**
   * Path to the file.
   */
  protected String filename = null;

  private static final String TAG_ROW = "<row>";
  private static final String TAG_ROWEND = "</row>";
  private static final String TAG_CELL = "<cell>";
  private static final String TAG_CELLEND = "</cell>";
  private static final String STR_NULL = "null";

  /**
   * Data factory used to do the search.
   */
  protected AbstractPaginator dataFactory = null;

  /**
   * Constructor.
   * @param filename Name of XML file
   */
  public XMLReport( String filename ) {
    try
    {
      Properties p = ro.finsiel.eunis.OSEnvironment.getEnvVars();
      BASE_FILENAME = p.getProperty( "TOMCAT_HOME" ) + "/webapps/eunis/temp/";
      fileStream = new PrintWriter( new OutputStreamWriter( new FileOutputStream( BASE_FILENAME + filename ), "UTF-8" ) );
      fileStream.write( "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" );
      fileStream.write( "<results>" );
      this.filename = filename;
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  /**
   * Write an row within xml.
   * @param row row data
   */
  public void writeRow( List<String> row ) {
    try
    {
      if ( null == fileStream )
      {
        return;
      }
      if ( null == row )
      {
        return;
      }
      fileStream.write( TAG_ROW );
      for ( String _data : row )
      {
        String cell = TAG_CELL;
        if ( null != _data )
        {
          cell += Utilities.treatURLAmp( _data );
        }
        else
        {
          cell += STR_NULL;
        }
        cell += TAG_CELLEND;
        fileStream.write( cell );
        fileStream.write( EOL );
      }
      fileStream.write( TAG_ROWEND );
      fileStream.write( EOL );
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
  }

  /**
   * Close xml file.
   */
  public void closeFile() {
    if ( null != fileStream )
    {
      try
      {
        fileStream.write( "</results>" );
        fileStream.flush();
        fileStream.close();
      }
      catch ( Exception _ex )
      {
        System.err.println( "Exception while closing stream." );
        _ex.printStackTrace();
      }
    }
  }

  /**
   * Getter for filename property.
   * @return filename
   */
  public String getFilename() {
    return filename;
  }
}
