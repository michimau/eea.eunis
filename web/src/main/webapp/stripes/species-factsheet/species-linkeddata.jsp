<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
    <h3>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'External data')}
    </h3>

    <c:choose>
        <c:when test="${not empty actionBean.allQueries}">

            <div id="panels_query" class="eea-accordion-panels collapsed-by-default">
                <c:forEach items="${actionBean.allQueries}" var="query">

                    <div class="eea-accordion-panel" style="clear: both;">
                        <h2 class="notoc eea-icon-right-container" style="background-color: white;">${query.title}</h2>
                        <div class="pane">
                            <p>${query.summary}</p>

                            <c:choose>
                                <c:when test="${not empty query.resultCols && not empty query.resultRows}">
                                    <c:if test="${fn:length(query.resultRows) gt 10}">
                                        <div class="scroll-auto" style="height: 400px">
                                    </c:if>
                                    <div style="overflow-x:auto ">
                                        <display:table name="${query.resultRows}" class="listing" pagesize="2000" sort="list">
                                            <c:forEach var="cl" items="${query.resultCols}">
                                                <display:column property="${cl.property}" title="${cl.title}" decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator"/>
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

        </c:when>
        <c:otherwise>
            No external data sets available for this species
        </c:otherwise>
    </c:choose>


</stripes:layout-definition>
