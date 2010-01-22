<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	
<c:set var="title" value=""></c:set>
<c:choose>
	<c:when test="${eunis:exists(actionBean.factsheet)}">
		<c:set var="title" value="${actionBean.scientificName }"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="title" value="${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}"></c:set>
	</c:otherwise>
</c:choose>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}">
	<stripes:layout-component name="head">
		<script language="JavaScript" src="script/species.js" type="text/javascript"></script>
    	<script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
	</stripes:layout-component>
	
	<stripes:layout-component name="contents">
		<!-- MAIN CONTENT -->
		
		<c:choose> 
			<c:when test="${eunis:exists(actionBean.factsheet)}">
			
			<img alt="${eunis:cms(actionBean.contentManagement,'loading_data')}" id="loading" src="images/loading.gif" />
			  <h1 class="documentFirstHeading">
				${actionBean.scientificName }
			  <c:if test="${actionBean.referedFromName != null}">
			   <span class="redirection-msg">&#8213; redirected from <strong>${actionBean.referedFromName }</strong></span>
			  </c:if>
			  </h1>
			<div class="documentActions">
			  <h5 class="hiddenStructure">${eunis:cmsPhrase(actionBean.contentManagement, 'Document Actions') }</h5>
			  <ul>
			    <li>
			      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
			            alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
			            title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" /></a>
			    </li>
			    <li>
			      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
			             alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
			             title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" /></a>
			    </li>
			    <li>
			      <a href="javascript:openLink('species-factsheet-pdf.jsp?idSpecies=${actionBean.factsheet.idSpecies}&amp;idSpeciesLink=${actionBean.factsheet.idSpeciesLink}');">
			      	<img src="images/pdf.png"
			             alt="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}"
			             title="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}" /></a>
			             ${eunis:cmsTitle(actionBean.contentManagement, 'header_download_pdf_title')}
			    </li>
			  </ul>
			  </div>
			  <br clear="all" />
		                ${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')} : ${actionBean.scientificName }
		                <br />
		                ${eunis:cmsPhrase(actionBean.contentManagement, 'Author')} : <strong>${actionBean.author}</strong>
		                <br />
		                <br />
		                <div id="tabbedmenu">
		                  <ul>
			              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
		              		<c:choose>
		              			<c:when test="${dataTab.id eq actionBean.tab}">
			              			<li id="currenttab">
			              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}" 
			              				href="species-factsheet.jsp?tab=${dataTab.id}&amp;idSpecies=${actionBean.factsheet.idSpecies}">${dataTab.value}</a>
			              			</li>
		              			</c:when>
		              			<c:otherwise>
		              				<li>
			              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
			              				 href="species-factsheet.jsp?tab=${dataTab.id}&amp;idSpecies=${actionBean.factsheet.idSpecies}">${dataTab.value}</a>
			              			</li>
		              			</c:otherwise>
		              		</c:choose>
		              		</c:forEach>
		                  </ul>
		                </div>
		                <br style="clear:both;" clear="all" />
		                <br />
		                <c:if test="${actionBean.tab == 0}">
		                	<%-- General information--%>
			                <jsp:include page="/species-factsheet-general.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 1}">
		                	<%-- Vernacular names tab --%>
			                <jsp:include page="/species-factsheet-vern.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 2}">
		                	<%-- Geographical distribution --%>
			                <jsp:include page="/species-factsheet-geo.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 3}">
		                	<%-- Population --%>
			                <jsp:include page="/species-factsheet-pop.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 4}">
		                	<%-- Trends --%>
			                <jsp:include page="/species-factsheet-trends.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.specieNatureObject.idNatureObject}" />
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.speciesNatureObject.idSpecie}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 5}">
		                	<%-- References --%>
			                <jsp:include page="/species-factsheet-references.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 6}">
		                	<%-- Grid distribution --%>
			                <jsp:include page="/species-factsheet-distribution.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                  <jsp:param name="kmlUrl" value="${pageContext.request.contextPath}/species-factsheet-distribution-kml.jsp?idSpecies=${actionBean.factsheet.idSpecies}&amp;idSpeciesLink=${actionBean.factsheet.idSpeciesLink}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 7}">
		                	<%-- Threat statis --%>
			                <jsp:include page="/species-factsheet-threat.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                  <jsp:param name="scName" value="${actionBean.scientificName}" />
			                  <jsp:param name="expand" value="true" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 8}">
		                	<%-- Legal instruments --%>
			                <jsp:include page="/species-factsheet-legal.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 9}">
		                	<%-- Related habitats --%>
			                <jsp:include page="/species-factsheet-habitats.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 10}">
		                	<%-- Related sites --%>
			                <jsp:include page="/species-factsheet-sites.jsp">
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 11}">
		                	<%-- GBIF observations --%>
			                <jsp:include page="/species-factsheet-gbif.jsp">
			                  <jsp:param name="scientificName" value="${actionBean.scientificName}" />
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
			</c:when>
			<c:otherwise>
				<div class="error-msg">
		           ${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}
		        </div>	
			
			</c:otherwise>
		</c:choose>
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'general_information')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'vernacular_names')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'geographical_distribution')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'population')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'trends')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'references')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'grid_distribution')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'threat_status')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'legal_instruments')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'habitat_types')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'sites')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'gbif')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'species_factsheet_title')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'show')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'loading_data')}
		    ${eunis:br(actionBean.contentManagement)}
		<!-- END MAIN CONTENT -->
		<script type="text/javascript">
	    //<![CDATA[
	      try
	      {
	        var ctrl_loading = document.getElementById( "loading" );
	        ctrl_loading.style.display = "none";
	      }
	      catch ( e )
	      {
	      }
	        // Writes a warning if the page is called as a popup. Works only in IE
	        if ( history.length == 0 && document.referrer != '') {
	            c = document.getElementById('content');
	            w = document.createElement('div');
	            w.className = "note-msg";
	            w.innerHTML = "<strong>Notice</strong> <p>This page was opened as a new window. The back button has been disabled by the referring page. Close the window to exit.</p>";
	            c.insertBefore(w, c.firstChild);
	        }
	      //]]>
	    </script>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="species-factsheet.jsp" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>
