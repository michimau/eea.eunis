<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Import Red List">

	<stripes:layout-component name="contents">
	
	<script type="text/javascript">
	//<![CDATA[
    	function showHide(val) {
      		if(val.value != -1)
          		document.getElementById("newsource").style.display = 'none';
      		else
      			document.getElementById("newsource").style.display = 'inline';
    	}
	//]]>
  	</script>
	
	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Import Red List</h1>
	        <stripes:form action="/dataimport/importredlist" method="post" name="f">
	        	<b>XML files</b> (max 5 files per import):<br/>
	        	<stripes:file name="files[0]" size="50"/><br/>
	        	<stripes:file name="files[1]" size="50"/><br/>
	        	<stripes:file name="files[2]" size="50"/><br/>
	        	<stripes:file name="files[3]" size="50"/><br/>
	        	<stripes:file name="files[4]" size="50"/><br/>
	        	<stripes:checkbox name="delete" id="delete"/>
	        	<stripes:label for="delete"> - delete old threats (only deletes old threats of species that importer finds in XML file(s))</stripes:label><br/>
	        	<table border="0">
				<col style="width:10em"/>
				<col style="width:50em"/>
	        		<tr>
	        			<td><stripes:label for="idDc">Source</stripes:label></td>
			        	<td>
			        		<stripes:select name="idDc" id="idDc" style="width:100%;" onchange="javascript:showHide(this);">
			        			<stripes:option value="-1">- new source -</stripes:option>
			        			<stripes:options-collection collection="${actionBean.sources}" value="key" label="value"/>
			        		</stripes:select>
			        	</td>
			        </tr>
	        	</table>
	        	<table border="0" id="newsource">
				<col style="width:10em"/>
				<col style="width:50em"/>
	        		<tr>
	        			<td><stripes:label for="title">Title</stripes:label></td>
			        	<td><stripes:text name="title" id="title" style="width:100%"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="source">Source</stripes:label></td>
			        	<td><stripes:text name="source" id="source" style="width:100%"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="editor">Editor</stripes:label></td>
			        	<td><stripes:text name="editor" id="editor" style="width:100%"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="url">URL</stripes:label></td>
			        	<td><stripes:text name="url" id="url" style="width:100%"/></td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="date">Publish year</stripes:label></td>
			        	<td><stripes:text name="date" id="date" size="4"/> (YYYY)</td>
			        </tr>
			        <tr>
			        	<td><stripes:label for="publisher">Publisher</stripes:label></td>
			        	<td><stripes:text name="publisher" id="publisher" style="width:100%"/></td>
			        </tr>
			   </table>
			   <table border="0">
				<col style="width:60em"/>
			        <tr>
			        	<td style="text-align:center"><stripes:submit name="importRedList" value="Import"/></td>
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
	</stripes:layout-component>
</stripes:layout-render>
