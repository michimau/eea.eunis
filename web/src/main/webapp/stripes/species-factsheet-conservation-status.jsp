<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



	<h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Conservation status')}</h2>
	<c:choose>

		<c:when test="${not empty actionBean.queryResultColsBiogeographical && not empty actionBean.queryResultRowsBiogeographical}">
			<div style="font-weight: bold;">
				${eunis:cmsPhrase(actionBean.contentManagement,'Biogeographical assessment:')}
			</div>
			<div style="width:100%; overflow-x:scroll;">
				<display:table name="actionBean.queryResultRowsBiogeographical" class="sortable"
					pagesize="50" sort="list"
					requestURI="/species/${actionBean.idSpecies}/conservation_status">
					<c:forEach var="cl" items="${actionBean.queryResultColsBiogeographical}">
							<display:column property="${cl.property}"
								title="${cl.property}"
								sortable="${cl.sortable}"
								decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator" />
					</c:forEach>
				</display:table>
			</div>
			<c:if test="${not empty actionBean.attribution}">
				<b>Source:</b> ${actionBean.attribution}
					</c:if>
		</c:when>
		<c:otherwise>
			 		Query didn't return any result!
			 	</c:otherwise>
	</c:choose>
	<br/>
	<c:choose>
		<c:when test="${not empty actionBean.queryResultColsCountry && not empty actionBean.queryResultRowsCountry}">
			<div style="font-weight: bold;">
				${eunis:cmsPhrase(actionBean.contentManagement,'Country assessment:')}
			</div>
			<div style="width:100%; overflow-x:scroll;">
				<display:table name="actionBean.queryResultRowsCountry" class="sortable"
					pagesize="50" sort="list"
					requestURI="/species/${actionBean.idSpecies}/conservation_status">
					<display:caption></display:caption>
					<c:forEach var="cl2" items="${actionBean.queryResultColsCountry}">
							<display:column property="${cl2.property}"
								title="${cl2.property}"
								sortable="${cl2.sortable}"
								decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator" />
					</c:forEach>
				</display:table>
			</div>
			<c:if test="${not empty actionBean.attribution}">
				<b>Source:</b> ${actionBean.attribution}
					</c:if>
		</c:when>
		<c:otherwise>
			 		Query didn't return any result!
			 	</c:otherwise>
	</c:choose>

</stripes:layout-definition>
