package ro.finsiel.eunis.reports.species;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.speciesByReferences.RefDomain;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.speciesByReferences.ReferencesBean;
import ro.finsiel.eunis.search.species.speciesByReferences.ReferencesPaginator;
import ro.finsiel.eunis.search.species.speciesByReferences.SpeciesRefWrapper;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * Generate the PDF reports for Species -> Scientific names search
 *
 * @author finsiel
 * @version 1.0
 */
public class TSVSpeciesReferencesReport extends AbstractTSVReport {
  /**
   * Form bean to retrieve data for search etc.
   */
  private ReferencesBean formBean = null;

  /**
   * Constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVSpeciesReferencesReport( String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies,
                                     String SQL_DRV, String SQL_URL, String SQL_USR, String SQL_PWD) {
    super( "species-references_" + sessionID + ".tsv" );
    this.formBean = ( ReferencesBean ) formBean;
    this.filename = "species-references_" + sessionID + ".tsv";
    this.dataFactory = new ReferencesPaginator(new RefDomain(formBean.toSearchCriteria(),
                                                                          formBean.toSortCriteria(),
                                                                          showEUNISInvalidatedSpecies,
                                                                          SQL_DRV,
                                                                          SQL_URL,
                                                                          SQL_USR,
                                                                          SQL_PWD));
    int x = formBean.toSearchCriteria().length;
    System.out.println( "x = " + x );
    dataFactory.setSortCriteria(formBean.toSortCriteria());
  }

  /**
   * Create the table headers
   *
   * @return An array with the columns headers of the table
   */
  public List createHeader() {
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
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          SpeciesRefWrapper specie = (SpeciesRefWrapper)resultSet.get( i );
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
          Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
          if ( sortVernList.size() > 0 )
          {
            for (int ii = 0; ii < sortVernList.size(); ii++)
            {
              VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(ii);
              String vernacularName = aVernName.getName();

              if ( ii == 0 )
              {
                Vector row = new Vector();
                // Group
                row.addElement( specie.getGroupName() );
                // Order
                row.addElement( specie.getOrderName() );
                // Family
                row.addElement( specie.getFamilyName() );
                // Scientific name
                row.addElement( specie.getScientificName() );
                // Vernacular name
                row.addElement( vernacularName );
                writeRow( row );
              }
              else
              {
                Vector row = new Vector();
                // Group
                row.addElement( "" );
                // Order
                row.addElement( "" );
                // Family
                row.addElement( "" );
                // Scientific name
                row.addElement( "" );
                // Vernacular name
                row.addElement( vernacularName );
                writeRow( row );
              }
            }
          }
          else
          {
            Vector row = new Vector();
            // Group
            row.addElement( specie.getGroupName() );
            // Order
            row.addElement( specie.getOrderName() );
            // Family
            row.addElement( specie.getFamilyName() );
            // Scientific name
            row.addElement( specie.getScientificName() );
            // Vernacular name
            row.addElement( "-" );
            writeRow( row );
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