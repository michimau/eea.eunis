package ro.finsiel.eunis.reports.habitats.legal;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalDomain;
import ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.habitats.HabitatsSearchUtility;
import ro.finsiel.eunis.search.habitats.legal.LegalPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * Generate the TSV report for the Habitats -> Legal search
 *
 * @author Monica Secrieru
 * @version 1.2
 */
public class TSVHabitatLegalReport extends AbstractTSVReport
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
  public TSVHabitatLegalReport( String sessionID, AbstractFormBean formBean )
  {
    super( "HabitatsLegalReport_" + sessionID + ".tsv" );
    this.formBean = formBean;
    this.filename = "HabitatsLegalReport_" + sessionID + ".tsv";
    // Init the data factory
    if ( null != formBean )
    {
      dataFactory = new LegalPaginator( new EUNISLegalDomain( formBean.toSearchCriteria(), formBean.toSortCriteria() ) );
      dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVHabitatLegalReport.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    // Level
    headers.addElement( "Level" );
    // Code
    headers.addElement( "Code" );
    // Scientific name
    headers.addElement( "English name" );
    // Vernacular names (multiple rows)
    headers.addElement( "Legal text" );
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
          EUNISLegalPersist habitat = ( EUNISLegalPersist ) resultSet.get( i );

          List legalTexts = HabitatsSearchUtility.findHabitatLegalInstrument( habitat.getIdHabitat() );
          if ( legalTexts.size() > 0 )
          {
            for (int j = 0; j < legalTexts.size(); j++)
            {
              EUNISLegalPersist legalText = (EUNISLegalPersist) legalTexts.get(j);
              if ( j == 0 )
              {
                Vector aRow = new Vector();
                // Level
                aRow.addElement( habitat.getHabLevel().toString() );
                // Code
                aRow.addElement( habitat.getEunisHabitatCode() );
                // English name
                aRow.addElement( habitat.getScientificName() );
                // Legal text
                aRow.addElement( legalText.getLegalName() );
                writeRow( aRow );
              }
              else
              {
                Vector aRow = new Vector();
                // Level
                aRow.addElement( "" );
                // Code
                aRow.addElement( "" );
                // English name
                aRow.addElement( "" );
                // Legal text
                aRow.addElement( legalText.getLegalName() );
                writeRow( aRow );
              }
            }
          }
          else
          {
            Vector aRow = new Vector();
            // Level
            aRow.addElement( habitat.getHabLevel().toString() );
            // Code
            aRow.addElement( habitat.getEunisHabitatCode() );
            // English name
            aRow.addElement( habitat.getScientificName() );
            // Legal text
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