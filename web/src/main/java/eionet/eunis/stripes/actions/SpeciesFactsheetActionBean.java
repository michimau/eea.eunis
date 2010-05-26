package eionet.eunis.stripes.actions;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.simpleframework.xml.convert.AnnotationStrategy;
import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.Format;

import com.ibm.icu.util.StringTokenizer;

import ro.finsiel.eunis.ImageProcessing;
import ro.finsiel.eunis.factsheet.species.GeographicalStatusWrapper;
import ro.finsiel.eunis.factsheet.species.NationalThreatWrapper;
import ro.finsiel.eunis.factsheet.species.SpeciesFactsheet;
import ro.finsiel.eunis.factsheet.species.ThreatColor;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPictureDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPicturePersist;
import ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.DistributionWrapper;
import ro.finsiel.eunis.jrfTables.species.factsheet.ReportsDistributionStatusPersist;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import ro.finsiel.eunis.search.UniqueVector;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.search.species.VernacularNameWrapper;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.dto.ClassificationDTO;
import eionet.eunis.dto.LinkDTO;
import eionet.eunis.dto.PictureDTO;
import eionet.eunis.dto.ResourceDto;
import eionet.eunis.dto.SpeciesDistributionDTO;
import eionet.eunis.dto.SpeciesFactsheetDto;
import eionet.eunis.dto.SpeciesSynonymDto;
import eionet.eunis.dto.VernacularNameDto;
import eionet.eunis.util.Constants;
import eionet.eunis.util.Pair;

