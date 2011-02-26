package ro.finsiel.eunis.factsheet.habitats;


import ro.finsiel.eunis.jrfTables.JRFSortable;


/**
 * This class is used to encapsulate a relation between given habitat and other habitats.
 * @author finsiel
 * @see ro.finsiel.eunis.jrfTables.JRFSortable
 */
public class HabitatFactsheetRelWrapper implements JRFSortable {

    /**
     * Sort this object after its EUNIS_CODE.
     */
    public static final int SORT_EUNIS_CODE = 0;
    private int criteria = 0;

    private String eunisCode = "";
    private String scientificName = "";
    private String relation = "";
    private Integer level = new Integer(0);
    private String idHabitat = "";

    /**
     * Implemented from JRFSortable.
     * @return String representation of this object used within sorting.
     * @see ro.finsiel.eunis.jrfTables.JRFSortable#getSortCriteria
     */
    public String getSortCriteria() {
        switch (criteria) {
        case SORT_EUNIS_CODE:
            return eunisCode;
        }
        return "";
    }

    /**
     * Getter for criteria property.
     * @return Sort criteria.
     */
    public int getCriteria() {
        return criteria;
    }

    /**
     * Setter for criteria property.
     * @param criteria Sort criteria.
     */
    public void setCriteria(int criteria) {
        this.criteria = criteria;
    }

    /**
     * Getter for eunisCode property.
     * @return EUNIS code.
     */
    public String getEunisCode() {
        return eunisCode;
    }

    /**
     * Getter for relation property.
     * @return Relation with this habitat.
     */
    public String getRelation() {
        return relation;
    }

    /**
     * Getter for scientificName property.
     * @return scientificName.
     */
    public String getScientificName() {
        return scientificName;
    }

    /**
     * Getter for level property.
     * @return Level.
     */
    public Integer getLevel() {
        if (level == null) {
            return new Integer(0);
        }
        return level;
    }

    /**
     * Setter for level property.
     * @param level Level.
     */
    public void setLevel(Integer level) {
        this.level = level;
    }

    /**
     * Getter for idHabitat property.
     * @return idHabitat.
     */
    public String getIdHabitat() {
        return idHabitat;
    }

    /**
     * Setter for idHabitat property.
     * @param idHabitat ID_HABITAT.
     */
    public void setIdHabitat(String idHabitat) {
        this.idHabitat = idHabitat;
    }

    /**
     * Getter for eunisCode property.
     * @param eunisCode EUNIS_CODE.
     */
    public void setEunisCode(String eunisCode) {
        this.eunisCode = eunisCode;
    }

    /**
     * Setter for scientificName property.
     * @param scientificName SCIENTIFIC_NAME.
     */
    public void setScientificName(String scientificName) {
        this.scientificName = scientificName;
    }

    /**
     * Setter for relation property.
     * @param relation Relation.
     */
    public void setRelation(String relation) {
        this.relation = relation;
    }
}
