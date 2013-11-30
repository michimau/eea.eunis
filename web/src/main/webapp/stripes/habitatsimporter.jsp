<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Import habitats" bookmarkPageName="dataimport/importhabitats">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Import habitats</h1>
	        <stripes:form action="/dataimport/importhabitats" method="post" name="f">
	        	<stripes:label for="file0">XML file for references (REFERENCES)</stripes:label>
	        	<stripes:file name="fileReferences" id="file0"/><br/>
	        	<stripes:label for="file1">XML file for habitats (HABITAT)</stripes:label>
	        	<stripes:file name="fileHabitats" id="file1"/><br/>
	        	<stripes:label for="file2">XML file for habitat descriptions (HABTEXT)</stripes:label>
	        	<stripes:file name="fileHabitatsDesc" id="file2"/><br/>
	        	<stripes:label for="file3">XML file for class codes (CLASSCODES)</stripes:label>
	        	<stripes:file name="fileClassCodes" id="file3"/><br/>
	        	<stripes:label for="file4">XML file for habitats class codes relations (HABEQUIV)</stripes:label>
	        	<stripes:file name="fileHabitatClassCodes" id="file4"/><br/><br/>
				<stripes:submit name="importHabitats" value="Import"/><br/>
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
	</stripes:layout-component>
</stripes:layout-render>
