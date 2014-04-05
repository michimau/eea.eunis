<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
               <!-- quick facts -->

               <script>
                   function openSection(sectionName) {
                       if($('#' + sectionName + ' ~ h2').attr('class').indexOf('current')==-1)
                           $('#' + sectionName + ' ~ h2').click();
                   }
               </script>


               <!--  Gallery on left -->
                <div class="left-area species">


                    <%--<ul id="galleryView2" class="galleryView js-noFilmstrip">--%>
                        <%--<li>--%>
                            <%--<span class="panel-overlay">Overlay text goes here</span>--%>
                            <%--<img src="mr-monkey/image_large" />--%>
                        <%--</li>--%>
                        <%--<li><img src="monkey-with-makeup/image_large" /></li>--%>
                    <%--</ul>--%>
                    <%----%>
                    <ul id="speciesGallery" class="galleryViewss">
                            <c:forEach items="${actionBean.pics}" var="pic" varStatus="loop">
                                <li>
                                    <img src="${pic.path}/${pic.filename}"
                                    title="${pic.description}"
                                     style="display: none;"
                                     data-description="${pic.source}"
                                     />
                                </li>
                            </c:forEach>
                        </ul>
                    <p class="text-right">
                        <a href="http://images.google.com/images?q=${eunis:replaceTags(actionBean.scientificName)}">Images from the web</a>
                    </p>
                </div>

                <!-- Textual facts on right -->
                <div class="right-area quickfacts">
                    <h4>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h4>
                    <div>
                        <ul>
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Threat status Europe')}:
                                <a href="${ actionBean.pageUrl }#threat_status" onclick="openSection('threat_status');">
                                <span class="bold">
                                    <c:choose>
                                        <c:when test="${not empty actionBean.consStatusEU.statusName}">
                                            ${actionBean.consStatusEU.statusName}
                                        </c:when>
                                        <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not assessed')}</c:otherwise>
                                    </c:choose>
                                </span>
                                </a>
                            </li>
                            <li>
                                <c:choose>
                                    <c:when test="${actionBean.protectedByEUDirectives or fn:length(actionBean.legalStatuses)>0}">
                                        Protected by
                                        <c:if test="${actionBean.protectedByEUDirectives}">
                                            <span class="bold">EU Nature Directives</span>
                                        </c:if>
                                        <c:if test="${actionBean.protectedByEUDirectives and fn:length(actionBean.legalStatuses)>0}">and</c:if>
                                        <c:if test="${fn:length(actionBean.legalStatuses)>0}">
                                            <a href="${ actionBean.pageUrl }#legal_status" onclick="openSection('legal_status');"><span class="bold">${ fn:length(actionBean.legalStatuses) }</span></a>
                                            <c:if test="${actionBean.protectedByEUDirectives and fn:length(actionBean.legalStatuses)>0}">other</c:if>
                                            <c:choose>
                                                <c:when test="${fn:length(actionBean.legalStatuses)>1}">
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'international agreements')}
                                                </c:when>
                                                <c:otherwise>
                                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'international agreement')}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not listed in legal texts')}</c:otherwise>
                                </c:choose>
                            </li>
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Protected in')}:
                                <a href="${ actionBean.pageUrl }#protected" onclick="openSection('protected');"><span class="bold">${ actionBean.speciesSitesCount }</span></a>
                                    ${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 sites')}.
                            </li>
                            <c:if test="${not empty actionBean.habitats}">
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Lives in ')}:
                                <span class="bold">
                                    <c:choose>
                                        <c:when test="${not empty actionBean.habitats}">
                                            <c:forEach items="${actionBean.habitats}" var="habitat" varStatus="loopStatus">
                                                ${habitat}<c:if test="${!loopStatus.last}">, </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>Not avaliable</c:otherwise>
                                    </c:choose>
                                </span>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'habitats')}
                            </li>
                            </c:if>
                            <c:if test="${not empty actionBean.nobanisFactsheetLink}">
                            <li>
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Reported as invasive by')}
                                <span class="bold"><a href="${actionBean.nobanisLink.url}">NOBANIS</a></span>,
                                see also
                                <span class="bold"><a href="${actionBean.nobanisFactsheetLink.url}">fact sheet</a></span>
                            </li>
                            </c:if>
                        </ul>

                        <c:if test="${!empty actionBean.n2000id}">
                            <p class="discreet">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 code')}: ${actionBean.n2000id}
                            </p>
                        </c:if>
                    </div>
                </div>


                <!-- END quick facts -->
</stripes:layout-definition>