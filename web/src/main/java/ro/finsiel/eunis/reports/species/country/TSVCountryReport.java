package ro.finsiel.eunis.reports.species.country;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.jrfTables.species.country.*;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.country.CountryBean;
import ro.finsiel.eunis.search.species.country.CountryPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * XML and PDF report.
 */
public class TSVCountryReport extends AbstractTSVReport
{
  private CountryBean formBean = null;

  /**
   * Constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVCountryReport(String sessionID, CountryBean formBean, boolean showEUNISInvalidatedSpecies)
  {
    super("SpeciesCountryReport_" + sessionID + ".tsv");
    this.formBean = formBean;
    this.filename = "SpeciesCountryReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SpeciesCountryReport_" + sessionID + ".xml");

    String countryName = this.formBean.getCountryName();
    String regionName = this.formBean.getRegionName();
    // Init the data factory
    // Init the data factory depending on the type of search
    // *a* country / *a* region
    if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
    {
      this.dataFactory = new CountryPaginator(new CountryRegionDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
    }
    // *any* country / *a* region
    if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
    {
      this.dataFactory = new CountryPaginator(new RegionDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
    }
    // *a* country / *any* region
    if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))
    {
      this.dataFactory = new CountryPaginator(new CountryDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
    }
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    if (null == formBean)
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    headers.addElement("Group");
    headers.addElement("Country");
    headers.addElement("Biogeoregion");
    headers.addElement("Scientific name");
    headers.addElement("Vernacular names");
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
        return; // Do not write anything, since there are no results
      }
      // Write table header
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      // Write data page by page
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++)
      {
        List resultSet = dataFactory.getPage(_currPage);
        final String countryName = formBean.getCountryName();
        final String regionName = formBean.getRegionName();
        // Write data row by row
        for (int i = 0; i < resultSet.size(); i++)
        {
          // Retrieve a specie
          Vector<String> aRow = new Vector<String>();
          Vector<String> xmlRow = new Vector<String>();
          String cellGroup = "";
          String cellCountry = "";
          String cellBiogeoregion = "";
          String cellScientificName = "";
          Integer cellIdVernacularSearch = new Integer(0);

          // *a* country / *a* region
          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
          {
            CountryRegionPersist specie = (CountryRegionPersist) resultSet.get(i);
            cellGroup = (null == specie.getCommonName()) ? "" : (specie.getCommonName().equalsIgnoreCase("null")) ? "" : specie.getCommonName();
            cellCountry = formBean.getCountryName();
            cellBiogeoregion = formBean.getRegionName();
            cellScientificName = specie.getScientificName();
            cellIdVernacularSearch = specie.getIdNatureObject();
          }
          // *any* country / *a* region
          if (null != countryName && countryName.equalsIgnoreCase("any") && null != regionName && !regionName.equalsIgnoreCase("any"))
          {
            RegionPersist specie = (RegionPersist) resultSet.get(i);
            cellGroup = (null == specie.getCommonName()) ? "" : (specie.getCommonName().equalsIgnoreCase("null")) ? "" : specie.getCommonName();
            cellCountry = formBean.getCountryName();
            cellBiogeoregion = formBean.getRegionName();
            cellScientificName = specie.getScientificName();
            cellIdVernacularSearch = specie.getIdNatureObjectRep();
          }
          // *a* country / *any* region
          if (null != countryName && !countryName.equalsIgnoreCase("any") && null != regionName && regionName.equalsIgnoreCase("any"))
          {
            CountryPersist specie = (CountryPersist) resultSet.get(i);
            cellGroup = (null == specie.getCommonName()) ? "" : (specie.getCommonName().equalsIgnoreCase("null")) ? "" : specie.getCommonName();
            cellCountry = formBean.getCountryName();
            cellBiogeoregion = formBean.getRegionName();
            cellScientificName = specie.getScientificName();
            cellIdVernacularSearch = specie.getIdNatureObjectRep();
          }
          aRow.addElement(cellGroup);
          xmlRow.addElement(cellGroup);
          aRow.addElement(cellCountry);
          xmlRow.addElement(cellCountry);
          aRow.addElement(cellBiogeoregion);
          xmlRow.addElement(cellBiogeoregion);
          aRow.addElement(cellScientificName);
          xmlRow.addElement(cellScientificName);
          // Vernacular names (multiple rows)
          String xmlVernacularNames = "";
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(cellIdVernacularSearch);
          if (vernNamesList.size() > 0)
          {
            Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
            boolean blankLine = false;
            for (int v = 0; v < sortVernList.size(); v++)
            {
              VernacularNameWrapper aVernName = (VernacularNameWrapper) sortVernList.get(v);
              if (!blankLine)
              {
                // Language
                aRow.addElement(aVernName.getLanguage());
                // Vernacular name
                aRow.addElement(aVernName.getName());
                blankLine = true;
                writeRow(aRow);
              }
              else
              {
                Vector<String> anotherRow = new Vector<String>();
                anotherRow.addElement("");
                anotherRow.addElement("");
                anotherRow.addElement("");
                anotherRow.addElement("");
                // Language
                anotherRow.addElement(aVernName.getLanguage());
                // Vernacular name
                anotherRow.addElement(aVernName.getName());
                writeRow(anotherRow);
              }
              xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
            }
          }
          else
          {
            // If vernacular names list is empty add something to fill the cell or table gets screwed
            aRow.addElement("-");
            writeRow(aRow);
          }
          xmlRow.add(xmlVernacularNames);
          // XML Report
          xmlreport.writeRow(xmlRow);
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
