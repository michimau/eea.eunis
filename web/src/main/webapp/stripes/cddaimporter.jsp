<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Import National CDDA sites and designations">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Import National CDDA sites and designations</h1>
	        <stripes:form action="/dataimport/importcdda" method="post" name="f">
	        	<stripes:label for="file1">XML file for designations</stripes:label>
	        	<stripes:file name="fileDesignations" id="file1"/><br/>
	        	<stripes:label for="file2">XML file for sites</stripes:label>
	        	<stripes:file name="fileSites" id="file2"/><br/>
	        	<stripes:checkbox name="updateCountrySitesFactsheet" id="update"/>
	        	<stripes:label for="update"> - automatically update "chm62edt_country_sites_factsheet" table after import</stripes:label><br/>
				<stripes:submit name="importCdda" value="Import"/>
			</stripes:form>
		</c:when>
		<c:otherwise>
			<div class="error-msg">
				You are not logged in or you do not have enough privileges to view this page!
			</div>
		</c:otherwise>
	</c:choose>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="dataimport/importcdda" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>
