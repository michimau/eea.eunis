package ro.finsiel.eunis.reports.species;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.formBeans.CombinedSearchBean;
import ro.finsiel.eunis.jrfTables.species.advanced.DictionaryDomain;
import ro.finsiel.eunis.jrfTables.species.advanced.DictionaryPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.JavaSorter;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.search.species.advanced.DictionaryPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * Generate the PDF reports for Species -> Scientific names search.
 *
 * @author finsiel
 * @version 1.0
 */
public class TSVSpeciesAdvanced extends AbstractTSVReport {
  /**
   * Use the bean in order to see which columns should I display on the report.
   */
  private CombinedSearchBean formBean = null;

  boolean showGroup = false;
  boolean showOrder = false;
  boolean showFamily = false;
  boolean showScientificName = false;
  boolean showVernacularName = false;
  boolean showDistribution = false;
  boolean showThreat = false;
  boolean showCountry = false;
  boolean showRegion = false;
  boolean showSynonyms = false;
  boolean showReferences = false;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesAdvanced(String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies) {
    super("SpeciesAdvancedReport_" + sessionID + ".tsv");
    this.formBean = (CombinedSearchBean) formBean;
    this.filename = "SpeciesAdvancedReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SpeciesAdvancedReport_" + sessionID + ".xml");

    Vector columnsDisplayed = this.formBean.parseShowColumns();
    showGroup = columnsDisplayed.contains("showGroup");
    showOrder = columnsDisplayed.contains("showOrder");
    showFamily = columnsDisplayed.contains("showFamily");
    showScientificName = columnsDisplayed.contains("showScientificName");
    showVernacularName = columnsDisplayed.contains("showVernacularName");
    showDistribution = columnsDisplayed.contains("showDistribution");
    showThreat = columnsDisplayed.contains("showThreat");
    showCountry = columnsDisplayed.contains("showCountry");
    showRegion = columnsDisplayed.contains("showRegion");
    showSynonyms = columnsDisplayed.contains("showSynonyms");
    showReferences = columnsDisplayed.contains("showReferences");
    this.dataFactory = new DictionaryPaginator(new DictionaryDomain(sessionID));
    this.dataFactory.setSortCriteria(formBean.toSortCriteria());
  }

  /**
   * Create the table headers.
   *
   * @return An array with the columns headers of the table
   */
  public List<String> createHeader() {
    if (null == formBean) {
      return new Vector<String>();
    }
    Vector<String> headers = new Vector<String>();
    // Group
    if (showGroup) {
      headers.addElement("Group");
    }
    // Order
    if (showOrder) {
      headers.addElement("Order");
    }
    // Family
    if (showFamily) {
      headers.addElement("Family");
    }
    // Scientific name
    if (showScientificName) {
      headers.addElement("Scientific name");
    }
    // Common names (multiple rows)
    if (showVernacularName) {
      headers.addElement("Common names");
    }
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
      // Write table header
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++) {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++) {
          Vector<String> aRow = new Vector<String>();
          Vector<String> xmlrow = new Vector<String>();
          String cellGroup;
          String cellOrder;
          String cellFamily;
          String cellScientificName;
          Integer cellIdVernacularSearch;

          DictionaryPersist specie = (DictionaryPersist) resultSet.get(i);
          cellGroup = specie.getCommonName();
          cellOrder = specie.getTaxonomicNameOrder();
          cellFamily = specie.getTaxonomicNameFamily();
          cellScientificName = specie.getScientificName();
          cellIdVernacularSearch = specie.getIdNatureObject();
          // Group
          if (showGroup) {
            aRow.addElement(cellGroup);
            xmlrow.addElement(cellGroup);
          }
          // Order
          if (showOrder) {
            aRow.addElement(cellOrder);
            xmlrow.addElement(cellOrder);
          }
          // Family
          if (showFamily) {
            aRow.addElement(cellFamily);
            xmlrow.addElement(cellFamily);
          }
          // Scientific name
          if (showScientificName) {
            aRow.addElement(cellScientificName);
            xmlrow.addElement(cellScientificName);
          }
          // Common names (multiple rows)
          if (showVernacularName) {
            String xmlVernacularNames = "";
            Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(cellIdVernacularSearch);
            if (vernNamesList.size() > 0) {
              Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
              boolean blankLine = false;
              boolean atLeastALine = false;
              for (int v = 0; v < sortVernList.size(); v++) {
                VernacularNameWrapper aVernName = (VernacularNameWrapper) sortVernList.get(v);
                xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
                atLeastALine = true;
                if (!blankLine) {
                  // Language
                  aRow.addElement(aVernName.getLanguage());
                  // Common name
                  aRow.addElement(aVernName.getName());
                  blankLine = true;
                  writeRow(aRow);
                } else {
                  Vector<String> anotherRow = new Vector<String>();
                  if (showGroup) {
                    anotherRow.addElement("");
                  }
                  if (showOrder) {
                    anotherRow.addElement("");
                  }
                  if (showFamily) {
                    anotherRow.addElement("");
                  }
                  if (showScientificName) {
                    anotherRow.addElement("");
                  }
                  // Language
                  anotherRow.addElement(aVernName.getLanguage());
                  // Common name
                  anotherRow.addElement(aVernName.getName());
                  writeRow(anotherRow);
                }
              }
              if (!atLeastALine) {
                writeRow(aRow);
              }
              xmlrow.add(xmlVernacularNames);
            } else {
              // If common names list is empty add something to fill the cell or table gets screwed
              aRow.addElement("-");
              writeRow(aRow);
            }
          } else {
            writeRow(aRow);
          }

          xmlreport.writeRow(xmlrow);
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
