package ro.finsiel.eunis.factsheet.sites;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import eionet.eunis.util.Constants;
import org.apache.log4j.Logger;

import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.jrfTables.*;
import ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityAttributesDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityAttributesPersist;
import ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.RegionsCodesDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteHabitatsDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteRelationsDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesDomain;
import ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesDomain;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dto.PictureDTO;

/**
 * This is the factsheet generator for the site's factsheet.
 *
 * @author finsiel
 */
public class SiteFactsheet {


    /**
     * Define a site of type NATURA 2000.
     */
    public static final int TYPE_NATURA2000 = 0;

    /**
     * Define a site of type CORINE BIOTOPES.
     */
    public static final int TYPE_CORINE = 1;

    /**
     * Define a site of type DIPLOMA.
     */
    public static final int TYPE_DIPLOMA = 2;

    /**
     * Define a site of type CDDA_NATIONAL.
     */
    public static final int TYPE_CDDA_NATIONAL = 3;

    /**
     * Define a site of type CDDA_INTERNATIONAL.
     */
    public static final int TYPE_CDDA_INTERNATIONAL = 4;

    /**
     * Define a site of type BIOGENETIC RESERVE.
     */
    public static final int TYPE_BIOGENETIC = 5;

    /**
     * Define a site of type NATURE_NET.
     */
    public static final int TYPE_NATURENET = 6;

    /**
     * Define a site of type EMERALD.
     */
    public static final int TYPE_EMERALD = 7;

    private static Logger logger = Logger.getLogger(SiteFactsheet.class);
    private String idSite = null;
    private Chm62edtSitesPersist siteTableObject = null;
    private String siteTableDesignations = null;
    private Chm62edtSitesAttributesPersist siteTableAttributes = null;
    private Chm62edtRegionCodesPersist regionCodes = null;

    /**
     * The main constructor for factsheet's and takes as parameter the ID of the site.
     *
     * @param idSite - Site ID for which factsheet is constructed.
     */
    public SiteFactsheet(String idSite) {
        this.idSite = idSite;
    }

    public Integer getIdDc() {
        try {
            Integer pk = getSiteObject().getIdNatureObject();

            if (pk == null) {
                return null;
            }
            Chm62edtNatureObjectPersist persist = (Chm62edtNatureObjectPersist) new Chm62edtNatureObjectDomain().find(pk);

            return persist.getIdDc();
        } catch (Exception warning) {
            logger.error(warning);
        }
        return null;
    }

