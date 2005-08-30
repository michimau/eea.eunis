package ro.finsiel.eunis.reports.species.legal;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.legal.LegalStatusDomain;
import ro.finsiel.eunis.jrfTables.species.legal.LegalStatusPersist;
import ro.finsiel.eunis.jrfTables.species.legal.ScientificLegalDomain;
import ro.finsiel.eunis.jrfTables.species.legal.ScientificLegalPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.legal.LegalBean;
import ro.finsiel.eunis.search.species.legal.LegalPaginator;
import ro.finsiel.eunis.search.species.legal.LegalSearchCriteria;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * Generate the PDF reports for Species -> Legal search
 * @version 1.0
 */
public class TSVLegalReport extends AbstractTSVReport
{
  /**
   * Use the bean in order to see which columns should I display on the report
   */
  private LegalBean formBean = null;

  /**
   * Form we are coming from (I or II)
   */
  private int typeForm;

  /**
   * Constructor
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVLegalReport( String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies )
  {
    super( "SpeciesCountryReport_" + sessionID + ".tsv" );
    this.formBean = ( LegalBean ) formBean;
    this.filename = "SpeciesCountryReport_" + sessionID + ".tsv";
    typeForm = Utilities.checkedStringToInt( this.formBean.getTypeForm(), LegalSearchCriteria.CRITERIA_SPECIES.intValue() );
    // Form 1
    if ( LegalSearchCriteria.CRITERIA_SPECIES.intValue() == typeForm )
    {
      this.dataFactory = new LegalPaginator( new ScientificLegalDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies ) );
    }
    // Form 2
    if ( LegalSearchCriteria.CRITERIA_LEGAL.intValue() == typeForm )
    {
      this.dataFactory = new LegalPaginator( new LegalStatusDomain( formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies ) );
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
    // Scientific name
    headers.addElement( "Scientific name" );
    // Group
    headers.addElement( "Group" );
    // Legal text
    headers.addElement( "Legal text" );
    // Abbreviation
    headers.addElement( "Abbreviation" );
    // Comment
    headers.addElement( "Comment" );
    // URL
    headers.addElement( "URL" );
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
          Vector aRow = new Vector();

          String cellScientificName = "";
          String cellGroup = "";
          String cellLegalText = "";
          String cellAbbreviation = "";
          String cellComment = "";
          String cellURL = "";

          // Form 1
          if ( LegalSearchCriteria.CRITERIA_SPECIES.intValue() == typeForm )
          {
            ScientificLegalPersist specie = ( ScientificLegalPersist ) resultSet.get( i );

            cellScientificName = specie.getScientificName();
            cellGroup = specie.getCommonName();
            cellLegalText = specie.getTitle();
            cellAbbreviation = specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex();
            cellComment = specie.getComment();
            cellURL = specie.getUrl();
          }
          // Form 2
          if ( LegalSearchCriteria.CRITERIA_LEGAL.intValue() == typeForm )
          {
            LegalStatusPersist specie = ( LegalStatusPersist ) resultSet.get( i );

            cellScientificName = specie.getScientificName();
            cellGroup = specie.getCommonName();
            cellLegalText = specie.getTitle();
            cellAbbreviation = specie.getAlternative() + "- Annex/Appendix " + specie.getAnnex();
            cellComment = specie.getComment();
            cellURL = specie.getUrl();
          }
          aRow.addElement( cellScientificName );
          aRow.addElement( cellGroup );
          aRow.addElement( cellLegalText );
          aRow.addElement( cellAbbreviation );
          aRow.addElement( cellComment );
          aRow.addElement( cellURL );
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