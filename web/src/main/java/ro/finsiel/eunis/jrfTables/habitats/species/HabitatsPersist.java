package ro.finsiel.eunis.jrfTables.habitats.species;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: Sep 17, 2003
 * Time: 11:01:37 AM
 */
public class HabitatsPersist extends PersistentObject {
  private Integer idNatureObject = null;

  ///
  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
  }
}
