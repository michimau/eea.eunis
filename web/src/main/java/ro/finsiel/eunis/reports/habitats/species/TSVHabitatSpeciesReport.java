package ro.finsiel.eunis.reports.habitats.species;

/**
 * Date: Apr 16, 2003
 * Time: 11:14:23 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.species.ScientificNameDomain;
import ro.finsiel.eunis.jrfTables.habitats.species.ScientificNamePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.species.SpeciesBean;
import ro.finsiel.eunis.search.habitats.species.SpeciesPaginator;
import ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria;
import ro.finsiel.eunis.utilities.TableColumns;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVHabitatSpeciesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private SpeciesBean formBean = null;

  private boolean showEUNISInvalidatedSpecies = false;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   * @param searchAttribute attribute searched
   */
  public TSVHabitatSpeciesReport(String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies, Integer searchAttribute)
  {
    super("HabitatSpeciesReport_" + sessionID + ".tsv");
    this.formBean = (SpeciesBean) formBean;
    this.filename = "HabitatSpeciesReport_" + sessionID + ".tsv";
    this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    xmlreport = new XMLReport("HabitatSpeciesReport_" + sessionID + ".xml");
    // Init the data factory
    if (null != formBean)
    {
      Integer database = Utilities.checkedStringToInt(((SpeciesBean) formBean).getDatabase(), ScientificNameDomain.SEARCH_EUNIS);
      this.dataFactory = new SpeciesPaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
          formBean.toSortCriteria(),
          database,
          showEUNISInvalidatedSpecies,
          searchAttribute));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVHabitatSpeciesReport.class.getName() + "::ctor() - Warning: formBean was null!");
    }
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader()
  {
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), ScientificNameDomain.SEARCH_EUNIS);
    if (null == formBean)
    {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Level
    if (formBean.getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString()))
    {
      headers.addElement("Level");
    }
    // Code
    if (0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH))
    {
      headers.addElement("EUNIS Code");
      headers.addElement("ANNEX I Code");
    }
    if (0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS))
    {
      headers.addElement("EUNIS Code");
    }
    if (0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I))
    {
      headers.addElement("ANNEX I Code");
    }
    // Habitat name
    headers.addElement("Name");
    // English name
    headers.addElement("Habitat type english name");
    // Species
    headers.addElement("Species");

    return headers;
  }

  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
   */
  public void writeData()
  {
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), ScientificNameDomain.SEARCH_EUNIS);
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
      Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++)
      {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++)
        {
          ScientificNamePersist habitat = (ScientificNamePersist) resultSet.get(i);

          // List of species attributes.
          Integer idNatureObject = habitat.getIdNatureObject();
          List resultsSpecies = new ScientificNameDomain().findSpeciesFromHabitat(new SpeciesSearchCriteria(searchAttribute,
              formBean.getScientificName(),
              relationOp),
              database,
              showEUNISInvalidatedSpecies,
              idNatureObject,
              searchAttribute);
          if (resultsSpecies != null && resultsSpecies.size() > 0)
          {
            for(int ii = 0; ii < resultsSpecies.size(); ii++)
            {
              TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
              String scientificName = (String) tableColumns.getColumnsValues().get(0);

              if(ii == 0)
              {
                Vector<String> aRow = new Vector<String>();
                // Level
                if ((formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString()))
                {
                  aRow.addElement(habitat.getHabLevel().toString());
                }
                // Code
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH))
                {
                  aRow.addElement(habitat.getEunisHabitatCode());
                  aRow.addElement(habitat.getCodeAnnex1());
                }
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS))
                {
                  aRow.addElement(habitat.getEunisHabitatCode());
                }
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I))
                {
                  aRow.addElement(habitat.getCodeAnnex1());
                }
                // Name
                aRow.addElement(habitat.getScientificName());
                // English name
                aRow.addElement(habitat.getDescription());
                // Species
                aRow.addElement(scientificName);
                writeRow(aRow);
              }
              else
              {
                Vector<String> aRow = new Vector<String>();
                // Level
                if ((formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString()))
                {
                  aRow.addElement("");
                }
                // Code
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH))
                {
                  aRow.addElement("");
                  aRow.addElement("");
                }
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS))
                {
                  aRow.addElement("");
                }
                if (0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I))
                {
                  aRow.addElement("");
                }
                // Name
                aRow.addElement("");
                // English name
                aRow.addElement("");
                // Species
                aRow.addElement(scientificName);
                writeRow(aRow);
              }
            }
          }
          else
          {
            Vector<String> aRow = new Vector<String>();
            // Level
            if ((formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString()))
            {
              aRow.addElement(habitat.getHabLevel().toString());
            }
            // Code
            if (0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH))
            {
              aRow.addElement(habitat.getEunisHabitatCode());
              aRow.addElement(habitat.getCodeAnnex1());
            }
            if (0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS))
            {
              aRow.addElement(habitat.getEunisHabitatCode());
            }
            if (0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I))
            {
              aRow.addElement(habitat.getCodeAnnex1());
            }
            // Name
            aRow.addElement(habitat.getScientificName());
            // English name
            aRow.addElement(habitat.getDescription());
            // Species
            aRow.addElement("");
            writeRow(aRow);
          }

          // XML Report
          Vector<String> aRow = new Vector<String>();
          // Level
          if ((formBean).getDatabase().equalsIgnoreCase(ScientificNameDomain.SEARCH_EUNIS.toString()))
          {
            aRow.addElement(habitat.getHabLevel().toString());
          }
          // Code
          if (0 == database.compareTo(ScientificNameDomain.SEARCH_BOTH))
          {
            aRow.addElement(habitat.getEunisHabitatCode());
            aRow.addElement(habitat.getCodeAnnex1());
          }
          if (0 == database.compareTo(ScientificNameDomain.SEARCH_EUNIS))
          {
            aRow.addElement(habitat.getEunisHabitatCode());
          }
          if (0 == database.compareTo(ScientificNameDomain.SEARCH_ANNEX_I))
          {
            aRow.addElement(habitat.getCodeAnnex1());
          }
          // Name
          aRow.addElement(habitat.getScientificName());
          // English name
          aRow.addElement(habitat.getDescription());
          // Species
          String species = "";
          for(int ii = 0; ii < resultsSpecies.size(); ii++)
          {
            TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
            species += "<species>" + tableColumns.getColumnsValues().get(0) + "</species>";
          }
          aRow.addElement(species);
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
