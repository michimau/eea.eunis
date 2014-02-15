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
                    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h2>
                    <div>

                        <p><a href="${ actionBean.pageUrl }#threat_status" onclick="if($('#threat_status ~ h2').attr('class').indexOf('current')==-1) $('#threat_status ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'Threat status Europe')}</a>
                                <span class="bold">${actionBean.consStatusEU.statusName}</span></p>

                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Protected by ')}
                        <span class="bold">Not available</span> EU Nature Directives and
                        <span class="bold">${ actionBean.legalInstrumentCount }</span>
                            <a href="${ actionBean.pageUrl }#legal_status" onclick="if($('#legal_status ~ h2').attr('class').indexOf('current')==-1) $('#legal_status ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'international agreement(s)')}</a>.</p>

                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Protected in')}  <span class="bold">${ actionBean.speciesSitesCount }</span>
                            <a href="${ actionBean.pageUrl }#protected" onclick="if($('#protected ~ h2').attr('class').indexOf('current')==-1) $('#protected ~ h2').click(); ">${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 sites')}</a>.</p>

                        <c:if test="${not empty actionBean.habitats}">
                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Lives in ')}
                            <span class="bold">
                                <c:choose>
                                    <c:when test="${not empty actionBean.habitats}">
                                    <c:forEach items="${actionBean.habitats}" var="habitat" varStatus="loopStatus">
                                        ${habitat}<c:if test="${!loopStatus.last}">, </c:if>
                                    </c:forEach>
                                    </c:when>
                                    <c:otherwise>Not avaliable</c:otherwise>
                                </c:choose>
                            </span> ${eunis:cmsPhrase(actionBean.contentManagement, 'habitats')}</p>
                        </c:if>

                        <c:if test="${actionBean.invasiveNobanis}">
                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Reported as invasive by ')}
                            <span class="bold">Nobanis</span></p>
                        </c:if>

                        <c:if test="${!empty actionBean.n2000id}">
                            <p class="discreet">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 code:')} ${actionBean.n2000id}
                            </p>
                        </c:if>

                        <p><a href="#generic-references-overlay" rel="#generic-references-overlay" class="float-right standardButton">${eunis:cmsPhrase(actionBean.contentManagement, 'Other resources')}</a></p>
                    </div>
                    <!-- Generic other resources overlay -->
                    <div class="overlay" id="generic-references-overlay">


                            <c:choose>
                                <c:when test="${!empty actionBean.gbifLink}">
                                    <p>
                                        <a href="http://data.gbif.org/species/${actionBean.gbifLink}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF page')}</a>
                                      </p>
                                </c:when>
                                  <c:otherwise>
                                    <p>
                                        <a href="http://data.gbif.org/species/${actionBean.gbifLink2}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF search')}</a>
                                      </p>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${actionBean.natureObjectAttributesMap['sameSynonymAnimalsWCMC'] == null && actionBean.natureObjectAttributesMap['sameSynonymPlantsWCMC'] == null}">
                                <p>
                                    <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on UNEP-WCMC')}" href="http://www.unep-wcmc-apps.org/isdb/Taxonomy/tax-gs-search2.cfm?displaylanguage=ENG&amp;source=${actionBean.kingdomname}&amp;GenName=${actionBean.specie.genus}&amp;SpcName=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC search')}</a>
                                  </p>
                            </c:if>

                            <c:if test="${actionBean.factsheet.speciesGroup == 'fishes'}">
                                <p>
                                    <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fishbase')}" href="http://www.fishbase.de/Summary/SpeciesSummary.php?genusname=${actionBean.specie.genus}&amp;speciesname=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fishbase search')}</a>
                                </p>
                            </c:if>
                            <c:if test="${!empty actionBean.wormsid}">
                                <p>
                                    <a href="http://www.marinespecies.org/aphia.php?p=taxdetails&amp;id=${actionBean.wormsid}" title="World Register of Marine Species page">${eunis:cmsPhrase(actionBean.contentManagement, 'WoRMS page')}</a>
                                </p>
                            </c:if>
                            <c:choose>
                                <c:when test="${!empty actionBean.faeu}">
                                    <p>
                                        <a href="http://www.faunaeur.org/full_results.php?id=${actionBean.faeu}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fauna Europaea page')}</a>
                                    </p>
                                </c:when>
                                  <c:otherwise>
                                    <c:if test="${actionBean.kingdomname == 'Animals'}">
                                    <p>
                                        <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fauna Europaea')}" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus=${actionBean.specie.genus}&amp;species=${actionBean.speciesName}">${eunis:cmsPhrase(actionBean.contentManagement, 'Search Fauna Europaea')}</a>
                                    </p>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${empty actionBean.itisTSN}">
                                <p>
                                <a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=Scientific_Name&amp;search_kingdom=every&amp;search_span=exactly_for&amp;search_value=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;categories=All&amp;source=html&amp;search_credRating=All">${eunis:cmsPhrase(actionBean.contentManagement, 'Search ITIS')}</a>
                                </p>
                            </c:if>
                            <c:choose>
                                <c:when test="${!empty actionBean.ncbi}">
                                    <p>
                                        <a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=${actionBean.ncbi}&amp;lvl=0">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI:')}${actionBean.ncbi}</a>
                                    </p>
                                </c:when>
                                  <c:otherwise>
                                    <p>
                                        <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on NCBI Taxonomy browser')}" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI Taxonomy search')}</a>
                                    </p>
                                </c:otherwise>
                            </c:choose>
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


                <!-- END quick facts -->
</stripes:layout-definition>