package ro.finsiel.eunis.search.species.country;


import ro.finsiel.eunis.jrfTables.JRFSortable;


/**
 * This class wraps the characteristics of a Country. It encapsulates its name and code (see CHM62EDT_COUNTRY table,
 * column EUNIS_AREA_CODE. Implements JRFSortable interface so that you can sort objects of this type.
 * @author finsiel
 */
public class CountryWrapper implements JRFSortable {

    /** Name of the country. */
    private String name = "";

    /** Country code. */
    private String code = "";

    /** Country's ID Geoscope. */
    private String idGeoscope = "";

    /**
     * Normal constructor.
     * @param name Country name
     * @param code Country code
     * @param idGeoscope Country ID Geoscope
     */
    public CountryWrapper(String name, String code, String idGeoscope) {
        this.name = name;
        this.code = code;
        this.idGeoscope = idGeoscope;
    }

    /** Getter for name property.
     * @return Country name
     */
    public String getName() {
        return name;
    }

    /** Setter for name property.
     * @param name New name of the country. Default "".
     */
    public void setName(String name) {
        this.name = name;
    }

    /** Getter for country's code.
     * @return Country code as stated in CHM62EDT_COUNTRY_BIOGEOREGION
     */
    public String getCode() {
        return code;
    }

    /** Setter for country code as stated in CHM62EDT_COUNTRY_BIOGEOREGION.
     * @param code New country code. Default is "".
     */
    public void setCode(String code) {
        this.code = code;
    }

    /** Getter for country's ID Geoscope.
     * @return New value for country's ID Geoscope. Default is "".
     */
    public String getIdGeoscope() {
        return idGeoscope;
    }

    /**
     * This method will return a string after which the comparison between same type of objects can be done.
     * @return sort criteria.
     */
    public String getSortCriteria() {
        return name;
    }
}
