package ro.finsiel.eunis.reports;

import ro.finsiel.eunis.search.AbstractPaginator;

import java.io.*;
import java.util.List;
import java.util.Properties;

/**
 * This class creates a file which contains a TAB-separated table with values.
 * @author finsiel
 * @version 1.0
 */
public abstract class AbstractTSVReport implements Serializable {
  /** Sets the number of results retrieved at one query, and write at once in PDF file. */
  protected static final int RESULTS_PER_PAGE = 1000;
  // TSV generator dependent fields
  /** Directory where file will be written. */
  protected static String BASE_FILENAME = "webapps/eunis/temp/";
  /** EOL - END OF LINE \r\n .*/
  protected static final String EOL = "\r\n";
  /** TAB - Separator for two rows of the table. */
  protected static final String TAB = "\t";
  /** Basic I/O data stream constructed around the file object. */
  protected PrintWriter fileStream = null;
  /** Path to the file. */
  protected String filename = null;

  /**
   * Data factory used to do the search.
   */
  protected AbstractPaginator dataFactory = null;

  /**
   * XML report writer.
   */
  protected XMLReport xmlreport = null;

  /**
   * Constructor.
   * @param filename The absolute path to the generated file (PATH + FILENAME)
   */
  public AbstractTSVReport(String filename) {
    try {
      Properties p = ro.finsiel.eunis.OSEnvironment.getEnvVars();
      BASE_FILENAME = p.getProperty("TOMCAT_HOME") + "/webapps/eunis/temp/";
      fileStream = new PrintWriter( BASE_FILENAME + filename );
    } catch (Exception _ex) {
      _ex.printStackTrace();
    }
  }

  /** Use this method to write specific data into the file. Implemented in inherited classes. */
  public abstract void writeData();

  /** Returns the name of the file (the last element from the path i.e. /temp/myapp/test.txt - returns test.txt).
   * @return The name of the file
   */
  public String getFilename() {
    return filename;
  }

  /**
   * XML file name.
   * @return filename
   */
  public String getXMLFilename()
  {
    if ( xmlreport == null ) return null;
    return xmlreport.getFilename();
  }

  /** Write a single row of data into the file.
   * @param data data to be written, resembling the row...
   * @throws IOException When I/O exception occurrs
   */
  public void writeRow(List data) throws IOException {
    if (null == fileStream) return;
    if (null == data) return;
    for (int i = 0; i < data.size(); i++) {
      String _data = (String) data.get(i);
      if (null != _data) {
        fileStream.write(_data );
      } else {
        fileStream.write( "null" );
      }
      if (i < data.size() - 1) fileStream.write(TAB);
    }
    fileStream.write(EOL);
  }

  /** Closes the file, but before if flushes the output. */
  public void closeFile() {
    if (null != fileStream) {
      try
      {
        if( xmlreport != null )
        {
          xmlreport.closeFile();
        }
        fileStream.close();
      } catch (Exception _ex)
      {
        System.err.println("Exception while closing stream.");
        _ex.printStackTrace();
      }
    }
  }

  /**
   * Count search results.
   * @return no. of results
   */
  public int countResults()
  {
    int ret = 0;
    if ( dataFactory != null )
    {
      try
      {
        ret = dataFactory.countResults();
      }
      catch( Exception ex )
      {
        ex.printStackTrace();
      }
    }
    return ret;
  }
}