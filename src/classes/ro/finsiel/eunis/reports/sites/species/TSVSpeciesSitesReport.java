package ro.finsiel.eunis.reports.sites.species;

/**
 * Date: Jul 9, 2003
 * Time: 3:08:51 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.species.SpeciesDomain;
import ro.finsiel.eunis.jrfTables.sites.species.SpeciesPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.species.SpeciesBean;
import ro.finsiel.eunis.search.sites.species.SpeciesPaginator;
import ro.finsiel.eunis.search.sites.species.SpeciesSearchCriteria;
import ro.finsiel.eunis.utilities.TableColumns;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * XML and PDF report.
 */
public class TSVSpeciesSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private SpeciesBean formBean = null;

  private boolean showInvalidatedSpecies = false;

  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showInvalidatedSpecies Show invalidated species
   * @param searchAttribute Type of search
   */
  public TSVSpeciesSitesReport( String sessionID, AbstractFormBean formBean, boolean showInvalidatedSpecies, Integer searchAttribute )
  {
    super( "SpeciesSitesReport_" + sessionID + ".tsv" );
    this.formBean = ( SpeciesBean )formBean;
    this.filename = "SpeciesSitesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport( "SpeciesSitesReport_" + sessionID + ".xml" );
    this.showInvalidatedSpecies = showInvalidatedSpecies;
    // Init the data factory
    if ( null != formBean )
    {
      boolean[] source = {
          ( this.formBean ).getDB_NATURA2000() != null,
          ( this.formBean ).getDB_CORINE() != null,
          ( this.formBean ).getDB_DIPLOMA() != null,
          ( this.formBean ).getDB_CDDA_NATIONAL() != null,
          ( this.formBean ).getDB_CDDA_INTERNATIONAL() != null,
          ( this.formBean ).getDB_BIOGENETIC() != null,
          false,
          ( this.formBean ).getDB_EMERALD() != null
      };
      dataFactory = new SpeciesPaginator( new SpeciesDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showInvalidatedSpecies, source, searchAttribute ) );
      this.dataFactory.setSortCriteria( formBean.toSortCriteria() );
    }
    else
    {
      System.out.println( TSVSpeciesSitesReport.class.getName() + "::ctor() - Warning: formBean was null!" );
    }
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    if ( null == formBean )
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Source database
    headers.addElement( "Source data set" );
    // DesignationTypes
    headers.addElement( "Designation type" );
    // Name
    headers.addElement( "Site name" );
    // Species
    headers.addElement( "Species" );
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes.
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

      Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);

      boolean[] source = {
          ( this.formBean ).getDB_NATURA2000() != null,
          ( this.formBean ).getDB_CORINE() != null,
          ( this.formBean ).getDB_DIPLOMA() != null,
          ( this.formBean ).getDB_CDDA_NATIONAL() != null,
          ( this.formBean ).getDB_CDDA_INTERNATIONAL() != null,
          ( this.formBean ).getDB_BIOGENETIC() != null,
          false,
          ( this.formBean ).getDB_EMERALD() != null
      };
      for ( int _currPage = 0; _currPage < _pagesCount; _currPage++ )
      {
        List resultSet = dataFactory.getPage( _currPage );
        for ( int i = 0; i < resultSet.size(); i++ )
        {
          SpeciesPersist site = ( SpeciesPersist ) resultSet.get( i );
          String designations = "";
          if( site.getIdGeoscope() != null )
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString( site.getIdDesignation(), site.getIdGeoscope().toString() );
          }

          Integer idNatureObject = site.getIdNatureObject();
          List resultsSpecies = new SpeciesDomain().findSpeciesFromSite( new SpeciesSearchCriteria( searchAttribute,
              formBean.getSearchString(),
              relationOp ),
              showInvalidatedSpecies,
              idNatureObject,
              searchAttribute, source );
          if ( resultsSpecies != null && resultsSpecies.size() > 0 )
          {
            for(int ii=0;ii<resultsSpecies.size();ii++)
            {
              TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
              String scientificName = (String)tableColumns.getColumnsValues().get(0);
              if ( ii == 0 )
              {
                Vector<String> aRow = new Vector<String>();
                // Source database
                aRow.addElement( ( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) ) );
                // Designations
                aRow.addElement( designations );
                // Name
                aRow.addElement( Utilities.formatString( site.getName() ) );
                // Species
                aRow.addElement( scientificName );
                writeRow( aRow );
              }
              else
              {
                Vector<String> aRow = new Vector<String>();
                // Source database
                aRow.addElement( "" );
                // Designations
                aRow.addElement( "" );
                // Name
                aRow.addElement( "" );
                // Species
                aRow.addElement( scientificName );
                writeRow( aRow );
              }
            }
          }
          else
          {
            Vector<String> aRow = new Vector<String>();
            // Source database
            aRow.addElement( ( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) ) );
            // Designations
            aRow.addElement( designations );
            // Name
            aRow.addElement( Utilities.formatString( site.getName() ) );
            // Species
            aRow.addElement( "-" );
            writeRow( aRow );
          }

          // XML Report
          Vector<String> aRow = new Vector<String>();
          // Source database
          aRow.addElement( ( SitesSearchUtility.translateSourceDB( site.getSourceDB() ) ) );
          // Designations
          aRow.addElement( designations );
          // Name
          aRow.addElement( Utilities.formatString( site.getName() ) );
          // Species
          String species = "";
          for(int ii=0;ii<resultsSpecies.size();ii++)
          {
            TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
            species += "<species>" + tableColumns.getColumnsValues().get(0) + "</species>";
          }
          aRow.addElement( species );
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
