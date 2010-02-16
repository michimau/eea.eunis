<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Match geospecies">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Match geospecies</h1>
	        <stripes:form action="/dataimport/matchgeospecies" method="post" name="f">
	        	<stripes:file name="file"/><br/>
				<stripes:submit name="importObjects" value="Import"/>
			</stripes:form>
			
			<c:if test="${!empty actionBean.objects}">
				<p>Mark the species suggestions that are the same species. Max 300 on the page</p>
				<stripes:form action="/dataimport/matchgeospecies" method="post" name="f">
					<table width="100%" border="0" class="listing">
						<thead>
							<tr>
								<th>Identifier</th>
								<th>GeoSpecies Name</th>
								<th>EUNIS Name</th>
								<th colspan="3">Relation</th>
							</tr>
						</thead>
						<tfoot>
						<tr>
							<td colspan="6" style="text-align:middle"><stripes:submit name="save" value="Save"/></td>
						</tr>
						</tfoot>
						<tbody>
						<c:forEach items="${actionBean.objects}" var="object" varStatus="loop">
							<tr>
								<td><a class="link-plain" href="${object.identifier}" target="_blank">${object.identifier}</a></td>
								<td>${object.name}</td>
								<td><a href="${pageContext.request.contextPath}/species/${object.specieId}" target="_blank">${object.nameSql}</a></td>
								<td>
									<stripes:label for="maybesame${object.natureObjectId}">Maybe</stripes:label>
									<stripes:radio checked="true" name="issame['${object.identifier}']" id="maybesame${object.natureObjectId}" value="maybesame"/>
								</td>
								<td>
									<stripes:label for="issame${object.natureObjectId}">Same</stripes:label>
									<stripes:radio name="issame['${object.identifier}']" id="issame${object.natureObjectId}" value="issame"/>
								</td>
								<td>
									<stripes:label for="notsame${object.natureObjectId}">No</stripes:label>
									<stripes:radio name="issame['${object.identifier}']" id="notsame${object.natureObjectId}" value="notsame"/>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</stripes:form>
			</c:if>
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
                		<jsp:param name="page_name" value="dataimport/matchgeospecies" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
		</div>
		<!-- end of the main and left columns -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>
