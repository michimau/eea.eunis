<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value="General external data"></c:set>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}">
	<stripes:layout-component name="head">
		<script src="<%=request.getContextPath()%>/script/overlib.js" type="text/javascript"></script>
	</stripes:layout-component>

	<stripes:layout-component name="contents">
	    <h2>
	        ${eunis:cmsPhrase(actionBean.contentManagement, 'External data')}
	    </h2>
	    <c:choose>
	        <c:when test="${empty actionBean.query}">
	            <c:if test="${not empty actionBean.queries}">
	                <p>
	                This page contains reports that query foreign systems for structured data that <em>links</em> to the species.
	                It is possible that there is no relevant data and then the query shows nothing. As more data becomes available as external data we will add more queries.
	                </p>
	                <h3>Select a query:</h3>
	                <dl>
	                    <c:forEach items="${actionBean.queries}" var="query" varStatus="loop">
	                        <dt><a href="species/${actionBean.idSpecies}/linkeddata?query=${query.id}" rel="nofollow">${query.title}</a></dt>
	                        <dd>${query.summary}</dd>
	                    </c:forEach>
	                </dl>
	            </c:if>
	        </c:when>
	        <c:otherwise>
	            <c:if test="${not empty actionBean.queries}">
	                <div style="font-weight:bold">Select a query:</div>
	                <stripes:form action="/species/${actionBean.idSpecies}/linkeddata" method="post">
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
	                    <div style="overflow-x:auto ">
	                        <display:table name="actionBean.queryResultRows" class="sortable" pagesize="30" sort="list" requestURI="/species/${actionBean.idSpecies}/linkeddata">
	                            <c:forEach var="cl" items="${actionBean.queryResultCols}">
	                                <display:column property="${cl.property}" title="${cl.title}" sortable="${cl.sortable}" decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator"/>
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
	        </c:otherwise>
	    </c:choose>
</stripes:layout-component>
</stripes:layout-render>