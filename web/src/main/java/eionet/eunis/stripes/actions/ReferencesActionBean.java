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
@UrlBinding("/references/{idref}/{tab}")
public class ReferencesActionBean extends AbstractStripesAction {

    /** */
    public final static String DEFAULT_FILTER_VALUE = "Search reference by author or title here ...";

    private String idref;
    private CustomPaginatedList<ReferenceDTO> refs;
    private DcIndexDTO dcIndex;
    private List<AttributeDto> dcAttributes;

    /** selected tab */
    private String tab;

    /** tabs to display */
    private List<Pair<String, String>> tabsWithData = new LinkedList<Pair<String, String>>();

    List<ReferenceSpeciesGroupDTO> speciesGrouped = new ArrayList<ReferenceSpeciesGroupDTO>();
    List<ReferenceSpeciesDTO> speciesByName = new ArrayList<ReferenceSpeciesDTO>();
    
    List<PairDTO> habitats = new ArrayList<PairDTO>();

    private int page = 1;
    private String sort;
    private String dir;

    /** References tab filter input and it's default phrase. */
    private String filterPhrase = DEFAULT_FILTER_VALUE;
    
    /** The value is assigned from the sorting selector form */
    private int listing = 1;

    @DefaultHandler
    @DontValidate(ignoreBindingErrors = true)
    public Resolution defaultAction() {
        if (tab == null || tab.length() == 0) {
            tab = "general";
        }

        String forwardPage = "/stripes/references.jsp";

        String eeaHome = getContext().getInitParameter("EEA_HOME");
        String btrail = "";
        IReferencesDao dao = DaoFactory.getDaoFactory().getReferncesDao();

        String defaultPageSize = getContext().getApplicationProperty("default.page.size");
        
        System.out.println("Listing: "+listing);

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
                if (listing == 1){
                    speciesGrouped = ReferencesDomain.getSpeciesForAReferenceByGroup(idref,
                            getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                            getContext().getJdbcUser(),
                            getContext().getJdbcPassword());
                }
                if (listing == 2){
                    speciesByName = ReferencesDomain.getSpeciesForAReference(idref,
                            getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                            getContext().getJdbcUser(),
                            getContext().getJdbcPassword());    
                }

                habitats = ReferencesDomain.getHabitatsForAReferences(idref,
                        getContext().getJdbcDriver(), getContext().getJdbcUrl(),
                        getContext().getJdbcUser(),
                        getContext().getJdbcPassword());

            } catch (CriteriaMissingException e) {
                e.printStackTrace();
            }
            tabsWithData.add(new Pair<String, String>("general", getContentManagement().cmsPhrase("General information")));
            if ((speciesGrouped != null && speciesGrouped.size() > 0) || (speciesByName != null && speciesByName.size() > 0)) {
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
            refs = dao.getReferences(page, Integer.parseInt(defaultPageSize), sort, dir, filterPhrase);
            setMetaDescription("references");
        }
        setBtrail(btrail);

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

    public int getListing() {
        return listing;
    }

    public void setListing(int listing) {
        this.listing = listing;
    }

    public List<ReferenceSpeciesDTO> getSpeciesByName() {
        return speciesByName;
    }

    public void setSpeciesByName(List<ReferenceSpeciesDTO> speciesByName) {
        this.speciesByName = speciesByName;
    }

}
