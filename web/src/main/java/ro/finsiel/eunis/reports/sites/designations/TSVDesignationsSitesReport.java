package ro.finsiel.eunis.reports.sites.designations;

/**
 * Date: Jul 9, 2003
 * Time: 3:44:13 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.designations.DesignationsDomain;
import ro.finsiel.eunis.jrfTables.sites.designations.DesignationsPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.designations.DesignationsBean;
import ro.finsiel.eunis.search.sites.designations.DesignationsPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * TSV and XML report generation.
 */
public class TSVDesignationsSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private DesignationsBean formBean = null;

  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVDesignationsSitesReport(String sessionID, AbstractFormBean formBean)
  {
    super("DesignationsSitesReport_" + sessionID + ".tsv");
    this.formBean = (DesignationsBean) formBean;
    this.filename = "DesignationsSitesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("DesignationsSitesReport_" + sessionID + ".xml");
    // Init the data factory
    if (null != formBean)
    {
      boolean[] source =
          {
              this.formBean.getDB_NATURA2000() != null,
              this.formBean.getDB_CORINE() != null,
              this.formBean.getDB_DIPLOMA() != null,
              this.formBean.getDB_CDDA_NATIONAL() != null,
              this.formBean.getDB_CDDA_INTERNATIONAL() != null,
              this.formBean.getDB_BIOGENETIC() != null,
              false,
              this.formBean.getDB_EMERALD() != null
          };
      dataFactory = new DesignationsPaginator(new DesignationsDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), source));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVDesignationsSitesReport.class.getName() + "::ctor() -> Warning: formBean was null!");
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
    // Source database
    headers.addElement("Source data set");
    // Country
    headers.addElement("Country");
    // Designation
    headers.addElement("Designation name");
    // DesignationEn
    headers.addElement("English designation name");
    // Abreviation
    headers.addElement("Abbreviation");
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
        // Write data row by row
        for (int i = 0; i < resultSet.size(); i++)
        {
          // Retrieve a site
          DesignationsPersist designation = (DesignationsPersist) resultSet.get(i);
          Vector<String> aRow = new Vector<String>();
          // Source data set
          aRow.addElement(SitesSearchUtility.translateSourceDB(designation.getDataSet()));
          // Country
          aRow.addElement(Utilities.formatString(designation.getCountry()));
          // Designation
          aRow.addElement(Utilities.formatString(designation.getDescription()));
          // DesignationEn
          aRow.addElement(Utilities.formatString(designation.getDescriptionEn()));
          // Abbreviation
          aRow.addElement(Utilities.formatString(designation.getAbbreviation()));
          writeRow(aRow);
          xmlreport.writeRow(createHeader());
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
