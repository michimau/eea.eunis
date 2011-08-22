package ro.finsiel.eunis.reports.species.sites;

/**
 * Date: Apr 16, 2003
 * Time: 11:14:23 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesDomain;
import ro.finsiel.eunis.jrfTables.species.sites.SpeciesSitesPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.sites.SitesBean;
import ro.finsiel.eunis.search.species.sites.SitesPaginator;
import ro.finsiel.eunis.search.species.sites.SitesSearchCriteria;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSpeciesSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private SitesBean formBean = null;
  private boolean showInvalidatedSpecies;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   * @param showInvalidatedSpecies Show invalidated species
   */
  public TSVSpeciesSitesReport(String sessionID, AbstractFormBean formBean, boolean showInvalidatedSpecies) {
    super("SpeciesSitesReport_" + sessionID + ".tsv");
    this.formBean = (SitesBean) formBean;
    this.filename = "SpeciesSitesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SpeciesSitesReport_" + sessionID + ".xml");
    this.showInvalidatedSpecies = showInvalidatedSpecies;
    // Init the data factory
    if (null != formBean) {
      Integer searchAttribute = Utilities.checkedStringToInt(((SitesBean) formBean).getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
      boolean[] source_db = { true, true, true, true, true, true, true, true };
      this.dataFactory = new SitesPaginator(new SpeciesSitesDomain(formBean.toSearchCriteria(),
          formBean.toSortCriteria(),
          showInvalidatedSpecies,
          searchAttribute,
          source_db));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    } else {
      System.out.println(TSVSpeciesSitesReport.class.getName() + "::ctor() - Warning: formBean was null!");
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
    // Group
    headers.addElement("Group");
    // Order
    headers.addElement("Order");
    // Family
    headers.addElement("Family");
    // Scientific name
    headers.addElement("Scientific name");
    // Sites
    headers.addElement("Sites names");
    return headers;
  }


  /**
   * Use this method to write specific data into the file. Implemented in inherited classes
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
      Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), SitesSearchCriteria.SEARCH_NAME);
      Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
      boolean[] source_db = { true, true, true, true, true, true, true, true };
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++) {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++) {
          SpeciesSitesPersist specie = (SpeciesSitesPersist) resultSet.get(i);
          Integer idNatureObject = specie.getIdNatureObject();
          List resultsSites = new SpeciesSitesDomain().findSitesWithSpecies(
              new SitesSearchCriteria(searchAttribute,
                  formBean.getScientificName(),
                  relationOp),
              source_db,
              searchAttribute,
              idNatureObject,
              showInvalidatedSpecies);
          String sites = "";
          if (resultsSites.size() > 0) {
            for(int ii=0;ii<resultsSites.size();ii++) {
              List l = (List) resultsSites.get(ii);
              if (ii == 0) {
                Vector<String> aRow = new Vector<String>();
                // Group
                aRow.addElement(specie.getCommonName());
                // Order
                aRow.addElement(specie.getTaxonomicNameOrder());
                // Family
                aRow.addElement(specie.getTaxonomicNameFamily());
                // Scientific name
                aRow.addElement(specie.getScientificName());
                // Sites names
                aRow.addElement(l.get(0) + "(" + l.get(1) + ")");
                writeRow(aRow);
              } else {
                Vector<String> aRow = new Vector<String>();
                // Group
                aRow.addElement("");
                // Order
                aRow.addElement("");
                // Family
                aRow.addElement("");
                // Scientific name
                aRow.addElement("");
                // Sites names
                aRow.addElement(l.get(0) + "(" + l.get(1) + ")");
                writeRow(aRow);
              }
              sites += "<site name=\"" + l.get(0)  + "\" database=\"" + l.get(1) + "\" />";
            }
          } else {
            Vector<String> aRow = new Vector<String>();
            // Group
            aRow.addElement(specie.getCommonName());
            // Order
            aRow.addElement(specie.getTaxonomicNameOrder());
            // Family
            aRow.addElement(specie.getTaxonomicNameFamily());
            // Scientific name
            aRow.addElement(specie.getScientificName());
            // Sites names
            aRow.addElement("-");
            writeRow(aRow);
          }
          Vector<String> aRow = new Vector<String>();
          // Group
          aRow.addElement(specie.getCommonName());
          // Order
          aRow.addElement(specie.getTaxonomicNameOrder());
          // Family
          aRow.addElement(specie.getTaxonomicNameFamily());
          // Scientific name
          aRow.addElement(specie.getScientificName());
          // Sites names
          aRow.addElement(sites);
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
