<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Documents">

	<stripes:layout-component name="contents">
		<!-- MAIN CONTENT -->
					<h2>Documents:</h2>
					<display:table name="${actionBean.docs}" class="sortable" sort="list" id="listItem" htmlId="listItem" requestURI="/documents" decorator="eionet.eunis.util.DocumentsTableDecorator">
						<display:column property="idDoc" title="ID_DC"/>
						<display:column property="docTitle" title="Title" sortable="true" sortProperty="title"/>
					</display:table>

		<!-- END MAIN CONTENT -->
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="documents" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>
