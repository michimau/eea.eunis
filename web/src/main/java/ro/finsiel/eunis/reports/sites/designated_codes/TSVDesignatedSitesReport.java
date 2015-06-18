package ro.finsiel.eunis.reports.sites.designated_codes;

/**
 * Date: Jul 10, 2003
 * Time: 3:09:59 PM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationDomain;
import ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.designation_code.DesignationBean;
import ro.finsiel.eunis.search.sites.designation_code.DesignationPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * TSV and XML report generation.
 */
public class TSVDesignatedSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private DesignationBean formBean = null;

  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVDesignatedSitesReport(String sessionID, AbstractFormBean formBean)
  {
    super("DesignatedSitesReport_" + sessionID + ".tsv");
    this.formBean = (DesignationBean) formBean;
    this.filename = "DesignatedSitesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("DesignatedSitesReport_" + sessionID + ".xml");
    // Init the data factory
    if (null != formBean)
    {
      SourceDb sourceDb = ((DesignationBean) formBean).getSourceDb();
      dataFactory = new DesignationPaginator(new DesignationDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), sourceDb));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVDesignatedSitesReport.class.getName() + "::ctor() - Warning: formBean was null!");
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
    // Name
    headers.addElement("Name");
    // DesignationTypes
    headers.addElement("Designation name");
    // Coordinates
    headers.addElement("Longitude");
    headers.addElement("Latitude");
    // Size
    headers.addElement("Size (ha)");
    // Year
    headers.addElement("Designation year");
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
          DesignationPersist site = (DesignationPersist) resultSet.get(i);
          String designations = "";
          if (site.getIdDesign() != null && site.getGeoscope() != null)
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString(site.getIdDesign(), site.getGeoscope());
          }

          Vector<String> aRow = new Vector<String>();
          // Source database
          aRow.addElement(SitesSearchUtility.translateSourceDB(site.getSourceDB()));
          //Country
          aRow.addElement(Utilities.formatString(site.getCountry()));
          // Name
          aRow.addElement(Utilities.formatString(site.getName()));
          // DesignationTypes
          aRow.addElement(designations);
          // Coordinates
          aRow.addElement(SitesSearchUtility.formatPDFLongitude(site.getLongitude()));
          aRow.addElement(SitesSearchUtility.formatPDFLatitude(site.getLatitude()));
          // size
          aRow.addElement(Utilities.formatAreaPDF(site.getArea(), 9, 2, " "));
          // Year
          aRow.addElement(SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB()));
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
