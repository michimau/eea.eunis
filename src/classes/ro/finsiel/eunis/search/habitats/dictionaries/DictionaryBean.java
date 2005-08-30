/**
 * Date: Apr 4, 2003
 * Time: 2:19:24 PM
 */
package ro.finsiel.eunis.search.habitats.dictionaries;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.jrfTables.*;

import java.util.Vector;
import java.util.List;

public class DictionaryBean extends AbstractFormBean {
  public static final int DATABASE_EUNIS = 0;
  public static final int DATABASE_ANNEX = 1;

  public static final int DICT_ALTITUDE = 0;
  public static final int DICT_CHEMISTRY = 1;
  public static final int DICT_CLIMATE = 2;
  public static final int DICT_COVERAGE = 3;
  public static final int DICT_HUMIDITY = 4;
  public static final int DICT_IMPACT = 5;
  public static final int DICT_LIGHT = 6;
  public static final int DICT_PH = 7;
  public static final int DICT_LIFEFORM = 8;
  public static final int DICT_TEMPERATURE = 9;
  public static final int DICT_USAGE = 10;
  public static final int DICT_WATER = 11;
  public static final int DICT_SUBSTRATE = 12;

  public static final int OP_EQUALS = 0;
  public static final int OP_BETWEEN = 1;

  private String selectDatabase = null;
  private String selectDictionary = null;
  private String selectOp = null;
  private String searchVal = null;
  private String searchValMin = null;
  private String searchValMax = null;

  /**
   *
   * @return
   */
  public String getDictionaryHuman() {
    String ret = "n/a";
    int dictionary = Utilities.checkedStringToInt(getSelectDictionary(), DICT_ALTITUDE);
    switch (dictionary) {
      case DICT_ALTITUDE:
        ret = "Altitude";
        break;
      case DICT_CHEMISTRY:
        ret = "Chemistry";
        break;
      case DICT_CLIMATE:
        ret = "Climate";
        break;
      case DICT_COVERAGE:
        ret = "Coverage";
        break;
      case DICT_HUMIDITY:
        ret = "Humidity";
        break;
      case DICT_IMPACT:
        ret = "Impact";
        break;
      case DICT_LIGHT:
        ret = "Light";
        break;
      case DICT_PH:
        ret = "pH (Acidity)";
        break;
      case DICT_LIFEFORM:
        ret = "Life form";
        break;
      case DICT_TEMPERATURE:
        ret = "Temperature";
        break;
      case DICT_USAGE:
        ret = "Usage";
        break;
      case DICT_WATER:
        ret = "Water";
        break;
      case DICT_SUBSTRATE:
        ret = "Substrate";
        break;
    }
    return ret;
  }

  /**
   *
   * @param dictionary
   * @return
   */
  public List getDictionaryValues(int dictionary) {
    List results = new Vector();
    try {
      switch (dictionary) {
        case DICT_ALTITUDE:
          results = new Chm62edtAltitudeDomain().findAll();
          break;
        case DICT_CHEMISTRY:
          results = new Chm62edtChemistryDomain().findAll();
          break;
        case DICT_CLIMATE:
          results = new Chm62edtClimateDomain().findAll();
          break;
        case DICT_COVERAGE:
          results = new Chm62edtCoverDomain().findAll();
          break;
        case DICT_HUMIDITY:
          results = new Chm62edtHumidityDomain().findAll();
          break;
        case DICT_IMPACT:
          results = new Chm62edtImpactDomain().findAll();
          break;
        case DICT_LIGHT:
          results = new Chm62edtLightIntensityDomain().findAll();
          break;
        case DICT_PH:
          results = new Chm62edtPhDomain().findAll();
          break;
        case DICT_LIFEFORM:
          results = new Chm62edtLifeFormDomain().findAll();
          break;
        case DICT_TEMPERATURE:
          results = new Chm62edtTemperatureDomain().findAll();
          break;
        case DICT_USAGE:
          results = new Chm62edtUsageDomain().findAll();
          break;
        case DICT_WATER:
          results = new Chm62edtWaterDomain().findAll();
          break;
        case DICT_SUBSTRATE:
          results = new Chm62edtSubstrateDomain().findAll();
          break;
      }
    } catch (Exception ex) {
      ex.printStackTrace(System.err);
      results = new Vector();
    } finally {
      if (null == results) results = new Vector();
      return results;
    }
  }

  /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches...
   * @return  objects which are used for search / filter
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    return new AbstractSearchCriteria[0];
  }

  /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again...
   * @return objects which are used for sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    return new AbstractSortCriteria[0];
  }

  /** This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<
   */
  public String toURLParam(Vector classFields) {
    return null;
  }

  /** This method will transform the request parameters into a form compatible hidden input parameters, for example:
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt
   * @return An form compatible type of representation of request parameters
   */
  public String toFORMParam(Vector classFields) {
    return null;
  }

  public String getSelectDatabase() {
    return selectDatabase;
  }

  public void setSelectDatabase(String selectDatabase) {
    this.selectDatabase = selectDatabase;
  }

  public String getSelectDictionary() {
    return selectDictionary;
  }

  public void setSelectDictionary(String selectDictionary) {
    this.selectDictionary = selectDictionary;
  }

  public String getSelectOp() {
    return selectOp;
  }

  public void setSelectOp(String selectOp) {
    this.selectOp = selectOp;
  }

  public String getSearchVal() {
    return searchVal;
  }

  public void setSearchVal(String searchVal) {
    this.searchVal = searchVal;
  }

  public String getSearchValMin() {
    return searchValMin;
  }

  public void setSearchValMin(String searchValMin) {
    this.searchValMin = searchValMin;
  }

  public String getSearchValMax() {
    return searchValMax;
  }

  public void setSearchValMax(String searchValMax) {
    this.searchValMax = searchValMax;
  }
}
