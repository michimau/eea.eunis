package ro.finsiel.eunis.reports.sites.names;

/**
 * Date: Jul 25, 2003
 * Time: 9:14:45 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.names.NameDomain;
import ro.finsiel.eunis.jrfTables.sites.names.NamePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.names.NameBean;
import ro.finsiel.eunis.search.sites.names.NamePaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * TSV and XML report generation.
 */
public class TSVNamesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private NameBean formBean = null;
  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVNamesReport(String sessionID, AbstractFormBean formBean)
  {
    super("SitesNamesReport_" + sessionID + ".tsv");
    this.formBean = (NameBean) formBean;
    this.filename = "SitesNamesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("SitesNamesReport_" + sessionID + ".xml");
    if (null != formBean)
    {
      SourceDb sourceDb = ((NameBean) formBean).getSourceDb();
      dataFactory = new NamePaginator(new NameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), "", sourceDb));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVNamesReport.class.getName() + "::ctor() - Warning: formBean was null!");
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
    // Source data set
    headers.addElement("Source data set");
    // Country
    headers.addElement("Country");
    // Name
    headers.addElement("Name");
    // Designations
    headers.addElement("Designation type");
    // Coordinates
    headers.addElement("Longitude");
    headers.addElement("Latitude");
    // Size
    headers.addElement("Size");
    // Year
    //headers.addElement("Designation year");
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
      if (_pagesCount == 0) // Do not write anything, since there are no results
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
          NamePersist site = (NamePersist) resultSet.get(i);

          String designations = "";
          if (site.getIdDesignation() != null && site.getIdGeoscope() != null)
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString(site.getIdDesignation(), site.getIdGeoscope().toString());
          }
          Vector<String> aRow = new Vector<String>();
          // Source database
          aRow.addElement(SitesSearchUtility.translateSourceDB(site.getSourceDB()));
          // Country
          aRow.addElement(Utilities.formatString(site.getAreaNameEn()));
          // Name
          aRow.addElement(Utilities.formatString(site.getName()));
          // Designations
          aRow.addElement(designations);
          // Coordinates
          aRow.addElement(SitesSearchUtility.formatPDFLongitude(site.getLongitude()));
          aRow.addElement(SitesSearchUtility.formatPDFLatitude(site.getLatitude()));
          // Altitude
          aRow.addElement(Utilities.formatAreaPDF(site.getArea(), 9, 2, ""));
          // Year
          //aRow.addElement(SitesSearchUtility.parseDesignationYear(site.getDesignationDate(), site.getSourceDB()));
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
