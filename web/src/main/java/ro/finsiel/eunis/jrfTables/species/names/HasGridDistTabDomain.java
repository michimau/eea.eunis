package ro.finsiel.eunis.jrfTables.species.names;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:13 $
 **/
public class HasGridDistTabDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new HasGridDistTabPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    JoinTable Species = null;

    this.setTableName("CHM62EDT_SPECIES");

    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES", "getIdSpecies", "setIdSpecies", DEFAULT_TO_ZERO));
    this.addColumnSpec(new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink", "setIdSpeciesLink", DEFAULT_TO_ZERO));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_EMPTY_STRING));

    Species = new JoinTable("CHM62EDT_TAB_PAGE_SPECIES", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT,GRID_DISTRIBUTION='Y'");
    this.addJoinTable(Species);
    
  }

}