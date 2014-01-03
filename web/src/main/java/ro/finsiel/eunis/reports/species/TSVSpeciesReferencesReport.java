package ro.finsiel.eunis.reports.species;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.speciesByReferences.RefDomain;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
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
 * XML and PDF report.
 */
public class TSVSpeciesReferencesReport extends AbstractTSVReport {
  /**
   * Form bean to retrieve data for search etc.
   */
  private ReferencesBean formBean = null;

  /**
   * Constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showEUNISInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesReferencesReport(String sessionID, AbstractFormBean formBean, boolean showEUNISInvalidatedSpecies) {
    super("species-references_" + sessionID + ".tsv");
    this.formBean = (ReferencesBean) formBean;
    this.filename = "species-references_" + sessionID + ".tsv";
    xmlreport = new XMLReport("species-references_" + sessionID + ".xml");
    this.dataFactory = new ReferencesPaginator(new RefDomain(formBean.toSearchCriteria(),
                                                                          formBean.toSortCriteria(),
                                                                          showEUNISInvalidatedSpecies));
    dataFactory.setSortCriteria(formBean.toSortCriteria());
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
    headers.addElement("Group");
    headers.addElement("Order");
    headers.addElement("Family");
    headers.addElement("Scientific name");
    headers.addElement("Vernacular names");
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
          String xmlVernacularNames = "";
          SpeciesRefWrapper specie = (SpeciesRefWrapper)resultSet.get(i);
          Vector vernNamesList = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
          Vector sortVernList = new JavaSorter().sort(vernNamesList, JavaSorter.SORT_ALPHABETICAL);
          if (sortVernList.size() > 0) {
            for (int ii = 0; ii < sortVernList.size(); ii++) {
              VernacularNameWrapper aVernName = (VernacularNameWrapper)sortVernList.get(ii);
              String vernacularName = aVernName.getName();
              xmlVernacularNames += "<name language=\"" + aVernName.getLanguage() + "\">" + aVernName.getName() + "</name>";
              if (ii == 0) {
                Vector<String> row = new Vector<String>();
                // Group
                row.addElement(specie.getGroupName());
                // Order
                row.addElement(specie.getOrderName());
                // Family
                row.addElement(specie.getFamilyName());
                // Scientific name
                row.addElement(specie.getScientificName());
                // Vernacular name
                row.addElement(vernacularName);
                writeRow(row);
              } else {
                Vector<String> row = new Vector<String>();
                // Group
                row.addElement("");
                // Order
                row.addElement("");
                // Family
                row.addElement("");
                // Scientific name
                row.addElement("");
                // Vernacular name
                row.addElement(vernacularName);
                writeRow(row);
              }
            }
          } else {
            Vector<String> row = new Vector<String>();
            // Group
            row.addElement(specie.getGroupName());
            // Order
            row.addElement(specie.getOrderName());
            // Family
            row.addElement(specie.getFamilyName());
            // Scientific name
            row.addElement(specie.getScientificName());
            // Vernacular name
            row.addElement("-");
            writeRow(row);
          }
          Vector<String> row = new Vector<String>();
          // Group
          row.addElement(specie.getGroupName());
          // Order
          row.addElement(specie.getOrderName());
          // Family
          row.addElement(specie.getFamilyName());
          // Scientific name
          row.addElement(specie.getScientificName());
          // Vernacular name
          row.addElement(xmlVernacularNames);
          xmlreport.writeRow(row);
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
