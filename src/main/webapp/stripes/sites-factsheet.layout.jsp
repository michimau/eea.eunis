<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main site factsheet page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="stripes"
	uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib prefix="eunis"
	uri="http://eunis.eea.europa.eu/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html lang="${actionBean.context.sessionManager.currentLanguage}"
	xmlns="http://www.w3.org/1999/xhtml"
	xml:lang="${actionBean.context.sessionManager.currentLanguage}">
<head>
<jsp:include page="/header-page.jsp">
	<jsp:param name="metaDescription" value="${actionBean.metaDescription}" />
</jsp:include>
<title>${actionBean.pageTitle }</title>
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
</head>
<body>
	<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
	<div id="visual-portal-wrapper"><jsp:include page="/header.jsp" />
	<!-- The wrapper div. It contains the three columns. -->
	<div id="portal-columns" class="visualColumnHideTwo"><!-- start of the main and left columns -->
	<div id="visual-column-wrapper"><!-- start of main content block -->
	<div id="portal-column-content">
	<div id="content">
	<div class="documentContent" id="region-content">
		<jsp:include page="/header-dynamic.jsp">
			<jsp:param name="location" value="${actionBean.btrail}" />
		</jsp:include> 
		<a name="documentContent"></a> 
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
											alt="${eunis:cms(actionBean.contentManagement, 'Print this page')}"
											title="${eunis:cms(actionBean.contentManagement, 'Print this page')}" />
									</a>
									${eunis:cmsTitle(actionBean.contentManagement, 'Print this page')}
								</li>
								<li>
									<a href="javascript:toggleFullScreenMode();">
										<img
											src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
											alt="${eunis:cms(actionBean.contentManagement, 'Toggle full screen mode')}"
											title="${eunis:cms(actionBean.contentManagement, 'Toggle full screen mode')}" />
									</a>
									${eunis:cmsTitle(actionBean.contentManagement, 'Toggle full screen mode')}
								</li>
								<li>
									<a href="javascript:openLink('sites-factsheet-pdf.jsp?idsite=${actionBean.idsite}')">
										<img
											src="images/pdf.png"
											alt="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}"
											title="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}" />
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
												title="Open ${eunis:cms(actionBean.contentManagement, dataTab.value)}"
												href="sites-factsheet.jsp?tab=${dataTab.id}&amp;idsite=${actionBean.idsite}">
											${eunis:cms(actionBean.contentManagement, dataTab.value)}</a></li>
										</c:when>
										<c:otherwise>
											<li><a
												title="Open ${eunis:cms(actionBean.contentManagement, dataTab.value)}"
												href="sites-factsheet.jsp?tab=${dataTab.id}&amp;idsite=${actionBean.idsite}">
											${eunis:cms(actionBean.contentManagement, dataTab.value)}</a></li>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</ul>
						</div>
						<br class="brClear" />
						<br />
						<c:if test="${actionBean.tab == 0}">
							<jsp:include page="/sites-factsheet-general.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 1}">
							<jsp:include page="/sites-factsheet-faunaflora.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 2}">
							<jsp:include page="/sites-factsheet-designations.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 3}">
							<jsp:include page="/sites-factsheet-habitats.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 4}">
							<jsp:include page="/sites-factsheet-related.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 5}">
							<jsp:include page="/sites-factsheet-other.jsp">
								<jsp:param name="idsite" value="${actionBean.idsite}" />
							</jsp:include></c:if>
		
						<c:choose>
							<c:when test="${actionBean.factsheet.picturesForSites ne null and fn:length(actionBean.factsheet.picturesForSites) >0}">
								<br />
								<br />
								<div style="width: 100%;">
									<a
										title="${eunis:cms(actionBean.contentManagement, 'sites_factsheet_openpictures')}"
										href="javascript:openpictures('pictures.jsp?idobject=${actionBean.idsite}&amp;natureobjecttype=Sites',600,600)">
										${eunis:cmsPhrase(actionBean.contentManagement, 'View pictures')}
									</a>
									${eunis:cmsTitle(actionBean.contentManagement, 'sites_factsheet_openpictures')}
								</div>
							</c:when>
							<c:otherwise>
								<c:if test="actionBean.sessionManager.authenticated">
									<br />
									<br />
									<div style="width: 100%;">
										<a
											title="${eunis:cms(actionBean.contentManagement, 'sites_factsheet_openpictures')}"
											href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;idobject=${actionBean.idsite}&amp;natureobjecttype=Sites',600,600)">
											${eunis:cmsPhrase(actionBean.contentManagement, 'Upload	pictures')}
										</a>
										${eunis:cmsTitle(actionBean.contentManagement, 'sites_factsheet_openpictures')}
									</div>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<br />
						<br />
		                ${eunis:cmsPhrase(actionBean.contentManagement, 'Upload pictures')}
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
	</div>
	</div>
	</div>
	<!-- end of main content block --> 
	<!-- start of the left (by default at least) column -->
	<div id="portal-column-one">
		<div class="visualPadding">
			<jsp:include page="/inc_column_left.jsp">
				<jsp:param name="page_name" value="sites-factsheet.jsp" />
			</jsp:include>
		</div>
	</div>
	<!-- end of the left (by default at least) column -->
	</div>
	<!-- end of the main and left columns --> <!-- start of right (by default at least) column -->
	<div id="portal-column-two">
		<div class="visualPadding">
			<jsp:include page="/right-dynamic.jsp">
				<jsp:param name="mapLink" value="show" />
			</jsp:include>
		</div>
	</div>
	<!-- end of the right (by default at least) column -->
	<div class="visualClear"><!-- --></div>
	</div>
	<!-- end column wrapper --> 
	<jsp:include page="/footer-static.jsp" />
	</div>
	<script language="JavaScript" type="text/javascript">
      //<![CDATA[
      try {
	        var ctrl_loading = document.getElementById( "loading" );
	        ctrl_loading.style.display = "none";
	  } catch ( e ){}
      //]]>
    </script>
</body>
</html>
