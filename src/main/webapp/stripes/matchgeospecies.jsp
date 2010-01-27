<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Match geospecies">

	<stripes:layout-component name="contents">

        <h1>Match geospecies</h1>
        <stripes:form action="/dataimporter/matchgeospecies" method="post" name="f">
        	<stripes:file name="file"/><br/>
			<stripes:submit name="importObjects" value="Import"/>
		</stripes:form>
		
		<c:if test="${!empty actionBean.objects}">
			<stripes:form action="/dataimporter/matchgeospecies" method="post" name="f">
				<table width="100%" border="0" class="listing">
					<tr>
						<th>Identifier</th>
						<th>GeoSpecies Name</th>
						<th>EUNIS Name</th>
						<th></th>
						<th></th>
					</tr>
					<c:forEach items="${actionBean.objects}" var="object" varStatus="loop">
						<tr>
							<td><a href="${object.identifier}" target="_blank">${object.identifier}</a></td>
							<td>${object.name}</td>
							<td>${object.nameSql}</td>
							<td>
								<stripes:label for="issame">issame</stripes:label>
								<stripes:radio name="issame['${object.identifier}']" id="issame" value="yes"/>
							</td>
							<td>
								<stripes:label for="notsame">notsame</stripes:label>
								<stripes:radio name="issame['${object.identifier}']" id="notsame" value="no"/>
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="5" align="right"><stripes:submit name="save" value="Save"/></td>
					</tr>
				</table>
			</stripes:form>
		</c:if>

	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="dataimporter/matchgeospecies" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>