package ro.finsiel.eunis.factsheet.habitats;


/**
 * This class encapsulates information about a habiatat (CODE, LEVEL AND ID).
 * Used in habitat factsheet.
 * @author finsiel
 */
public class CodeLevelWrapper {
    private String code = "";
    private Integer level = new Integer(0);
    private String idHabitat = "";

    /**
     * Getter for code property.
     * @return Habitat code.
     */
    public String getCode() {
        return code;
    }

    /**
     * Setter for code property.
     * @param code Code.
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * Getter for level property.
     * @return Habitat level (remember that only EUNIS habitats have code - Annex does not).
     */
    public Integer getLevel() {
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
     * @return ID of the habitat (ID_HABITAT from CHM62EDT_HABITAT).
     */
    public String getIdHabitat() {
        return idHabitat;
    }

    /**
     * Setter for idHabitat property.
     * @param idHabitat ID of the habitat (ID_HABITAT from CHM62EDT_HABITAT).
     */
    public void setIdHabitat(String idHabitat) {
        this.idHabitat = idHabitat;
    }
}
