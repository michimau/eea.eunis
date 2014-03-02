<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
                <!-- species status -->
                <a name="species-status"></a>
                <%--<h2 class="visualClear">How is this species doing?</h2>--%>

                <div class="left-area">
                    <div class="threat-status-indicator width-12">
                        <h3>${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red list status of threatened species')}</h3>
                        <p>The Threat Status' concept in IUCN Red lists assess the distance from extinction.</p>
                        <c:if test="${not empty actionBean.consStatus}">

                            <c:set var="statusCodeWO" value="${not empty actionBean.consStatusWO ? fn:toLowerCase(actionBean.consStatusWO.threatCode) : 'un'}"></c:set>
                            <c:set var="statusCodeEU" value="${not empty actionBean.consStatusEU ? fn:toLowerCase(actionBean.consStatusEU.threatCode) : 'un' }"></c:set>
                            <c:set var="statusCodeE25" value="${not empty actionBean.consStatusE25 ? fn:toLowerCase(actionBean.consStatusE25.threatCode) : 'un' }"></c:set>

                            <c:set var="statusCodeEU-title" value="${statusCodeEU eq 'un' ? 'Not assessed threat level for the Europe' : actionBean.consStatusEU.statusDesc}"></c:set>
                            <c:set var="statusCodeE25-title" value="${statusCodeE25 eq 'un' ? 'Not assessed threat level for the EU' : actionBean.consStatusE25.statusDesc}"></c:set>

                            <div class="threat-status-${statusCodeWO} roundedCorners">
                                <%--World status--%>
                                <c:choose>
                                    <c:when test="${!empty actionBean.consStatusWO}">
                                        <c:choose>
                                            <c:when test="${!empty actionBean.redlistLink}">
                                                <a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/0">
                                            </c:when>
                                            <c:otherwise>
                                                <a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;mode=">
                                            </c:otherwise>
                                        </c:choose>
                                            <div class="text-right eea-flexible-tooltip-right" title="${actionBean.consStatusWO.statusDesc}">
                                                <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'World')}</p>
                                                <p class="threat-status-label small-text">${actionBean.consStatusWO.statusName}</p>
                                                <p class="threat-status-source">${eunis:treatURLSpecialCharacters(actionBean.consStatusWO.reference)}</p>
                                            </div>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-right eea-flexible-tooltip-right" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed threat level for the world')}">
                                            <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'World')}</p>
                                            <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed')}</p>
                                            <p class="threat-status-source small-text">
                                                <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%--EU status--%>
                                <div class="threat-status-${statusCodeEU} roundedCorners width-11">
                                    <c:choose>
                                        <c:when test="${not empty actionBean.consStatusEU}">

                                        <c:choose>
                                            <c:when test="${!empty actionBean.redlistLink}">
                                                <a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/1">
                                            </c:when>
                                            <c:otherwise>
                                                <a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;mode=">
                                            </c:otherwise>
                                        </c:choose>
                                            <%--<a href="references/${actionBean.consStatusEU.idDc}">--%>
                                                <div class="text-right eea-flexible-tooltip-right" title="${actionBean.consStatusEU.statusDesc}">
                                                    <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Europe')}</p>
                                                    <p class="threat-status-label small-text">${actionBean.consStatusEU.statusName}</p>
                                                    <p class="threat-status-source">${eunis:treatURLSpecialCharacters(actionBean.consStatusEU.reference)}</p>
                                                </div>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-right eea-flexible-tooltip-right" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed threat level for the Europe')}">
                                                <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Europe')}</p>
                                                <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed')}</p>
                                                <p class="threat-status-source small-text">
                                                    <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <%--E25 status--%>
                                    <div class="threat-status-${statusCodeE25} roundedCorners width-9">
                                        <c:choose>
                                            <c:when test="${not empty actionBean.consStatusE25}">
                                                <c:choose>
                                                    <c:when test="${!empty actionBean.redlistLink}">
                                                        <a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/1">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;mode=">
                                                    </c:otherwise>
                                                </c:choose>
                                                <%--<a href="references/${actionBean.consStatusE25.idDc}">--%>
                                                    <div class="text-right eea-flexible-tooltip-right" title="${actionBean.consStatusE25.statusDesc}">
                                                        <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'EU')}</p>
                                                        <p class="threat-status-label small-text">${actionBean.consStatusE25.statusName}</p>
                                                        <p class="threat-status-source">${eunis:treatURLSpecialCharacters(actionBean.consStatusE25.reference)}</p>
                                                    </div>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-right eea-flexible-tooltip-right" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed threat level for the EU')}">
                                                    <p class="threat-status-region x-small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'EU')}</p>
                                                    <p class="threat-status-label small-text">${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed')}</p>
                                                    <p class="threat-status-source small-text">
                                                        <img src="<%=request.getContextPath()%>/images/icon-questionmark.png"/></p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
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
                                    <a href="#threat-status-overlay" rel="#threat-status-overlay" class="float-right standardButton">${eunis:cmsPhrase(actionBean.contentManagement, 'Other resources')}</a>
                                </div>
                            </div>
                        </c:if>

                        <!-- Threat status other resources overlay -->
                        <div class="overlay" id="threat-status-overlay">

                            <p>
                                <a href="http://ec.europa.eu/environment/nature/conservation/species/redlist/">${eunis:cmsPhrase(actionBean.contentManagement, 'European Red List (by European Commission)')}</a>
                            </p>


                        </div>

                    </div>
                    <fieldset>
                        <legend><strong>IUCN Red List Category</strong></legend>
                        <table class="legend-table" style="width: 100%;">
                        <tr class="discreet">
                            <td><div class="threat-status-dd legend-color"> </div> Data deficient</td>
                            <td><div class="threat-status-lc legend-color"> </div> Least Concern</td>
                            <td><div class="threat-status-nt legend-color"> </div> Near Threatened</td>
                            <td><div class="threat-status-vu legend-color"> </div> Vulnerable</td>
                        </tr>
                        <tr class="discreet">
                            <td><div class="threat-status-en legend-color"> </div> Endangered</td>
                            <td><div class="threat-status-cr legend-color"> </div> Critically endangered</td>
                            <td><div class="threat-status-ew legend-color"> </div> Extinct in the wild</td>
                            <td><div class="threat-status-ex legend-color"> </div> Extinct</td>
                        </tr>
                        </table>
                    </fieldset>
                </div>

                <div class="right-area conservation-status">
                    <h3>EU's conservation status by biogeographical regions</h3>
                    <p>EU's conservation status assesses the distance from a defined favorable situation as described in the Habitats Directive.</p>
                    <div class="map-view" style="border:1px solid #050505;">
                        <iframe id="speciesStatusMap" src="" height="400px" width="100%"></iframe>
                    </div>

                    <script>
                        addReloadOnDisplay("speciesStatusPane", "speciesStatusMap", "http://discomap.eea.europa.eu/map/Filtermap/?webmap=7ddade4a57384b48ae2f4f020b6a813b&speciesname=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}");
                    </script>

                    <div class="footer">
                        <!-- Table definition dropdown example -->
                        <div class="table-definition contain-float">
                            <c:if test="${not empty actionBean.conservationStatusQueryResultRows}">
                                <span class="table-definition-target standardButton float-left">
                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'See full table details')}
                                </span>
                            </c:if>
                        </div>

                    </div>
                </div>
                <!-- END species status -->
</stripes:layout-definition>
