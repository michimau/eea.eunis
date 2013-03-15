package ro.finsiel.eunis.search.sites;


import ro.finsiel.eunis.search.AbstractSearchCriteria;


/**
 * Base class for all search criterias used in sites search.
 * @author finsiel
 */
public abstract class SitesSearchCriteria extends AbstractSearchCriteria {

    /**
     * Source db.
     */
    public static final Integer CRITERIA_SOURCE_DB = new Integer(0);

    /**
     * Site name.
     */
    public static final Integer CRITERIA_ENGLISH_NAME = new Integer(1);

    /**
     * Site country.
     */
    public static final Integer CRITERIA_COUNTRY = new Integer(2);

    /**
     * Site designation type.
     */
    public static final Integer CRITERIA_DESIGN_TYPE = new Integer(3);

    /**
     * Site size.
     */
    public static final Integer CRITERIA_SIZE = new Integer(4);

    /**
     * Site mean altitude.
     */
    public static final Integer CRITERIA_ALTITUDE_MEAN = new Integer(5);

    /**
     * Site minimum altitude.
     */
    public static final Integer CRITERIA_ALTITUDE_MIN = new Integer(6);

    /**
     * Site maximum altitude.
     */
    public static final Integer CRITERIA_ALTITUDE_MAX = new Integer(7);

    /**
     * Site surface area.
     */
    public static final Integer CRITERIA_AREA = new Integer(8);

    /**
     * Site length.
     */
    public static final Integer CRITERIA_LENGTH = new Integer(9);

    /**
     * Site - biogeoregion relation.
     */
    public static final Integer CRITERIA_REGION = new Integer(10);

    /**
     * Site deisgnation.
     */
    public static final Integer CRITERIA_DESIGNATION_MAIN = new Integer(11);

    /**
     * Site designation in english.
     */
    public static final Integer CRITERIA_DESIGN_TYPE_EN = new Integer(12);

    /**
     * Site designation in french.
     */
    public static final Integer CRITERIA_DESIGN_TYPE_FR = new Integer(13);

    /**
     * Site abbreviation.
     */
    public static final Integer CRITERIA_ABREVIATION = new Integer(14);

    /**
     * Site designation for refine search.
     */
    public static final Integer CRITERIA_DESIGN = new Integer(15);

    /**
     * Site designation for refine search in english.
     */
    public static final Integer CRITERIA_DESIGN_EN = new Integer(16);

    /**
     * Site designation for refine search in french.
     */
    public static final Integer CRITERIA_DESIGN_FR = new Integer(17);

    /**
     * Site source db. for refine search.
     */
    public static final Integer CRITERIA_SOURCE = new Integer(18);

    /**
     * Site country for refine search.
     */
    public static final Integer CRITERIA_ISO = new Integer(19);

    /**
     * Site habitat for refine search.
     */
    public static final Integer CRITERIA_HABITAT = new Integer(20);

    /**
     * Site species link.
     */
    public static final Integer CRITERIA_SPECIES = new Integer(21);
    
    /**
     * Site ID.
     */
    public static final Integer CRITERIA_ID = new Integer(22);
}
