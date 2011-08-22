package ro.finsiel.eunis.reports.species.synonym;

/**
 * Date: Jul 23, 2003
 * Time: 11:20:17 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNameDomain;
import ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNamePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.species.synonyms.SynonymsPaginator;
import ro.finsiel.eunis.utilities.TableColumns;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSpeciesSynonymReport extends AbstractTSVReport {

  /**
   * Form bean used for search.
   */
  private AbstractFormBean formBean = null;
  private boolean showEUNISInvalidatedSpecies = false;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesSynonymReport(String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies) {
    super("SpeciesSynonymReport_" + sessionID + ".tsv");
    this.formBean = formBean;
    this.filename = "SpeciesSynonymReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SpeciesSynonymReport_" + sessionID + ".xml");
    this.showEUNISInvalidatedSpecies = showEUNISInvalidatedSpecies;
    if (null != formBean) {
      dataFactory = new SynonymsPaginator(new ScientificNameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    } else {
      System.out.println(TSVSpeciesSynonymReport.class.getName() + "::ctor() - Warning: formBean was null!");
    }
  }

  /**
   * Create the table headers.
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader() {
    if (null == formBean) {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Scientific name
    headers.addElement("Group");
    headers.addElement("Synonym name");
    headers.addElement("Species");
    return headers;
  }


  /**
   * Use this method to write specific data into the file. Implemented in inherited classes.
   */
  public void writeData() {
    if (null == dataFactory) {
      return;
    }
    dataFactory.setPageSize(RESULTS_PER_PAGE);
    try {
      int _pagesCount = dataFactory.countPages();
      if (_pagesCount == 0) {
        closeFile();
        return;
      }
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++) {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++) {
          ScientificNamePersist specie = (ScientificNamePersist) resultSet.get(i);
          List resultsSpecies;
          String synonyms = "";
          try {
            resultsSpecies = new ScientificNameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), showEUNISInvalidatedSpecies).geSpeciesListForASynonym(specie.getIdSpec());

            if (resultsSpecies.size() > 0) {
              for (int j = 0; j < resultsSpecies.size(); j++) {
                TableColumns tableColumns = (TableColumns) resultsSpecies.get(j);
                String scientificName = (String)tableColumns.getColumnsValues().get(0);
                Vector<String> aRow = new Vector<String>();
                if (j == 0) {
                  aRow.addElement(specie.getGrName());
                  aRow.addElement(specie.getScName());
                  aRow.addElement(scientificName);
                }
                else {
                  aRow.addElement("");
                  aRow.addElement("");
                  aRow.addElement(scientificName);
                }
                writeRow(aRow);
                synonyms += "<synonym>" + scientificName + "</synonym>";
              }
            }
            else {
              Vector<String> aRow = new Vector<String>();
              aRow.addElement(specie.getGrName());
              aRow.addElement(specie.getScName());
              aRow.addElement("-");
              writeRow(aRow);
            }
          }
          catch (Exception ex) {
            ex.printStackTrace();
          }
          Vector<String> aRow = new Vector<String>();
          aRow.addElement(specie.getGrName());
          aRow.addElement(specie.getScName());
          aRow.addElement(synonyms);
          xmlreport.writeRow(aRow);
        }
      }
    } catch (CriteriaMissingException ex) {
      ex.printStackTrace();
    } catch (InitializationException iex) {
      iex.printStackTrace();
    } catch (IOException ioex) {
      ioex.printStackTrace();
    } catch (Exception ex2) {
      ex2.printStackTrace();
    } finally {
      closeFile();
    }
  }
}
