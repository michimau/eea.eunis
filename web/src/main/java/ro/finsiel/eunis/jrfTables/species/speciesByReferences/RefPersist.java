package ro.finsiel.eunis.jrfTables.species.speciesByReferences;

/**
 * Date: Aug 19, 2003
 * Time: 3:52:53 PM
 */

import net.sf.jrf.domain.PersistentObject;

public class RefPersist extends PersistentObject {

    private Integer idSpecies = null;
    private Integer idSpeciesLink = null;
    private Integer idNatureObject = null;
    private String scientificName = null;
    private String groupName = null;
    private String orderName = null;
    private String familyName = null;

    public RefPersist() {
        super();
    }

    public Integer getIdSpecies() {
        return idSpecies;
    }

    public void setIdSpecies(Integer idSpecies) {
        this.idSpecies = idSpecies;
    }

    public Integer getIdSpeciesLink() {
        return idSpeciesLink;
    }

    public void setIdSpeciesLink(Integer idSpeciesLink) {
        this.idSpeciesLink = idSpeciesLink;
    }

    public Integer getIdNatureObject() {
        return idNatureObject;
    }

    public void setIdNatureObject(Integer idNatureObject) {
        this.idNatureObject = idNatureObject;
    }

    public String getScientificName() {
        return scientificName;
    }

    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

}
