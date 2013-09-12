package eionet.eunis.dto;

/**
 * 
 * DTO class to transfer data for the references page for species list
 * 
 * @author Jaak Kapten
 */
public class ReferenceSpeciesDTO {

    private String id;
    private String name;
    private String author;
    private int groupSpeciesId;
    private String groupCommonName;
    private String groupScientificName;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

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

}
