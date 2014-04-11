package eionet.eunis.stripes.actions;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringUtils;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.jrfTables.ReferencesDomain;
import ro.finsiel.eunis.jrfTables.habitats.legal.EUNISLegalDomain;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.habitats.legal.LegalSearchCriteria;
import ro.finsiel.eunis.search.habitats.legal.LegalSortCriteria;
import ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria;
import ro.finsiel.eunis.utilities.EunisUtil;
import eionet.eunis.dao.DaoFactory;
import eionet.eunis.dao.IReferencesDao;
import eionet.eunis.dto.AttributeDto;
import eionet.eunis.dto.DcIndexDTO;
import eionet.eunis.dto.PairDTO;
import eionet.eunis.dto.ReferenceDTO;
import eionet.eunis.dto.ReferenceSpeciesDTO;
import eionet.eunis.dto.ReferenceSpeciesGroupDTO;
import eionet.eunis.util.Constants;
import eionet.eunis.util.CustomPaginatedList;
import eionet.eunis.util.Pair;

/**
 * Action bean for references.
 *
 * @author Risto Alt
 */
@UrlBinding("/references/{idref}/{section}")
public class ReferencesActionBean extends AbstractStripesAction {

    /** */
    public final static String DEFAULT_FILTER_VALUE = "Search reference by author or title here ...";

    private String idref;
    private String section;
    private CustomPaginatedList<ReferenceDTO> refs;
    private DcIndexDTO dcIndex;
    private List<AttributeDto> dcAttributes;

    /** tabs to display */
//    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();

    List<ReferenceSpeciesGroupDTO> speciesGrouped = new ArrayList<ReferenceSpeciesGroupDTO>();
    List<ReferenceSpeciesDTO> speciesByName = new ArrayList<ReferenceSpeciesDTO>();
    
    List<PairDTO> habitats = new ArrayList<PairDTO>();

    private int page = 1;
    private String sort;
    private String dir;

    /** References tab filter input and it's default phrase. */
    private String filterPhrase = DEFAULT_FILTER_VALUE;
    
    @DefaultHandler
    @DontValidate(ignoreBindingErrors = true)
    public Resolution defaultAction() {

        String forwardPage = "/stripes/references.jsp";

        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "";
        IReferencesDao dao = DaoFactory.getDaoFactory().getReferncesDao();

        String defaultPageSize = getContext().getApplicationProperty("default.page.size");
        
//        System.out.println("Listing: "+listing);

        if (!StringUtils.isBlank(idref) && EunisUtil.isNumber(idref)) {
            forwardPage = "/stripes/reference.jsp";

            dcIndex = dao.getDcIndex(idref);
            dcAttributes = dao.getDcAttributes(idref);

            btrail = "eea#" + eeaHome
                    + ",home#index.jsp,references#references";
            if (dcIndex != null && dcIndex.getTitle() != null) {
                btrail += "," + dcIndex.getTitle();
            }
            if (dcIndex == null) {
                return new ErrorResolution(404);
            }
            try {
                ReferencesDomain refDomain = new ReferencesDomain(new ReferencesSearchCriteria[0], new AbstractSortCriteria[0]);
                speciesByName = refDomain.getSpeciesForAReference(idref);

                habitats = refDomain.getHabitatsForAReferences(idref);

//                LegalSearchCriteria[] legalSearchCriterias = { new LegalSearchCriteria("any", "%",dcIndex.getTitle(),2) };
//                LegalSortCriteria[] legalSortCriterias = {new LegalSortCriteria(2,1)};
//
//                EUNISLegalDomain habitatDomain = new EUNISLegalDomain(legalSearchCriterias, legalSortCriterias);
//
//                List habitats2 = habitatDomain.getResults(0,1000,legalSortCriterias);
//
//                System.out.println(habitats2.size());

            } catch (CriteriaMissingException e) {
                e.printStackTrace();
            }

            setMetaDescription("reference");
        } else if (!StringUtils.isBlank(idref) && !EunisUtil.isNumber(idref)) {
            handleEunisException("Reference ID has to be a number!", Constants.SEVERITY_ERROR);
            setMetaDescription("references");
        } else {
            btrail = "eea#" + eeaHome + ",home#index.jsp,references";
            refs = dao.getReferences(page, Integer.parseInt(defaultPageSize), sort, dir, filterPhrase);
            setMetaDescription("references");
        }
        setBtrail(btrail);

        // check that the linked section actually exists
        if(section.equals("species") && speciesByName.size() == 0){
            section = "";
        }
        if(section.equals("habitats") && habitats.size() == 0){
            section = "";
        }

        if(!(section.equals("") || section.equals("species") || section.equals("habitats"))){
            section = "";
        }

        return new ForwardResolution(forwardPage);
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

    public List<ReferenceSpeciesGroupDTO> getSpeciesGrouped() {
        return speciesGrouped;
    }

    public void setSpeciesGrouped(List<ReferenceSpeciesGroupDTO> speciesGrouped) {
        this.speciesGrouped = speciesGrouped;
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

    public String getFilterPhrase() {
        return filterPhrase;
    }

    public void setFilterPhrase(String filterPhrase) {
        this.filterPhrase = filterPhrase;
    }

    public String getDefaultFilterValue() {
        return DEFAULT_FILTER_VALUE;
    }

    public List<ReferenceSpeciesDTO> getSpeciesByName() {
        return speciesByName;
    }

    public void setSpeciesByName(List<ReferenceSpeciesDTO> speciesByName) {
        this.speciesByName = speciesByName;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }
}
