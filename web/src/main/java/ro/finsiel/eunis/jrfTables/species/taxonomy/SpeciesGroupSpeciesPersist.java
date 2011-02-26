package ro.finsiel.eunis.jrfTables.species.taxonomy;


/**
 * Date: Oct 15, 2003
 * Time: 12:58:13 PM
 */

import net.sf.jrf.domain.PersistentObject;


public class SpeciesGroupSpeciesPersist extends PersistentObject {

    private Integer idSpecies = null;
    private Integer idSpeciesLink = null;
    private String scientificName = null;
    private String CommonName = null;

    public SpeciesGroupSpeciesPersist() {
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

    public String getScientificName() {
        return scientificName;
    }

    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    public String getCommonName() {
        return CommonName;
    }

    public void setCommonName(String commonName) {
        CommonName = commonName;
    }
}
