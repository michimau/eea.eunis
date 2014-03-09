package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;

/**
 * Date: Oct 15, 2003
 * Time: 10:39:28 AM
 */
public class SitesDesignationsDomain extends AbstractDomain {

  public PersistentObject newPersistentObject() {
    return new SitesDesignationsPersist();
  }

  /****/
  public void setup() {

    this.setTableName("CHM62EDT_SITES");
    this.setReadOnly(true);
    //sites-designations fields
    this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    //designations fields
    this.addColumnSpec(new StringColumnSpec("ID_DESIGNATION", "getIdDesignation", "setIdDesignation", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION_EN", "getDescriptionEn", "setDescriptionEn", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION_FR", "getDescriptionFr", "setDescriptionFr", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AREA_NAME_EN", "getAreaName", "setAreaName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ORIGINAL_DATASOURCE", "getDataSource", "setDataSource", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NATIONAL_CATEGORY", "getNationalCategory", "setNationalCategory", DEFAULT_TO_NULL));
  }
}
