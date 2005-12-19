package ro.finsiel.eunis.reports.habitats.code;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain;
import ro.finsiel.eunis.jrfTables.habitats.code.CodePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.HabitatsSearchUtility;
import ro.finsiel.eunis.search.habitats.code.CodeBean;
import ro.finsiel.eunis.search.habitats.code.CodePaginator;
import ro.finsiel.eunis.search.habitats.code.OtherClassWrapper;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVHabitatCodeReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private CodeBean formBean = null;
  private Integer database;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVHabitatCodeReport( String sessionID, AbstractFormBean formBean )
  {
    super( "HabitatsCodeReport_" + sessionID + ".tsv" );
    this.formBean = ( CodeBean ) formBean;
    this.filename = "HabitatsCodeReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "HabitatsCodeReport_" + sessionID + ".xml" );
    // Init the data factory
    if ( null != formBean )
    {
      Integer _database = Utilities.checkedStringToInt( ( ( CodeBean ) formBean ).getDatabase(), CodeDomain.SEARCH_EUNIS );
      dataFactory = new CodePaginator( new CodeDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), _database ) );
      dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVHabitatCodeReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
    this.database = Utilities.checkedStringToInt( this.formBean.getDatabase(), CodeDomain.SEARCH_EUNIS );
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
    // Level
    if ( formBean.getDatabase().equalsIgnoreCase( CodeDomain.SEARCH_EUNIS.toString() ) )
    {
      headers.addElement( "Level" );
    }
    // Code
    if ( 0 == database.compareTo( CodeDomain.SEARCH_BOTH ) )
    {
      headers.addElement( "EUNIS code" );
      headers.addElement( "ANNEX I code" );
    }
    if ( 0 == database.compareTo( CodeDomain.SEARCH_EUNIS ) )
    {
      headers.addElement( "EUNIS code" );
    }
    if ( 0 == database.compareTo( CodeDomain.SEARCH_ANNEX ) )
    {
      headers.addElement( "ANNEX I code" );
    }
    // Name
    headers.addElement( "Habitat type name" );
    // Relation
    headers.addElement( "Relation with other habitat types" );
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
      xmlreport.writeRow( createHeader() );
      Integer relationOp = Utilities.checkedStringToInt( formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS );
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          CodePersist habitat = ( CodePersist ) resultSet.get( i );
          Integer idHab = Utilities.checkedStringToInt( habitat.getIdHabitat(), 0 );
          List otherClassifications = HabitatsSearchUtility.findOtherClassifications( idHab, relationOp, formBean.getSearchString() );
          // TSV
          if ( otherClassifications.size() > 0 )
          {
            for ( int j = 0; j < otherClassifications.size(); j++ )
            {
              OtherClassWrapper classification = ( OtherClassWrapper ) otherClassifications.get( j );
              if ( j == 0 )
              {
                Vector<String> aRow = new Vector<String>();
                // Level
                if ( formBean.getDatabase().equalsIgnoreCase( CodeDomain.SEARCH_EUNIS.toString() ) )
                {
                  aRow.addElement( habitat.getHabLevel().toString() );
                }
                // Code
                if ( 0 == database.compareTo( CodeDomain.SEARCH_BOTH ) )
                {
                  aRow.addElement( habitat.getEunisHabitatCode() );
                  aRow.addElement( habitat.getCodeAnnex1() );
                }
                if ( 0 == database.compareTo( CodeDomain.SEARCH_EUNIS ) )
                {
                  aRow.addElement( habitat.getEunisHabitatCode() );
                }
                if ( 0 == database.compareTo( CodeDomain.SEARCH_ANNEX ) )
                {
                  aRow.addElement( habitat.getCodeAnnex1() );
                }
                // Scientific name
                aRow.addElement( habitat.getScientificName() );
                // Relation
                aRow.addElement( classification.getCode() + "-" + classification.getClassificatioName() + "(" + classification.getRelationDecoded() + ")" );
                writeRow( aRow );
              }
              else
              {
                Vector<String> aRow = new Vector<String>();
                // Level
                if ( formBean.getDatabase().equalsIgnoreCase( CodeDomain.SEARCH_EUNIS.toString() ) )
                {
                  aRow.addElement( "" );
                }
                // Code
                if ( 0 == database.compareTo( CodeDomain.SEARCH_BOTH ) )
                {
                  aRow.addElement( "" );
                  aRow.addElement( "" );
                }
                if ( 0 == database.compareTo( CodeDomain.SEARCH_EUNIS ) )
                {
                  aRow.addElement( "" );
                }
                if ( 0 == database.compareTo( CodeDomain.SEARCH_ANNEX ) )
                {
                  aRow.addElement( "" );
                }
                // Scientific name
                aRow.addElement( "" );
                // Relation
                aRow.addElement( classification.getCode() + "-" + classification.getClassificatioName() + "(" + classification.getRelationDecoded() + ")" );
                writeRow( aRow );
              }
            }
          }
          else
          {
            Vector<String> aRow = new Vector<String>();
            // Level
            if ( formBean.getDatabase().equalsIgnoreCase( CodeDomain.SEARCH_EUNIS.toString() ) )
            {
              aRow.addElement( habitat.getHabLevel().toString() );
            }
            // Code
            if ( 0 == database.compareTo( CodeDomain.SEARCH_BOTH ) )
            {
              aRow.addElement( habitat.getEunisHabitatCode() );
              aRow.addElement( habitat.getCodeAnnex1() );
            }
            if ( 0 == database.compareTo( CodeDomain.SEARCH_EUNIS ) )
            {
              aRow.addElement( habitat.getEunisHabitatCode() );
            }
            if ( 0 == database.compareTo( CodeDomain.SEARCH_ANNEX ) )
            {
              aRow.addElement( habitat.getCodeAnnex1() );
            }
            // Scientific name
            aRow.addElement( habitat.getScientificName() );
            // Relation
            aRow.addElement( "-" );
            writeRow( aRow );
          }

          // XML
          Vector<String> aRow = new Vector<String>();
          // Level
          if ( formBean.getDatabase().equalsIgnoreCase( CodeDomain.SEARCH_EUNIS.toString() ) )
          {
            aRow.addElement( habitat.getHabLevel().toString() );
          }
          // Code
          if ( 0 == database.compareTo( CodeDomain.SEARCH_BOTH ) )
          {
            aRow.addElement( habitat.getEunisHabitatCode() );
            aRow.addElement( habitat.getCodeAnnex1() );
          }
          if ( 0 == database.compareTo( CodeDomain.SEARCH_EUNIS ) )
          {
            aRow.addElement( habitat.getEunisHabitatCode() );
          }
          if ( 0 == database.compareTo( CodeDomain.SEARCH_ANNEX ) )
          {
            aRow.addElement( habitat.getCodeAnnex1() );
          }
          // Scientific name
          aRow.addElement( habitat.getScientificName() );

          String otherCodes = "";
          for ( int j = 0; j < otherClassifications.size(); j++ )
          {
            OtherClassWrapper classification = ( OtherClassWrapper ) otherClassifications.get( j );
            otherCodes += "<classification code=\"" + classification.getCode() + "\" " +
                                           "name=\"" + classification.getClassificatioName() + "\" " +
                                           " relation=\"" + classification.getRelationDecoded() + "\" />";
          }
          // Relation
          aRow.addElement( otherCodes );
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