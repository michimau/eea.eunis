package ro.finsiel.eunis.reports.sites.year;

/**
 * Date: Jul 25, 2003
 * Time: 10:01:30 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.year.YearDomain;
import ro.finsiel.eunis.jrfTables.sites.year.YearPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.year.YearBean;
import ro.finsiel.eunis.search.sites.year.YearPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * XML and PDF report.
 */
public class TSVYearReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private YearBean formBean = null;

  /**
   * Constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVYearReport( String sessionID, AbstractFormBean formBean )
  {
    super( "YearReport_" + sessionID + ".tsv" );
    this.formBean = ( YearBean ) formBean;
    this.filename = "YearReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "YearReport_" + sessionID + ".xml" );
    // Init the data factory
    if ( null != formBean )
    {
      boolean[] source =
          {
              this.formBean.getDB_NATURA2000() != null,
              this.formBean.getDB_CORINE() != null,
              this.formBean.getDB_DIPLOMA() != null,
              this.formBean.getDB_CDDA_NATIONAL() != null,
              this.formBean.getDB_CDDA_INTERNATIONAL() != null,
              this.formBean.getDB_BIOGENETIC() != null,
              false,
              this.formBean.getDB_EMERALD() != null
          };
      dataFactory = new YearPaginator( new YearDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), source ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVYearReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    if ( null == formBean )
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Source database
    headers.addElement( "Source data set" );
    // Country
    headers.addElement( "Country" );
    // Name
    headers.addElement( "Name" );
    // DesignationTypes
    headers.addElement( "Designation type" );
    // Coordinates
    headers.addElement( "Longitude" );
    headers.addElement( "Latitude" );
    // Size
    headers.addElement( "Size" );
    // Year
    headers.addElement( "Designation year" );
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes.
   */
  public void writeData()
  {
    if ( null == dataFactory )
    {
      return;
    }
    dataFactory.setPageSize( RESULTS_PER_PAGE );
    try
    {
      int _pagesCount = dataFactory.countPages();
      if ( _pagesCount == 0 )
      {
        closeFile();
        return;
      }
      writeRow( createHeader() );
      xmlreport.writeRow( createHeader() );
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          YearPersist site = ( YearPersist ) resultSet.get( i );
          String designations = "";
          if ( site.getIdDesignation() != null && site.getIdGeoscope() != null )
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString( site.getIdDesignation(), site.getIdGeoscope().toString() );
          }
          Vector<String> aRow = new Vector<String>();
          // Source database
          aRow.addElement( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) );
          // Country
          aRow.addElement( Utilities.formatString( site.getAreaNameEn() ) );
          // Name
          aRow.addElement( Utilities.formatString( site.getName() ) );
          // DesignationTypes
          aRow.addElement( designations );
          // Coordinates
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec() ) );
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec() ) );
          // Altitude
          aRow.addElement( Utilities.formatAreaPDF( site.getArea(), 9, 2, "" ) );
          // Year
          aRow.addElement( SitesSearchUtility.parseDesignationYear( site.getDesignationDate(), site.getSourceDB() ) );
          writeRow( aRow );
          xmlreport.writeRow( aRow );
        }
      }
    }
    catch ( CriteriaMissingException ex )
    {
      ex.printStackTrace();
    }
    catch ( InitializationException iex )
    {
      iex.printStackTrace();
    }
    catch ( IOException ioex )
    {
      ioex.printStackTrace();
    }
    catch ( Exception ex2 )
    {
      ex2.printStackTrace();
    }
    finally
    {
      closeFile();
    }
  }
}
