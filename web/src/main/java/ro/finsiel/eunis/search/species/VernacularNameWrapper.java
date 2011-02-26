package ro.finsiel.eunis.search.species;


import ro.finsiel.eunis.search.JavaSortable;


/**
 * This class encapsulates an Vernacular name for the Species->Country/Region type of search
 * By implementing JavaSortable interface, this objects can be sortable after their language criteria,
 * so a bunch of these objects could be sorted ascending or descending.
 * @author finsiel
 */
public class VernacularNameWrapper implements JavaSortable {

    /**
     * Language.
     */
    private String language = "";
  
    private String languageCode = "";

    /**
     * Name in that language.
     */
    private String name = "";

    /**
     * ID_DC for references.
     */
    private Integer idDc = null;

    /**
     * Creates a new VernacularNameWrapper object.
     * @param language Language.
     * @param name Name in that language.
     */
    public VernacularNameWrapper(String language, String name) {
        this.language = language;
        this.name = name;
    }

    /**
     * Creates a new VernacularNameWrapper object.
     * @param idDc ID_DC
     * @param language Language
     * @param name Name.
     */
    public VernacularNameWrapper(String language, String name, Integer idDc) {
        this.idDc = idDc;
        this.language = language;
        this.name = name;
    }

    /**
     * Init constructor.
     * @param language
     * @param languageCode
     * @param name
     * @param idDc
     */
    public VernacularNameWrapper(String language, String languageCode, String name, Integer idDc) {
        this(language, name, idDc);
        this.languageCode = languageCode;
    }

    /**
     * Getter for language property.
     * @return language.
     */
    public String getLanguage() {
        return language;
    }

    /**
     * Setter for language property.
     * @param language The new value for language.
     */
    public void setLanguage(String language) {
        this.language = language;
    }

    /**
     * Getter for name property.
     * @return The name in specified language.
     */
    public String getName() {
        return name;
    }

    /**
     * Setter for name property.
     * @param name The new value for name.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * This method will return a string after which the comparison between same type.
     * of objects can be done.
     * @return Sort criteria used for sorting.
     */
    public String getSortCriteria() {
        return language;
    }

    /**
     * Getter for idDc property.
     * @return idDc.
     */
    public Integer getIdDc() {
        return idDc;
    }

    /**
     * Setter for idDc property.
     * @param idDc idDc.
     */
    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public void setLanguageCode(String languageCode) {
        this.languageCode = languageCode;
    }
}
