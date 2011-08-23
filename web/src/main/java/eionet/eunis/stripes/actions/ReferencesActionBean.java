package eionet.eunis.stripes.actions;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.jrfTables.ReferencesDomain;
import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.IReferencesDao;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;
import eionet.eunis.dto.PairDTO;
import eionet.eunis.dto.ReferenceDTO;
import eionet.eunis.rdf.GenerateReferenceRDF;
import eionet.eunis.stripes.extensions.Redirect303Resolution;
import eionet.eunis.util.Constants;
import eionet.eunis.util.CustomPaginatedList;
import eionet.eunis.util.DcTermsLabels;
import eionet.eunis.util.Pair;


/**
 * Action bean for references.
 *
 * @author Risto Alt
 */
@UrlBinding("/references/{idref}/{tab}")
public class ReferencesActionBean extends AbstractStripesAction {

    private String idref;
    private CustomPaginatedList<ReferenceDTO> refs;
    private DcIndexDTO dcIndex;
    private List<AttributeDto> dcAttributes;

    // selected tab
    private String tab;
    // tabs to display
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();

    private String domainName;

    List<PairDTO> species = new ArrayList<PairDTO>();
    List<PairDTO> habitats = new ArrayList<PairDTO>();

    private int page;
    private String sort;
    private String dir;

    private Map<String, String> dcTermsLabels = new HashMap<String, String>();

    @DefaultHandler
    @DontValidate(ignoreBindingErrors = true)
    public Resolution defaultAction() {

        domainName = getContext().getInitParameter("DOMAIN_NAME");

        // Resolve what format should be returned - RDF or HTML
        if (!StringUtils.isBlank(idref) && EunisUtil.isNumber(idref)) {
            if (tab != null && tab.equals("rdf")) {
                return generateRdf();
            }
            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/references/" + idref + "/rdf");
            }
        } else {
            if (idref != null && idref.equals("rdf")) {
                return generateRdfAll();
            }
            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/references/rdf");
            }
        }

        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        String forwardPage = "/stripes/references.jsp";

        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "";
        IReferencesDao dao = DaoFactory.getDaoFactory().getReferncesDao();

        String defaultPageSize = getContext().getApplicationProperty("default.page.size");

        if (!StringUtils.isBlank(idref) && EunisUtil.isNumber(idref)) {
            forwardPage = "/stripes/reference.jsp";

            dcIndex = dao.getDcIndex(idref);
            dcAttributes = dao.getDcAttributes(idref);
            dcTermsLabels = DcTermsLabels.getDctermslabels();

            btrail = "eea#" + eeaHome
            + ",home#index.jsp,references#references";
            if (dcIndex != null && dcIndex.getTitle() != null) {
                btrail += "," + dcIndex.getTitle();
            }
            if (dcIndex == null) {
                return new ErrorResolution(404);
            }
            try {
                species = ReferencesDomain.getSpeciesForAReference(idref,
                        getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                        getContext().getJdbcUser(),
                        getContext().getJdbcPassword());

                habitats = ReferencesDomain.getHabitatsForAReferences(idref,
                        getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                        getContext().getJdbcUser(),
                        getContext().getJdbcPassword());

            } catch (CriteriaMissingException e) {
                e.printStackTrace();
            }
            tabsWithData.add(new Pair<String, String>("general", getContentManagement().cmsPhrase("General information")));
            if (species != null && species.size() > 0) {
                tabsWithData.add(new Pair<String, String>("species", getContentManagement().cmsPhrase("Species")));
            }
            if (habitats != null && habitats.size() > 0) {
                tabsWithData.add(new Pair<String, String>("habitats", getContentManagement().cmsPhrase("Habitats")));
            }

            setMetaDescription("reference");
        } else if (!StringUtils.isBlank(idref) && !EunisUtil.isNumber(idref)) {
            handleEunisException("Reference ID has to be a number!", Constants.SEVERITY_ERROR);
            setMetaDescription("references");
        } else {
            btrail = "eea#" + eeaHome + ",home#index.jsp,references";
            refs = dao.getReferences(page, Integer.parseInt(defaultPageSize), sort, dir);
            setMetaDescription("references");
        }
        setBtrail(btrail);

        return new ForwardResolution(forwardPage);
    }

    /**
     * Generates RDF for all references.
     */
    private Resolution generateRdfAll() {

        StringBuffer rdf = new StringBuffer();
        try {
            rdf.append(GenerateReferenceRDF.HEADER);
            List<DcIndexDTO> objects = DaoFactory.getDaoFactory().getReferncesDao().getDcObjects();
            for (DcIndexDTO object : objects) {
                GenerateReferenceRDF genRdf = new GenerateReferenceRDF(object);
                rdf.append(genRdf.getReferenceRdf());
            }
            rdf.append(Constants.RDF_FOOTER);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, rdf.toString());
    }

    /**
     * Generates RDF for a single reference.
     */
    private Resolution generateRdf() {

        StringBuffer rdf = new StringBuffer();
        try {
            rdf.append(GenerateReferenceRDF.HEADER);

            GenerateReferenceRDF genRdf = new GenerateReferenceRDF(idref);
            rdf.append(genRdf.getReferenceRdf());

            rdf.append(Constants.RDF_FOOTER);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, rdf.toString());
    }


    public String getIdref() {
        return idref;
    }

    public void setIdref(String idref) {
        this.idref = idref;
    }

    public CustomPaginatedList<ReferenceDTO> getRefs() {
        return refs;
    }

    public void setRefs(CustomPaginatedList<ReferenceDTO> refs) {
        this.refs = refs;
    }

    public DcIndexDTO getDcIndex() {
        return dcIndex;
    }

    public void setDcIndex(DcIndexDTO dcIndex) {
        this.dcIndex = dcIndex;
    }

    public String getTab() {
        return tab;
    }

    public void setTab(String tab) {
        this.tab = tab;
    }

    public List<Pair<String, String>> getTabsWithData() {
        return tabsWithData;
    }

    public void setTabsWithData(List<Pair<String, String>> tabsWithData) {
        this.tabsWithData = tabsWithData;
    }

    public List<PairDTO> getSpecies() {
        return species;
    }

    public void setSpecies(List<PairDTO> species) {
        this.species = species;
    }

    public List<PairDTO> getHabitats() {
        return habitats;
    }

    public void setHabitats(List<PairDTO> habitats) {
        this.habitats = habitats;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public List<AttributeDto> getDcAttributes() {
        return dcAttributes;
    }

    public Map<String, String> getDcTermsLabels() {
        return dcTermsLabels;
    }

}