    /**
     * Generate a description for search engines.
     */
    public String getDescription() {
        String ret = "";

        try {
            ret = getSiteObject().getName();

            if (getCountry() != null && !getCountry().equalsIgnoreCase("")) {
                ret += " is located within " + getCountry();
            }
            if (getSiteObject().getArea() != null && getSiteObject().getArea().equalsIgnoreCase("")) {
                ret += ", has a surface of " + getSiteObject().getArea() + " hectares";
            }
            ret += " is part of the " + SitesSearchUtility.translateSourceDB(getSiteObject().getSourceDB()) + " database.";
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return ret;
    }

    /**
     * Find site attributes from chm62edt_report_attributes.
     *
     * @param attributeName Name of the attribute (NAME column from table, ex. COVER, GLOBAL, POPULATION etc.)
     * @param idReportAttribute ID_REPORT_ATTRIBUTES for that nature object (ex.
     *            chm62edt_nature_object_report_type.ID_REPORT_ATTRIBUTES).
     * @return An Chm62edtReportAttributesPersist objects with this information.
     */
    public Chm62edtReportAttributesPersist findSiteAttributes(String attributeName, Integer idReportAttribute) {
        Chm62edtReportAttributesPersist attribute = null;

        try {
            List results =
                    new Chm62edtReportAttributesDomain().findWhere("NAME LIKE '%" + attributeName
                            + "%' AND ID_REPORT_ATTRIBUTES='" + idReportAttribute + "'");

            if (null != results && results.size() > 0) {
                attribute = ((Chm62edtReportAttributesPersist) results.get(0));
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return attribute;
    }

    /**
     * Find species from this site.
     *
     * @return List of SiteSpeciesPersist objects.
     */
    public List findSitesSpeciesByIDNatureObject() {
        List results = new Vector();

        try {
            results = new SiteSpeciesDomain().findWhere("A.ID_NATURE_OBJECT='" + getSiteObject().getIdNatureObject() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    // public List findSitesSpeciesByIDNatureObjectNatura2000() {
    // List results = new Vector();
    // try {
    // results = new SiteSpeciesDomain().findWhere("A.ID_NATURE_OBJECT='" + getSiteObject().getIdNatureObject() +
    // "' AND A.ID_REPORT_TYPE='-1'");
    // } catch (Exception _ex) {
    // _ex.printStackTrace(System.err);
    // results = new Vector();
    // }
    // if (null == results) results = new Vector();
    // return results;
    // }
    //

    /**
     * Species listed within natura 2000 directives.
     *
     * @return List of species SitesSpeciesReportAttributesPersist objects
     */
    public List findEunisSpeciesListedAnnexesDirectivesForSitesNatura2000() {
        List results;

        try {
            results =
                    new SitesSpeciesReportAttributesDomain().findWhere("A.ID_NATURE_OBJECT='"
                            + getSiteObject().getIdNatureObject()
                            + "' AND E.NAME='SOURCE_TABLE' AND E.VALUE IN (" + EunisUtil.SPECIES_GROUPS + ")");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find non-EUNIS species related to site, listed in directives.
     *
     * @return List of Chm62edtSitesAttributesPersis objects
     */
    public List findNotEunisSpeciesListedAnnexesDirectives() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE IN ('AMPREP','BIRD','FISHES','INVERT','MAMMAL','PLANT') AND NAME LIKE 'OTHER_SPECIES_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2)");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find other non-EUNIS species related to this site.
     *
     * @return List of Chm62edtSitesAttributesPersist objects
     */
    public List findNotEunisSpeciesOtherMentioned() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE = 'spec' AND NAME LIKE 'OTHER_SPECIES_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2)");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find non-EUNIS species related to site, listed in Annexes and directives.
     *
     * @param attrName attribute name
     * @return Species object
     */
    public Chm62edtSitesAttributesPersist findNotEunisSpeciesListedAnnexesDirectivesAttributes(String attrName) {
        if (attrName == null || attrName.trim().length() <= 0) {
            return null;
        }
        Chm62edtSitesAttributesPersist result = null;

        try {
            List attrList =
                    new Chm62edtSitesAttributesDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE IN ('AMPREP','BIRD','FISHES','INVERT','MAMMAL','PLANT') AND NAME = 'OTHER_SPECIES_"
                                    + attrName + "'");

            if (attrList != null && attrList.size() > 0) {
                result = (Chm62edtSitesAttributesPersist) attrList.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }

        return result;
    }

    /**
     * Non-EUNIS species mentioned in other attributes, related to this site.
     *
     * @param attrName Attribute name
     * @return Species object
     */
    public Chm62edtSitesAttributesPersist findNotEunisSpeciesOtherMentionedAttributes(String attrName) {
        if (attrName == null || attrName.trim().length() <= 0) {
            return null;
        }
        attrName = EunisUtil.replaceTagsImport(attrName);
        Chm62edtSitesAttributesPersist result = null;

        try {
            List attrList =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND SOURCE_TABLE = 'spec' AND NAME = 'OTHER_SPECIES_" + attrName + "'");

            if (attrList != null && attrList.size() > 0) {
                result = (Chm62edtSitesAttributesPersist) attrList.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }

        return result;
    }

    /**
     * Isolation information for an site.
     *
     * @param id Site id
     * @return Isolation description
     */
    public String findIsolation(String id) {
        if (id == null) {
            return "";
        }
        String result = "";

        try {
            List res = new Chm62edtIsolationDomain().findWhere("ID_ISOLATION='" + id + "'");

            if (res != null && res.size() > 0) {
                result = ((Chm62edtIsolationPersist) res.get(0)).getName();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Retrieve values from chm62edt_global.
     *
     * @param id ID_GLOBAL
     * @return List of Chm62edtGlobalPersist objects
     */
    public String findGlobal(String id) {
        if (id == null) {
            return "";
        }
        String result = "";

        try {
            List res = new Chm62edtGlobalDomain().findWhere("ID_GLOBAL='" + id + "'");

            if (res != null && res.size() > 0) {
                result = ((Chm62edtGlobalPersist) res.get(0)).getName();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Get conservation name for natura site.
     *
     * @param id site id
     * @return Conservation name
     */
    public String findConservNatura2000(String id) {
        if (id == null) {
            return "";
        }
        String result = "";

        try {
            List res = new Chm62edtNatura2000ConservationCodeDomain().findWhere("ID_CONSERVATION_CODE='" + id + "'");

            if (res != null && res.size() > 0) {
                result = ((Chm62edtNatura2000ConservationCodePersist) res.get(0)).getName();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Find population for an site.
     *
     * @param id site id
     * @return Population description
     */
    public String findPopulation(String id) {
        if (id == null) {
            return "";
        }
        String result = "";

        try {
            List res = new Chm62edtPopulationDomain().findWhere("ID_POPULATION='" + id + "'");

            if (res != null && res.size() > 0) {
                result = ((Chm62edtPopulationPersist) res.get(0)).getName();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * List of other unclassified species mentioned in Natura 2000 sites.
     *
     * @return List of SitesSpeciesReportAttributesPersist objects
     */
    public List findEunisSpeciesOtherMentionedForSitesNatura2000() {
        List results = new Vector();

        try {
            results =
                    new SitesSpeciesReportAttributesDomain().findWhere("A.ID_NATURE_OBJECT='"
                            + getSiteObject().getIdNatureObject() + "' AND E.NAME='SOURCE_TABLE' AND E.VALUE ='spec'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Species related to site.
     *
     * @return List of SiteSpeciesPersist objects
     */
    public List findSitesSpeciesByIDNatureObjectNatura2000Other() {
        List results = new Vector();

        try {
            results =
                    new SiteSpeciesDomain().findWhere("A.ID_NATURE_OBJECT='" + getSiteObject().getIdNatureObject()
                            + "' AND A.ID_REPORT_TYPE='-999'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find species which are characteristic only for sites (ie. not part of species module).
     *
     * @return List of Chm62edtSitesAttributesPersist objects.
     */
    public List findSitesSpecificSpecies() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain().findWhere("NAME LIKE 'SPECIES%' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find species which are characteristic only for sites (ie. not part of species module).
     *
     * @return List of Chm62edtSitesAttributesPersist objects.
     */
    public List findSitesSpecificSpeciesNatura2000() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain().findWhere("NAME LIKE 'SPECIES%' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find species which are characteristic only for sites (ie. not part of species module).
     *
     * @return List of Chm62edtSitesAttributesPersist objects.
     */
    public List findSitesSpecificSpeciesNatura2000Other() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain().findWhere("NAME LIKE 'OTHER_SPECIES%' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Retrieve all human activities for this site.
     *
     * @return Vector of HumanActivityPersist objects.
     */
    public List findHumanActivity() {
        List results;

        try {
            results =
                    new HumanActivityDomain().findWhere("LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find the human activity attribute fot this site.
     *
     * @param attribute Name of the attribute (ex. IN_OUT, INTENSITY, COVER etc.).
     * @param position Index
     * @return An HumanActivityAttributesPersist with this information or null.
     */
    public HumanActivityAttributesPersist findHumanActivityAttribute(String attribute, int position) {
        HumanActivityAttributesPersist result = null;

        try {
            List results =
                    new HumanActivityAttributesDomain().findWhere("LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "' AND C.NAME='" + attribute + "' LIMIT " + position + ", 10 ");

            if (null != results && results.size() > 0) {
                result = (HumanActivityAttributesPersist) results.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Find the human activity attribute fot this site.
     *
     * @param attribute Name of the attribute (ex. IN_OUT, INTENSITY, COVER etc.).
     * @return An HumanActivityAttributesPersist with this information or null.
     */
    public HumanActivityAttributesPersist findHumanActivityAttribute(String attribute) {
        HumanActivityAttributesPersist result = null;

        try {
            List results =
                    new HumanActivityAttributesDomain().findWhere("LOOKUP_TYPE = 'HUMAN_ACTIVITY' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "' AND C.NAME='" + attribute + "'");

            if (null != results && results.size() > 0) {
                result = (HumanActivityAttributesPersist) results.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Find habitats within this site. For Habitat listed in Directive
     *
     * @return List of SiteHabitatsPersist objects.
     */
    public List findHabit1Eunis() {
        List results = new Vector();

        try {
            results =
                    new SiteHabitatsDomain()
                            .findWhere("A.ID_NATURE_OBJECT='"
                                    + getSiteObject().getIdNatureObject()
                                    + "' and chm62edt_report_attributes.NAME='SOURCE_TABLE' and chm62edt_report_attributes.VALUE='habit1'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find habitats related to this site, not mentioned in EUNIS but related.
     *
     * @return List of Chm62edtSitesAttributesPersist objects
     */
    public List findHabit1NotEunis() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE = 'HABIT1' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2)");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find habitat from site's attribute.
     *
     * @param attrName Attribute's name
     * @return Habitat
     */
    public Chm62edtSitesAttributesPersist findHabit1NotEunisAttributes(String attrName) {
        if (attrName == null || attrName.trim().length() <= 0) {
            return null;
        }
        Chm62edtSitesAttributesPersist result = null;

        try {
            List attrList =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND SOURCE_TABLE = 'HABIT1' AND NAME = 'HABITAT_" + attrName + "'");

            if (attrList != null && attrList.size() > 0) {
                result = (Chm62edtSitesAttributesPersist) attrList.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }

        return result;
    }

    /**
     * Find habitat from site's attributes.
     *
     * @param attrName attribute name
     * @return Habitat
     */
    public Chm62edtSitesAttributesPersist findHabit2NotEunisAttributes(String attrName) {
        if (attrName == null || attrName.trim().length() <= 0) {
            return null;
        }
        Chm62edtSitesAttributesPersist result = null;

        try {
            List attrList =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND SOURCE_TABLE = 'HABIT2' AND NAME = 'HABITAT_" + attrName + "'");

            if (attrList != null && attrList.size() > 0) {
                result = (Chm62edtSitesAttributesPersist) attrList.get(0);
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }

        return result;
    }

    /**
     * Find habitats not in EUNIS.
     *
     * @return List of Chm62edtSitesAttributesPersist objects
     */
    public List findHabit2NotEunis() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE = 'HABIT2' AND NAME LIKE 'HABITAT_CODE_%' GROUP BY SUBSTRING(name,length(name) - instr(reverse(name),'_') + 2)");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find habitats within this site. For Other habitats mentioned in site
     *
     * @return List of SiteHabitatsPersist objects.
     */
    public List findHabit2Eunis() {
        List results = new Vector();

        try {
            results =
                    new SiteHabitatsDomain()
                            .findWhere("A.ID_NATURE_OBJECT='"
                                    + getSiteObject().getIdNatureObject()
                                    + "' and chm62edt_report_attributes.NAME='SOURCE_TABLE' and chm62edt_report_attributes.VALUE='habit2'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    // /**
    // * Find the habitats which are characteristic only to sites (ie. not part of habitats module).
    // * @return A list of Chm62edtSitesAttributesPersist objects.
    // */
    // public List findSitesSpecificHabitats() {
    // List results = new Vector();
    // try {
    // results = new
    // Chm62edtSitesAttributesDomain().findWhere(" NAME LIKE 'HABITAT%' AND NAME NOT LIKE 'HABITAT_CHARACTERIZATION' AND ID_SITE='"
    // + getSiteObject().getIdSite() + "'");
    // } catch (Exception _ex) {
    // _ex.printStackTrace(System.err);
    // results = new Vector();
    // }
    // if (null == results) results = new Vector();
    // return results;
    // }

    /**
     * Find the habitats which are characteristic only to sites (ie. not part of habitats module).
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List findSitesSpecificHabitats() {
        List results = new Vector();

        try {
            results =
                    new Chm62edtSitesAttributesDomain().findWhere(" NAME LIKE 'HABITAT_CODE_%' AND ID_SITE='"
                            + getSiteObject().getIdSite() + "' group by name");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find site relations with other sites.
     *
     * @return A list of SiteRelationsPersist objects.
     */
    public List findSiteRelations() {
        List results = new Vector();

        try {
            // results = new SiteRelationsDomain().findWhere("A.ID_SITE='" + getSiteObject().getIdSite() +
            // "' AND B.SOURCE_DB <> 'EMERALD'");
            results = new SiteRelationsDomain().findWhere("A.ID_SITE='" + getSiteObject().getIdSite() + "'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find Natura 2000 site relations with other sites from Natura 2000.
     *
     * @return A list of SiteRelationsPersist objects.
     */
    public List findSiteRelationsNatura2000Natura2000() {
        List results = new Vector();

        try {
            results =
                    new SiteRelationsDomain().findWhere("A.ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND B.SOURCE_DB = 'NATURA2000' AND A.SOURCE_TABLE = 'sitrel'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find Natura 2000 site relations with other sites from Corine.
     *
     * @return A list of SiteRelationsPersist objects.
     */
    public List findSiteRelationsNatura2000Corine() {
        List results = new Vector();

        try {
            results =
                    new SiteRelationsDomain().findWhere("A.ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND B.SOURCE_DB = 'NATURA2000' AND A.SOURCE_TABLE = 'corine'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * This method returns the type of habitat.
     *
     * @return Values are TYPE_XXXXXXXXX declared above.
     */
    public int getType() {
        String typeStr = getSiteObject().getSourceDB();

        if (typeStr.equalsIgnoreCase("NATURA2000")) {
            return SiteFactsheet.TYPE_NATURA2000;
        }
        if (typeStr.equalsIgnoreCase("CORINE")) {
            return SiteFactsheet.TYPE_CORINE;
        }
        if (typeStr.equalsIgnoreCase("DIPLOMA")) {
            return SiteFactsheet.TYPE_DIPLOMA;
        }
        if (typeStr.equalsIgnoreCase("CDDA_NATIONAL")) {
            return SiteFactsheet.TYPE_CDDA_NATIONAL;
        }
        if (typeStr.equalsIgnoreCase("CDDA_INTERNATIONAL")) {
            return SiteFactsheet.TYPE_CDDA_INTERNATIONAL;
        }
        if (typeStr.equalsIgnoreCase("BIOGENETIC")) {
            return SiteFactsheet.TYPE_BIOGENETIC;
        }
        if (typeStr.equalsIgnoreCase("NATURENET")) {
            return SiteFactsheet.TYPE_NATURENET;
        }
        if (typeStr.equalsIgnoreCase("EMERALD")) {
            return SiteFactsheet.TYPE_EMERALD;
        }
        return -1;
    }

    /**
     * This method checks if the given idSite does exist within database (there is a record with this ID_SITE in chm62edt_sites).
     *
     * @return true if site exists, false if doesn't or exception occurrs.
     */
    public boolean exists() {
        boolean ret = false;

        try {
            List results = new Chm62edtSitesDomain().findWhere("ID_SITE='" + EunisUtil.mysqlEscapes(idSite) + "'");

            if (results.size() > 0) {
                ret = true;
            } else {
                logger.info("SiteFactsheet::exists(): results list was empty. Site does not exists in database.");
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return ret;
    }

    /**
     * Retrieve information about this site (from chm62edt_site table).
     *
     * @return null if error occurrs or else the persistent object corresponding from DB.
     * @throws InitializationException if idSite was null during object construction.
     */
    private Chm62edtSitesPersist getSiteinformation() throws InitializationException {
        if (null == idSite) {
            throw new InitializationException("idSite was null, aborting.");
        }
        Chm62edtSitesPersist retObject = null;

        // Get the cached information
        if (null != siteTableObject) {
            return siteTableObject;
        }
        // If not initialized - get the data from DB into cache
        try {
            List results = new Chm62edtSitesDomain().findWhere("ID_SITE='" + EunisUtil.mysqlEscapes(idSite) + "'");

            if (null != results && results.size() > 0) {
                siteTableObject = (Chm62edtSitesPersist) results.get(0); // Save information in cache
                retObject = siteTableObject;
            } else {
                logger.warn("getSiteinformation(): results list was empty. Maybe data does not exists in database");
                siteTableObject = retObject = null;
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            retObject = null;
        }
        return retObject;
    }

    /**
     * Retrieve designation information for this site.
     *
     * @return null if error occurrs or else the persistent object corresponding from DB.
     * @throws InitializationException if idSite was null during object construction.
     */
    public String getDesignation() throws InitializationException {
        if (null == idSite) {
            throw new InitializationException("idSite was null, aborting.");
        }
        String retObject = null;

        // Get the cached information
        if (null != siteTableDesignations) {
            return siteTableDesignations;
        }
        // If not initialized - get the data from DB into cache
        try {
            List results =
                    new Chm62edtDesignationsDomain()
                            .findCustom(" SELECT A.* FROM chm62edt_designations AS A "
                                    + " INNER JOIN chm62edt_sites AS B ON (A.ID_DESIGNATION = B.ID_DESIGNATION AND A.ID_GEOSCOPE = B.ID_GEOSCOPE) "
                                    + " WHERE B.ID_SITE='" + idSite + "'");

            if (null != results && results.size() > 0) {
                String descr = ((Chm62edtDesignationsPersist) results.get(0)).getDescription();
                String descrEn = ((Chm62edtDesignationsPersist) results.get(0)).getDescriptionEn();
                String descrFr = ((Chm62edtDesignationsPersist) results.get(0)).getDescriptionFr();

                siteTableDesignations =
                        (descr == null || descr.trim().length() <= 0 ? (descrEn == null || descrEn.trim().length() <= 0 ? (descrFr == null
                                || descrFr.trim().length() <= 0 ? "" : descrFr)
                                : descrEn)
                                : descr); // Save information in cache
                retObject = siteTableDesignations;
            } else {
                siteTableDesignations = retObject = null;
                logger.warn("getSiteDesignations(): results list was empty. Maybe data does not exists in database");
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            retObject = null;
        }
        return retObject;
    }

    /**
     * Retrieve sites attributes information (from chm62edt_site_attributes).
     *
     * @return null if error occurrs or else the persistent object corresponding from DB.
     * @throws InitializationException if idSite was null during object construction.
     */
    private Chm62edtSitesAttributesPersist getSiteAttributes() throws InitializationException {
        if (null == idSite) {
            throw new InitializationException("idSite was null, aborting.");
        }
        Chm62edtSitesAttributesPersist retObject = null;

        // Get the cached information
        if (null != siteTableAttributes) {
            return siteTableAttributes;
        }
        // If not initialized - get the data from DB into cache
        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "'");

            if (null != results && results.size() > 0) {
                siteTableAttributes = (Chm62edtSitesAttributesPersist) results.get(0); // Save information in cache
                retObject = siteTableAttributes;
            } else {
                siteTableAttributes = retObject = null;
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            retObject = null;
        }
        return retObject;
    }

    /**
     * Get direct access to the site object.
     *
     * @return null if error ocurrs or site object if found in database.
     */
    public Chm62edtSitesPersist getSiteObject() {
        Chm62edtSitesPersist ret = null;

        try {
            ret = getSiteinformation();
        } catch (InitializationException _ex) {
            _ex.printStackTrace(System.err);
            ret = null;
        }
        return ret;
    }

    /**
     * Get direct access to the site designations object.
     *
     * @return null if error ocurrs or site object if found in database.
     */
    public Chm62edtSitesAttributesPersist getAttributesObject() {
        Chm62edtSitesAttributesPersist ret = null;

        try {
            ret = getSiteAttributes();
        } catch (InitializationException _ex) {
            _ex.printStackTrace(System.err);
            ret = null;
        }
        return ret;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='DATE_FIRST_DESIGNATION'.
     *
     * @return A non-null list of Chm62edtSitesAttributesPersist objects.
     */
    public String getDateFirstDesignation() {
        String ret = "";

        try {
            List list =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='DATE_FIRST_DESIGNATION'");

            if (null != list && list.size() > 0) {
                Chm62edtSitesAttributesPersist attribute = (Chm62edtSitesAttributesPersist) list.get(0);

                ret = attribute.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return ret;
    }

    /**
     * Find parent country via first 2 characters of ID_SITE from COUNTRY TABLE.
     *
     * @return Country or empty string if ISO_2L code is not found.
     */
    public String getParentCountry() {
        String result = "";
        Integer siteIDNatureObject = getSiteObject().getIdNatureObject();

        try {
            List list = new Chm62edtNatureObjectGeoscopeDomain().findWhere("ID_NATURE_OBJECT='" + siteIDNatureObject + "'");

            if (null != list && list.size() > 0) {
                Integer idGeoscope = ((Chm62edtNatureObjectGeoscopePersist) list.get(0)).getIdGeoscope();
                List countryList = new Chm62edtCountryDomain().findWhere("ID_GEOSCOPE='" + idGeoscope + "'");

                if (null != countryList && countryList.size() > 0) {
                    for (int i = 0; i < countryList.size(); i++) {
                        Chm62edtCountryPersist country = (Chm62edtCountryPersist) countryList.get(i);
                        String iso3WcmcParent = country.getIso3WcmcParent();

                        // If parent has a country, search that country...
                        if (null != iso3WcmcParent) {
                            List parentCountries = new Chm62edtCountryDomain().findWhere("ID_GEOSCOPE='" + idGeoscope + "'");

                            if (null != parentCountries && parentCountries.size() > 0) {
                                Chm62edtCountryPersist parentCountry = (Chm62edtCountryPersist) parentCountries.get(i);

                                if (parentCountry.getAreaNameEnglish() != null) {
                                    result += parentCountry.getAreaNameEnglish() + " ";
                                } else if (parentCountry.getAreaNameFrench() != null) {
                                    result += parentCountry.getAreaNameFrench() + " ";
                                } else {
                                    result += parentCountry.getAreaName() + " ";
                                }
                            }
                        } else {
                            // ...else return that country
                            if (country.getAreaNameEnglish() != null) {
                                result += country.getAreaNameEnglish() + " ";
                            } else if (country.getAreaNameFrench() != null) {
                                result += country.getAreaNameFrench() + " ";
                            } else {
                                result += country.getAreaName() + " ";
                            }
                        }
                    }
                } else {
                    logger.warn("getParentCountry() : countryList was empty.");
                }
            } else {
                logger.warn("getParentCountry() : list was empty. ");
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            result = "";
        }
        return result;
    }

    /**
     * Get name of country for this site. Tries first english, then falls back to French, then the country's
     * own name for itself.
     *
     * @return Country for this site.
     */
    public String getCountry() {
        String result = "";
        Integer siteIDNatureObject = getSiteObject().getIdNatureObject();

        try {
            List list = new Chm62edtNatureObjectGeoscopeDomain().findWhere("ID_NATURE_OBJECT='" + siteIDNatureObject + "'");

            if (null != list && list.size() > 0) {
                Integer idGeoscope = ((Chm62edtNatureObjectGeoscopePersist) list.get(0)).getIdGeoscope();
                List countryList = new Chm62edtCountryDomain().findWhere("ID_GEOSCOPE='" + idGeoscope + "'");

                if (null != countryList && countryList.size() > 0) {
                    for (int i = 0; i < countryList.size(); i++) {
                        Chm62edtCountryPersist country = (Chm62edtCountryPersist) countryList.get(i);

                        if (country.getAreaNameEnglish() != null) {
                            result += country.getAreaNameEnglish() + " ";
                        } else if (country.getAreaNameFrench() != null) {
                            result += country.getAreaNameFrench() + " ";
                        } else {
                            result += country.getAreaName() + " ";
                        }
                    }
                } else {
                    logger.warn("getParentCountry() : countryList was empty.");
                }
            } else {
                logger.warn("getParentCountry() : list was empty. ");
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            result = "";
        }
        return result;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='REGION_CODE'.
     *
     * @return A non-null list of Chm62edtSitesAttributesPersist objects.
     */
    public List getRegionCode() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='REGION_CODE'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * Retrieve administrative region codes for this site.
     *
     * @return A list of RegionsCodesPersist objects.
     */
    public List findAdministrativeRegionCodes() {
        List res = new Vector();

        try {
            res =
                    new RegionsCodesDomain().findWhere("ID_SITE='" + idSite
                            + "' AND C.LOOKUP_TYPE='REGION_CODE' GROUP BY D.ID_REGION_CODE, D.NAME, E.VALUE");
            // Eventually AND E.NAME='COVER'
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='AUTHOR'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getAuthor() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='AUTHOR'");

            if (null != results && results.size() > 0) {
                Chm62edtSitesAttributesPersist attribute = (Chm62edtSitesAttributesPersist) results.get(0);

                res = attribute.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        if (null == res) {
            res = "";
        }
        return res;
    }

    /**
     * Extracts region from region code (NUTS)
     * SELECT * FROM chm62edt_region_codes WHERE ID_REGION_CODE = 'nuts';
     * @return The name of the region
     */
    public Chm62edtRegionCodesPersist getRegionCodes(){
        if(regionCodes == null){
            try {
                List results = new Chm62edtRegionCodesDomain().findWhere("ID_REGION_CODE='" + getSiteObject().getNuts() +"'");

                if (null != results && results.size() > 0) {
                    regionCodes = (Chm62edtRegionCodesPersist) results.get(0);
                }

            } catch (Exception _ex) {
                _ex.printStackTrace(System.err);
                regionCodes = null;
            }
        }
        return regionCodes;
    }

    public String getRegionName()
    {
        Chm62edtRegionCodesPersist regionCodesPersist = getRegionCodes();
        if(regionCodesPersist != null){
            return regionCodesPersist.getName();
        }
        else {
            return "";
        }
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='BIOGEOREGION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getBiogeoregion() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='BIOGEOREGION'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='HABITAT_CHARACTERIZATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getHabitatCharacterization() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='HABITAT_CHARACTERIZATION'");

            if (null != results && results.size() > 0) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='FLORA_CHARACTERIZATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getFloraCharacterization() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='FLORA_CHARACTERIZATION'");

            if (null != results && results.size() > 0) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='FAUNA_CHARACTERIZATION'.
     *
     * @return A of Chm62edtSitesAttributesPersist objects.
     */
    public String getFaunaCharacterization() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='FAUNA_CHARACTERIZATION'");

            if (null != results && results.size() > 0) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CONTACT_INTERNATIONAL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getOfficialContactInternational() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CONTACT_INTERNATIONAL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CONTACT_NATIONAL'.
     *
     * @return A non-null list of Chm62edtSitesAttributesPersist objects.
     */
    public String getOfficialContactNational() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CONTACT_NATIONAL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CONTACT_REGIONAL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getOfficialContactRegional() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CONTACT_REGIONAL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CONTACT_LOCAL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getOfficialContactLocal() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CONTACT_LOCAL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='POTENTIAL_VEGETATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPotentialVegetation() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='POTENTIAL_VEGETATION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='GEOMORPHOLOGY'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getGeomorphology() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='GEOMORPHOLOGY'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='QUALITY'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getQuality() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='QUALITY'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='VULNERABILITY'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getVulnerability() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='VULNERABILITY'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='DOCUMENTATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getDocumentation() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='DOCUMENTATION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='EDUCATIONAL_INTEREST'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getEducationalInterest() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='EDUCATIONAL_INTEREST'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CULTURAL_HERITAGE'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getCulturalHeritage() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CULTURAL_HERITAGE'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='JUSTIFICATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getJustification() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='JUSTIFICATION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='METHODOLOGY'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getMethodology() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='METHODOLOGY'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='BUDGET'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getBudget() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='BUDGET'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='OFFICIAL_URL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getURLOfficial() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='OFFICIAL_URL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='INTERESTING_URL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getURLInteresting() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='INTERESTING_URL'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='RESIDENT'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getResident() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='RESIDENT'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='BREEDING'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getBreeding() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='BREEDING'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='WINTERING'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getWintering() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='WINTERING'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='STAGING'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getStaging() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='STAGING'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='POPULATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getPopulation() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='POPULATION'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='TYPOLOGY'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getTypology() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='TYPOLOGY'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='REFERENCE_DOCUMENT_NUMBER'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getReferenceDocumentNumber() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='REFERENCE_DOCUMENT_NUMBER'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='REFERENCE_DOCUMENT_SOURCE'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getReferenceDocumentSource() {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='REFERENCE_DOCUMENT_SOURCE'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='CONSERVATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getConservation() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='CONSERVATION'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='ISOLATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getIsolation() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='ISOLATION'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='GLOBAL'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public List getGlobal() {
        List res = new Vector();

        try {
            res = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='GLOBAL'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = new Vector();
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='MAP_ID'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getMapID() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='MAP_ID'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        if (null == res) {
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='MAP_SCALE'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getMapScale() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='MAP_SCALE'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='MAP_PROJECTION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getMapProjection() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='MAP_PROJECTION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='MAP_DETAILS'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getMapDetails() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='MAP_DETAILS'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_TYPE'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoType() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_TYPE'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_NUMBER'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoNumber() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_NUMBER'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_LOCATION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoLocation() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_LOCATION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_DESCRIPTION'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoDescription() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_DESCRIPTION'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_DATE'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoDate() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_DATE'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='idSite' AND NAME='PHOTO_AUTHOR'.
     *
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String getPhotoAuthor() {
        String res = "";

        try {
            List results = new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME='PHOTO_AUTHOR'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            if (null == res) {
                res = "";
            }
        }
        return res;
    }

    /**
     * Retrieve the pictures available for this site.
     *
     * @return A list of Chm62edtNatureObjectPicturePersist objects.
     */
    public List getPicturesForSites() {
        List results = new Vector();
        String where = "";
        Chm62edtNatureObjectPictureDomain nop = new Chm62edtNatureObjectPictureDomain();

        where += " ID_OBJECT='" + getSiteObject().getIdSite() + "'";
        where += " AND NATURE_OBJECT_TYPE='Sites'";
        try {
            results = nop.findWhere(where);
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        return results;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='XXXX' AND NAME like 'YYYY%'.
     *
     * @param attrName name of the attribute.
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String findSiteAttribute(String attrName) {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME LIKE '" + attrName
                            + "%' AND SOURCE_DB='" + getSiteObject().getSourceDB() + "'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * SELECT * FROM chm62edt_sites_ATTRIBUTES WHERE ID_SITE='XXXX' AND NAME='YYYY'.
     *
     * @param attrName name of the attribute.
     * @return A list of Chm62edtSitesAttributesPersist objects.
     */
    public String findSiteAttributeEquals(String attrName) {
        String res = "";

        try {
            List results =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + idSite + "' AND NAME = '" + attrName
                            + "' AND SOURCE_DB='" + getSiteObject().getSourceDB() + "'");

            if (null != results && !results.isEmpty()) {
                Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(0);

                res = persist.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            res = "";
        }
        return res;
    }

    /**
     * Get site ID.
     *
     * @return ID of the site for which factsheet is created
     */
    public String getIDSite() {
        return idSite;
    }

    /**
     * Get site ID_NATURE_OBJECT.
     *
     * @return ID_NATURE_OBJECT of the site for which factsheet is created
     */
    public Integer getIDNatureObject() {
        try {
            return getSiteObject().getIdNatureObject();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Other related sites using Natura 2000 designations.
     *
     * @return List of DesignationsSitesRelatedDesignationsPersist objects
     */
    public List findSiteRelationsNatura2000Desigc() {
        List results = new Vector();

        try {
            results =
                    new DesignationsSitesRelatedDesignationsDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND SOURCE_TABLE = 'DESIGC' group by id_designation, description_en,NATIONAL_CATEGORY,overlap");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Other related sites using Natura 2000 designations.
     *
     * @return List of DesignationsSitesRelatedDesignationsPersist objects
     */
    public List findSiteRelationsNatura2000Desigr() {
        List results = new Vector();

        try {
            results =
                    new DesignationsSitesRelatedDesignationsDomain()
                            .findWhere("ID_SITE='"
                                    + getSiteObject().getIdSite()
                                    + "' AND SOURCE_TABLE = 'DESIGR' group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Relation with other sites.
     *
     * @return List of DesignationsSitesRelatedDesignationsPersist objects
     */
    public List findSiteRelationsCorine() {
        List results = new Vector();

        try {
            results =
                    new DesignationsSitesRelatedDesignationsDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' group by designated_site,description_en,NATIONAL_CATEGORY,overlap,overlap_type");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Find habitats within this site.
     *
     * @return List of SiteHabitatsPersist objects.
     */
    public List findSitesHabitatsByIDNatureObject() {
        List results = new Vector();

        try {
            String isGoodHabitat =
                    " IF(TRIM(chm62edt_habitat.CODE_2000) <> '',RIGHT(chm62edt_habitat.CODE_2000,2),1) <> IF(TRIM(chm62edt_habitat.CODE_2000) <> '','00',2) AND IF(TRIM(chm62edt_habitat.CODE_2000) <> '',LENGTH(chm62edt_habitat.CODE_2000),1) = IF(TRIM(chm62edt_habitat.CODE_2000) <> '',4,1) ";

            results =
                    new SiteHabitatsDomain().findWhere(isGoodHabitat + " AND A.ID_NATURE_OBJECT='"
                            + getSiteObject().getIdNatureObject()
                            + "' GROUP BY chm62edt_habitat.ID_NATURE_OBJECT, chm62edt_sites.ID_NATURE_OBJECT");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
            results = new Vector();
        }
        if (null == results) {
            results = new Vector();
        }
        return results;
    }

    /**
     * Determine site type: Natura 2000, Corine, CDDA etc.
     *
     * @return Habitat type
     */
    public String getSiteType() {
        List results = new Vector();
        String sType = "";

        try {
            results =
                    new Chm62edtSitesAttributesDomain().findWhere(" NAME='TYPE' AND ID_SITE = '" + getSiteObject().getIdSite()
                            + "'");
            if (results.size() > 0) {
                Chm62edtSitesAttributesPersist t = (Chm62edtSitesAttributesPersist) results.get(0);

                sType = t.getValue();
            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return sType;
    }

    /**
     * Returns the underlying site's main picture available in the database. If no such picture exists, the method returns null.
     *
     * @param picturePath
     * @param domainName
     * @return picture metadata as object
     */
    public PictureDTO getMainPicture(String picturePath, String domainName) {

        PictureDTO result = null;
        try {
            List<Chm62edtNatureObjectPicturePersist> pictureList = getPicturesForSites(1, true);
            if (pictureList != null && !pictureList.isEmpty()) {

                Chm62edtNatureObjectPicturePersist mainPicture = pictureList.get(0);
                if (mainPicture != null) {

                    String maxWidthStr = mainPicture.getMaxWidth().toString();
                    String maxHeightStr = mainPicture.getMaxHeight().toString();
                    Integer maxWidthInt = Utilities.checkedStringToInt(maxWidthStr, Integer.valueOf(0));
                    Integer maxHeightInt = Utilities.checkedStringToInt(maxHeightStr, Integer.valueOf(0));

                    String styleAttr = "max-width:300px; max-height:400px;";
                    if (maxWidthInt != null && maxWidthInt.intValue() > 0 && maxHeightInt != null && maxHeightInt.intValue() > 0) {
                        styleAttr = "max-width: " + maxWidthInt.intValue() + "px; max-height: " + maxHeightInt.intValue() + "px";
                    }

                    String description = mainPicture.getDescription();
                    if (description == null || description.equals("")) {
                        description = getSiteObject().getDescription();
                    }

                    result = new PictureDTO();
                    result.setFilename(mainPicture.getFileName());
                    result.setDescription(description);
                    result.setSource(mainPicture.getSource());
                    result.setSourceUrl(mainPicture.getSourceUrl());
                    result.setStyle(styleAttr);
                    result.setMaxwidth(maxWidthStr);
                    result.setMaxheight(maxHeightStr);
                    result.setPath(picturePath);
                    result.setDomain(domainName);
                    result.setLicense(mainPicture.getLicense());
                }

            }
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return result;
    }

    /**
     * Returns the main pictures of this site,a s present in the chm62edt_nature_object_picture table.
     *
     * @param limit - max number of pictures to return
     * @param mainPicOnly - only return the thumbnail.
     * @return list of pictures
     */
    private List<Chm62edtNatureObjectPicturePersist> getPicturesForSites(Integer limit, boolean mainPicOnly) {

        List<Chm62edtNatureObjectPicturePersist> resultList = new ArrayList<Chm62edtNatureObjectPicturePersist>();
        Chm62edtNatureObjectPictureDomain pictureDomain = new Chm62edtNatureObjectPictureDomain();
        String where = "";
        where += " ID_OBJECT='" + getSiteObject().getIdSite() + "'";
        where += " AND NATURE_OBJECT_TYPE='Sites'";

        if (mainPicOnly) {
            where += " AND MAIN_PIC = 1";
        }
        if (limit != null) {
            where += " LIMIT " + limit;
        }

        try {
            resultList = pictureDomain.findWhere(where);
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }
        return resultList;
    }

    /**
     * Lists the NUTS administrative regions
     *
     * @return Attributes list with NUTS code and name in the SDF
     */
    public List<Chm62edtSitesAttributesPersist> findSiteRegions() {
        List<Chm62edtSitesAttributesPersist> result = new ArrayList<Chm62edtSitesAttributesPersist>();

        try {
            result =
                    new Chm62edtSitesAttributesDomain().findWhere("ID_SITE='" + getSiteObject().getIdSite()
                            + "' AND NAME like 'NUTS_%'");
        } catch (Exception _ex) {
            _ex.printStackTrace(System.err);
        }

        return result;
    }
}
