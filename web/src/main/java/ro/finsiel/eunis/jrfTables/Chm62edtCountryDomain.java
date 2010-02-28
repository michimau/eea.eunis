package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

import java.util.List;

/**
 * JRF table for CHM62EDT_COUNTRY.
 * @author finsiel
 **/
public class Chm62edtCountryDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtCountryPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_COUNTRY");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_COUNTRY", "getIdCountry", "setIdCountry", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("EUNIS_AREA_CODE", "getEunisAreaCode", "setEunisAreaCode", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("AREA_NAME", "getAreaName", "setAreaName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AREA_NAME_EN", "getAreaNameEnglish", "setAreaNameEnglish", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AREA_NAME_FR", "getAreaNameFrench", "setAreaNameFrench", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ISO_2L", "getIso2l", "setIso2l", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ISO_3L", "getIso3l", "setIso3l", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("ISO_N", "getIsoN", "setIsoN", null, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("ISO_2_WCMC", "getIso2Wcmc", "setIso2Wcmc", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ISO_3_WCMC", "getIso3Wcmc", "setIso3Wcmc", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ISO_3_WCMC_PARENT", "getIso3WcmcParent", "setIso3WcmcParent", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("TEL_CODE", "getTelCode", "setTelCode", null));
    this.addColumnSpec(new StringColumnSpec("AREUCD", "getAreucd", "setAreucd", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("SORT_NUMBER", "getSortNumber", "setSortNumber", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("COUNTRY_TYPE", "getCountryType", "setCountryType", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("SURFACE", "getSurface", "setSurface", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("NGO", "getNgo", "setNgo", null));
    this.addColumnSpec(new IntegerColumnSpec("NUMBER_DESIGN_AREA", "getNumberDesignArea", "setNumberDesignArea", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SOURCE", "getSource", "setSource", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("POLITICAL_STATUS", "getPoliticalStatus", "setPoliticalStatus", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("POPULATION", "getPopulation", "setPopulation", DEFAULT_TO_NULL));
    this.addColumnSpec(new DoubleColumnSpec("POP_DENSITY", "getPopDensity", "setPopDensity", null));
    this.addColumnSpec(new StringColumnSpec("CAPITAL", "getCapital", "setCapital", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CURRENCY_CODE", "getCurrencyCode", "setCurrencyCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CURRENCY_NAME", "getCurrencyName", "setCurrencyName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_MIN", "getLatMin", "setLatMin", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("LAT_MAX", "getLatMax", "setLatMax", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("LONG_MIN", "getLongMin", "setLongMin", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("LONG_MAX", "getLongMax", "setLongMax", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new IntegerColumnSpec("ALT_MIN", "getAltMin", "setAltMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ALT_MAX", "getAltMax", "setAltMax", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("SELECTION", "getSelection", "setSelection", null, REQUIRED));
  }
}