<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<%@ page import=
"ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
java.util.List,
java.util.HashMap,
java.util.Map,
ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesPersist,
ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesPersist,
ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.utilities.EunisUtil,
ro.finsiel.eunis.utilities.SQLUtilities, ro.finsiel.eunis.search.Utilities"
%>


<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
String siteid = request.getParameter("idsite");
SiteFactsheet factsheet = new SiteFactsheet(siteid);
WebContentManagement cm = SessionManager.getWebContent();
int type = factsheet.getType();
String designationDescr = factsheet.getDesignation();

String SQL_DRV = application.getInitParameter("JDBC_DRV");
String SQL_URL = application.getInitParameter("JDBC_URL");
String SQL_USR = application.getInitParameter("JDBC_USR");
String SQL_PWD = application.getInitParameter("JDBC_PWD");

SQLUtilities sqlc = new SQLUtilities();
sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
String information = factsheet.getSiteObject().getRespondent();
 
/* All data for species. */
List species                                = null;
List sitesSpecificspecies                   = null;
List eunisSpeciesListedAnnexesDirectives    = null;
List eunisSpeciesOtherMentioned             = null;
List notEunisSpeciesListedAnnexesDirectives = null;
List notEunisSpeciesOtherMentioned          = null;
HashMap<String, Integer> speciesStatistics   = new HashMap<String, Integer>();

