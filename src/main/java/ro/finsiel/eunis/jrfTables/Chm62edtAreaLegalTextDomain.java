package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * JRF table for CHM62EDT_AREA_LEGAL_TEXT outer join CHM62EDT_LEGAL_AREA_EVENT inner join CHM62EDT_COUNTRY.
 * @author finsiel
 **/
public class Chm62edtAreaLegalTextDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtAreaLegalTextPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_AREA_LEGAL_TEXT");
    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                    new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)
            )
    );
    this.addColumnSpec(new StringColumnSpec("LEGAL_DATE", "getLegalDate", "setLegalDate", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_LEGAL_AREA_EVENT", "getIdLegalAreaEvent", "setIdLegalAreaEvent", DEFAULT_TO_ZERO));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("INPUT_DATE", "getInputDate", "setInputDate", DEFAULT_TO_NULL));

    OuterJoinTable legalAreaEvent = new OuterJoinTable("CHM62EDT_LEGAL_AREA_EVENT", "ID_LEGAL_AREA_EVENT", "ID_LEGAL_AREA_EVENT");
    legalAreaEvent.addJoinColumn(new StringJoinColumn("NAME", "setName"));
    this.addJoinTable(legalAreaEvent);

    JoinTable country = new JoinTable("CHM62EDT_COUNTRY", "ID_GEOSCOPE", "ID_GEOSCOPE");
    country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
    country.addJoinColumn(new StringJoinColumn("ISO_2_WCMC", "setIso2Wcmc"));
    country.addJoinColumn(new StringJoinColumn("ISO_2L", "setIso2l"));
    this.addJoinTable(country);
  }
}