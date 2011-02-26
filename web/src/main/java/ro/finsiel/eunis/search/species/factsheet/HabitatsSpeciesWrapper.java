package ro.finsiel.eunis.search.species.factsheet;


/**
 * Wrapper for relation beween species and habitats.
 * @author finsiel
 */
public class HabitatsSpeciesWrapper {
    private String speciesName = null;
    private Integer idSpecies = null;
    private Integer idSpeciesLink = null;
    private String geoscope = null;
    private String abundance = null;
    private String frequencies = null;
    private String faithfulness = null;
    private String speciesStatus = null;
    private String comment = null;

    /**
     * Ctor.
     * @param idSpecies ID_SPECIES from CHM62EDT_SPECIES.
     * @param idSpeciesLink ID_SPECIES_LINK from CHM62EDT_SPECIES.
     * @param scientificName SCIENTIFIC_NAME from CHM62EDT_SPECIES.
     * @param geoscope ID_GEOSCOPE of the country.
     * @param abundance Abundance attribute value.
     * @param frequencies Frequencies attribute value.
     * @param faithfulness Faithfulness attribute value.
     * @param speciesStatus Species status attribute value.
     * @param comment Comment.
     */
    public HabitatsSpeciesWrapper(Integer idSpecies, Integer idSpeciesLink, String scientificName, String geoscope, String abundance, String frequencies, String faithfulness, String speciesStatus, String comment) {
        this.speciesName = scientificName;
        this.idSpecies = idSpecies;
        this.idSpeciesLink = idSpeciesLink;
        this.geoscope = geoscope;
        this.abundance = abundance;
        this.frequencies = frequencies;
        this.faithfulness = faithfulness;
        this.speciesStatus = speciesStatus;
        this.comment = comment;
    }

    /**
     * Getter for speciesName property.
     * @return speciesName.
     */
    public String getSpeciesName() {
        return speciesName;
    }

    /**
     * Getter for idSpecies property.
     * @return idSpecies.
     */
    public Integer getIdSpecies() {
        return idSpecies;
    }

    /**
     * Getter for idSpeciesLink property.
     * @return idSpeciesLink.
     */
    public Integer getIdSpeciesLink() {
        return idSpeciesLink;
    }

    /**
     * Getter for geoscope property.
     * @return geoscope.
     */
    public String getGeoscope() {
        return geoscope;
    }

    /**
     * Getter for abundance property.
     * @return abundance.
     */
    public String getAbundance() {
        return abundance;
    }

    /**
     * Getter for frequencies property.
     * @return frequencies.
     */
    public String getFrequencies() {
        return frequencies;
    }

    /**
     * Getter for faithfulness property.
     * @return faithfulness.
     */
    public String getFaithfulness() {
        return faithfulness;
    }

    /**
     * Getter for speciesStatus property.
     * @return speciesStatus.
     */
    public String getSpeciesStatus() {
        return speciesStatus;
    }

    /**
     * Getter for comment property.
     * @return comment.
     */
    public String getComment() {
        return comment;
    }
}
