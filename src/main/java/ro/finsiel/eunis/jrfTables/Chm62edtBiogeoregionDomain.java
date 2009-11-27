package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

import java.util.List;

/**
 * JRF table for CHM62EDT_BIOGEOREGION.
 * @author finsiel
 **/
public class Chm62edtBiogeoregionDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtBiogeoregionPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_BIOGEOREGION");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_BIOGEOREGION", "getIdBiogeoregion", "setIdBiogeoregion", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CODE", "getBiogeoregionCode", "setBiogeoregionCode", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CODE_EEA", "getBiogeoregionCodeEea", "setBiogeoregionCodeEea", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NAME", "getBiogeoregionName", "setBiogeoregionName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new ShortColumnSpec("SELECTION", "getSelection", "setSelection", null, REQUIRED));
  }
}