package ro.finsiel.eunis.search.sites;

import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist;
import ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SitesDesignationsDomain;
import ro.finsiel.eunis.search.Utilities;

import java.util.List;
import java.util.Vector;

/**
 * Utility class used in sites search.
 *
 * @author finsiel
 */
public class SitesSearchUtility
{
  /**
   * Number for sites allowed to be displayed simultaneously in a map.
   */
  public static int SITES_PER_MAP = 300;

  /**
   * Parse date according to database type.
   *
   * @param date     Year to be parsed.
   * @param sourceDB Source DB.
   * @return Year.
   */
  public static String parseDesignationYear( String date, String sourceDB )
  {
    String ret = date;
    if ( date == null ) return "";
    if( sourceDB.equalsIgnoreCase( "CDDA_NATIONAL" ) )
    {
      if ( date.lastIndexOf( "/" ) < 0 && date.length() > 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "BIOGENETIC" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "CDDA_INTERNATIONAL" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( date.length() - 4, date.length() );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "CORINE" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "NATURA2000" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "DIPLOMA" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "NATURENET" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    if ( sourceDB.equalsIgnoreCase( "EMERALD" ) )
    {
      if ( date.length() >= 4 )
      {
        ret = date.substring( 0, 4 );
      }
    }
    return ret;
  }

  /**
   * Retrieve the list of designation matching a criterion.<br />
   * This method implements: SELECT * FROM CHM62EDT_DESIGNATIONS WHERE sql LIMIT 0, Utilities.MAX_POPUP_RESULTS.
   *
   * @param where SQL where.
   * @return A list of Chm62edtDesignationsPersist objects.
   */
  public static List findDesignationsWhere( String where )
  {
    List results = new Vector();
    String sql = where;
    sql += " LIMIT 0, " + Utilities.MAX_POPUP_RESULTS;
    try
    {
      results = new Chm62edtDesignationsDomain().findWhere( sql );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Format the coordinates displayed within web page.
   *
   * @param latNS   Latitude (N or S)
   * @param latDeg  Latitude in degrees.
   * @param latMin  Latitude in minutes.
   * @param latSec  Latitude in seconds.
   * @param longEW  Longitude (E or W).
   * @param longDeg Longitude in degrees.
   * @param longMin Longitude in minutes.
   * @param longSec Longitude in seconds.
   * @return Formatted coordinates.
   * @deprecated by formatCoordinates(String longitudeLatitude, String degrees, String minutes, String seconds)
   */
  public static String formatCoordinates( String latNS, String latDeg, String latMin, String latSec,
                                          String longEW, String longDeg, String longMin, String longSec )
  {
    if ( ( null != latNS && latNS.equalsIgnoreCase( "-1" ) ) || ( null != latDeg && latDeg.equalsIgnoreCase( "-1" ) ) ||
        ( null != latMin && latMin.equalsIgnoreCase( "-1" ) ) || ( null != latSec && latSec.equalsIgnoreCase( "-1" ) ) ||
        ( null != longEW && longEW.equalsIgnoreCase( "-1" ) ) || ( null != longDeg && longDeg.equalsIgnoreCase( "-1" ) ) ||
        ( null != longMin && longMin.equalsIgnoreCase( "-1" ) ) || ( null != longSec && longSec.equalsIgnoreCase( "-1" ) ) )
    {
      return "n/a&nbsp;";
    }

    // IF LONG_EW == NULL && LONG_DEG == 0 RETURN EMPTY STRING
    if ( null == longEW && ( null != longDeg && longDeg.equalsIgnoreCase( "0" ) ) )
    {
      return "n/a&nbsp;";
    }
    // IF LAT_NS == NULL && LAT_DEG == 0 RETURN EMPTY STRING
    if ( null == latNS && ( null != latDeg && latDeg.equalsIgnoreCase( "0" ) ) )
    {
      return "n/a&nbsp;";
    }

    // IF ALL THREE FIELDS ARE 0 RETURN ""
    int iLatDeg = Utilities.checkedStringToInt( latDeg, 0 );
    int iLatMin = Utilities.checkedStringToInt( latMin, 0 );
    int iLatSec = Utilities.checkedStringToInt( latSec, 0 );
    if ( 0 == iLatDeg && 0 == iLatMin && 0 == iLatSec )
    {
      return "n/a&nbsp;";
    }
    // IF ALL THREE FIELDS ARE 0 RETURN ""
    int iLongDeg = Utilities.checkedStringToInt( longDeg, 0 );
    int iLongMin = Utilities.checkedStringToInt( longMin, 0 );
    int iLongSec = Utilities.checkedStringToInt( longSec, 0 );
    if ( 0 == iLongDeg && 0 == iLongMin && 0 == iLongSec )
    {
      return "n/a&nbsp;";
    }

    StringBuffer ret = new StringBuffer();
    ret.append( "<span style=\"font-family:courier; font-size: 10px\">" );
    // -----------
    ret.append( ( null != longEW && !longEW.equalsIgnoreCase( "n/a" ) ) ? longEW : " " );
    ret.append( " " );
    ret.append( ( null != longDeg ) ? ( ( longDeg.length() == 1 ) ? "&nbsp;" + longDeg : longDeg ) : "&nbsp;&nbsp;" );
    ret.append( "&deg;" );
    ret.append( ( null != longMin ) ? ( ( longMin.length() == 1 ) ? "0" + longMin : longMin ) : "00" );
    ret.append( "'" );
    ret.append( ( null != longSec ) ? ( ( longSec.length() == 1 ) ? "0" + longSec : longSec ) : "00" );
    ret.append( "\"" );
    // -----------
    ret.append( "/" );
    ret.append( ( null != latNS && !latNS.equalsIgnoreCase( "n/a" ) ) ? latNS : " " );
    ret.append( " " );
    ret.append( ( null != latDeg ) ? ( ( latDeg.length() == 1 ) ? "&nbsp;" + latDeg : latDeg ) : "&nbsp;&nbsp;" );
    ret.append( "&deg;" );
    ret.append( ( null != latMin ) ? ( ( latMin.length() == 1 ) ? "0" + latMin : latMin ) : "00" );
    ret.append( "'" );
    ret.append( ( null != latSec ) ? ( ( latSec.length() == 1 ) ? "0" + latSec : latSec ) : "00" );
    ret.append( "\"" );
    ret.append( "</span>" );
    return ret.toString();
  }

  /**
   * This is the final method for formatting coordinates.
   *
   * @param longitudeOrLatitude Longitude or latitude ((E or W) or (N or S)).
   * @param degrees             Longitude/Latitude in degrees.
   * @param minutes             Longitude/Latitude in minutes.
   * @param seconds             Longitude/Latitude in seconds.
   * @return Formatted coordinates.
   */
  public static String formatCoordinates( String longitudeOrLatitude, String degrees, String minutes, String seconds )
  {
    if ( ( ( null != longitudeOrLatitude && longitudeOrLatitude.equalsIgnoreCase( "-1" ) ) || ( null != degrees && degrees.equalsIgnoreCase( "-1" ) ) ) ||
        ( ( null != minutes && minutes.equalsIgnoreCase( "-1" ) ) || ( null != seconds && seconds.equalsIgnoreCase( "-1" ) ) ) )
    {
      return "n/a";
    }

    // IF LONG_EW == NULL && LONG_DEG == 0 RETURN EMPTY STRING
    if ( null == longitudeOrLatitude && ( null != degrees && degrees.equalsIgnoreCase( "0" ) ) )
    {
      return "n/a";
    }

    // IF ALL THREE FIELDS ARE 0 RETURN ""
    int iDegrees = Utilities.checkedStringToInt( degrees, 0 );
    int iMinutes = Utilities.checkedStringToInt( minutes, 0 );
    int iSeconds = Utilities.checkedStringToInt( seconds, 0 );
    if ( 0 == iDegrees && 0 == iMinutes && 0 == iSeconds )
    {
      return "n/a";
    }

    StringBuffer ret = new StringBuffer();
    ret.append( "<span class=\"coordinates\">" );
    // -----------
    ret.append( ( null != longitudeOrLatitude && !longitudeOrLatitude.equalsIgnoreCase( "n/a" ) ) ? longitudeOrLatitude : " " );
    ret.append( " " );
    ret.append( ( null != degrees ) ? ( ( degrees.length() == 1 ) ? "&nbsp;" + degrees : degrees ) : "&nbsp;&nbsp;" );
    ret.append( "&deg;" );
    ret.append( ( null != minutes ) ? ( ( minutes.length() == 1 ) ? "0" + minutes : minutes ) : "00" );
    ret.append( "'" );
    ret.append( ( null != seconds ) ? ( ( seconds.length() == 1 ) ? "0" + seconds : seconds ) : "00" );
    ret.append( "\"" );
    ret.append( "</span>" );
    return ret.toString();
  }

  /**
   * Format coordinates for PDF reports.
   *
   * @param longitudeOrLatitude Longitude or latitude ((E or W) or (N or S)).
   * @param degrees             Longitude/Latitude in degrees.
   * @param minutes             Longitude/Latitude in minutes.
   * @param seconds             Longitude/Latitude in seconds.
   * @return Formatted coordinates.
   */
  public static String formatCoordinatesPDF( String longitudeOrLatitude, String degrees, String minutes, String seconds )
  {
    if ( ( ( null != longitudeOrLatitude && longitudeOrLatitude.equalsIgnoreCase( "-1" ) ) || ( null != degrees && degrees.equalsIgnoreCase( "-1" ) ) ) ||
        ( ( null != minutes && minutes.equalsIgnoreCase( "-1" ) ) || ( null != seconds && seconds.equalsIgnoreCase( "-1" ) ) ) )
    {
      return "";
    }

    // IF LONG_EW == NULL && LONG_DEG == 0 RETURN EMPTY STRING
    if ( null == longitudeOrLatitude && ( null != degrees && degrees.equalsIgnoreCase( "0" ) ) )
    {
      return "";
    }

    // IF ALL THREE FIELDS ARE 0 RETURN ""
    int iDegrees = Utilities.checkedStringToInt( degrees, 0 );
    int iMinutes = Utilities.checkedStringToInt( minutes, 0 );
    int iSeconds = Utilities.checkedStringToInt( seconds, 0 );
    if ( 0 == iDegrees && 0 == iMinutes && 0 == iSeconds )
    {
      return "";
    }

    StringBuffer ret = new StringBuffer();

    // -----------
    ret.append( ( null != longitudeOrLatitude && !longitudeOrLatitude.equalsIgnoreCase( "n/a" ) ) ? longitudeOrLatitude : " " );
    ret.append( " " );
    ret.append( ( null != degrees ) ? ( ( degrees.length() == 1 ) ? " " + degrees : degrees ) : "  " );
    ret.append( "°" );
    ret.append( ( null != minutes ) ? ( ( minutes.length() == 1 ) ? "0" + minutes : minutes ) : "00" );
    ret.append( "'" );
    ret.append( ( null != seconds ) ? ( ( seconds.length() == 1 ) ? "0" + seconds : seconds ) : "00" );
    ret.append( "\"" );

    return ret.toString();
  }

  /**
   * Format the coordinates displayed within factsheet pdf.
   *
   * @param latNS   Latitude (N or S)
   * @param latDeg  Latitude in degrees.
   * @param latMin  Latitude in minutes.
   * @param latSec  Latitude in seconds.
   * @param longEW  Longitude (E or W).
   * @param longDeg Longitude in degrees.
   * @param longMin Longitude in minutes.
   * @param longSec Longitude in seconds.
   * @return Formatted coordinates.
   */
  public static String formatCoordinatesPDF( String latNS, String latDeg, String latMin, String latSec,
                                             String longEW, String longDeg, String longMin, String longSec )
  {
    if ( ( null != latNS && latNS.equalsIgnoreCase( "-1" ) ) || ( null != latDeg && latDeg.equalsIgnoreCase( "-1" ) ) ||
        ( null != latMin && latMin.equalsIgnoreCase( "-1" ) ) || ( null != latSec && latSec.equalsIgnoreCase( "-1" ) ) ||
        ( null != longEW && longEW.equalsIgnoreCase( "-1" ) ) || ( null != longDeg && longDeg.equalsIgnoreCase( "-1" ) ) ||
        ( null != longMin && longMin.equalsIgnoreCase( "-1" ) ) || ( null != longSec && longSec.equalsIgnoreCase( "-1" ) ) )
    {
      return "";
    }

    StringBuffer ret = new StringBuffer();
    // -----------
    ret.append( ( null != longEW && !longEW.equalsIgnoreCase( "n/a" ) ) ? longEW : " " );
    ret.append( " " );
    ret.append( ( null != longDeg ) ? ( ( longDeg.length() == 1 ) ? " " + longDeg : longDeg ) : "  " );
    ret.append( "°" );
    ret.append( ( null != longMin ) ? ( ( longMin.length() == 1 ) ? "0" + longMin : longMin ) : "00" );
    ret.append( "'" );
    ret.append( ( null != longSec ) ? ( ( longSec.length() == 1 ) ? "0" + longSec : longSec ) : "00" );
    ret.append( "\"" );
    // -----------
    ret.append( "/" );
    ret.append( ( null != latNS && !latNS.equalsIgnoreCase( "n/a" ) ) ? latNS : " " );
    ret.append( " " );
    ret.append( ( null != latDeg ) ? ( ( latDeg.length() == 1 ) ? " " + latDeg : latDeg ) : "  " );
    ret.append( "°" );
    ret.append( ( null != latMin ) ? ( ( latMin.length() == 1 ) ? "0" + latMin : latMin ) : "00" );
    ret.append( "'" );
    ret.append( ( null != latSec ) ? ( ( latSec.length() == 1 ) ? "0" + latSec : latSec ) : "00" );
    ret.append( "\"" );
    return ret.toString();
  }

  /**
   * Take the coordinates for a list of sites and put them in a string, separated by comma. Used for retrieve maps
   * from map server.
   *
   * @param sites List of sites (CoordinatesProvider objects).
   * @return String with coordinates separated by comma.
   */
  public static String computeCoordinatesForSites( List sites )
  {
    StringBuffer result = new StringBuffer();
    if ( null == sites || sites.isEmpty() )
    {
      return "";
    }
    for ( int i = 0; i < sites.size(); i++ )
    {
      CoordinatesProvider site = ( CoordinatesProvider ) sites.get( i );
      String coordinate = getCoordinateForSite( site );
      if ( null != coordinate )
      {
        result.append( coordinate );
        String siteName = site.getName();
        if ( siteName.length() > 5 )
        {
          siteName = siteName.substring( 0, 5 ) + "...";
        }
        result.append( ":-2:" + siteName );
        if ( i < sites.size() - 1 )
        {
          result.append( "," );
        }
      }
    }
    return result.toString();
  }

  /**
   * format the coordinates for a single site (in the format Latitude:Longitude).
   *
   * @param site Site.
   * @return Formated coordinate.
   */
  public static String getCoordinateForSite( CoordinatesProvider site )
  {
    Utilities.startTimer();
    String result = null;
    int latSign = 1;
    int longSign = 1;
    latSign = ( null == site.getLatNS() || site.getLatNS().length() == 0 ) ? 1 : -1;
    longSign = ( null == site.getLongEW() || site.getLongEW().length() == 0 ) ? 1 : -1;
    String latDeg = "";
    String longDeg = "";
    // Decimal coordinates
    if ( latSign == -1 )
    {
      latDeg += "-" + latDeg;
    }
    if ( longSign == -1 )
    {
      longDeg += "-" + longDeg;
    }
    if ( null != site.getLongitude() && site.getLongitude().length() > 0 && !site.getLongitude().equalsIgnoreCase( "n/a" ) )
    {
      longDeg = site.getLongitude();
      if ( null != site.getLatitude() && site.getLatitude().length() > 0 && !site.getLatitude().equalsIgnoreCase( "n/a" ) )
      {
        latDeg = site.getLatitude();
        result = "" + longDeg.substring( 0, 5 ) + ":" + latDeg.substring( 0, 5 );
        return result;
      }
    }
    //
    if ( null != site.getLatDeg() && !site.getLatDeg().equalsIgnoreCase( "-1" ) && site.getLatDeg().equalsIgnoreCase( "n/a" ) )
    {
      if ( null != site.getLatMin() && !site.getLatMin().equalsIgnoreCase( "-1" ) && site.getLatMin().equalsIgnoreCase( "n/a" ) )
      {
        if ( null != site.getLatSec() && !site.getLatSec().equalsIgnoreCase( "-1" ) && site.getLatSec().equalsIgnoreCase( "n/a" ) )
        {
          if ( null != site.getLongDeg() && !site.getLongDeg().equalsIgnoreCase( "-1" ) && site.getLongDeg().equalsIgnoreCase( "n/a" ) )
          {
            if ( null != site.getLongMin() && !site.getLongMin().equalsIgnoreCase( "-1" ) && site.getLongMin().equalsIgnoreCase( "n/a" ) )
            {
              if ( null != site.getLongSec() && !site.getLongSec().equalsIgnoreCase( "-1" ) && site.getLongSec().equalsIgnoreCase( "n/a" ) )
              {
                int LatDeg = Utilities.checkedStringToInt( site.getLatDeg(), 0 );
                int LatMin = Utilities.checkedStringToInt( site.getLatMin(), 0 );
                int LatSec = Utilities.checkedStringToInt( site.getLatSec(), 0 );
                int LongDeg = Utilities.checkedStringToInt( site.getLongDeg(), 0 );
                int LongMin = Utilities.checkedStringToInt( site.getLongMin(), 0 );
                int LongSec = Utilities.checkedStringToInt( site.getLongSec(), 0 );
                latDeg = "" + ( ( float ) LatDeg + ( LatMin / 60F ) + ( LatSec / 3600F ) );
                longDeg = "" + ( ( float ) LongDeg + ( LongMin / 60F ) + ( LongSec / 3600F ) );
                result = "" + longDeg.substring( 0, 5 ) + ":" + latDeg.substring( 0, 5 );
                return result;
              }
            }
          }
        }
      }
    }
    return result;
  }

  /**
   * Translate the SOURCE_DB field from CHM62EDT_SITES in human readable language.
   *
   * @param sourceDB Source db.
   * @return Source database.
   */
  public static String translateSourceDB( String sourceDB )
  {
    if ( null == sourceDB )
    {
      return "n/a";
    }
    String result = sourceDB.replaceAll( "CDDA_NATIONAL", "CDDA National" ).replaceAll( "CDDA_INTERNATIONAL", "CDDA International" ).replaceAll( "NATURA2000", "Natura 2000" ).replaceAll( "CORINE", "Corine" ).replaceAll( "DIPLOMA", "European diploma" ).replaceAll( "BIOGENETIC", "Biogenetic reserves" ).replaceAll( "NATURENET", "NatureNet" ).replaceAll( "EMERALD", "Emerald" );
    return result;
  }

  /**
   * Translate the SOURCE_DB field from CHM62EDT_SITES in SQL compatible language.
   *
   * @param sourceDB The source database in human language
   * @return The string identifying the DB within database (ie. CDDA National corresponds to CDDA_NATIONAL).
   */
  public static String translateSourceDBInvert( String sourceDB )
  {
    if ( null == sourceDB )
    {
      return sourceDB;
    }
    if ( sourceDB.equalsIgnoreCase( "CDDA National" ) )
    {
      return "CDDA_NATIONAL";
    }
    if ( sourceDB.equalsIgnoreCase( "CDDA International" ) )
    {
      return "CDDA_INTERNATIONAL";
    }
    if ( sourceDB.equalsIgnoreCase( "Natura 2000" ) )
    {
      return "NATURA2000";
    }
    if ( sourceDB.equalsIgnoreCase( "Corine biotopes" ) )
    {
      return "CORINE";
    }
    if ( sourceDB.equalsIgnoreCase( "European diploma" ) )
    {
      return "DIPLOMA";
    }
    if ( sourceDB.equalsIgnoreCase( "Biogenetic reserve" ) )
    {
      return "BIOGENETIC";
    }
    if ( sourceDB.equalsIgnoreCase( "NatureNet" ) )
    {
      return "NATURENET";
    }
    if ( sourceDB.equalsIgnoreCase( "Emerald" ) )
    {
      return "EMERALD";
    }
    return sourceDB;
  }

  /**
   * Compute the distance between two sites.
   *
   * @param site1 Site 1
   * @param site2 Site 2
   * @return Distance.
   */
  public static float distanceBetweenSites( Chm62edtSitesPersist site1, Chm62edtSitesPersist site2 )
  {
    float site1X = Utilities.checkedStringToFloat( site1.getLongitude(), 0 );
    float site2X = Utilities.checkedStringToFloat( site2.getLongitude(), 0 );
    float site1Y = Utilities.checkedStringToFloat( site1.getLatitude(), 0 );
    float site2Y = Utilities.checkedStringToFloat( site2.getLatitude(), 0 );

    float xDelta = ( Math.abs( site2X - site1X ) );
    float yDelta = ( Math.abs( site2Y - site1Y ) );
    float distance = ( xDelta * xDelta ) + ( yDelta * yDelta );
    distance = ( float ) Math.sqrt( distance );
    return distance * 115;
  }

  /**
   * This method finds the designation for a site, given its IdDesignation and IdGeoscope.<br />
   * This method also filters invalid designations names (those who have the DESCRIPTION column empty).
   * <br />
   * Implementing SQL is:
   * <br />
   * SELECT * FROM CHM62EDT_DESIGNATIONS B" +
   * WHERE B.ID_DESIGNATION='" + idDesignation + "' AND B.ID_GEOSCOPE=" + idGeoscope + " ORDER BY B.DESCRIPTION, B.DESCRIPTION_EN, B.DESCRIPTION_FR";
   *
   * @param idDesignation idDesignation of his designation.
   * @param idGeoscope    idGeoscope of his designation.
   * @return A list of Chm62edtDesignationsPersist objects.
   */
  public static List findDesignationsForSite( String idDesignation, String idGeoscope )
  {
    List results = new Vector();
    String listFields = "ID_DESIGNATION,ID_GEOSCOPE,ID_DC,DESCRIPTION,DESCRIPTION_EN,DESCRIPTION_FR,ORIGINAL_DATASOURCE," +
        "CDDA_SITES,REFERENCE_AREA,TOTAL_AREA,NATIONAL_LAW,NATIONAL_CATEGORY,NATIONAL_LAW_REFERENCE,NATIONAL_LAW_AGENCY," +
        "DATA_SOURCE,TOTAL_NUMBER,REFERENCE_NUMBER,REFERENCE_DATE,REMARK,REMARK_SOURCE";
    String sql = "SELECT " + listFields + " FROM CHM62EDT_DESIGNATIONS B" +
        " WHERE B.ID_DESIGNATION='" + idDesignation + "' AND B.ID_GEOSCOPE=" + idGeoscope + " ORDER BY B.DESCRIPTION, B.DESCRIPTION_EN, B.DESCRIPTION_FR";
    try
    {
      results = new Chm62edtDesignationsDomain().findCustom( sql );
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    List tempList = new Vector();
    // Remove the invalid designations
    for ( int i = 0; i < results.size(); i++ )
    {
      Chm62edtDesignationsPersist designation = ( Chm62edtDesignationsPersist ) results.get( i );
      if ( !designation.getDescription().equalsIgnoreCase( "" ) ||
          !designation.getDescriptionEn().equalsIgnoreCase( "" ) ||
          !designation.getDescriptionFr().equalsIgnoreCase( "" ) )
      {
        tempList.add( designation );
      }
    }
    results = tempList;
    return results;
  }

  public static String siteDesignationsAsCommaSeparatedString( String idDesignation, String idGeoscope )
  {
    List results = new Vector();
    String listFields = "ID_DESIGNATION,ID_GEOSCOPE,ID_DC,DESCRIPTION,DESCRIPTION_EN,DESCRIPTION_FR,ORIGINAL_DATASOURCE," +
        "CDDA_SITES,REFERENCE_AREA,TOTAL_AREA,NATIONAL_LAW,NATIONAL_CATEGORY,NATIONAL_LAW_REFERENCE,NATIONAL_LAW_AGENCY," +
        "DATA_SOURCE,TOTAL_NUMBER,REFERENCE_NUMBER,REFERENCE_DATE,REMARK,REMARK_SOURCE";
    String sql = "SELECT " + listFields + " FROM CHM62EDT_DESIGNATIONS B" +
        " WHERE B.ID_DESIGNATION='" + idDesignation + "' AND B.ID_GEOSCOPE=" + idGeoscope + " ORDER BY B.DESCRIPTION, B.DESCRIPTION_EN, B.DESCRIPTION_FR";
    try
    {
      results = new Chm62edtDesignationsDomain().findCustom( sql );
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
    }
    String result = "";
    for ( int i = 0; i < results.size(); i++ )
    {
      Chm62edtDesignationsPersist designation = ( Chm62edtDesignationsPersist ) results.get( i );

      if ( !designation.getDescription().equals( "" ) )
      {
        result += designation.getDescription();
      }
      else if ( !designation.getDescriptionEn().equalsIgnoreCase( "" ) )
      {
        result += designation.getDescriptionEn();
      }
      else if ( !designation.getDescriptionFr().equalsIgnoreCase( "" ) )
      {
        result += designation.getDescriptionFr();
      }
      if ( i < results.size() - 1 )
      {
        result += ",";
      }
    }
    return result;
  }


  /**
   * Find sites specified by a designation.
   *
   * @param idDesignation ID_DESIGNATION.
   * @param geoscope      Country ID_GEOSCOPE (three letters).
   * @return List of DesignationPersist objects.
   */
  public static List findSitesForDesignation( String idDesignation, String geoscope )
  {
    List result = new Vector();
    try
    {
      List tempList = new DesignationDomain().findWhere( " J.ID_DESIGNATION='" + idDesignation +
          "' AND J.ID_GEOSCOPE=" + geoscope +
          " AND J.ID_GEOSCOPE=C.ID_GEOSCOPE" +
          " GROUP BY C.ID_NATURE_OBJECT,G.AREA_NAME_EN" );
      if ( tempList != null && tempList.size() > 0 )
      {
        result = tempList;
      }
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Find designations for a site (displayed in factsheet).
   *
   * @param idSite ID_SITE.
   * @return List of SitesDesignationsPersist.
   */
  public static List findDesignationsForSitesFactsheet( String idSite )
  {
    List result = new Vector();
    try
    {
      List tempList = new SitesDesignationsDomain().findCustom( "SELECT A.ID_SITE, A.ID_DESIGNATION," +
          " B.DESCRIPTION,B.DESCRIPTION_EN,B.DESCRIPTION_FR,C.AREA_NAME_EN,B.ORIGINAL_DATASOURCE,A.ID_GEOSCOPE" +
          " FROM CHM62EDT_SITES AS A" +
          " INNER JOIN CHM62EDT_DESIGNATIONS AS B ON (A.ID_DESIGNATION = B.ID_DESIGNATION AND A.ID_GEOSCOPE = B.ID_GEOSCOPE)" +
          " INNER JOIN CHM62EDT_COUNTRY AS C ON (A.ID_GEOSCOPE = C.ID_GEOSCOPE)" +
          " WHERE A.ID_SITE = '" + idSite + "'" +
          " GROUP BY A.ID_DESIGNATION,C.AREA_NAME_EN,B.DESCRIPTION" );
      if ( tempList != null && tempList.size() > 0 )
      {
        result = tempList;
      }
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }
    return result;
  }
}