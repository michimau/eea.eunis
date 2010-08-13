<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${actionBean.pageTitle }">
	<stripes:layout-component name="head">
		<c:if test="${eunis:exists(actionBean.factsheet)}">
			<link rel="alternate" type="application/rdf+xml" title="RDF" href="${pageContext.request.contextPath}/sites/${actionBean.idsite}" />
		</c:if>
		<script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
		<script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
		<script language="JavaScript" type="text/javascript">
		    //<![CDATA[
		      function openWindow(theURL,winName,features)
		      {
		        window.open(theURL,winName,features);
		      }
		
		      function openLink(URL)
		      {
		        eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
		      }
		
		      function openGooglePics(URL)
		      {
		        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
		      }
		
		      function openpictures(URL, width, height)
		      {
		        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width="+width+",height="+height+",left=100,top=0');");
		      }
		
		      function openunepwcmc(URL, width, height)
		      {
		        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
		      }
		    //]]>
		    </script>
	</stripes:layout-component>
	<stripes:layout-component name="contents">

		<!-- MAIN CONTENT --> 
		<c:choose>
			<c:when test="${actionBean.factsheet.IDNatureObject == null}">
				<div class="error-msg">
					${eunis:cmsPhrase(actionBean.contentManagement, ('We are sorry, the requested site does not exist'))}
				</div>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${eunis:exists(actionBean.factsheet)}">
		
						<img id="loading" src="images/loading.gif"
							alt="${eunis:cms(actionBean.contentManagement, 'loading')}"
							title="${eunis:cms(actionBean.contentManagement, 'loading')}" />
						<h1 class="documentFirstHeading">${actionBean.factsheet.siteObject.name }</h1>
						<div class="documentActions">
							<h5 class="hiddenStructure">${eunis:cms(actionBean.contentManagement, 'Document Actions')}</h5>
							${eunis:cmsTitle(actionBean.contentManagement, 'Document Actions')}
							<ul>
								<li>
									<a href="javascript:this.print();">
										<img
											src="http://webservices.eea.europa.eu/templates/print_icon.gif"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" />
									</a>
								</li>
								<li>
									<a href="javascript:toggleFullScreenMode();">
										<img
											src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" />
									</a>
								</li>
								<li>
									<a href="javascript:openLink('sites-factsheet-pdf.jsp?idsite=${actionBean.idsite}')">
										<img
											src="images/pdf.png"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'header_download_pdf_title')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'header_download_pdf_title')}" />
									${eunis:cmsTitle(actionBean.contentManagement, 'header_download_pdf_title')}
									</a>
								</li>
							</ul>
						</div>
						<div class="documentDescription">
							${eunis:cmsPhrase(actionBean.contentManagement, 'Factsheet filled with data from')} ${actionBean.sdb}
							${eunis:cmsPhrase(actionBean.contentManagement, 'data set')}
						</div>
						<div id="tabbedmenu">
							<ul>
								<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
									<c:choose>
										<c:when test="${dataTab.id eq actionBean.tab}">
											<li id="currenttab"><a
												title="Open ${dataTab.value}"
												href="sites/${actionBean.idsite}/${dataTab.id}">
												${dataTab.value}</a></li>
										</c:when>
										<c:otherwise>
											<li><a
												title="Open ${dataTab.value}"
												href="sites/${actionBean.idsite}/${dataTab.id}">
												${dataTab.value}</a></li>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</ul>
						</div>
						<br class="brClear" />
						<br />
						<c:if test="${actionBean.tab == 'general'}">
							<jsp:include page="/sites-factsheet-general.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'faunaflora'}">
							<jsp:include page="/sites-factsheet-faunaflora.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'designations'}">
							<jsp:include page="/sites-factsheet-designations.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'habitats'}">
							<jsp:include page="/sites-factsheet-habitats.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'sites'}">
							<jsp:include page="/sites-factsheet-related.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'other'}">
							<jsp:include page="/sites-factsheet-other.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include></c:if>
		
					</c:when>
					<c:otherwise>
		                <br />
					</c:otherwise>
				</c:choose>
				<c:forEach items="${actionBean.tabs}" var="tab">
                  ${eunis:cmsMsg(actionBean.contentManagement, tab)}
                  ${eunis:br(actionBean.contentManagement)}
				</c:forEach>
                 ${eunis:cmsMsg(actionBean.contentManagement, 'sites_factsheet_title')}
                 ${eunis:br(actionBean.contentManagement)}
                 ${eunis:cmsMsg(actionBean.contentManagement, 'loading')}		
			</c:otherwise>
		</c:choose> 
		<!-- END MAIN CONTENT -->
		<script language="JavaScript" type="text/javascript">
	      //<![CDATA[
	      try {
		        var ctrl_loading = document.getElementById( "loading" );
		        ctrl_loading.style.display = "none";
		  } catch ( e ){}
	      //]]>
	    </script>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
				<div class="visualPadding">
					<jsp:include page="/inc_column_left.jsp">
						<jsp:param name="page_name" value="sites" />
					</jsp:include>
				</div>
			</div>
          	<!-- end of the left (by default at least) column -->
		<!-- end of the main and left columns -->
		<!-- start of right (by default at least) column -->
		<div id="portal-column-two">
			<div class="visualPadding">
				<jsp:include page="/right-dynamic.jsp">
					<jsp:param name="mapLink" value="show" />
				</jsp:include>
			</div>
		</div>
	</stripes:layout-component>
</stripes:layout-render>

