package ro.finsiel.eunis.jrfTables.sites.statistics;

/**
 * Date: Jul 24, 2003
 * Time: 4:38:47 PM
 */

import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision$ $Date$
 **/
public class CountrySitesFactsheetDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new CountrySitesFactsheetPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_COUNTRY_SITES_FACTSHEET");
    this.setReadOnly(true);


    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("AREA_NAME_EN", "getCountry", "setCountry", DEFAULT_TO_NULL)

            )
    );


    this.addColumnSpec(new StringColumnSpec("NUMBER_OF_SITES", "getNumberOfSites", "setNumberOfSites", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NUMBER_OF_SPECIES", "getNumberOfSpecies", "setNumberOfSpecies", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NUMBER_OF_HABITATS", "getNumberOfHabitats", "setNumberOfHabitats", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NO_SITES_PER_SQUARE_KM", "getPerSquare", "setPerSquare", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("PROCENT_NO_SITES_WITH_SURFACE_AVAILABLE", "getSurfaceAvailable", "setSurfaceAvailable", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("TOTAL_SIZE", "getTotalSize", "setTotalSize", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AVG_SIZE", "getAvgSize", "setAvgSize", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NO_OF_PRIORITY_SITES", "getNoPriority", "setNoPriority", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("TOTAL_SIZE_FOR_PRIORITY_SITES", "getTotalPriority", "setTotalPriority", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("STANDARD_DEVIATION", "getDeviation", "setDeviation", DEFAULT_TO_NULL));


  }
}