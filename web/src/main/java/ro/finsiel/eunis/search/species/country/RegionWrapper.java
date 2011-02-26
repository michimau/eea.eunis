package ro.finsiel.eunis.search.species.country;


import ro.finsiel.eunis.jrfTables.JRFSortable;


/**
 * This class wraps the characteristics of a Region.
 * It encapsulates its name and code (see CHM62EDT_COUNTRY table, column EUNIS_AREA_CODE.
 * It implements JRFSortable interface so that you can sort objects of this type.
 * @author finsiel
 */
public class RegionWrapper implements JRFSortable {

    /** Name of the region. */
    private String name = "";

    /** Region's code as stated in CHM62EDT_COUNTRY_BIOGEOREGION.*/
    private String code = "";

    /** Region's ID_GEOSCOPE. */
    private String idGeoscope = "";

    /** Percentage of region in country. */
    private Integer percentage = new Integer(0);

    /**
     * Ctor.
     * @param name Region's  name
     * @param code Region's code
     * @param idGeoscope Region's ID Geoscope
     * @param percentage percentage of region in country
     */
    public RegionWrapper(String name, String code, String idGeoscope, Integer percentage) {
        this.name = name;
        this.code = code;
        this.idGeoscope = idGeoscope;
        this.percentage = percentage;
    }

    /**
     * Getter for name property.
     * @return Name of this region
     */
    public String getName() {
        return name;
    }

    /**
     * Setter for name property.
     * @param name New name for the region
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter for code property.
     * @return The code property for this region
     */
    public String getCode() {
        return code;
    }

    /**
     * Setter for code property.
     * @param code New value for code property
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * Getter for idGeoscope of this region.
     * @return The ID Geoscope of this region
     */
    public String getIdGeoscope() {
        return idGeoscope;
    }

    /**
     * This method will return a string after which the comparison between same type of objects can be done.
     * @return The sort criteria (name)
     */
    public String getSortCriteria() {
        return name;
    }

    /**
     * Getter for percentage property.
     * @return percentage.
     */
    public Integer getPercentage() {
        return percentage;
    }

    /**
     * Setter for percentage property.
     * @param percentage percentage.
     */
    public void setPercentage(Integer percentage) {
        this.percentage = percentage;
    }
}
