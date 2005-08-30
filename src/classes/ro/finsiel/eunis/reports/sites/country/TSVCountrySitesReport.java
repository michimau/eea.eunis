package ro.finsiel.eunis.reports.sites.country;

/**
 * Date: May 26, 2003
 * Time: 3:59:43 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.country.CountryDomain;
import ro.finsiel.eunis.jrfTables.sites.country.CountryPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.country.CountryBean;
import ro.finsiel.eunis.search.sites.country.CountryPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


public class TSVCountrySitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search
   */
  private CountryBean formBean = null;

  /**
   * Normal constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVCountrySitesReport( String sessionID, AbstractFormBean formBean )
  {
    super( "CountrySitesReport_" + sessionID + ".tsv" );
    this.formBean = ( CountryBean ) formBean;
    this.filename = "CountrySitesReport_" + sessionID + ".tsv";
    // Init the data factory
    if ( null != formBean )
    {
      boolean[] source = {
          this.formBean.getDB_NATURA2000() != null,
          this.formBean.getDB_CORINE() != null,
          this.formBean.getDB_DIPLOMA() != null,
          this.formBean.getDB_CDDA_NATIONAL() != null,
          this.formBean.getDB_CDDA_INTERNATIONAL() != null,
          this.formBean.getDB_BIOGENETIC() != null,
          false,
          this.formBean.getDB_EMERALD() != null
      };
      dataFactory = new CountryPaginator( new CountryDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), source ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVCountrySitesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
  }

  /**
   * Create the table headers
   *
   * @return An array with the columns headers of the table
   */
  public List createHeader()
  {
    if ( null == formBean )
    {
      return new Vector();
    }
    Vector headers = new Vector();
    // Source database
    headers.addElement( "Source data set" );
    // Name
    headers.addElement( "Name" );
    // DesignationTypes
    headers.addElement( "Designation name" );
    // Coordinates
    headers.addElement( "Longitude" );
    headers.addElement( "Latitude" );
    // Size
    headers.addElement( "Size (ha)" );
    // Year
    headers.addElement( "Designation year" );
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
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
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          CountryPersist site = ( CountryPersist ) resultSet.get( i );
          String designations = "";
          if ( site.getIdDesignation() != null && site.getIdGeoscope() != null )
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString( site.getIdDesignation(), site.getIdGeoscope().toString() );
          }

          Vector aRow = new Vector();
          // Source data set
          aRow.addElement( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) );
          // Name
          aRow.addElement( Utilities.formatString( site.getName() ) );
          // DesignationTypes
          aRow.addElement( designations );
          // Coordinates
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec() ) );
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec() ) );
          // Size
          aRow.addElement( Utilities.formatAreaPDF( site.getArea(), 9, 2, " " ) );
          // Year
          aRow.addElement( SitesSearchUtility.parseDesignationYear( site.getYear(), site.getSourceDB() ) );
          writeRow( aRow );
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
