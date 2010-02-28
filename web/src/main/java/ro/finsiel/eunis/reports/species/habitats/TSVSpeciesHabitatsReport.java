package ro.finsiel.eunis.reports.species.habitats;

/**
 * Date: May 13, 2003
 * Time: 11:45:51 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.habitats.ScientificNameDomain;
import ro.finsiel.eunis.jrfTables.species.habitats.ScientificNamePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.habitats.HabitateBean;
import ro.finsiel.eunis.search.species.habitats.HabitatePaginator;
import ro.finsiel.eunis.search.species.habitats.HabitateSearchCriteria;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSpeciesHabitatsReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private HabitateBean formBean = null;
  private boolean showInvalidatedSpecies = false;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesHabitatsReport( String sessionID, AbstractFormBean formBean, boolean showInvalidatedSpecies )
  {
    super( "SpeciesHabitatsReport_" + sessionID + ".tsv" );
    this.formBean = ( HabitateBean ) formBean;
    this.filename = "SpeciesHabitatsReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "SpeciesHabitatsReport_" + sessionID + ".xml" );
    this.showInvalidatedSpecies = showInvalidatedSpecies;
    if ( null != formBean )
    {
      Integer database = Utilities.checkedStringToInt( ( ( HabitateBean ) formBean ).getDatabase(), ScientificNameDomain.SEARCH_EUNIS );
      Integer searchAttribute = Utilities.checkedStringToInt( ( ( HabitateBean ) formBean ).getSearchAttribute(), ScientificNameDomain.SEARCH_EUNIS );
      dataFactory = new HabitatePaginator( new ScientificNameDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showInvalidatedSpecies, searchAttribute, database ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVSpeciesHabitatsReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }

  }

  /**
   * Create the table headers.
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    if ( null == formBean )
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Group
    headers.addElement( "Group" );
    // Order
    headers.addElement( "Order" );
    // Family
    headers.addElement( "Family" );
    // Scientific name
    headers.addElement( "Species scientific name" );
    // Habitat types
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
      Integer searchAttribute = Utilities.checkedStringToInt( formBean.getSearchAttribute(), HabitateSearchCriteria.SEARCH_NAME );
      Integer relationOp = Utilities.checkedStringToInt( formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS );
      Integer database = Utilities.checkedStringToInt( formBean.getDatabase(), HabitateSearchCriteria.SEARCH_NAME );
      writeRow( createHeader() );
      xmlreport.writeRow( createHeader() );
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          ScientificNamePersist specie = ( ScientificNamePersist ) resultSet.get( i );

          Vector<String> aRow = new Vector<String>();
          Vector<String> xmlRow = new Vector<String>();
          String cellGroup;
          String cellOrder;
          String cellFamily;
          String cellScientificName;

          Integer idNatureObject = specie.getIdNatureObject();

          List resultsHabitats = new ScientificNameDomain().findHabitatsWithSpecies(
              new HabitateSearchCriteria(
                  searchAttribute,
                  formBean.getScientificName(),
                  relationOp ),
              database,
              searchAttribute,
              idNatureObject,
              showInvalidatedSpecies );
          String habitats = "";
          if ( resultsHabitats.size() > 0 )
          {
            for ( int j = 0; j < resultsHabitats.size(); j++ )
            {
              aRow = new Vector<String>();
              String habitatName = Utilities.treatURLSpecialCharacters( ( String ) resultsHabitats.get( j ) );
              if ( j == 0 )
              {
                cellGroup = specie.getCommonName();
                cellOrder = Utilities.formatString( specie.getTaxonomicNameOrder() );
                cellFamily = specie.getTaxonomicNameFamily();
                cellScientificName = specie.getScientificName();
                // Group
                aRow.addElement( cellGroup );
                // Order
                aRow.addElement( cellOrder );
                // Family
                aRow.addElement( cellFamily );
                // Scientific name
                aRow.addElement( cellScientificName );
                // Habitat
                aRow.addElement( habitatName );
                writeRow( aRow );
              }
              else
              {
                // Group
                aRow.addElement( "" );
                // Order
                aRow.addElement( "" );
                // Family
                aRow.addElement( "" );
                // Scientific name
                aRow.addElement( "" );
                // Habitat
                aRow.addElement( habitatName );
                writeRow( aRow );
              }
              habitats += "<habitat>" + habitatName + "</habitat>";
            }
          }
          else
          {
            cellGroup = specie.getCommonName();
            cellOrder = Utilities.formatString( specie.getTaxonomicNameOrder() );
            cellFamily = specie.getTaxonomicNameFamily();
            cellScientificName = specie.getScientificName();

            // Group
            aRow.addElement( cellGroup );
            // Order
            aRow.addElement( cellOrder );
            // Family
            aRow.addElement( cellFamily );
            // Scientific name
            aRow.addElement( cellScientificName );
            // Habitat
            aRow.addElement( "-" );
            writeRow( aRow );
          }
          xmlRow.add( specie.getCommonName() );
          xmlRow.add( Utilities.formatString( specie.getTaxonomicNameOrder() ) );
          xmlRow.add( specie.getTaxonomicNameFamily() );
          xmlRow.add( specie.getScientificName() );
          xmlRow.add( habitats );
          xmlreport.writeRow( xmlRow );
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
