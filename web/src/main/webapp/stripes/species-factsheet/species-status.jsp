<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
                <!-- species status -->
                <h2>How is this species doing?</h2>

                <div class="left-area">
                    <div class="threat-status-indicator width-12">
                        <h3>${eunis:cmsPhrase(actionBean.contentManagement, 'International Threat Status')}</h3>
                        <c:if test="${not empty actionBean.consStatus}">

                            <c:set var="statusCodeWO" value="${not empty actionBean.consStatusWO ? fn:toLowerCase(actionBean.consStatusWO.threatCode) : 'un'}"></c:set>
                            <c:set var="statusCodeEU" value="${not empty actionBean.consStatusEU ? fn:toLowerCase(actionBean.consStatusEU.threatCode) : 'un' }"></c:set>
                            <c:set var="statusCodeE25" value="${not empty actionBean.consStatusE25 ? fn:toLowerCase(actionBean.consStatusE25.threatCode) : 'un' }"></c:set>

                            <div class="threat-status-${statusCodeWO} roundedCorners">

                                <div class="text-right">
                                    <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'World')}</p>
                                    <c:choose>
                                        <c:when test="${not empty actionBean.consStatusWO}">
                                            <p class="threat-status-label small-text eea-flexible-tooltip-right" title="${actionBean.consStatusWO.statusDesc}">${actionBean.consStatusWO.statusName}</p>
                                            <p class="threat-status-source"><a href="references/${actionBean.consStatusWO.idDc}">${eunis:treatURLSpecialCharacters(actionBean.consStatusWO.reference)}</a></p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Unknown')}</p>
                                            <p class="threat-status-source small-text eea-flexible-tooltip-right" title="Unknown threat level for the world">
                                                <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="threat-status-${statusCodeEU} roundedCorners width-11">
                                    <div class="text-right">
                                        <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Europe')}</p>
                                        <c:choose>
                                            <c:when test="${not empty actionBean.consStatusEU}">
                                                <p class="threat-status-label small-text eea-flexible-tooltip-right" title="${actionBean.consStatusEU.statusDesc}">${actionBean.consStatusEU.statusName}</p>
                                                <p class="threat-status-source"><a href="references/${actionBean.consStatusEU.idDc}">${eunis:treatURLSpecialCharacters(actionBean.consStatusEU.reference)}</a></p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Unknown')}</p>
                                                <p class="threat-status-source small-text eea-flexible-tooltip-right" title="Unknown threat level for the Europe">
                                                    <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="threat-status-${statusCodeE25} roundedCorners width-9">
                                        <div class="text-right">
                                            <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'EU')}</p>
                                            <c:choose>
                                                <c:when test="${not empty actionBean.consStatusE25}">
                                                    <p class="threat-status-label small-text eea-flexible-tooltip-right" title="${actionBean.consStatusE25.statusDesc}">${actionBean.consStatusE25.statusName}</p>
                                                    <p class="threat-status-source"><a href="references/${actionBean.consStatusE25.idDc}">${eunis:treatURLSpecialCharacters(actionBean.consStatusE25.reference)}</a></p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Unknown')}</p>
                                                    <p class="threat-status-source small-text eea-flexible-tooltip-right" title="Unknown threat level for the EU">
                                                        <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    <div class="footer">
                        <c:if test="${not empty actionBean.consStatus}">
                            <!-- Table definition dropdown example -->
                            <div class="table-definition contain-float">
                                <div class="width-12 contain-float">
                                    <span class="table-definition-target standardButton float-left">
                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'See full table details')}
                                    </span>
                                    <a href="#threat-status-overlay" rel="#threat-status-overlay" class="float-right">${eunis:cmsPhrase(actionBean.contentManagement, 'Other resources')}</a>
                                </div>
                                <div class="table-definition-body">
                                    <table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'International Threat Status')}" class="listing fullwidth">
                                        <colgroup><col style="width: 20%">
                                            <col style="width: 20%">
                                            <col style="width: 20%">
                                            <col style="width: 40%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Area')}
                                                    <img src="http://www.eea.europa.eu/arrowUp.gif" height="6" width="9"></th>
                                                <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
                                                    <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                                <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'International threat code')}
                                                    <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                                <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
                                                    <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${actionBean.consStatus}" var="threat" varStatus="loop">
                                                <tr>
                                                    <td>
                                                        ${eunis:treatURLSpecialCharacters(threat.country)}
                                                    </td>
                                                    <td>
                                                        ${eunis:treatURLSpecialCharacters(threat.status)}
                                                    </td>
                                                    <td>
                                                        <span class="boldUnderline" title="${eunis:treatURLSpecialCharacters(threat.statusDesc)}">
                                                            ${eunis:treatURLSpecialCharacters(threat.threatCode)}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="references/${threat.idDc}">${eunis:treatURLSpecialCharacters(threat.reference)}</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>

                        <!-- Threat status other resources overlay -->
                        <div class="overlay" id="threat-status-overlay">

                            <p>
                                <c:choose>
                                    <c:when test="${!empty actionBean.redlistLink}">
                                        <a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/0">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List page')}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;mode=">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List search')}</a>
                                    </c:otherwise>
                                </c:choose>
                            </p>


                        </div>

                    </div>
                </div>

                <div class="right-area conservation-status">
                    <h3>EU's conservation status by biogeographical regions</h3>

                    <div class="map-view">
                        <img src="<%=request.getContextPath()%>/images/biogeograpical-service.png"/>
                    </div>

                    <div class="footer">
                        <!-- Table definition dropdown example -->
                        <div class="table-definition contain-float">
                            <span class="table-definition-target standardButton float-left">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'See full table details')}
                            </span>
                            <a href="#conservation-status-overlay" rel="#conservation-status-overlay" class="float-right">Other resources</a>
                            <c:if test="${not empty actionBean.conservationStatusQueryResultRows}">
                                <c:forEach items="${actionBean.conservationStatusQueries}" var="query">
                                    <div class="table-definition-body visualClear">
                                        <div style="margin-top:20px">
                                            <p style="font-weight:bold">${eunis:cmsPhrase(actionBean.contentManagement, query.title)}:</p>
                                            <c:set var="queryId" value="${query.id}"/>

                                            <div style="overflow-x:auto">
                                                <span class="pagebanner">${fn:length(actionBean.conservationStatusQueryResultRows[queryId])} item<c:if test="${fn:length(actionBean.conservationStatusQueryResultRows[queryId]) != 1}">s</c:if> found.</span>
                                                <table style="margin-top:20px" class="datatable listing inline-block">
                                                    <thead>
                                                        <tr>
                                                            <c:forEach var="col" items="${actionBean.conservationStatusQueryResultCols[queryId]}">
                                                                <th class="dt_sortable">
                                                                 ${col.property}
                                                                </th>
                                                            </c:forEach>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="row" items="${actionBean.conservationStatusQueryResultRows[queryId]}">
                                                            <tr>
                                                                <c:forEach var="col" items="${actionBean.conservationStatusQueryResultCols[queryId]}">
                                                                    <td>${row[col.property]}</td>
                                                                </c:forEach>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                        <!-- Conservation status other resources overlay -->
                        <div class="overlay" id="conservation-status-overlay">
                            <c:forEach items="${actionBean.links}" var="link" varStatus="loop">
                                <p>
                                    <c:choose>
                                        <c:when test="${!empty link.url}">
                                            <a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
                                        </c:when>
                                        <c:otherwise>
                                            ${link.name}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <!-- END species status -->
</stripes:layout-definition>