/**
 * ActionBean to replace old /species-factsheet.jsp.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@UrlBinding("/species/{idSpecies}/{tab}")
public class SpeciesFactsheetActionBean extends AbstractStripesAction implements RdfAware {
	
	private static final String[][] allTypes = new String[][]{
		{"GENERAL_INFORMATION","general"},
		{"VERNACULAR_NAMES","vernacular"},
		{"GEOGRAPHICAL_DISTRIBUTION","countries"},
		{"POPULATION","population"},
		{"TRENDS","trends"},
		{"REFERENCES","references"},
		{"GRID_DISTRIBUTION","grid"},
		{"LEGAL_INSTRUMENTS","legal"},
		{"HABITATS","habitats"},
		{"SITES","sites"},
		{"GBIF","gbif"}};

	private static final String EXPECTED_IN_PREFIX = "http://eunis.eea.europa.eu/sites/";

	private String idSpecies;
	private int idSpeciesLink;
	
	private SpeciesFactsheet factsheet;
	private String scientificName = "";
	private String author = "";
	
	
	//selected tab
	private String tab;
	//tabs to display
	private List<Pair<String,String>> tabsWithData = new LinkedList<Pair<String,String>>();
	//refered from name
	private String referedFromName;

	//General tab variables
	private PictureDTO pic;
	private SpeciesNatureObjectPersist specie;
	private List<ClassificationDTO> classifications;
	private String authorDate;
	private String gbifLink;
    private String gbifLink2;
    private String kingdomname;
    private String redlistLink;
    private String scientificNameURL;
    private String speciesName;
    private String wormsid;
    private String faeu;
    private String itisTSN;
    private String ncbi;
    private ArrayList<LinkDTO> links;
    private List consStatus;
    private List subSpecies;
    private String domainName;
    private String urlPic;
    
    //Vernacular names tab variables
    private List<VernacularNameWrapper> vernNames;
    
    
    //countries tab variables
    private Vector<GeographicalStatusWrapper> bioRegions;
    boolean showGeoDistribution = false;
    private String filename;
    private UniqueVector colorURL;
    private String mapserverURL;
    private String parameters;
    private Hashtable statusColorPair;
	
	//Grid distribution tab variables
	private String gridImage;
	private boolean gridDistSuccess;
	private List<SpeciesDistributionDTO> speciesDistribution;

	
	@DefaultHandler
	@SuppressWarnings("unchecked")
	public Resolution index(){
		String idSpeciesText = null;
		if(tab == null || tab.length() == 0){
			tab = "general";
		}
		
		//sanity checks
		if(StringUtils.isBlank(idSpecies) && idSpeciesLink == 0) {
			factsheet = new SpeciesFactsheet(0, 0);
		}
		int tempIdSpecies = 0;
		
		//get idSpecies based on the request param.
		if (StringUtils.isNumeric(idSpecies)) {
			tempIdSpecies = new Integer(idSpecies);
		} else if (!StringUtils.isBlank(idSpecies)) {
			idSpeciesText = idSpecies;
			tempIdSpecies = getContext().getSpeciesFactsheetDao().getIdSpeciesForScientificName(this.idSpecies);
		}
		
		
		int mainIdSpecies = getContext().getSpeciesFactsheetDao().getCanonicalIdSpecies(tempIdSpecies);
		//it is not a synonym, check the referer
		if (mainIdSpecies == tempIdSpecies) {
			Integer referedFrom = (Integer) getContext().getFromSession("referer");
			if (referedFrom != null && referedFrom > 0) {
				getContext().removeFromSession("referer");
				referedFromName = getContext().getSpeciesFactsheetDao().getScientificName(referedFrom);
			}
			factsheet = new SpeciesFactsheet(mainIdSpecies, mainIdSpecies);
		}
		//it's a synonym for another specie, redirect.
		else {
			getContext().addToSession("referer", tempIdSpecies);
			return new RedirectResolution(getUrlBinding()).addParameter("idSpecies", mainIdSpecies);
		}
		
		if (StringUtils.isNotBlank(idSpeciesText) && !factsheet.exists()) {
			//redirecting to more general search in case user tried text based search
			String redirectUrl = "/species-names-result.jsp?pageSize=10" +
					"&relationOp=2&typeForm=0&showGroup=true&showOrder=true" +
					"&showFamily=true&showScientificName=true&showVernacularNames=true" +
					"&showValidName=true&searchSynonyms=true&sort=2&ascendency=0" +
					"&scientificName=" + idSpeciesText;
			return new RedirectResolution(redirectUrl);
		}
		
		if (factsheet.exists()) {
			//set up some vars used in the presentation layer
			setMetaDescription(factsheet.getSpeciesDescription());
			scientificName = StringEscapeUtils.escapeHtml(
					factsheet.getSpeciesNatureObject().getScientificName());
			author  = StringEscapeUtils.escapeHtml(
					factsheet.getSpeciesNatureObject().getAuthor());
			
			SQLUtilities sqlUtil = getContext().getSqlUtilities();
			for (int i = 0; i< allTypes.length; i++) {
				if (!sqlUtil.TabPageIsEmpy(factsheet.getSpeciesNatureObject().getIdNatureObject().toString(), "SPECIES", allTypes[i][0])) {
					tabsWithData.add(new Pair<String, String>(allTypes[i][1], getContentManagement().cms(allTypes[i][0].toLowerCase())));
				}
			}
			
			specie = factsheet.getSpeciesNatureObject();
			domainName = getContext().getInitParameter("DOMAIN_NAME");
			
			if(tab != null && tab.equals("general")){
				generalTabActions(mainIdSpecies);
			}
			
			if(tab != null && tab.equals("vernacular")){
				vernNames = SpeciesSearchUtility.findVernacularNames(specie.getIdNatureObject());
			}
			
			if(tab != null && tab.equals("countries")){
				geoTabActions();
			}
			
			if(tab != null && tab.equals("grid")){
				gridDistributionTabActions();
			}
			
		} 
		String eeaHome = getContext().getInitParameter("EEA_HOME");
		String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,factsheet";
		setBtrail(btrail);
		return new ForwardResolution("/stripes/species-factsheet.layout.jsp");
	}

	private int getSpeciesId() {
		int tempIdSpecies = 0;
		//get idSpecies based on the request param.
		if (StringUtils.isNumeric(idSpecies)) {
			tempIdSpecies = new Integer(idSpecies);
		} else if (!StringUtils.isBlank(idSpecies)) {
			tempIdSpecies = getContext().getSpeciesFactsheetDao().getIdSpeciesForScientificName(this.idSpecies);
		}
		return tempIdSpecies;
	}
	
	public Resolution generateRdf() {
		int speciesId = getSpeciesId();
		if (speciesId == 0) {
			return new ErrorResolution(404);
		}
		factsheet = new SpeciesFactsheet(speciesId,speciesId);
		if (!factsheet.exists()) {
			return new ErrorResolution(404);
		}
		
		Persister persister = new Persister(new Format(4));
		
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		SpeciesFactsheetDto dto = new SpeciesFactsheetDto();
		dto.setSpeciesId(factsheet.getSpeciesObject().getIdSpecies());
		dto.setScientificName(factsheet.getSpeciesObject().getScientificName());
		dto.setGenus(factsheet.getSpeciesObject().getGenus());
		dto.setAuthor(factsheet.getSpeciesObject().getAuthor());
		dto.setDwcScientificName(dto.getScientificName() + ' ' + dto.getAuthor());
		
		dto.setAttributes(
				getContext().getSpeciesFactsheetDao().getAttributesForNatureObject(
						factsheet.getSpeciesObject().getIdNatureObject()));
		
		//setting expectedInLocations
		List<String> expectedLocations = getContext().getSpeciesFactsheetDao().getExpectedInSiteIds(
				factsheet.getSpeciesObject().getIdSpecies(),
				0);
		if (expectedLocations != null && !expectedLocations.isEmpty()) {
			List<ResourceDto> expectedInSites = new LinkedList<ResourceDto>();
			for(String siteId : expectedLocations) {
				expectedInSites.add(new ResourceDto(siteId, EXPECTED_IN_PREFIX));
			}
			dto.setExpectedInLocations(expectedInSites);
		}
		
		List<VernacularNameWrapper> vernacularNames = SpeciesSearchUtility.findVernacularNames(
						factsheet.getSpeciesObject().getIdNatureObject());
		if (factsheet.getIdSpeciesLink() != null 
					&& !factsheet.getIdSpeciesLink().equals(factsheet.getIdSpecies())) {
			dto.setSynonymFor(new SpeciesSynonymDto(factsheet.getIdSpeciesLink()));
		}
		List<Integer> isSynonymFor = getContext()
				.getSpeciesFactsheetDao()
				.getSynonyms(factsheet.getIdSpecies());
		List<SpeciesSynonymDto> speciesSynonym = new LinkedList<SpeciesSynonymDto>();
		if (isSynonymFor != null && !isSynonymFor.isEmpty()) {
			for(Integer idSpecies : isSynonymFor) {
				speciesSynonym.add(new SpeciesSynonymDto(idSpecies));
			}
			dto.setHasSynonyms(speciesSynonym);
		}
		
		
		if (vernacularNames != null) {
			List<VernacularNameDto> vernacularDtos = new LinkedList<VernacularNameDto>();
			for (VernacularNameWrapper wrapper : vernacularNames) {
				vernacularDtos.add(new VernacularNameDto(wrapper));
			}
			dto.setVernacularNames(vernacularDtos);
		}
		
		try {
			buffer.write(SpeciesFactsheetDto.HEADER.getBytes("UTF-8"));
			persister.write(dto, buffer, "UTF-8");
			buffer.write(SpeciesFactsheetDto.FOOTER.getBytes("UTF-8"));
			buffer.flush();
			return new StreamingResolution(
					"application/rdf+xml",
					buffer.toString("UTF-8"));
		} catch (Exception ignored) {
			logger.warn("exception while generating rdf for species, " + ignored);
			throw new RuntimeException(ignored);
		}
//		return new ErrorResolution(404);
	}
	
	private void generalTabActions(int mainIdSpecies) {
		
		consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());
		urlPic="idobject=" + specie.getIdSpecies() + "&amp;natureobjecttype=Species";
		
		List<Chm62edtNatureObjectPicturePersist> pictures = new Chm62edtNatureObjectPictureDomain()
		.findWhere("MAIN_PIC = 1 AND ID_OBJECT = " + mainIdSpecies );
		if (pictures != null && !pictures.isEmpty()) {
			String mainPictureMaxWidth = pictures.get(0).getMaxWidth().toString();
			String mainPictureMaxHeight = pictures.get(0).getMaxHeight().toString();
			Integer mainPictureMaxWidthInt = Utilities.checkedStringToInt(mainPictureMaxWidth, new Integer(0));
			Integer mainPictureMaxHeightInt = Utilities.checkedStringToInt(mainPictureMaxHeight, new Integer(0));
			
			String styleAttr = "max-width:300px; max-height:400px;";
			if(mainPictureMaxWidthInt != null && mainPictureMaxWidthInt.intValue() > 0 && mainPictureMaxHeightInt != null && mainPictureMaxHeightInt.intValue() > 0){
				styleAttr = "max-width: "+mainPictureMaxWidthInt.intValue()+"px; max-height: "+mainPictureMaxHeightInt.intValue()+"px";
			}
			
			String desc = pictures.get(0).getDescription();
			if(desc == null || desc.equals(""))
				desc = specie.getScientificName();
			
			String picturePath = getContext().getInitParameter("UPLOAD_DIR_PICTURES_SPECIES");
			
			pic = new PictureDTO();
			pic.setFilename(pictures.get(0).getFileName());
			pic.setDescription(desc);
			pic.setSource(pictures.get(0).getSource());
			pic.setStyle(styleAttr);
			pic.setMaxwidth(mainPictureMaxWidth);
			pic.setMaxheight(mainPictureMaxHeight);
			pic.setPath(picturePath);
			pic.setDomain(domainName);
			pic.setUrl(urlPic);
		}
		
		List list = new Vector<Chm62edtTaxcodePersist>();
	    try{
	    	list = new Chm62edtTaxcodeDomain().findWhere("ID_TAXONOMY = '" + specie.getIdTaxcode() + "'");
	    
		    authorDate = SpeciesFactsheet.getBookAuthorDate(factsheet.getTaxcodeObject().IdDcTaxcode());
		    classifications = new ArrayList<ClassificationDTO>();
		    if (list != null && list.size() > 0){
		    	Chm62edtTaxcodePersist t = (Chm62edtTaxcodePersist) list.get(0);
		    	String str = t.getTaxonomyTree();
		    	StringTokenizer st = new StringTokenizer(str,",");
		    	int i = 0;
		    	while(st.hasMoreTokens()){
		    		StringTokenizer sts = new StringTokenizer(st.nextToken(),"*");
		    		String classification_id = sts.nextToken();
		            String classification_level = sts.nextToken();
		            String classification_name = sts.nextToken();
		            
		            if(classification_level.equalsIgnoreCase("kingdom"))
		            	kingdomname = classification_name;
	    		
		    		ClassificationDTO classif = new ClassificationDTO();
		    		classif.setId(classification_id);
		    		classif.setLevel(classification_level);
		    		classif.setName(classification_name);
		    		classifications.add(classif);
		    	}
		    }
		    
		    gbifLink = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_GBIF);//specie.getScientificName();
		    gbifLink2 = specie.getScientificName();
	      	gbifLink2 = gbifLink2.replaceAll( "\\.", "" );
	      	gbifLink2 = URLEncoder.encode(gbifLink2,"UTF-8");
	      	
	      	String sn = scientificName;
	        sn=sn.replaceAll("sp.","").replaceAll("ssp.","");
	        
	        if( kingdomname.equalsIgnoreCase( "Animalia" ) ) kingdomname = "Animals";
	        if( kingdomname.equalsIgnoreCase( "Plantae" ) ) kingdomname = "Plants";
	        if( kingdomname.equalsIgnoreCase( "Fungi" ) ) kingdomname = "Mushrooms";

	        speciesName = (scientificName.trim().indexOf(" ")>=0? scientificName.trim().substring(scientificName.indexOf(" ") + 1) : scientificName);
	        
	        redlistLink = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SPECIES_REDLIST);
	        
	        // List of species national threat status.
	    	if( consStatus != null && consStatus.size() > 0 ) {
	    		for (int i=0;i<consStatus.size();i++){
	    			NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
	    			if(threat.getReference() != null && threat.getReference().indexOf("IUCN")>=0){
	    				scientificNameURL = scientificName.replace(' ','+');
	    			}
	    		}
	    	}
	    	
	    	// World Register of Marine Species - also has seals etc.
	    	wormsid = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_WORMS);
	    	
	    	if(kingdomname.equalsIgnoreCase("Animals"))
	    		faeu = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_FAEU);
	    	
	    	itisTSN = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_ITIS);
	    	ncbi = factsheet.getLink(specie.getIdNatureObject(),Constants.SAME_SYNONYM_NCBI);
	    	
	    	String[][] linkTab = {
	    		{Constants.ART17_SUMMARY,"Art. 17 summary"},
	    		{Constants.BBC_PAGE,"BBC page"},
	    		{Constants.BIOLIB_PAGE,"Biolib page"},
	    		{Constants.BUG_GUIDE,"Bug Guide page"},
	    		{Constants.WIKIPEDIA_ARTICLE,"Wikipedia article"},
	    		{Constants.WIKISPECIES_ARTICLE,"Wikispecies article"}
	    	};
	    	String linkUrl;
	    	links = new ArrayList<LinkDTO>();
	    	for(String[] linkSet : linkTab) {
	    		linkUrl = factsheet.getLink(specie.getIdNatureObject(), linkSet[0]);
	    		if(linkUrl != null && linkUrl.length() > 0) {
	    			LinkDTO linkDTO = new LinkDTO();
	    			linkDTO.setName(linkSet[1]);
	    			linkDTO.setUrl(linkUrl);
	    			links.add(linkDTO);
	        	}
	    	}
	    	
	    	if( consStatus.size() > 0 ){
	    		List<NationalThreatWrapper> newList = new ArrayList<NationalThreatWrapper>();
	    		for (int i = 0; i < consStatus.size(); i++){
	    			String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
	    			NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
	    			String statusDesc = factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ");
	    			threat.setStatusDesc(statusDesc);
	    			newList.add(threat);
	    		}
	    		consStatus = newList;
	    	}
	    	
	    	subSpecies = factsheet.getSubspecies();
	    	if (!subSpecies.isEmpty()) {
	    		List<SpeciesNatureObjectPersist> newList = new ArrayList<SpeciesNatureObjectPersist>();
	    		for (int i = 0; i < subSpecies.size(); i++){
	    			SpeciesNatureObjectPersist species = (SpeciesNatureObjectPersist)subSpecies.get(i);
	    			String bad = SpeciesFactsheet.getBookAuthorDate(species.getIdDublinCore());
	    			if(bad != null)
	    				species.setBookAuthorDate(bad);
	    			newList.add(species);
	    		}
	    		subSpecies = newList;
	    	}
	    	
	    } catch (Exception ex) {
	    	ex.printStackTrace();
	    }
	}
	
	private void geoTabActions() {
		bioRegions = SpeciesFactsheet.getBioRegionIterator(specie.getIdNatureObject(), factsheet.getIdSpecies() );
		if( bioRegions.size() > 0 ){
			// Display map
		    colorURL = new UniqueVector();
		    UniqueVector statuses = new UniqueVector();
		    // Get all distinct statuses
		    for (int i = 0;  i < bioRegions.size(); i++){
		    	GeographicalStatusWrapper aRow = ( GeographicalStatusWrapper )bioRegions.get(i);
		    	statuses.addElement( aRow.getStatus() );
		    }
		    // Compute distinct color for each status
		    statusColorPair = ThreatColor.getColorsForMap(statuses);
		    Vector addedCountries = new Vector();
		    //fix to display in map legend only visible colours
		    statuses.clear();
		    for ( int i = 0; i < bioRegions.size(); i++ ){
		    	GeographicalStatusWrapper aRow = (GeographicalStatusWrapper)bioRegions.get(i);
		    	Chm62edtCountryPersist cntry = aRow.getCountry();
		    	if ( cntry != null && !addedCountries.contains( cntry.getAreaNameEnglish() ) ){
		    		String color = ":H" + (String)statusColorPair.get(aRow.getStatus().toLowerCase());
		    		String countryColPair = (cntry.getIso2Wcmc()==null)?cntry.getIso2l():cntry.getIso2Wcmc() + color;
		    		colorURL.addElement(countryColPair);
		    		addedCountries.add(  cntry.getAreaNameEnglish() );
		    		//	fix to display in map legend only visible colours
		    		statuses.addElement( aRow.getStatus() );
		    	}
		    }
		    //fix to display in map legend only visible colours
		    statusColorPair = ThreatColor.getColorsForMap(statuses);
		    
		    int COUNTRIES_PER_MAP = Utilities.checkedStringToInt( getContext().getInitParameter( "COUNTRIES_PER_MAP" ), 120 );
		    if ( addedCountries.size() < COUNTRIES_PER_MAP ){
		    	showGeoDistribution = true;
		    	mapserverURL = getContext().getInitParameter("EEA_MAP_SERVER");
		    	parameters = "mapType=Standard_B&amp;Q=" + colorURL.getElementsSeparatedByComma() + "&amp;outline=1";
		    	filename = mapserverURL + "/getmap.asp?" + parameters;
		    }
		}
	}
	
	private void gridDistributionTabActions() {
		
		speciesDistribution = new ArrayList<SpeciesDistributionDTO>();
		
		DistributionWrapper dist = new DistributionWrapper(factsheet.getSpeciesNatureObject().getIdNatureObject());
		List d = dist.getDistribution();
		if (null != d && d.size() > 0){
			String filename = getContext().getRequest().getSession().getId() + "_" + new Date().getTime() + "_europe.jpg";
			String tempDir = getContext().getInitParameter( "TEMP_DIR" );
		    String inputFilename = getContext().getServletContext().getRealPath("/") + "gis/europe-bio.jpg";
		    gridImage = tempDir + filename;
		    String outputFilename = getContext().getServletContext().getRealPath("/") + gridImage;

		    gridDistSuccess = false;
		    try {
		    	ImageProcessing img = new ImageProcessing( inputFilename, outputFilename );
		    	img.init();
		    	for (int i = 0; i < d.size(); i += 2){
		    		ReportsDistributionStatusPersist dis;
		    		if ( i < d.size() - 1 ){
		    			dis = ( ReportsDistributionStatusPersist ) d.get( i + 1 );
		    			if(dis.getLatitude() != null && dis.getLongitude() != null && dis.getLatitude().doubleValue() != 0 && dis.getLongitude().doubleValue() != 0){
		    				double longitude = dis.getLongitude().doubleValue();
		    				double latitude = dis.getLatitude().doubleValue();
		    				int x;
		    				int y;
		    				//WEST +15
		    				//EAST +44
		    				//NORTH +73
		    				//SOUTH +34
		    				//PIC SIZE: 616 x 407
		    				//the map goes from -15 to 44 in longitude
		    				x = ( int ) ( ( 616 * 15 ) / 59 + ( ( longitude * 616 ) / 59 ) );
		    				//the map goes from 34 to 73 in latitude
		    				y = ( int ) ( 407 - ( ( ( ( latitude - 34 ) * 407 ) / 39 ) ) );
		    				int radius = 4;
		    				img.drawPoint( x, y, Color.RED, radius );
		    			}
		    		}
		    	}
		    	img.save();
		    	gridDistSuccess = true;
		    } catch( Throwable ex ) {
		    	gridDistSuccess = false;
		    	ex.printStackTrace();
		    }
		    
		    for (int i = 0; i < d.size(); i += 2){
		    	SpeciesDistributionDTO gridDTO = new SpeciesDistributionDTO();
		    	
		        ReportsDistributionStatusPersist dis = (ReportsDistributionStatusPersist) d.get(i);
		        gridDTO.setName(dis.getIdLookupGrid());
		        gridDTO.setStatus(dis.getDistributionStatus());
		        gridDTO.setReference(dis.getIdDc().toString());
		        if (i < d.size() - 1){
		        	dis = (ReportsDistributionStatusPersist) d.get(i+1);
		        	gridDTO.setLongitude(dis.getLongitude().toString());
		        	gridDTO.setLatitude(dis.getLatitude().toString());
		        }
		        speciesDistribution.add(gridDTO);
		    }
		}
	}

	/**
	 * @return the factsheet
	 */
	public SpeciesFactsheet getFactsheet() {
		return factsheet;
	}

	/**
	 * @param factsheet the factsheet to set
	 */
	public void setFactsheet(SpeciesFactsheet factsheet) {
		this.factsheet = factsheet;
	}

	/**
	 * @return the currentTab
	 */
	public String getTab() {
		return tab;
	}

	/**
	 * @param currentTab the currentTab to set
	 */
	public void setTab(String tab) {
		this.tab = tab;
	}

	/**
	 * @return the tabsWithData
	 */
	public List<Pair<String, String>> getTabsWithData() {
		return tabsWithData;
	}

	/**
	 * @return the idSpecies
	 */
	public String getIdSpecies() {
		return idSpecies;
	}

	/**
	 * @param idSpecies the idSpecies to set
	 */
	public void setIdSpecies(String idSpecies) {
		this.idSpecies = idSpecies;
	}

	/**
	 * @return the referedFromName
	 */
	public String getReferedFromName() {
		return referedFromName;
	}

	/**
	 * @return the idSpeciesLink
	 */
	public int getIdSpeciesLink() {
		return idSpeciesLink;
	}

	/**
	 * @param idSpeciesLink the idSpeciesLink to set
	 */
	public void setIdSpeciesLink(int idSpeciesLink) {
		this.idSpeciesLink = idSpeciesLink;
	}


	/**
	 * @return the scientificName
	 */
	public String getScientificName() {
		return scientificName;
	}


	/**
	 * @return the author
	 */
	public String getAuthor() {
		return author;
	}

	public boolean isGridDistSuccess() {
		return gridDistSuccess;
	}

	public void setGridDistSuccess(boolean gridDistSuccess) {
		this.gridDistSuccess = gridDistSuccess;
	}

	public List<SpeciesDistributionDTO> getSpeciesDistribution() {
		return speciesDistribution;
	}

	public String getGridImage() {
		return gridImage;
	}

	public PictureDTO getPic() {
		return pic;
	}

	public void setPic(PictureDTO pic) {
		this.pic = pic;
	}

	public SpeciesNatureObjectPersist getSpecie() {
		return specie;
	}

	public void setSpecie(SpeciesNatureObjectPersist specie) {
		this.specie = specie;
	}

	public List<ClassificationDTO> getClassifications() {
		return classifications;
	}

	public void setClassifications(List<ClassificationDTO> classifications) {
		this.classifications = classifications;
	}

	public String getAuthorDate() {
		return authorDate;
	}

	public void setAuthorDate(String authorDate) {
		this.authorDate = authorDate;
	}

	public String getGbifLink() {
		return gbifLink;
	}

	public void setGbifLink(String gbifLink) {
		this.gbifLink = gbifLink;
	}

	public String getGbifLink2() {
		return gbifLink2;
	}

	public void setGbifLink2(String gbifLink2) {
		this.gbifLink2 = gbifLink2;
	}

	public String getKingdomname() {
		return kingdomname;
	}

	public void setKingdomname(String kingdomname) {
		this.kingdomname = kingdomname;
	}

	public String getRedlistLink() {
		return redlistLink;
	}

	public void setRedlistLink(String redlistLink) {
		this.redlistLink = redlistLink;
	}

	public String getScientificNameURL() {
		return scientificNameURL;
	}

	public void setScientificNameURL(String scientificNameURL) {
		this.scientificNameURL = scientificNameURL;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
	}

	public String getWormsid() {
		return wormsid;
	}

	public void setWormsid(String wormsid) {
		this.wormsid = wormsid;
	}

	public String getFaeu() {
		return faeu;
	}

	public void setFaeu(String faeu) {
		this.faeu = faeu;
	}

	public String getItisTSN() {
		return itisTSN;
	}

	public void setItisTSN(String itisTSN) {
		this.itisTSN = itisTSN;
	}

	public String getNcbi() {
		return ncbi;
	}

	public void setNcbi(String ncbi) {
		this.ncbi = ncbi;
	}

	public ArrayList<LinkDTO> getLinks() {
		return links;
	}

	public void setLinks(ArrayList<LinkDTO> links) {
		this.links = links;
	}

	public List getConsStatus() {
		return consStatus;
	}

	public void setConsStatus(List consStatus) {
		this.consStatus = consStatus;
	}

	public List getSubSpecies() {
		return subSpecies;
	}

	public void setSubSpecies(List subSpecies) {
		this.subSpecies = subSpecies;
	}

	public String getDomainName() {
		return domainName;
	}

	public void setDomainName(String domainName) {
		this.domainName = domainName;
	}

	public String getUrlPic() {
		return urlPic;
	}

	public void setUrlPic(String urlPic) {
		this.urlPic = urlPic;
	}

	public Vector<GeographicalStatusWrapper> getBioRegions() {
		return bioRegions;
	}

	public void setBioRegions(Vector<GeographicalStatusWrapper> bioRegions) {
		this.bioRegions = bioRegions;
	}

	public boolean isShowGeoDistribution() {
		return showGeoDistribution;
	}

	public void setShowGeoDistribution(boolean showGeoDistribution) {
		this.showGeoDistribution = showGeoDistribution;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public UniqueVector getColorURL() {
		return colorURL;
	}

	public void setColorURL(UniqueVector colorURL) {
		this.colorURL = colorURL;
	}

	public String getMapserverURL() {
		return mapserverURL;
	}

	public void setMapserverURL(String mapserverURL) {
		this.mapserverURL = mapserverURL;
	}

	public String getParameters() {
		return parameters;
	}

	public void setParameters(String parameters) {
		this.parameters = parameters;
	}

	public Hashtable getStatusColorPair() {
		return statusColorPair;
	}

	public void setStatusColorPair(Hashtable statusColorPair) {
		this.statusColorPair = statusColorPair;
	}

	public List<VernacularNameWrapper> getVernNames() {
		return vernNames;
	}

	public void setVernNames(List<VernacularNameWrapper> vernNames) {
		this.vernNames = vernNames;
	}


}
