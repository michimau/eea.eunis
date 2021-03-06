package ro.finsiel.eunis.dataimport.legal;

/**
 * Bean to keep the Geographic and other restrictions Excel sheet data
 */
public class RestrictionsRow {
    private String species;
    private String legalText;
    private String restriction;
    private int priority = 0;

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getLegalText() {
        return legalText;
    }

    public void setLegalText(String legalText) {
        this.legalText = legalText;
    }

    public String getRestriction() {
        return restriction;
    }

    public void setRestriction(String restriction) {
        this.restriction = restriction;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    @Override
    public String toString() {
        return "RestrictionsRow{" +
                "species='" + species + '\'' +
                ", legalText='" + legalText + '\'' +
                ", restriction='" + restriction + '\'' +
                '}';
    }
}
