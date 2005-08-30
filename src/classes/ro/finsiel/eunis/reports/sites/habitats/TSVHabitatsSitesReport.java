package ro.finsiel.eunis.reports.sites.habitats;

/**
 * Date: Jul 9, 2003
 * Time: 3:27:00 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.habitats.HabitatDomain;
import ro.finsiel.eunis.jrfTables.sites.habitats.HabitatPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.habitats.HabitatBean;
import ro.finsiel.eunis.search.sites.habitats.HabitatPaginator;
import ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


public class TSVHabitatsSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search
   */
  private HabitatBean formBean = null;

  /**
   * Normal constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVHabitatsSitesReport( String sessionID, AbstractFormBean formBean, Integer searchAttribute )
  {
    super( "HabitatsSitesReport_" + sessionID + ".tsv" );
    this.formBean = ( HabitatBean ) formBean;
    this.filename = "HabitatsSitesReport_" + sessionID + ".tsv";
    // Init the data factory
    if ( null != formBean )
    {
      boolean[] source = { true, true, true, true, true, true, false, true };
      dataFactory = new HabitatPaginator(
          new HabitatDomain(
              formBean.toSearchCriteria(),
              formBean.toSortCriteria(),
              Utilities.checkedStringToInt(this.formBean.getDatabase(), HabitatDomain.SEARCH_EUNIS), source, searchAttribute));
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
    // Source database
    headers.addElement( "Source data set" );
    // DesignationTypes
    headers.addElement( "Designation type" );
    // Code
    headers.addElement( "Site code" );
    // Name
    headers.addElement( "Site name" );
    // Habitats
    headers.addElement( "Habitat types" );
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
      Integer searchAttribute = Utilities.checkedStringToInt( formBean.getSearchAttribute(), HabitatSearchCriteria.SEARCH_NAME );
      Integer relationOp = Utilities.checkedStringToInt( formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS );
      boolean[] source_db = { true, true, true, true, true, true, false, true };
      writeRow( createHeader() );
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          HabitatPersist site = ( HabitatPersist ) resultSet.get( i );
          String designations = "";
          if ( site.getIdDesignation() != null && site.getIdGeoscope() != null )
          {
           designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString( site.getIdDesignation(), site.getIdGeoscope().toString() );
          }
          List resultsHabitats = new HabitatDomain().findHabitatsFromSpecifiedSite(
              new HabitatSearchCriteria( searchAttribute,
                  formBean.getSearchString(),
                  relationOp ),
              searchAttribute,
              source_db,
              Utilities.formatString( site.getName(), "" ) );
          if ( resultsHabitats.size() > 0 )
          {
            for ( int ii = 0; ii < resultsHabitats.size(); ii++ )
            {
              String habitatName = (String) resultsHabitats.get(ii);
              if ( ii == 0 )
              {
                Vector aRow = new Vector();
                // Source database
                aRow.addElement( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) );
                // DesignationTypes
                aRow.addElement( designations );
                // Site code
                aRow.addElement( site.getIdSite() );
                // Name
                aRow.addElement( Utilities.formatString( site.getName() ) );
                // Habitat
                aRow.addElement( habitatName );
                writeRow( aRow );
              }
              else
              {
                Vector aRow = new Vector();
                // Source database
                aRow.addElement( "" );
                // DesignationTypes
                aRow.addElement( "" );
                // Site code
                aRow.addElement( "" );
                // Name
                aRow.addElement( " ");
                // Habitat
                aRow.addElement( Utilities.formatString( habitatName ) );
                writeRow( aRow );
              }
            }
          }
          else
          {
            Vector aRow = new Vector();
            // Source database
            aRow.addElement( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) );
            // DesignationTypes
            aRow.addElement( designations );
            // Site code
            aRow.addElement( site.getIdSite() );
            // Name
            aRow.addElement( Utilities.formatString( site.getName() ) );
            // Habitat
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
