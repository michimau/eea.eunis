package ro.finsiel.eunis.search.sites;

/**
 * This interface is used to access objects which encapsulates sites information in order
 * to retrieve their coordinate information (longitude, latitude etc).<br />
 * Generic functions which works with site information will cast persist objects to this interface<br />
 * Persistent objects will implement this interface in order to be used by this methods.
 * @see ro.finsiel.eunis.search.sites.SitesSearchUtility#computeCoordinatesForSites as an example of method which
 * uses this kind of object.
 * @author finsiel
 */
public interface CoordinatesProvider {

  /**
   * Nmae of the site.
   * @return Name of the site.
   */
  public String getName();

  /**
   * Site's latitude (N/S).
   * @return 'N'/'S' or null
   */
  public String getLatNS();

  /**
   * Site's latitude in degrees.
   * @return Numeric value with site's latitude (degrees) information
   */
  public String getLatDeg();

  /**
   * Site's latitude in minutes.
   * @return Numeric value with site's latitude (minutes) information
   */
  public String getLatMin();

  /**
   * Site's latitude in seconds.
   * @return Numeric value with site's latitude (seconds) information
   */
  public String getLatSec();

  /**
   * Site's longitude (E/W).
   * @return 'E'/'W' or null
   */
  public String getLongEW();

  /**
   * Site's lontitude in degrees.
   * @return Numeric value with site's longitude (degrees) information
   */
  public String getLongDeg();

  /**
   * Site's longitude in minutes.
   * @return Numeric value with site's longitude (minutes) information
   */
  public String getLongMin();

  /**
   * Site's longitude in seconds.
   * @return Numeric value with site's longitude (seconds) information
   */
  public String getLongSec();

  /**
   * Site's latitude position in decimal degrees.
   * @return Numeric value with site's latitude information
   */
  public String getLatitude();

  /**
   * Site's longitude position in decimal degrees.
   * @return Numeric value with site's longitude information
   */
  public String getLongitude();
}