package ro.finsiel.eunis.jrfTables.species.habitats;


import net.sf.jrf.domain.PersistentObject;

import java.util.StringTokenizer;


public class ScientificNamePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idSpecies = null;

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private String i_scientificName = null;

    private Integer i_idSpeciesLink = null;

    private String commonName = null;
    private String taxonomicNameOrder = null;
    private String taxonomicNameFamily = null;
    private String habitatScientificName = null;
    private String taxonomyLevel = null;
    private String taxonomyTree = null;
    private String taxonomyName = null;

    public ScientificNamePersist() {
        super();
    }

    /** Getter for a database field */
    public String getTaxonomicNameOrder() {
        String level = this.getTaxonomyLevel();

        if (level != null && level.equalsIgnoreCase("order_column")) {
            return this.getTaxonomyName();
        } else {
            String result = "";
            String str = this.getTaxonomyTree();

            StringTokenizer st = new StringTokenizer(str, ",");

            while (st.hasMoreTokens()) {
                StringTokenizer sts = new StringTokenizer(st.nextToken(), "*");
                String classification_id = sts.nextToken();
                String classification_level = sts.nextToken();
                String classification_name = sts.nextToken();

                if (classification_level != null
                        && classification_level.equalsIgnoreCase("order_column")) {
                    result = classification_name;
                    break;
                }
            }

            return result;
        }
    }

    /** Getter for a database field */
    public String getTaxonomicNameFamily() {
        String level = this.getTaxonomyLevel();

        if (level != null && level.equalsIgnoreCase("family")) {
            return this.getTaxonomyName();
        } else {
            String result = "";
            String str = this.getTaxonomyTree();

            StringTokenizer st = new StringTokenizer(str, ",");

            while (st.hasMoreTokens()) {
                StringTokenizer sts = new StringTokenizer(st.nextToken(), "*");
                String classification_id = sts.nextToken();
                String classification_level = sts.nextToken();
                String classification_name = sts.nextToken();

                if (classification_level != null
                        && classification_level.equalsIgnoreCase("family")) {
                    result = classification_name;
                    break;
                }
            }

            return result;
        }
    }

    public void setTaxonomicNameOrder(String taxonomicNameOrder) {
        this.taxonomicNameOrder = taxonomicNameOrder;
    }

    public void setTaxonomicNameFamily(String taxonomicNameFamily) {
        this.taxonomicNameFamily = taxonomicNameFamily;
    }

    public String getCommonName() {
        return commonName;
    }

    public void setCommonName(String commonName) {
        this.commonName = commonName;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdSpecies() {
        return i_idSpecies;
    }

    /**
     * Getter for a database field.
     **/
    public String getScientificName() {
        return i_scientificName;
    }

    public Integer getIdSpeciesLink() {
        return i_idSpeciesLink;
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSpecies
     **/
    public void setIdSpecies(Integer idSpecies) {
        i_idSpecies = idSpecies;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param scientificName
     **/
    public void setScientificName(String scientificName) {
        i_scientificName = scientificName;
        this.markModifiedPersistentState();
    }

    public void setIdSpeciesLink(Integer idSpeciesLink) {
        i_idSpeciesLink = idSpeciesLink;
        this.markModifiedPersistentState();
    }

    public String getHabitatScientificName() {
        return habitatScientificName;
    }

    public void setHabitatScientificName(String habitatScientificName) {
        this.habitatScientificName = habitatScientificName;
    }

    public String getTaxonomyLevel() {
        return taxonomyLevel;
    }

    public void setTaxonomyLevel(String taxonomyLevel) {
        this.taxonomyLevel = taxonomyLevel;
    }

    public String getTaxonomyTree() {
        return taxonomyTree;
    }

    public void setTaxonomyTree(String taxonomyTree) {
        this.taxonomyTree = taxonomyTree;
    }

    public String getTaxonomyName() {
        return taxonomyName;
    }

    public void setTaxonomyName(String taxonomyName) {
        this.taxonomyName = taxonomyName;
    }
}
