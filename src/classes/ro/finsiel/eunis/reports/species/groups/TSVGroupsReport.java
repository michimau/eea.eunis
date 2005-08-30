package ro.finsiel.eunis.reports.species.groups;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.groups.GroupsDomain;
import ro.finsiel.eunis.jrfTables.species.groups.GroupsPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.groups.GroupsBean;
import ro.finsiel.eunis.search.species.groups.GroupsPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * Generate the PDF reports for Species -> Groups search
 *
 * @author Monica Secrieru
 * @version 1.0
 */
public class TSVGroupsReport extends AbstractTSVReport
{
  /**
   * Use the bean in order to see which columns should I display on the report
   */
  private GroupsBean formBean = null;

  /**
   * Constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVGroupsReport( String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies )
  {
    super( "SpeciesCountryReport_" + sessionID + ".tsv" );
    this.formBean = ( GroupsBean ) formBean;
    this.filename = "SpeciesCountryReport_" + sessionID + ".tsv";
    if ( null != formBean )
    {
      dataFactory = new GroupsPaginator( new GroupsDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies ) );
    }
    else
    {
      System.out.println( TSVGroupsReport.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    headers.addElement( "Group" );
    headers.addElement( "Order" );
    headers.addElement( "Family" );
    headers.addElement( "Scientific name" );
    headers.addElement( "Vernacular names" );
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
          GroupsPersist specie = ( GroupsPersist ) resultSet.get( i );
          String cellGroup = specie.getCommonName();
          String cellOrder;
          String cellFamily;
          cellOrder = specie.getTaxonomicNameOrder();
          cellOrder = ( null == specie.getTaxonomicNameOrder() ) ? "" : ( specie.getTaxonomicNameOrder().equalsIgnoreCase( "null" ) ) ? "" : cellOrder;
          cellFamily = ( specie.getTaxonomyLevel() != null && specie.getTaxonomyLevel().equalsIgnoreCase( "family" ) ? ( specie.getTaxonomicNameFamily() != null && !specie.getTaxonomicNameFamily().equalsIgnoreCase( "null" ) ? specie.getTaxonomicNameFamily() : "" ) : "" );
          Vector aRow = new Vector();
          aRow.addElement( cellGroup );
          aRow.addElement( cellOrder );
          aRow.addElement( cellFamily );
          aRow.addElement( specie.getScientificName() );
          // Vernacular names (multiple rows)
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames( specie.getIdNatureObject() );
          if ( vernNamesList.size() > 0 )
          {
            Vector sortVernList = new JavaSorter().sort( vernNamesList, JavaSorter.SORT_ALPHABETICAL );
            boolean blankLine = false;
            for ( int v = 0; v < sortVernList.size(); v++ )
            {
              VernacularNameWrapper aVernName = ( VernacularNameWrapper ) sortVernList.get( v );
              if ( !blankLine )
              {
                // Language
                aRow.addElement( aVernName.getLanguage() );
                // Vernacular name
                aRow.addElement( aVernName.getName() );
                blankLine = true;
                writeRow( aRow );
              }
              else
              {
                Vector anotherRow = new Vector();
                anotherRow.addElement( "" );
                anotherRow.addElement( "" );
                anotherRow.addElement( "" );
                anotherRow.addElement( "" );
                // Language
                anotherRow.addElement( aVernName.getLanguage() );
                // Vernacular name
                anotherRow.addElement( aVernName.getName() );
                writeRow( anotherRow );
              }
            }
          }
          else
          {
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