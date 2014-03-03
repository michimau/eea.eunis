<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <h3>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'External data')}
    </h3>
    <p>
        This page contains reports that query foreign systems for structured data that <em>links</em> to the species.
        It is possible that there is no relevant data and then the query shows nothing. As more data becomes available as external data we will add more queries.
    </p>

    <div id="panels_query" class="eea-accordion-panels collapsed-by-default">
    <c:forEach items="${actionBean.allQueries}" var="query">

        <div class="eea-accordion-panel" style="clear: both;">
            <h2 class="notoc eea-icon-right-container">${query.title}</h2>
            <div class="pane">
                <p>${query.summary}</p>

                <c:choose>
                    <c:when test="${not empty query.resultCols && not empty query.resultRows}">
                        <c:if test="${fn:length(query.resultRows) gt 10}">
                            <div class="scroll-auto" style="height: 400px">
                        </c:if>
                            <div style="overflow-x:auto ">
                                <display:table name="${query.resultRows}" class="sortable" pagesize="2000" sort="list">
                                    <c:forEach var="cl" items="${query.resultCols}">
                                        <display:column property="${cl.property}" title="${cl.title}" sortable="${cl.sortable}" decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator"/>
                                    </c:forEach>
                                </display:table>
                        <c:if test="${fn:length(query.resultRows) gt 10}">
                            </div>
                        </c:if>
                        </div>
                        <c:if test="${not empty query.attribution}">
                            <b>Source:</b> ${query.attribution}
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        Query didn't return any result!
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </c:forEach>
    </div>

</stripes:layout-definition>
