/**
 * Date: Apr 23, 2003
 * Time: 2:30:37 PM
 */
package ro.finsiel.eunis.reports.habitats.country;


import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain;
import ro.finsiel.eunis.jrfTables.habitats.country.CountryPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.country.CountryBean;
import ro.finsiel.eunis.search.habitats.country.CountryPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVCountryReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private CountryBean formBean = null;
  private Integer database;

  /**
   * Constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVCountryReport(String sessionID, AbstractFormBean formBean)
  {
    super("HabitatsCountryReport_" + sessionID + ".tsv");
    this.formBean = (CountryBean) formBean;
    this.filename = "HabitatsCountryReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("HabitatsCountryReport_" + sessionID + ".xml");
    // Init the data factory
    if (null != formBean)
    {
      Integer _database = Utilities.checkedStringToInt(((CountryBean) formBean).getDatabase(), CountryDomain.SEARCH_EUNIS);
      dataFactory = new CountryPaginator(new CountryDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), _database));
      dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVCountryReport.class.getName() + "::ctor() - Warning: formBean was null!");
    }
    database = Utilities.checkedStringToInt(this.formBean.getDatabase(), CountryDomain.SEARCH_EUNIS);
  }

  /**
   * Create the table headers.
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    if (null == formBean)
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Country
    headers.addElement("Country");
    // Region
    headers.addElement("Biogeographic region");
    // Level
    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
    {
      headers.addElement("Level");
    }
    // Code
    if (0 == database.compareTo(CountryDomain.SEARCH_BOTH))
    {
      headers.addElement("EUNIS code");
      headers.addElement("ANNEX I code");
    }
    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
    {
      headers.addElement("EUNIS code");
    }
    if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I))
    {
      headers.addElement("ANNEX I code");
    }
    // Name
    headers.addElement("Habitat type name");
    // English name
    headers.addElement("Habitat type english name");
    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
   */
  public void writeData()
  {
    if (null == dataFactory)
    {
      return;
    }
    dataFactory.setPageSize(RESULTS_PER_PAGE);
    try
    {
      int _pagesCount = dataFactory.countPages();
      if (_pagesCount == 0)
      {
        closeFile();
        return;
      }
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++)
      {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++)
        {
          // Retrieve a habitat
          CountryPersist habitat = (CountryPersist) resultSet.get(i);
          Vector<String> aRow = new Vector<String>();
          // Country
          aRow.addElement(habitat.getCountry());
          // Region
          aRow.addElement(habitat.getRegion());
          if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
          {
            aRow.addElement(habitat.getLevel().toString());
          }
          // Code
          if (0 == database.compareTo(CountryDomain.SEARCH_BOTH))
          {
            aRow.addElement(habitat.getEunisHabitatCode());
            aRow.addElement(habitat.getCodeAnnex1());
          }
          if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS))
          {
            aRow.addElement(habitat.getEunisHabitatCode());
          }
          if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I))
          {
            aRow.addElement(habitat.getCodeAnnex1());
          }
          // Name
          aRow.addElement(habitat.getScientificName());
          // English name
          aRow.addElement(Utilities.formatString(habitat.getDescription()));
          writeRow(aRow);
          xmlreport.writeRow(aRow);
        }
      }
    }
    catch (CriteriaMissingException ex)
    {
      ex.printStackTrace();
    }
    catch (InitializationException iex)
    {
      iex.printStackTrace();
    }
    catch (IOException ioex)
    {
      ioex.printStackTrace();
    }
    catch (Exception ex2)
    {
      ex2.printStackTrace();
    }
    finally
    {
      closeFile();
    }
  }
}
