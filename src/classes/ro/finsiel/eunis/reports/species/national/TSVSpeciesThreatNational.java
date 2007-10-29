package ro.finsiel.eunis.reports.species.national;

/**
 * Date: Jul 24, 2003
 * Time: 9:52:20 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusDomain;
import ro.finsiel.eunis.jrfTables.species.national.NationalThreatStatusPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.national.NationalPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSpeciesThreatNational extends AbstractTSVReport {
  /**
   * Form bean used for search.
   */
  private AbstractFormBean formBean = null;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesThreatNational( String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies ) {
    super( "SpeciesThreatNationalReport_" + sessionID + ".tsv" );
    this.formBean = formBean;
    this.filename = "SpeciesThreatNationalReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "SpeciesThreatNationalReport_" + sessionID + ".xml" );
    if ( null != formBean )
    {
      dataFactory = new NationalPaginator( new NationalThreatStatusDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVSpeciesThreatNational.class.getName() + "::ctor() - Warning: formBean was null!" );
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
    // Group
    headers.addElement( "Group" );
    // Country
    headers.addElement( "Country" );
    // Scientific name
    headers.addElement( "Scientific name" );
    // Vernacular names (multiple rows)
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
          NationalThreatStatusPersist specie = ( NationalThreatStatusPersist ) resultSet.get( i );
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames( specie.getIdNatureObject() );
          Vector sortVernList = new JavaSorter().sort( vernNamesList, JavaSorter.SORT_ALPHABETICAL );
          String xmlVernacularNames = "";
          if ( sortVernList.size() > 0 )
          {
            for ( int ii = 0; ii < sortVernList.size(); ii++ )
            {
              VernacularNameWrapper aVernName = ( VernacularNameWrapper ) sortVernList.get( ii );
              String vernacularName = aVernName.getName();

              if ( ii == 0 )
              {
                Vector<String> aRow = new Vector<String>();
                // Group
                aRow.addElement( specie.getCommonName() );
                // Country
                aRow.addElement( specie.getCountry() );
                // Scientific name
                aRow.addElement( specie.getScName() );
                // Vernacular name
                aRow.addElement( vernacularName );
                writeRow( aRow );
              }
              else
              {
                Vector<String> aRow = new Vector<String>();
                // Group
                aRow.addElement( "" );
                // Country
                aRow.addElement( "" );
                // Scientific name
                aRow.addElement( "" );
                // Vernacular name
                aRow.addElement( vernacularName );
                writeRow( aRow );
              }
              xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
            }
          }
          else
          {
            Vector<String> aRow = new Vector<String>();
            // Group
            aRow.addElement( specie.getCommonName() );
            // Country
            aRow.addElement( specie.getCountry() );
            // Scientific name
            aRow.addElement( specie.getScName() );
            // Vernacular name
            aRow.addElement( "-" );
            writeRow( aRow );
          }
          Vector<String> aRow = new Vector<String>();
          aRow.addElement( specie.getCommonName() );
          aRow.addElement( specie.getCountry() );
          aRow.addElement( specie.getScName() );
          aRow.addElement( xmlVernacularNames );
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
