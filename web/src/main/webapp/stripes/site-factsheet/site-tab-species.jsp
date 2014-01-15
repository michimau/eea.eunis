<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
<%@ page import=
"ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
 ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesPersist,
 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
 ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesPersist,
 ro.finsiel.eunis.WebContentManagement,
 ro.finsiel.eunis.utilities.EunisUtil,
 ro.finsiel.eunis.utilities.SQLUtilities,
 ro.finsiel.eunis.search.Utilities"
%>
<%@ page import="java.util.*" %>


<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
String siteid = request.getParameter("idsite");
SiteFactsheet factsheet = new SiteFactsheet(siteid);
WebContentManagement cm = SessionManager.getWebContent();
int type = factsheet.getType();

/* All data for species. */
List species                                = new ArrayList();
List sitesSpecificspecies                   = new ArrayList();
List eunisSpeciesListedAnnexesDirectives    = new ArrayList();
List eunisSpeciesOtherMentioned             = new ArrayList();
List notEunisSpeciesListedAnnexesDirectives = new ArrayList();
List notEunisSpeciesOtherMentioned          = new ArrayList();

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
                                for (Object specy : species) {
                                    SiteSpeciesPersist specie = (SiteSpeciesPersist) specy;
                            %>
                            <tr>
                                <td>
                                    <a class="link-plain"
                                       href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%>
                                    </a>
                                </td>
                                <td align="center">
                                    <%=specie.getSpeciesCommonName()%>
                                </td>
                            </tr>
                            <%
                                }
							}

                            for (Object sitesSpecificspecy : sitesSpecificspecies) {
                                    Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist) sitesSpecificspecy;
                            %>
                            <tr>
                                <td>
                                    <a href="http://www.google.com/search?q=<%=specie.getValue()%>"><%=specie.getValue()%>
                                    </a>
                                </td>
                                <td></td>
                            </tr>
                            <%
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
                            for (Object eunisSpeciesListedAnnexesDirective : eunisSpeciesListedAnnexesDirectives) {
                                SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist) eunisSpeciesListedAnnexesDirective;
                        %>
                        <tr>
                            <td>
                                <a class="link-plain"
                                   href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%>
                                </a>
                            </td>
                            <td>
                                <%=specie.getSpeciesCommonName()%>
                            </td>
                        </tr>
                        <%
                             }
						}
						if(!notEunisSpeciesListedAnnexesDirectives.isEmpty()) {
                            for (Object notEunisSpeciesListedAnnexesDirective : notEunisSpeciesListedAnnexesDirectives) {
                                Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist) notEunisSpeciesListedAnnexesDirective;
                                String specName = specie.getName();
                                specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_") + 1));
                                String groupName = specie.getSourceTable();
                                groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("amprep") ? "Amphibians"
                                        : (groupName.equalsIgnoreCase("bird") ? "Birds"
                                        : (groupName.equalsIgnoreCase("fishes") ? "Fishes"
                                        : (groupName.equalsIgnoreCase("invert") ? "Invertebrates"
                                        : (groupName.equalsIgnoreCase("mammal") ? "Mammals"
                                        : (groupName.equalsIgnoreCase("plant") ? "Flowering Plants" : "")))))));
                        %>
                        <tr>
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
                                    for (Object anEunisSpeciesOtherMentioned : eunisSpeciesOtherMentioned) {
                                        SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist) anEunisSpeciesOtherMentioned;
                        %>
                        <tr>
                            <td>
                                <a class="link-plain"
                                   href="species/<%=specie.getIdSpecies()%>"><%=specie.getSpeciesScientificName()%>
                                </a>
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
                                for (Object aNotEunisSpeciesOtherMentioned : notEunisSpeciesOtherMentioned) {
                                    Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist) aNotEunisSpeciesOtherMentioned;
                                    String specName = specie.getName();
                                    specName = (specName == null ? "" : specName.substring(specName.lastIndexOf("_") + 1));
                                    attribute2 = factsheet.findNotEunisSpeciesOtherMentionedAttributes("TAXGROUP_" + specName);
                                    String groupName = (null != attribute2) ? ((null != attribute2.getValue()) ? attribute2.getValue() : "") : "";
                                    groupName = (groupName == null ? "" : (groupName.equalsIgnoreCase("P") ? "Plants"
                                            : (groupName.equalsIgnoreCase("A") ? "Amphibians"
                                            : (groupName.equalsIgnoreCase("F") ? "Fishes"
                                            : (groupName.equalsIgnoreCase("I") ? "Invertebrates"
                                            : (groupName.equalsIgnoreCase("M") ? "Mammals"
                                            : (groupName.equalsIgnoreCase("B") ? "Birds"
                                            : (groupName.equalsIgnoreCase("F") ? "Flowering"
                                            : (groupName.equalsIgnoreCase("R") ? "Reptiles" : "")))))))));
                        %>
                        <tr>
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
	<c:choose>
	<c:when test="${actionBean.totalSpeciesCount>0}">
		<div class="paginate">
			<%
			if ( species != null) {
				for (int i = 0; i < species.size(); i++) {
					SiteSpeciesPersist specie = (SiteSpeciesPersist)species.get(i);
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

                for (Object sitesSpecificspecy : sitesSpecificspecies) {
                    Chm62edtSitesAttributesPersist specie = (Chm62edtSitesAttributesPersist) sitesSpecificspecy;
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
                for (Object eunisSpeciesListedAnnexesDirective : eunisSpeciesListedAnnexesDirectives) {
                    SitesSpeciesReportAttributesPersist specie = (SitesSpeciesReportAttributesPersist) eunisSpeciesListedAnnexesDirective;
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
			if(!notEunisSpeciesListedAnnexesDirectives.isEmpty()) {
				for (int i = 0; i < notEunisSpeciesListedAnnexesDirectives.size(); i++) {
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
    </c:when>
    <c:otherwise>
        There are no species to be displayed.
    </c:otherwise>
    </c:choose>
	</div>
</div>
	
<div class="right-area">
    <h3>Species summary</h3>
    Nature directives' species in this site (${actionBean.totalSpeciesCount})
		<table class="listing table-inline">
            <thead>
            <tr>
                <th scope="col"><%=cm.cmsPhrase("Species group")%></th>
                <th scope="col"><%=cm.cmsPhrase("Number")%></th>
            </tr>
            </thead>
            <c:forEach items="${actionBean.speciesStatisticsSorted}" var="ss" varStatus="loop">
                <tr>
                    <td>${ss.key}</td>
                    <td>${ss.value}</td>
                </tr>
            </c:forEach>
		</table>
</div>
</stripes:layout-definition>