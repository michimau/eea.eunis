package eionet.eunis.dto;

import java.util.List;

/**
 * 
 * DTO class for transferring reference species by species group.
 * 
 * @author Jaak
 */
public class ReferenceSpeciesGroupDTO {

    private int groupSpeciesId;
    private String groupCommonName;
    private String groupScientificName;
    private List<ReferenceSpeciesDTO> referenceSpecies;

    public int getGroupSpeciesId() {
        return groupSpeciesId;
    }

    public void setGroupSpeciesId(int groupSpeciesId) {
        this.groupSpeciesId = groupSpeciesId;
    }

    public String getGroupCommonName() {
        return groupCommonName;
    }

    public void setGroupCommonName(String groupCommonName) {
        this.groupCommonName = groupCommonName;
    }

    public String getGroupScientificName() {
        return groupScientificName;
    }

    public void setGroupScientificName(String groupScientificName) {
        this.groupScientificName = groupScientificName;
    }

    public List<ReferenceSpeciesDTO> getReferenceSpecies() {
        return referenceSpecies;
    }

    public void setReferenceSpecies(List<ReferenceSpeciesDTO> referenceSpecies) {
        this.referenceSpecies = referenceSpecies;
    }

}