%>
<div class="right-area">
	<div class="species-change-view">
		<div onclick="changeSpeciesView(0);" class="species-list">
			<i class="eea-icon eea-icon-align-justify"></i><br/>List
		</div>
		<div onclick="changeSpeciesView(1);" class="species-gallery">
			<i class="eea-icon eea-icon-th"></i><br/>Gallery
		</div>
	</div>
	<br/>
	<!-- ---------------------------------- LIST VIEW ------------------------------- -->
	<div id="sites-species-list" style="display: none;">
	<%
		/* 1. everything but Natura 2000 */
		if(SiteFactsheet.TYPE_EMERALD == type || SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_CORINE == type) {
			//list of species recognised in EUNIS
			species = factsheet.findSitesSpeciesByIDNatureObject();
			//list of species not recognised in EUNIS
			sitesSpecificspecies = factsheet.findSitesSpecificSpecies();
			if (!species.isEmpty() || !sitesSpecificspecies.isEmpty()) {
				Chm62edtReportAttributesPersist attribute;
				if ( species.size() > 0 ||  sitesSpecificspecies.size() > 0) {
				%>
					<table summary="<%=cm.cms("ecological_information_fauna_flora")%>" class="listing fullwidth table-inline">
						<thead>
							<tr>
								<th scope="col"><%=cm.cmsPhrase("Species scientific name")%></th>
								<th scope="col"><%=cm.cmsPhrase("Species group")%></th>
							</tr>
						</thead>
						<tbody>
							<%
							if ( species.size() > 0) {
								for (int i = 0; i < species.size(); i++) {			
									String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
									SiteSpeciesPersist specie = (SiteSpeciesPersist)species.get(i);
									String attrValue;
									String word = specie.getSpeciesCommonName();
									int count = speciesStatistics.containsKey(word) ? speciesStatistics.get(word) : 0;
									speciesStatistics.put(word, count + 1);
							%>
									<tr<%=cssClass%>>
										<td>
											<a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
										</td>
										<td align="center">
											<%=specie.getSpeciesCommonName()%>
										</td>		
									</tr>
							<%
								}
							}
							
							if (sitesSpecificspecies.size() > 0) {					
								for (int i = 0; i < sitesSpecificspecies.size(); i++) {
									String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
									Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)sitesSpecificspecies.get(i);
							%>
									<tr<%=cssClass%>>
										<td>
											<a href="http://www.google.com/search?q=<%=specie.getValue()%>"><%=specie.getValue()%></a>
										</td>
										<td></td>
									</tr>
							<%
								}
							}
							%>
						</tbody>
					</table>
					
					<br />
				<%
				}
			}
		}
		
		/* 2. only for Natura 2000 */
		if(SiteFactsheet.TYPE_NATURA2000 == type ) {
			eunisSpeciesListedAnnexesDirectives = factsheet.findEunisSpeciesListedAnnexesDirectivesForSitesNatura2000();
			eunisSpeciesOtherMentioned = factsheet.findEunisSpeciesOtherMentionedForSitesNatura2000();
			notEunisSpeciesListedAnnexesDirectives = factsheet.findNotEunisSpeciesListedAnnexesDirectives();
			notEunisSpeciesOtherMentioned = factsheet.findNotEunisSpeciesOtherMentioned();
		
			if (!eunisSpeciesListedAnnexesDirectives.isEmpty() || !eunisSpeciesOtherMentioned.isEmpty() || !notEunisSpeciesListedAnnexesDirectives.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty()) {
				Chm62edtReportAttributesPersist attribute;
				if (!eunisSpeciesListedAnnexesDirectives.isEmpty() || !notEunisSpeciesListedAnnexesDirectives.isEmpty() || !eunisSpeciesOtherMentioned.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty()) {
			%>
				<table summary="<%=cm.cms("species")%>" class="listing fullwidth table-inline">
					<thead>
						<tr>
							<th scope="col"><%=cm.cmsPhrase("Species scientific name")%></th>
							<th scope="col"><%=cm.cmsPhrase("Species group")%></th>	
						</tr>
					</thead>
					<tbody>
						<%
						if (!eunisSpeciesListedAnnexesDirectives.isEmpty()) {
							for (int i = 0; i < eunisSpeciesListedAnnexesDirectives.size(); i++){	
								String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
								SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesListedAnnexesDirectives.get(i);
								String word = specie.getSpeciesCommonName();
								int count = speciesStatistics.containsKey(word) ? speciesStatistics.get(word) : 0;
								speciesStatistics.put(word, count + 1);
						%>
								<tr class="<%=cssClass%>">
									<td>
										<a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
									</td>
									<td>
										<%=specie.getSpeciesCommonName()%>
									</td>
								</tr>
						<%
							}
						}
						if(!notEunisSpeciesListedAnnexesDirectives.isEmpty()) {
							Chm62edtSitesAttributesPersist attribute2 = null;
							for (int i = 0; i < notEunisSpeciesListedAnnexesDirectives.size(); i++) {
								String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
								Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesListedAnnexesDirectives.get(i);
								String specName = specie.getName();
								specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
								String groupName = specie.getSourceTable();
								groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("amprep") ? "Amphibians"
								:(groupName.equalsIgnoreCase("bird") ? "Birds"
								:(groupName.equalsIgnoreCase("fishes") ? "Fishes"
								:(groupName.equalsIgnoreCase("invert") ? "Invertebrates"
								:(groupName.equalsIgnoreCase("mammal") ? "Mammals"
								:(groupName.equalsIgnoreCase("plant") ? "Flowering Plants" : "")))))));
								
								String word = groupName;
								int count = speciesStatistics.containsKey(word) ? speciesStatistics.get(word) : 0;
								speciesStatistics.put(word, count + 1);
								%>
								<tr<%=cssClass%>>
									<td>
										<%=specName%>
									</td>
									<td align="center">
										<%=groupName%>
									</td>				
								</tr>
						<%
							}
						}
						
						if (!eunisSpeciesOtherMentioned.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty()) {
								if (!eunisSpeciesOtherMentioned.isEmpty()) {
								for (int i = 0; i < eunisSpeciesOtherMentioned.size(); i++) {
									String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
									SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesOtherMentioned.get(i);
									String word = specie.getSpeciesCommonName();
									int count = speciesStatistics.containsKey(word) ? speciesStatistics.get(word) : 0;
									speciesStatistics.put(word, count + 1);
							%>
									<tr class="<%=cssClass%>">
										<td>
											<a class="link-plain" href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%></a>
										</td>
										<td>
											<%=specie.getSpeciesCommonName()%>
										</td>	
									</tr>
							<%
								}
							}
							if (!notEunisSpeciesOtherMentioned.isEmpty()) {
								Chm62edtSitesAttributesPersist  attribute2 = null;
								for (int i = 0; i < notEunisSpeciesOtherMentioned.size(); i++) {
									String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
									Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesOtherMentioned.get(i);
									String specName = specie.getName();
									specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
									attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("TAXGROUP_"+specName);
									String groupName = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";
									groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("P") ? "Plants"
									:(groupName.equalsIgnoreCase("A") ? "Amphibians"
									:(groupName.equalsIgnoreCase("F") ? "Fishes"
									:(groupName.equalsIgnoreCase("I") ? "Invertebrates"
									:(groupName.equalsIgnoreCase("M") ? "Mammals"
									:(groupName.equalsIgnoreCase("B") ? "Birds"
									:(groupName.equalsIgnoreCase("F") ? "Flowering"
									:(groupName.equalsIgnoreCase("R") ? "Reptiles" : "")))))))));
									
									String word = groupName;
									int count = speciesStatistics.containsKey(word) ? speciesStatistics.get(word) : 0;
									speciesStatistics.put(word, count + 1);
									%>
									<tr class="<%=cssClass%>">
										<td>
											<%=specName%>
										</td>
										<td>
											<%=groupName%>
										</td>
									</tr>
						<%
								}
							}
						}
						%>
					</tbody>
				</table>
		<%
				}	
			}
		}
		%>
	</div>
	<!-- ---------------------------------- GALERY VIEW ------------------------------- -->
	<div id="sites-species-gallery">
		<div class="paginate">
			<%
			if ( species != null) {
				for (int i = 0; i < species.size(); i++) {
					SiteSpeciesPersist specie = (SiteSpeciesPersist)species.get(i);
					String attrValue;
			%>
				<div class="photoAlbumEntry">
		            <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/species/<%=specie.getIdSpecies()%>/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                	<%=specie.getSpeciesScientificName()%>
		                	<br/>
		                	<%=specie.getSpeciesCommonName()%>
		                </span>
		            </a>
       	 		</div>
			<%
				}
			}
			if (sitesSpecificspecies != null) {					
				for (int i = 0; i < sitesSpecificspecies.size(); i++) {
					Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)sitesSpecificspecies.get(i);
			%>
				<div class="photoAlbumEntry">
		            <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/sites/<%=specie.getIdSite()%>/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                	<%=specie.getValue()%>
		                	<br/>
		                	-
		                </span>
		            </a>
       	 		</div>
			<%
				}
			}
			if (eunisSpeciesListedAnnexesDirectives != null) {
				for (int i = 0; i < eunisSpeciesListedAnnexesDirectives.size(); i++){
					SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesListedAnnexesDirectives.get(i);
			%>
				<div class="photoAlbumEntry">
		            <a href="javascript:void(0);">
		                <span class="photoAlbumEntryWrapper">
		                    <img src="images/species/<%=specie.getIdSpecies()%>/thumbnail.jpg"/>
		                </span>
		                <span class="photoAlbumEntryTitle">
		                	<%=specie.getSpeciesScientificName()%>
		                	<br/>
		                	<%=specie.getSpeciesCommonName()%>
		                </span>
		            </a>
       	 		</div>
			<%
				}
			}
			if(!notEunisSpeciesListedAnnexesDirectives.isEmpty()) {
				Chm62edtSitesAttributesPersist attribute2 = null;
				for (int i = 0; i < notEunisSpeciesListedAnnexesDirectives.size(); i++) {
					String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
					Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesListedAnnexesDirectives.get(i);
					String specName = specie.getName();
					specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
					String groupName = specie.getSourceTable();
					groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("amprep") ? "Amphibians"
					:(groupName.equalsIgnoreCase("bird") ? "Birds"
					:(groupName.equalsIgnoreCase("fishes") ? "Fishes"
					:(groupName.equalsIgnoreCase("invert") ? "Invertebrates"
					:(groupName.equalsIgnoreCase("mammal") ? "Mammals"
					:(groupName.equalsIgnoreCase("plant") ? "Flowering Plants" : "")))))));
			%>
					<div class="photoAlbumEntry">
			            <a href="javascript:void(0);">
			                <span class="photoAlbumEntryWrapper">
			                    <img src="images/sites/<%=specie.getIdSite()%>/thumbnail.jpg"/>
			                </span>
			                <span class="photoAlbumEntryTitle">
			                	<%=specName%>
			                	<br/>
			                	<%=groupName%>
			                </span>
			            </a>
	       	 		</div>
			<%
				}
			}
			
			if (!eunisSpeciesOtherMentioned.isEmpty() || !notEunisSpeciesOtherMentioned.isEmpty()) {
					if (!eunisSpeciesOtherMentioned.isEmpty()) {
					for (int i = 0; i < eunisSpeciesOtherMentioned.size(); i++) {
						String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
						SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist)eunisSpeciesOtherMentioned.get(i);
				%>
					<div class="photoAlbumEntry">
			            <a href="javascript:void(0);">
			                <span class="photoAlbumEntryWrapper">
			                    <img src="images/species/<%=specie.getIdSpecies()%>/thumbnail.jpg"/>
			                </span>
			                <span class="photoAlbumEntryTitle">
			                	<%=specie.getSpeciesCommonName()%>
			                	<br/>
			                	<%=specie.getSpeciesScientificName()%>
			                </span>
			            </a>
	       	 		</div>	
				<%
					}
				}
				if (!notEunisSpeciesOtherMentioned.isEmpty()) {
					Chm62edtSitesAttributesPersist  attribute2 = null;
					for (int i = 0; i < notEunisSpeciesOtherMentioned.size(); i++) {
						String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
						Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist)notEunisSpeciesOtherMentioned.get(i);
						String specName = specie.getName();
						specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_")+1));
						attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("TAXGROUP_"+specName);
						String groupName = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";
						groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("P") ? "Plants"
						:(groupName.equalsIgnoreCase("A") ? "Amphibians"
						:(groupName.equalsIgnoreCase("F") ? "Fishes"
						:(groupName.equalsIgnoreCase("I") ? "Invertebrates"
						:(groupName.equalsIgnoreCase("M") ? "Mammals"
						:(groupName.equalsIgnoreCase("B") ? "Birds"
						:(groupName.equalsIgnoreCase("F") ? "Flowering"
						:(groupName.equalsIgnoreCase("R") ? "Reptiles" : "")))))))));
				%>
						<div class="photoAlbumEntry">
				            <a href="javascript:void(0);">
				                <span class="photoAlbumEntryWrapper">
				                    <img src="images/sites/<%=specie.getIdSite()%>/thumbnail.jpg"/>
				                </span>
				                <span class="photoAlbumEntryTitle">
				                	<%=groupName%>
				                	<br/>
				                	<%=specName%>
				                </span>
				            </a>
		       	 		</div>
			<%
					}
				}
			}
			%>
		</div>
	</div>
</div>
	
<div class="right-area">
	<fieldset class="widget-fieldset">
		<legend>Species group number</legend>
		<table>
			<%
			for (Map.Entry<String, Integer> entry : speciesStatistics.entrySet()) {
			    String key = entry.getKey();
			    Integer value = entry.getValue();
			%>	
				<tr>
					<td><%=key%></td>
					<td><%=value.intValue()%></td>
				</tr>
			<%
			}
			%>
		</table>
	</fieldset>
</div>
</stripes:layout-definition>