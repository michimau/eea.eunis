<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Documents.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<%@ taglib prefix="eunis" uri="http://eunis.eea.europa.eu/jstl/functions" %>
<%@ taglib prefix="display" uri="http://displaytag.sf.net" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />


<html lang="${SessionManager.currentLanguage}" xmlns="http://www.w3.org/1999/xhtml" xml:lang="${SessionManager.currentLanguage}">
  <head>
    <script language="JavaScript" src="script/species.js" type="text/javascript"></script>
    <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>

<title>
	Documents
</title>

   <jsp:include page="/header-page.jsp">
     <jsp:param name="metaDescription" value="documents" />
   </jsp:include>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <jsp:include page="/header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <jsp:include page="/header-dynamic.jsp">
                  <jsp:param name="location" value="${actionBean.btrail}" />
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
					<h2>Documents:</h2>
					<display:table name="${actionBean.docs}" class="sortable" sort="list" id="listItem" htmlId="listItem" requestURI="/documents" decorator="eionet.eunis.util.DocumentsTableDecorator">
						<display:column property="idDoc" title="ID_DC"/>
						<display:column property="docTitle" title="Title" sortable="true" sortProperty="title"/>
					</display:table>

<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
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
      </div>
      <!-- end column wrapper -->
      <jsp:include page="/footer-static.jsp" />
    </div>
  </body>
</html>
