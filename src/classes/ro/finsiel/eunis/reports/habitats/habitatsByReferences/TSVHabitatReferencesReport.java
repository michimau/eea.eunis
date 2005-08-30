package ro.finsiel.eunis.reports.habitats.habitatsByReferences;

/**
 * Date: Apr 24, 2003
 * Time: 4:36:02 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain;
import ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesBean;
import ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


public class TSVHabitatReferencesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search
   */
  private AbstractFormBean formBean = null;

  /**
   * Normal constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVHabitatReferencesReport( String sessionID, AbstractFormBean formBean )
  {
    super( "HabitatReferencesNewReport_" + sessionID + ".tsv" );
    this.formBean = formBean;
    this.filename = "HabitatReferencesNewReport_" + sessionID + ".tsv";
    if ( null != formBean )
    {
      Integer database = Utilities.checkedStringToInt( ( ( ReferencesBean ) formBean ).getDatabase(), RefDomain.SEARCH_EUNIS );
      Integer source = Utilities.checkedStringToInt( ( ( ReferencesBean ) formBean ).getSource(), RefDomain.SOURCE );
      dataFactory = new ReferencesPaginator( new RefDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), database, source ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVHabitatReferencesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
  }

  /**
   * Create the table headers
   *
   * @return An array with the columns headers of the table
   */
  public List createHeader()
  {
    Integer database = Utilities.checkedStringToInt( ( ( ReferencesBean ) formBean ).getDatabase(), RefDomain.SEARCH_EUNIS );
    if ( null == formBean )
    {
      return new Vector();
    }
    Vector headers = new Vector();
    // Level
    if ( ( ( ReferencesBean ) formBean ).getDatabase().equalsIgnoreCase( RefDomain.SEARCH_EUNIS.toString() ) )
    {
      headers.addElement( "Level" );
    }
    // Code
    if ( 0 == database.compareTo( RefDomain.SEARCH_BOTH ) )
    {
      headers.addElement( "EUNIS code" );
      headers.addElement( "ANNEX code" );
    }
    if ( 0 == database.compareTo( RefDomain.SEARCH_EUNIS ) )
    {
      headers.addElement( "EUNIS code" );
    }
    if ( 0 == database.compareTo( RefDomain.SEARCH_ANNEX_I ) )
    {
      headers.addElement( "ANNEX I code" );
    }

    // Habitat type name
    headers.addElement( "Habitat type name" );
    // Habitat type english name
    headers.addElement( "Habitat type english name" );

    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
   */
  public void writeData()
  {
    Integer database = Utilities.checkedStringToInt( ( ( ReferencesBean ) formBean ).getDatabase(), RefDomain.SEARCH_EUNIS );
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
        // Write data row by row
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          RefPersist specie = ( RefPersist ) resultSet.get( i );
          Vector aRow = new Vector();
          // Level
          if ( ( ( ReferencesBean ) formBean ).getDatabase().equalsIgnoreCase( RefDomain.SEARCH_EUNIS.toString() ) )
          {
            aRow.addElement( specie.getLevel().toString() );
          }
          // Code
          if ( 0 == database.compareTo( RefDomain.SEARCH_BOTH ) )
          {
            aRow.addElement( specie.getEunisCode() );
            aRow.addElement( specie.getAnnex1Code() );
          }
          if ( 0 == database.compareTo( RefDomain.SEARCH_EUNIS ) )
          {
            aRow.addElement( specie.getEunisCode() );
          }
          if ( 0 == database.compareTo( RefDomain.SEARCH_ANNEX_I ) )
          {
            aRow.addElement( specie.getAnnex1Code() );
          }
          // Habitat type name
          aRow.addElement( specie.getScName() );
          // Habitat type english name
          aRow.addElement( specie.getDescription() );
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