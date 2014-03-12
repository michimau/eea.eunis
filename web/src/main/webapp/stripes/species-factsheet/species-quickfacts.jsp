<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
               <!-- quick facts -->

               <!--  Gallery on left -->
                <div class="left-area species">

                    <div id="speciesGallery" class="galleryViews js-noFilmstrip" data-options='{
                        "pause_on_hover" : true,
                        "hover_nav_buttons_images" : false,
                        "keep_nav_buttons_visible" : true,
                        "theme_path": "${pageContext.request.contextPath}/images",
                        "nav_theme": ""}'>
                        <ul>
                            <c:forEach items="${actionBean.pics}" var="pic" varStatus="loop">
                                <li>
                                    <div class="panel-overlay">
                                        <h3>${pic.description}</h3>
                                        <p>${loop.index + 1}/${fn:length(actionBean.pics)}&nbsp;
                                            ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
                                            <c:choose>
                                                <c:when test="${!empty pic.sourceUrl}">
                                                    <a href="${eunis:treatURLSpecialCharacters(pic.sourceUrl)}">${pic.source}</a>
                                                </c:when>
                                                <c:otherwise>
                                                    ${pic.source}
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${!empty pic.license}">
                                                &nbsp;(${pic.license})
                                            </c:if>
                                        </p>
                                    </div>
                                    <img src="${pic.path}/${pic.filename}" title="${pic.description}" style="height: 1px; width: 1px" />
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <!-- TODO add link for authenticated users to upload/delete images -->
                    <p class="text-right">
                        <a href="http://images.google.com/images?q=${eunis:replaceTags(actionBean.scientificName)}">More images</a>
                    </p>
                </div>

                <!-- Textual facts on right -->
                <div class="right-area quickfacts">
                    <h4>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h4>
                    <div>
                        <ul>
                            <li>
                                <a href="${ actionBean.pageUrl }#threat_status" onclick="if($('#threat_status ~ h2').attr('class').indexOf('current')==-1) $('#threat_status ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'Threat status Europe')}</a>
                                <span class="bold">${actionBean.consStatusEU.statusName}</span></p>
                            </li>
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Protected by ')}
                                <span class="bold">Not available</span> EU Nature Directives and
                                <span class="bold">${ actionBean.legalInstrumentCount }</span>
                                <a href="${ actionBean.pageUrl }#legal_status" onclick="if($('#legal_status ~ h2').attr('class').indexOf('current')==-1) $('#legal_status ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'international agreement(s)')}</a>.
                            </li>
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Protected in')}  <span class="bold">${ actionBean.speciesSitesCount }</span>
                                    <a href="${ actionBean.pageUrl }#protected" onclick="if($('#protected ~ h2').attr('class').indexOf('current')==-1) $('#protected ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 sites')}</a>.
                            </li>
                            <c:if test="${not empty actionBean.habitats}">
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Lives in ')}
                                <span class="bold">
                                    <c:choose>
                                        <c:when test="${not empty actionBean.habitats}">
                                            <c:forEach items="${actionBean.habitats}" var="habitat" varStatus="loopStatus">
                                                ${habitat}<c:if test="${!loopStatus.last}">, </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>Not avaliable</c:otherwise>
                                    </c:choose>
                                </span> ${eunis:cmsPhrase(actionBean.contentManagement, 'habitats')}
                            </li>
                            </c:if>
                            <c:if test="${actionBean.invasiveNobanis}">
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Reported as invasive by ')}
                                <span class="bold">Nobanis</span>
                            </li>
                            </c:if>
                        </ul>

                        <c:if test="${!empty actionBean.n2000id}">
                            <p class="discreet">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 code:')} ${actionBean.n2000id}
                            </p>
                        </c:if>
                    </div>
                </div>


                <!-- END quick facts -->
</stripes:layout-definition>