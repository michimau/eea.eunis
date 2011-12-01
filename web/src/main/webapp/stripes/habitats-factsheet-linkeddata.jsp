<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<h2>
		${eunis:cmsPhrase(actionBean.contentManagement, 'Linked data')}
	</h2>
	<c:choose>
		<c:when test="${empty actionBean.query}">
			<c:if test="${not empty actionBean.queries}">
				<p>
				This page contains reports that query foreign systems for structured data the <em>links</em> to the habitat.
				It is possible that there is no relevant data and then the query show nothing. As more data becomes available we will add more queries.
				</p>
				<h3>Select a query:</h3>
				<dl>
					<c:forEach items="${actionBean.queries}" var="query" varStatus="loop">
				 		<dt><a href="habitats/${actionBean.idHabitat}/linkeddata?query=${query.id}" rel="nofollow">${query.title}</a></dt>
				 		<dd>${query.summary}</dd>
			 		</c:forEach>
			 	</dl>
		 	</c:if>
 		</c:when>
 		<c:otherwise>
 			<c:if test="${not empty actionBean.queries}">
 				<div style="font-weight:bold">Select a query:</div>
 				<stripes:form action="/habitats/${actionBean.idHabitat}/linkeddata" method="post">
				<p>
	 				<stripes:select name="query">
	 					<stripes:options-collection collection="${actionBean.queries}" label="title" value="id"/>
			 		</stripes:select>
			 		<stripes:submit name="linkeddata" value="Execute query"/>
				</p>
		 		</stripes:form>
 			</c:if>
		 	<c:choose>
			 	<c:when test="${not empty actionBean.queryResultCols && not empty actionBean.queryResultRows}">
			 		<display:table name="actionBean.queryResultRows" class="sortable" pagesize="50" sort="list" requestURI="/habitats/${actionBean.idHabitat}/linkeddata">
					    <c:forEach var="cl" items="${actionBean.queryResultCols}">
					      	<display:column property="${cl.property}" title="${cl.title}" sortable="${cl.sortable}" decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator"/>
					    </c:forEach>
					</display:table>
					<c:if test="${not empty actionBean.attribution}">
						<b>Source:</b> ${actionBean.attribution}
					</c:if>
			 	</c:when>
			 	<c:otherwise>
			 		Query didn't return any result!
			 	</c:otherwise>
		 	</c:choose>
 		</c:otherwise>
 	</c:choose>
</stripes:layout-definition>