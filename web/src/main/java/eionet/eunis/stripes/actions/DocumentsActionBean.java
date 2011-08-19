package eionet.eunis.stripes.actions;


import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

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
import eionet.eunis.dao.IDocumentsDao;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;
import eionet.eunis.dto.DocumentDTO;
import eionet.eunis.dto.PairDTO;
import eionet.eunis.rdf.GenerateDocumentRDF;
import eionet.eunis.stripes.extensions.Redirect303Resolution;
import eionet.eunis.util.Constants;
import eionet.eunis.util.CustomPaginatedList;
import eionet.eunis.util.Pair;


/**
 * Action bean to handle RDF export.
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/documents/{iddoc}/{tab}")
public class DocumentsActionBean extends AbstractStripesAction {

    private String iddoc;
    private CustomPaginatedList<DocumentDTO> docs;
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

    @DefaultHandler
    @DontValidate(ignoreBindingErrors = true)
    public Resolution defaultAction() {

        domainName = getContext().getInitParameter("DOMAIN_NAME");

        // Resolve what format should be returned - RDF or HTML
        if (!StringUtils.isBlank(iddoc) && EunisUtil.isNumber(iddoc)) {
            if (tab != null && tab.equals("rdf")) {
                return generateRdf();
            }
            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/documents/" + iddoc + "/rdf");
            }
        } else {
            if (iddoc != null && iddoc.equals("rdf")) {
                return generateRdfAll();
            }
            // If accept header contains RDF, then redirect to rdf page with code 303
            String acceptHeader = getContext().getRequest().getHeader("accept");
            if (acceptHeader != null && acceptHeader.contains(Constants.ACCEPT_RDF_HEADER)) {
                return new Redirect303Resolution(domainName + "/documents/rdf");
            }
        }

        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        String forwardPage = "/stripes/documents.jsp";

        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "";
        IDocumentsDao dao = DaoFactory.getDaoFactory().getDocumentsDao();

        String defaultPageSize = getContext().getApplicationProperty("default.page.size");

        if (!StringUtils.isBlank(iddoc) && EunisUtil.isNumber(iddoc)) {
            forwardPage = "/stripes/document.jsp";
            dcIndex = dao.getDcIndex(iddoc);
            dcAttributes = dao.getDcAttributes(iddoc);
            btrail = "eea#" + eeaHome
            + ",home#index.jsp,documents#documents";
            if (dcIndex != null && dcIndex.getTitle() != null) {
                btrail += "," + dcIndex.getTitle();
            }
            if (dcIndex == null) {
                return new ErrorResolution(404);
            }
            try {
                species = ReferencesDomain.getSpeciesForAReference(iddoc,
                        getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                        getContext().getJdbcUser(),
                        getContext().getJdbcPassword());

                habitats = ReferencesDomain.getHabitatsForAReferences(iddoc,
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

            setMetaDescription("document");
        } else if (!StringUtils.isBlank(iddoc) && !EunisUtil.isNumber(iddoc)) {
            handleEunisException("Document ID has to be a number!", Constants.SEVERITY_ERROR);
            setMetaDescription("documents");
        } else {
            btrail = "eea#" + eeaHome + ",home#index.jsp,documents";
            docs = dao.getDocuments(page, Integer.parseInt(defaultPageSize), sort, dir);
            setMetaDescription("documents");
        }
        setBtrail(btrail);

        return new ForwardResolution(forwardPage);
    }

    /**
     * Generates RDF for all documents.
     */
    private Resolution generateRdfAll() {

        StringBuffer rdf = new StringBuffer();
        try {
            rdf.append(GenerateDocumentRDF.HEADER);
            List<DcIndexDTO> objects = DaoFactory.getDaoFactory().getDocumentsDao().getDcObjects();
            for (DcIndexDTO object : objects) {
                GenerateDocumentRDF genRdf = new GenerateDocumentRDF(object);
                rdf.append(genRdf.getDocumentRdf());
            }
            rdf.append(Constants.RDF_FOOTER);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, rdf.toString());
    }

    /**
     * Generates RDF for a single document.
     */
    private Resolution generateRdf() {

        StringBuffer rdf = new StringBuffer();
        try {
            rdf.append(GenerateDocumentRDF.HEADER);

            GenerateDocumentRDF genRdf = new GenerateDocumentRDF(iddoc);
            rdf.append(genRdf.getDocumentRdf());

            rdf.append(Constants.RDF_FOOTER);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new StreamingResolution(Constants.ACCEPT_RDF_HEADER, rdf.toString());
    }


    public String getIddoc() {
        return iddoc;
    }

    public void setIddoc(String iddoc) {
        this.iddoc = iddoc;
    }

    public CustomPaginatedList<DocumentDTO> getDocs() {
        return docs;
    }

    public void setDocs(CustomPaginatedList<DocumentDTO> docs) {
        this.docs = docs;
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

}
