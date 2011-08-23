package eionet.eunis.stripes.actions;


import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist;
import ro.finsiel.eunis.jrfTables.sites.designation_code.DesignationPersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.designations.FactsheetDesignations;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dto.DesignationDcObjectDTO;
import eionet.eunis.rdf.GenerateDesignationRDF;
import eionet.eunis.stripes.extensions.Redirect303Resolution;
import eionet.eunis.util.Constants;


/**
 * Action bean to handle designations-factsheet functionality.
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tietoenator.com">contact</a>
 */
@UrlBinding("/designations/{idGeo}:{idDesig}/{tab}")
public class DesignationsFactsheetActionBean extends AbstractStripesAction {

    private String idGeo = "";
    private String idDesig = "";
    private boolean showSites = false;
    private String fromWhere = "";

    private String btrail;
    private String pageTitle = "";
    private String metaDescription = "";

    private String fromWho = "";
    private String country = "";
    private boolean isCountry = false;
    private String cddacount = "";
    private DesignationDcObjectDTO reference;
    private List<DesignationPersist> sites;
    private String siteIds = "";
    private boolean hasSites = false;

    private Chm62edtDesignationsPersist factsheet;

    // Variable for RDF generation
    private String tab;
    private StringBuffer rdf;
    private String domainName;

    /**
     * Init designation factsheet
     */
    @DefaultHandler
    public Resolution defaultAction() {

        // Resolve what format should be returned - RDF or HTML
        if (idGeo != null && idGeo.length() > 0 && idDesig != null && idDesig.length() > 0) {
            if (tab != null && tab.equals("rdf")) {
                return generateRdf();
            }
            domainName = getContext().getInitParameter("DOMAIN_NAME");

            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/designations/" + idGeo + ":" + idDesig + "/rdf");
            }
        }

        String eeaHome = getContext().getInitParameter("EEA_HOME");

        btrail = "eea#" + eeaHome + ",home#index.jsp,sites#sites.jsp,designation_factsheet_location";
        pageTitle = getContext().getInitParameter("PAGE_TITLE")
        + getContentManagement().cmsPhrase("Designation identification for ");

        if (idDesig != null && idGeo != null) {
            FactsheetDesignations design = new FactsheetDesignations(idDesig, idGeo);

            // Get the DesignationPersist object
            factsheet = design.FindDesignationPersist();
            if (factsheet != null) {

                // Name of designation
                fromWho = (factsheet.getDescription() != null
                        && !factsheet.getDescription().equalsIgnoreCase("")
                        ? factsheet.getDescription()
                                : "");
                if (fromWho.equalsIgnoreCase("")) {
                    fromWho = (factsheet.getDescriptionEn() != null
                            && !factsheet.getDescriptionEn().equalsIgnoreCase("")
                            ? factsheet.getDescriptionEn()
                                    : "");
                }

                country = Utilities.formatString(Utilities.findCountryByIdGeoscope(factsheet.getIdGeoscope()), "");
                if (country.equalsIgnoreCase("Europe")) {
                    country = "European Community";
                }

                if (country != null && country.trim().length() > 0) {
                    List countries = new Chm62edtCountryDomain().findWhere(
                            "ISO_2L<>'' AND ISO_2L<>'null' AND ISO_2L IS NOT NULL AND SELECTION <> 0 and AREA_NAME_EN ='"
                            + country + "'");

                    if (countries != null && countries.size() > 0) {
                        isCountry = true;
                    }
                }

                // Are CDDA sites or not
                if (factsheet.getCddaSites() != null) {
                    cddacount = factsheet.getCddaSites();
                    if (!cddacount.equalsIgnoreCase("Y")) {
                        cddacount = "Yes";
                    } else {
                        cddacount = "No";
                    }
                }
                try {
                    reference = DaoFactory.getDaoFactory().getReferncesDao().getDesignationDcObject(idDesig, idGeo);

                    if (showSites) {
                        sites = SitesSearchUtility.findSitesForDesignation(idDesig, idGeo);
                        int maxSitesPerMap = Utilities.checkedStringToInt(
                                getContext().getInitParameter(
                                "MAX_SITES_PER_MAP"),
                                2000);

                        if (sites.size() < maxSitesPerMap) {
                            for (int i = 0; i < sites.size(); i++) {
                                DesignationPersist site = sites.get(i);

                                siteIds += "'" + site.getIdSite() + "'";
                                if (i < sites.size() - 1) {
                                    siteIds += ",";
                                }
                            }
                        }
                    }

                    hasSites = getContext().getSqlUtilities().DesignationHasSites(idDesig, idGeo);

                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }

        return new ForwardResolution("/stripes/designations-factsheet.jsp");
    }

    /**
     * Generate RDF for a designation
     */
    private Resolution generateRdf() {
        try {
            rdf = new StringBuffer();
            rdf.append(GenerateDesignationRDF.HEADER);

            GenerateDesignationRDF genRdf = new GenerateDesignationRDF(idDesig, idGeo);
            rdf.append(genRdf.getDesignationRdf());

            rdf.append(Constants.RDF_FOOTER);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, rdf.toString());
    }

    public Chm62edtDesignationsPersist getFactsheet() {
        return factsheet;
    }

    /**
     * @return the btrail
     */
    public String getBtrail() {
        return btrail;
    }

    /**
     * @return the pageTitle
     */
    public String getPageTitle() {
        return pageTitle;
    }

    /**
     * @return the metaDescription
     */
    public String getMetaDescription() {
        return metaDescription;
    }

    public String getIdGeo() {
        return idGeo;
    }

    public void setIdGeo(String idGeo) {
        this.idGeo = idGeo;
    }

    public String getIdDesig() {
        return idDesig;
    }

    public void setIdDesig(String idDesig) {
        this.idDesig = idDesig;
    }

    public boolean isShowSites() {
        return showSites;
    }

    public void setShowSites(boolean showSites) {
        this.showSites = showSites;
    }

    public String getFromWhere() {
        return fromWhere;
    }

    public void setFromWhere(String fromWhere) {
        this.fromWhere = fromWhere;
    }

    public String getFromWho() {
        return fromWho;
    }

    public String getCountry() {
        return country;
    }

    public boolean getIsCountry() {
        return isCountry;
    }

    public String getCddacount() {
        return cddacount;
    }

    public DesignationDcObjectDTO getReference() {
        return reference;
    }

    public List<DesignationPersist> getSites() {
        return sites;
    }

    public boolean isHasSites() {
        return hasSites;
    }

    public String getSiteIds() {
        return siteIds;
    }

    public String getTab() {
        return tab;
    }

    public void setTab(String tab) {
        this.tab = tab;
    }

}
