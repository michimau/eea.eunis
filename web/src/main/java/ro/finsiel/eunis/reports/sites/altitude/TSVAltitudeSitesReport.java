package ro.finsiel.eunis.reports.sites.altitude;

/**
 * Date: May 19, 2003
 * Time: 9:32:23 AM
 */

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.sites.altitude.AltitudeDomain;
import ro.finsiel.eunis.jrfTables.sites.altitude.AltitudePersist;
import ro.finsiel.eunis.reports.AbstractTSVReport;
import ro.finsiel.eunis.reports.XMLReport;
import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.altitude.AltitudeBean;
import ro.finsiel.eunis.search.sites.altitude.AltitudePaginator;

import java.io.IOException;
import java.util.List;
import java.util.Vector;


/**
 * TSV and XML report generation.
 */
public class TSVAltitudeSitesReport extends AbstractTSVReport
{
  /**
   * Form bean used for search.
   */
  private AltitudeBean formBean = null;

  /**
   * Normal constructor.
   *
   * @param sessionID Session ID got from page
   * @param formBean  Form bean queried for output formatting (DB query, sort criterias etc)
   */
  public TSVAltitudeSitesReport(String sessionID, AbstractFormBean formBean)
  {
    super("AltitudeSitesReport_" + sessionID + ".tsv");
    this.formBean = (AltitudeBean) formBean;
    this.filename = "AltitudeSitesReport_" + sessionID + ".tsv";
    xmlreport = new XMLReport("AltitudeSitesReport_" + sessionID + ".xml");
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

      SourceDb sourceDb = SourceDb.fromArray(source);

      dataFactory = new AltitudePaginator(new AltitudeDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), sourceDb));
      this.dataFactory.setSortCriteria(formBean.toSortCriteria());
    }
    else
    {
      System.out.println(TSVAltitudeSitesReport.class.getName() + "::ctor() - Warning: formBean was null!");
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
    headers.addElement("Site name");
    // DesignationTypes
    headers.addElement("Designation name");
    // Coordinates
    headers.addElement("Longitude");
    headers.addElement("Latitude");
    // Altitude
    headers.addElement("Mean altitude");
    headers.addElement("Min altitude");
    headers.addElement("Max altitude");
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
        return;
      }
      writeRow(createHeader());
      xmlreport.writeRow(createHeader());
      for (int _currPage = 0; _currPage < _pagesCount; _currPage++)
      {
        List resultSet = dataFactory.getPage(_currPage);
        for (int i = 0; i < resultSet.size(); i++)
        {
          AltitudePersist site = (AltitudePersist) resultSet.get(i);
          String designations = "";
          if (site.getIdDesignation() != null && site.getIdGeoscope() != null)
          {
            designations = SitesSearchUtility.siteDesignationsAsCommaSeparatedString(site.getIdDesignation(), site.getIdGeoscope().toString());
          }
          Vector<String> aRow = new Vector<String>();
          // Source database
          aRow.addElement(SitesSearchUtility.translateSourceDB(site.getSourceDB()));
          // Country
          aRow.addElement(Utilities.formatString(site.getCountry()));
          // Name
          aRow.addElement(Utilities.formatString(site.getName()));
          // DesignationTypes
          aRow.addElement(designations);
          // Coordinates
          aRow.addElement(SitesSearchUtility.formatPDFLongitude(site.getLongitude()));
          aRow.addElement(SitesSearchUtility.formatPDFLatitude(site.getLatitude()));
          // Altitude
          aRow.addElement(Utilities.formatString(site.getAltMean()));
          aRow.addElement(Utilities.formatString(site.getAltMin()));
          aRow.addElement(Utilities.formatString(site.getAltMax()));
          // Year
          aRow.addElement(SitesSearchUtility.parseDesignationYear(site.getYear(), site.getSourceDB()));
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
