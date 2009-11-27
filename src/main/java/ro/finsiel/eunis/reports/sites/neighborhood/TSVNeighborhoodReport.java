package ro.finsiel.eunis.reports.sites.neighborhood;

/**
 * Date: Jul 25, 2003
 * Time: 9:14:45 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.Chm62edtSitesDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist;
import ro.finsiel.eunis.jrfTables.sites.neighborhood.NeighborhoodDomain;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.neighborhood.NeighborhoodBean;
import ro.finsiel.eunis.search.sites.neighborhood.NeighborhoodPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * TSV and XML report generation.
 */
public class TSVNeighborhoodReport extends AbstractTSVReport {
  /**
   * Form bean used for search.
   */
  private NeighborhoodBean formBean = null;
  private Chm62edtSitesPersist mainSite = null;

  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param idMainSite ID of main site
   * @param radius Radius of search
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVNeighborhoodReport( String sessionID, String idMainSite, float radius, AbstractFormBean formBean ) {
    super( "NeighborhoodReport_" + sessionID + ".tsv" );
    this.formBean = ( NeighborhoodBean ) formBean;
    this.filename = "NeighborhoodReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "DesignatedSitesReport_" + sessionID + ".xml" );
    if ( null != formBean )
    {
      List sites = new Chm62edtSitesDomain().findWhere( "ID_SITE='" + idMainSite + "'" );
      mainSite = ( Chm62edtSitesPersist ) sites.get( 0 );
      float originX = Utilities.checkedStringToFloat( mainSite.getLongitude(), 0 );
      float originY = Utilities.checkedStringToFloat( mainSite.getLatitude(), 0 );
      dataFactory = new NeighborhoodPaginator( new NeighborhoodDomain( idMainSite, radius, originX, originY, this.formBean.toSortCriteriaDetailsPage() ) );
      this.dataFactory.setSortCriteria( this.formBean.toSortCriteriaDetailsPage() );
    }
    else
    {
      System.out.println( TSVNeighborhoodReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader() {
    if ( null == formBean )
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    headers.addElement( "Source data set" );
    headers.addElement( "Site name" );
    headers.addElement( "Distance" );
    // Coordinates
    headers.addElement( "Longitude" );
    headers.addElement( "Latitude" );
    // Size
    headers.addElement( "Size" );
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes.
   */
  public void writeData() {
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
          Chm62edtSitesPersist site = ( Chm62edtSitesPersist ) resultSet.get( i );
          Vector<String> aRow = new Vector<String>();
          aRow.addElement( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) );
          aRow.addElement( Utilities.formatString( site.getName() ) );
          aRow.addElement( Utilities.formatAreaPDF( "" + SitesSearchUtility.distanceBetweenSites( mainSite, site ), 4, 3 , "" ) );
          // Coordinates
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLongEW(), site.getLongDeg(), site.getLongMin(), site.getLongSec() ) );
          aRow.addElement( SitesSearchUtility.formatCoordinatesPDF( site.getLatNS(), site.getLatDeg(), site.getLatMin(), site.getLatSec() ) );
          // Size
          aRow.addElement( Utilities.formatAreaPDF( site.getArea(), 5, 2, "" ) );
          writeRow( aRow );
          xmlreport.writeRow( createHeader() );
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
