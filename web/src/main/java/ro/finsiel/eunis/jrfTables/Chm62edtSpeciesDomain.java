package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

import java.util.List;

/**
 * JRF table for CHM62EDT_SPECIES.
 * @author finsiel
 **/
public class Chm62edtSpeciesDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtSpeciesPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_SPECIES");
    this.setReadOnly(true);

    this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES", "getIdSpecies", "setIdSpecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new ShortColumnSpec("VALID_NAME", "getValidName", "setValidName", null, REQUIRED));
    this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink", "setIdSpeciesLink", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("TYPE_RELATED_SPECIES", "getTypeRelatedSpecies", "setTypeRelatedSpecies", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("TEMPORARY_SELECT", "getTemporarySelect", "setTemporarySelect", null));
    this.addColumnSpec(new StringColumnSpec("SPECIES_MAP", "getSpeciesMap", "setSpeciesMap", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_GROUP_SPECIES", "getIdGroupspecies", "setIdGroupspecies", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("ID_TAXONOMY", "getIdTaxcode", "setIdTaxcode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("GENUS", "getGenus", "setGenus", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("AUTHOR", "getAuthor", "setAuthor", DEFAULT_TO_NULL));
  }

  /**
   * Wrapper for SELECT COUNT(*) FROM CHM62EDT_SPECIES WHERE ID_GROUP_SPECIES=...
   * @param groupID ID_GROUP_SPECIES.
   * @return Number of species from that group.
   */
  public Long countByGroupID(Integer groupID) {
    Long result = new Long(0);
    try
    {
      result =  this.findLong("SELECT COUNT(*) FROM " + this.getTableAlias() + " WHERE ID_GROUP_SPECIES='" + groupID.toString() + "'");
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Wrapper for SELECT DISTINCT * FROM CHM62EDT_SPECIES WHERE...
   * @param whereString WHERE condition.
   * @return List of Chm62edtSpeciesPersist objects.
   */
  public List findWhereDistinct(String whereString) {
    String sql = "SELECT DISTINCT * FROM " + this.getTableAlias() + " ";
    sql = sql + whereString;
    return this.findCustom(sql);
  }

  /**
   * Wrapper for executing custom sql.
   * @param sql SQL.
   * @return List of Chm62edtSpeciesPersist objects.
   */
  public List findCustom(String sql) {
    return super.findCustom(sql);
  }

  /**
   * Wrapper for findLong.
   * @param whereSQL WHERE condition.
   * @return Long.
   */
  public Long countWhere(String whereSQL) {
    return this.findLong(whereSQL);
  }
}