<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Import Red List">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Import Red List</h1>
	        <stripes:form action="/dataimport/importredlist" method="post" name="f">
	        	<stripes:label for="file1">XML file for mammals</stripes:label>
	        	<stripes:file name="fileMammals" id="file1"/><br/>
	        	<stripes:label for="file2">XML file for amphibians</stripes:label>
	        	<stripes:file name="fileAmphibians" id="file2"/><br/>
	        	<stripes:label for="file3">XML file for reptiles</stripes:label>
	        	<stripes:file name="fileReptiles" id="file3"/><br/><br/>
	        	<table width="380" border="0">
	        		<tr>
	        			<td><stripes:label for="title">Title</stripes:label></td>
			        	<td><stripes:text name="title" id="title"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="source">Source</stripes:label></td>
			        	<td><stripes:text name="source" id="source"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="editor">Editor</stripes:label></td>
			        	<td><stripes:text name="editor" id="editor"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="url">URL</stripes:label></td>
			        	<td><stripes:text name="url" id="url"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="date">Publish year</stripes:label></td>
			        	<td><stripes:text name="date" id="date"/> (YYYY)</td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="publisher">Publisher</stripes:label></td>
			        	<td><stripes:text name="publisher" id="publisher"/></td>
			        </tr>
			        <tr>
			        	<td colspan="2" align="right"><stripes:submit name="importRedList" value="Import"/></td>
			        </tr>
			    </table>
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
                		<jsp:param name="page_name" value="dataimport/importredlist" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>
