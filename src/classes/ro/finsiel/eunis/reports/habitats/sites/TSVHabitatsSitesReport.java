package ro.finsiel.eunis.reports.habitats.sites;

/**
 * Date: May 13, 2003
 * Time: 2:59:54 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain;
import ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.sites.SitesBean;
import ro.finsiel.eunis.search.habitats.sites.SitesPaginator;
import ro.finsiel.eunis.search.habitats.sites.SitesSearchCriteria;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


public class TSVHabitatsSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search
   */
  private SitesBean formBean = null;

  /**
   * Normal constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVHabitatsSitesReport( String sessionID, AbstractFormBean formBean )
  {
    super( "HabitatsSitesReport_" + sessionID + ".tsv" );
    this.formBean = ( SitesBean ) formBean;
    this.filename = "HabitatsSitesReport_" + sessionID + ".tsv";
    // Init the data factory
    if ( null != formBean )
    {
      Integer database = HabitatsSitesDomain.SEARCH_BOTH;
      Integer searchAttribute = Utilities.checkedStringToInt( this.formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME );
      boolean[] source_db = { true, true, true, true, true, true, true, true };
      dataFactory = new SitesPaginator( new HabitatsSitesDomain( formBean.toSearchCriteria(),
          formBean.toSortCriteria(),
          searchAttribute,
          database,
          source_db ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVHabitatsSitesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    // Code
    headers.addElement( "EUNIS code" );
    headers.addElement( "ANNEX I code" );
    // Name
    headers.addElement( "Habitat name" );
    // English name
    headers.addElement( "Sites names" );
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
      Integer searchAttribute = Utilities.checkedStringToInt( formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME );
      Integer relationOp = Utilities.checkedStringToInt( formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS );
      boolean[] source_db = { true, true, true, true, true, true, true, true };
      Integer database = HabitatsSitesDomain.SEARCH_BOTH;
      writeRow( createHeader() );
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          HabitatsSitesPersist habitat = ( HabitatsSitesPersist ) resultSet.get( i );
          Integer idNatureObject = habitat.getIdNatureObject();

          List resultsSites = new HabitatsSitesDomain().findSitesWithHabitats(
              new SitesSearchCriteria( searchAttribute,
                  formBean.getScientificName(),
                  relationOp ),
              source_db,
              searchAttribute,
              idNatureObject,
              database );
          if ( resultsSites != null && resultsSites.size() > 0 )
          {
            for (int ii = 0; ii < resultsSites.size(); ii++)
            {
              List l = (List) resultsSites.get(ii);

              if ( ii == 0 )
              {
                Vector aRow = new Vector();
                // Code
                aRow.addElement( habitat.getEunisHabitatCode() );
                aRow.addElement( habitat.getCodeAnnex1() );
                // Name
                aRow.addElement( habitat.getScientificName() );
                // Sites
                aRow.addElement( (String) l.get(0) + "(" + (String) l.get(1) + ")" );
                writeRow( aRow );
              }
              else
              {
                Vector aRow = new Vector();
                // Code
                aRow.addElement( "" );
                aRow.addElement( "" );
                // Name
                aRow.addElement( "" );
                // Sites names
                aRow.addElement( (String) l.get(0) + "(" + (String) l.get(1) + ")" );
                writeRow( aRow );
              }
            }
          }
          else
          {
            Vector aRow = new Vector();
            // Code
            aRow.addElement( habitat.getEunisHabitatCode() );
            aRow.addElement( habitat.getCodeAnnex1() );
            // Name
            aRow.addElement( habitat.getScientificName() );
            // Sites names
            aRow.addElement( "-" );
            writeRow( aRow );
          }
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
