package ro.finsiel.eunis.reports.habitats.names;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain;
import ro.finsiel.eunis.jrfTables.habitats.names.NamesPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.names.NameBean;
import ro.finsiel.eunis.search.habitats.names.NamePaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * Generate the TSV report for the Habitats -> Names search
 *
 * @author Monica Secrieru
 * @version 1.2
 */
public class TSVHabitatNamesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search
   */
  private NameBean formBean = null;

  /**
   * Normal constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVHabitatNamesReport( String sessionID, AbstractFormBean formBean )
  {
    super( "HabitatsNamesReport_" + sessionID + ".tsv" );
    this.formBean = ( NameBean )formBean;
    this.filename = "HabitatsNamesReport_" + sessionID + ".tsv";
    // Init the data factory
    if ( null != formBean )
    {
      Integer database = Utilities.checkedStringToInt( ( ( NameBean ) formBean ).getDatabase(), NamesDomain.SEARCH_EUNIS );
      dataFactory = new NamePaginator( new NamesDomain( formBean.toSearchCriteria(), formBean.getMainSearchCriteriasExtra(), formBean.toSortCriteria(), database ) );
      dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVHabitatNamesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    Integer database = Utilities.checkedStringToInt( formBean.getDatabase(), NamesDomain.SEARCH_EUNIS );
    Vector headers = new Vector();
    // Level
    if ( 0 == database.compareTo( NamesDomain.SEARCH_EUNIS ) )
    {
      headers.addElement( "Level" );
    }
    // Code
    if ( 0 == database.compareTo( NamesDomain.SEARCH_BOTH ) )
    {
      headers.addElement( "EUNIS code" );
      headers.addElement( "ANNEX I code" );
    }
    if ( 0 == database.compareTo( NamesDomain.SEARCH_EUNIS ) )
    {
      headers.addElement( "EUNIS code" );
    }
    if ( 0 == database.compareTo( NamesDomain.SEARCH_ANNEX_I ) )
    {
      headers.addElement( "ANNEX I code" );
    }
    // Name
    headers.addElement( "Habitat type english name" );
    // English name
    headers.addElement( "Habitat type name" );
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
   */
  public void writeData()
  {
    Integer database = Utilities.checkedStringToInt( formBean.getDatabase(), NamesDomain.SEARCH_EUNIS );
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
          NamesPersist habitat = ( NamesPersist ) resultSet.get( i );
          Vector aRow = new Vector();
          // Level
          if ( 0 == database.compareTo( NamesDomain.SEARCH_EUNIS ) )
          {
            aRow.addElement( habitat.getHabLevel().toString() );
          }
          // Code
          if ( 0 == database.compareTo( NamesDomain.SEARCH_BOTH ) )
          {
            aRow.addElement( habitat.getEunisHabitatCode() );
            aRow.addElement( habitat.getCodeAnnex1() );
          }
          if ( 0 == database.compareTo( NamesDomain.SEARCH_EUNIS ) )
          {
            aRow.addElement( habitat.getEunisHabitatCode() );
          }
          if ( 0 == database.compareTo( NamesDomain.SEARCH_ANNEX_I ) )
          {
            aRow.addElement( habitat.getCodeAnnex1() );
          }
          // Name
          aRow.addElement( habitat.getScientificName() );
          // English name
          aRow.addElement( habitat.getDescription() );
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