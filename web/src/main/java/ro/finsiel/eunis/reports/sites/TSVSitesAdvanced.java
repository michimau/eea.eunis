package ro.finsiel.eunis.reports.sites;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.formBeans.CombinedSearchBean;
import ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryDomain;
import ro.finsiel.eunis.jrfTables.sites.advanced.DictionaryPersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.advanced.DictionaryPaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;

/**
 * TSV and XML report generation.
 */
public class TSVSitesAdvanced extends AbstractTSVReport
{
  /**
   * Use the bean in order to see which columns should I display on the report.
   */
  private CombinedSearchBean formBean = null;

  /**
   * Constructor.
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVSitesAdvanced(String sessionID, AbstractFormBean formBean)
  {
    super("SitesAdvancedReport_" + sessionID + ".tsv");
    this.formBean = (CombinedSearchBean) formBean;
    this.filename = "SitesAdvancedReport_" + sessionID + ".tsv";
    this.dataFactory = new DictionaryPaginator(new DictionaryDomain(sessionID));
    this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    xmlreport = new XMLReport("SitesAdvancedReport_" + sessionID + ".xml");
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
    // Source data set
    headers.addElement("Source data set");
    // Site name
    headers.addElement("Site name");
    // Designation type
    headers.addElement("Designation type");
    // Country
    headers.addElement("Country");
    // Designation year
    headers.addElement("Designation year");
    // Longitude
    headers.addElement("Longitude");
    // Latitude
    headers.addElement("Latitude");
    // Size
    headers.addElement("Size");
    // Length
    headers.addElement("Length");
    // Min. altitude
    headers.addElement("Min. altitude");
    // Max. altitude
    headers.addElement("Max. altitude");
    // Mean altitude
    headers.addElement("Mean altitude");
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
          DictionaryPersist site = (DictionaryPersist) resultSet.get(i);
          String designations = Utilities.formatString(site.getDesign());

          Vector<String> row = new Vector<String>();
          // Source data set
          row.addElement(SitesSearchUtility.translateSourceDB(site.getSourceDB()));
          // Site name
          row.addElement(site.getName());
          // Designation type
          row.addElement(designations);
          // Country
          row.addElement(site.getAreaNameEn());
          // Designation year
          row.addElement(SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB()));
          // Longitude
          row.addElement(SitesSearchUtility.formatPDFLongitude(site.getLongitude()));
          // Latitude
          row.addElement(SitesSearchUtility.formatPDFLatitude(site.getLatitude()));
          // Size
          row.addElement(Utilities.formatAreaPDF(site.getArea(), 5, 2, ""));
          // Length
          row.addElement(Utilities.formatAreaPDF(site.getLength(), 5, 2, ""));
          // Min. altitude
          row.addElement(Utilities.formatString(site.getAltMin()));
          // Max. altitude
          row.addElement(Utilities.formatString(site.getAltMax()));
          // Mean altitude
          row.addElement(Utilities.formatString(site.getAltMean()));
          writeRow(row);
          xmlreport.writeRow(row);
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
