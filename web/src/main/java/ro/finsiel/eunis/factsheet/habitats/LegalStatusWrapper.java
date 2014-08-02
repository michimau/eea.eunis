package ro.finsiel.eunis.factsheet.habitats;

import ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist;
import ro.finsiel.eunis.search.Utilities;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Wrapper for the Legal status, used for Habitats Legal display
 */
public class LegalStatusWrapper {

    /**
     * Mapping for habitat relation types to descriptions
     */
    public static final Map<String, String> relationTypeMap = new HashMap<String, String>();

    static {
        relationTypeMap.put("=", "Same");
        relationTypeMap.put(">", "Wider");
        relationTypeMap.put("<", "Narrower");
        relationTypeMap.put("#", "Overlap");
        relationTypeMap.put("?", "Not determined");
    }

    private HabitatLegalPersist legalPersist;
    private String annexTitle;
    private String annexLink;
    private String parentTitle;
    private String parentLink;
    private String parentAlternative;

    private List<String> moreInfo = new ArrayList<String>();

    public LegalStatusWrapper(HabitatLegalPersist legalPersist) {
        this.legalPersist = legalPersist;
    }

    public HabitatLegalPersist getLegalPersist() {
        return legalPersist;
    }

    public String getAnnexTitle() {
        return annexTitle;
    }

    public void setAnnexTitle(String annexTitle) {
        this.annexTitle = annexTitle;
    }

    public String getAnnexLink() {
        return annexLink;
    }

    public void setAnnexLink(String annexLink) {
        this.annexLink = annexLink;
    }

    public String getParentTitle() {
        return parentTitle;
    }

    public void setParentTitle(String parentTitle) {
        this.parentTitle = parentTitle;
    }

    public String getParentLink() {
        return parentLink;
    }

    public void setParentLink(String parentLink) {
        this.parentLink = parentLink;
    }

    public String getParentAlternative() {
        return parentAlternative;
    }

    public void setParentAlternative(String parentAlternative) {
        this.parentAlternative = parentAlternative;
    }

    /**
     * The meaning of the relation type
     * @return
     */
    public String getRelationTypeString(){
        if(legalPersist.getRelationType() == null)
            return null;
        return relationTypeMap.get(legalPersist.getRelationType());
    }

    public void addMoreInfo(String value) {
        moreInfo.add(value);
    }

    public List<String> getMoreInfo() {
        return moreInfo;
    }
}
