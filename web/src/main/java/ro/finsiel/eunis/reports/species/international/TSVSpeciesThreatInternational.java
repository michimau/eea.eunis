package ro.finsiel.eunis.reports.species.international;

/**
 * Date: May 14, 2003
 * Time: 4:48:40 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusDomain;
import ro.finsiel.eunis.jrfTables.species.internationalthreatstatus.InternationalThreatStatusPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.internationalthreatstatus.InternationalthreatstatusPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSpeciesThreatInternational extends AbstractTSVReport {
  /**
   * Form bean used for search.
   */
  private AbstractFormBean formBean = null;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesThreatInternational( String sessionID, AbstractFormBean formBean, boolean showInvalidatedSpecies ) {
    super( "SpeciesThreatInternationalReport_" + sessionID + ".tsv" );
    this.formBean = formBean;
    this.filename = "SpeciesThreatInternationalReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "SpeciesThreatInternationalReport_" + sessionID + ".xml" );
    // Init the data factory

    if ( null != formBean )
    {
      dataFactory = new InternationalthreatstatusPaginator( new InternationalThreatStatusDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showInvalidatedSpecies ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVSpeciesThreatInternational.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    headers.addElement( "Status" );
    headers.addElement( "Group" );
    headers.addElement( "Scientific name" );
    headers.addElement( "Vernacular names" );
    return headers;
  }


  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
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
          Vector<String> aRow = new Vector<String>();
          String cellStatus;
          String cellGroup;
          String cellScientificName;
          Integer cellIdVernacularSearch;

          InternationalThreatStatusPersist specie = ( InternationalThreatStatusPersist ) resultSet.get( i );
          cellStatus = specie.getDefAbrev();
          cellGroup = specie.getCommonName();
          cellScientificName = specie.getScName();
          cellIdVernacularSearch = specie.getIdNatureObject();

          aRow.addElement( cellStatus );
          aRow.addElement( cellGroup );
          aRow.addElement( cellScientificName );
          // Vernacular names (multiple rows)
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames( cellIdVernacularSearch );
          String xmlVernacularNames = "";
          if ( vernNamesList.size() > 0 )
          {
            Vector sortVernList = new JavaSorter().sort( vernNamesList, JavaSorter.SORT_ALPHABETICAL );
            boolean blankLine = false;
            boolean atLeastALine = false;
            for ( int v = 0; v < sortVernList.size(); v++ )
            {
              VernacularNameWrapper aVernName = ( VernacularNameWrapper ) sortVernList.get( v );
              atLeastALine = true;
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
                Vector<String> anotherRow = new Vector<String>();
                anotherRow.addElement( "" );
                anotherRow.addElement( "" );
                anotherRow.addElement( "" );
                // Language
                anotherRow.addElement( aVernName.getLanguage() );
                // Vernacular name
                anotherRow.addElement( aVernName.getName() );
                writeRow( anotherRow );
              }
              xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
            }
            if ( !atLeastALine )
            {
              writeRow( aRow );
            }
          }
          else
          {
            aRow.addElement( "-" );
            writeRow( aRow );
          }

          // XML Report
          Vector<String> xmlrow = new Vector<String>();
          xmlrow.addElement( cellStatus );
          xmlrow.addElement( cellGroup );
          xmlrow.addElement( cellScientificName );
          xmlrow.addElement( xmlVernacularNames );
          xmlreport.writeRow( xmlrow );
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
