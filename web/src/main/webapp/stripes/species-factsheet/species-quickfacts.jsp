<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
               <!-- quick facts -->

               <!--  Gallery on left -->
                <div class="left-area species">

                    <div class="galleryViews js-noFilmstrip" data-options='{
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
                                    <img src="${pic.path}/${pic.filename}" title="${pic.description}" />
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
                    <div class="bold">
                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It has')} <span class="quickfact-number">${ (actionBean.synonymsCount + 1) }</span>
                            <a href="#synonyms-overlay" rel="#synonyms-overlay">${eunis:cmsPhrase(actionBean.contentManagement, 'scientific names')}</a> ${eunis:cmsPhrase(actionBean.contentManagement, 'and')} 
                            <a href="#common-names-overlay" rel="#common-names-overlay">${eunis:cmsPhrase(actionBean.contentManagement, 'common names')}</a> ${eunis:cmsPhrase(actionBean.contentManagement, 'in')} 
                            <span class="quickfact-number">${ actionBean.vernNamesCount }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'languages')}
                            .</p>

                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Protected in')}  <span class="quickfact-number">${ actionBean.speciesSitesCount }</span>
                            <a href="${ actionBean.pageUrl }#protected">${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 sites')}</a>.</p>

                        <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Mentioned in')} <span class="quickfact-number">${ actionBean.legalInstrumentCount }</span>
                            <a href="${ actionBean.pageUrl }#legal-instruments">${eunis:cmsPhrase(actionBean.contentManagement, 'legal instruments')}</a>.</p>
  
                        <c:if test="${!empty actionBean.n2000id}">
                            <p class="discreet">
                                ${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 code:')} ${actionBean.n2000id}
                            </p>
                        </c:if>


                        <p><a href="#generic-references-overlay" rel="#generic-references-overlay" class="float-right">${eunis:cmsPhrase(actionBean.contentManagement, 'Other resources')}</a></p>
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

                    <div class="overlay" id="synonyms-overlay">
                        <table summary="List of synonyms" class="listing fullwidth">
                            <colgroup>
                            	<col style="width:40%">
                                <col style="width:40%">
                                <col style="width:20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}

                                        <img src="http://www.eea.europa.eu/arrowUp.gif" height="6" width="9"></th>
                                    <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
                                        <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                    <th scope="col" style="cursor: pointer;"><img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Type')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
                                        <img src="http://www.eea.europa.eu/arrowBlank.gif" height="6" width="9"></th>
                                </tr>
                            </thead>
                            <tbody>

							<tr class="zebraeven">
								<td>
									${eunis:treatURLSpecialCharacters(actionBean.scientificName)}</a>
								</td>
								<td>
									${eunis:treatURLSpecialCharacters(actionBean.author)}
								</td>
								<td>
									${eunis:cmsPhrase(actionBean.contentManagement, 'Valid name')}
								</td>
							</tr>


                                <c:forEach items="${actionBean.factsheet.synonymsIterator}" var="synonym" varStatus="loop">
                                    <tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/species/${synonym.idSpecies}">${eunis:treatURLSpecialCharacters(synonym.scientificName)}</a>
                                          </td>
                                          <td>
                                              ${eunis:treatURLSpecialCharacters(synonym.author)}
                                          </td>
                                          <td>
											${eunis:cmsPhrase(actionBean.contentManagement, 'Synonym')}
										</td>
                                    </tr>
                                </c:forEach>



                            </tbody>
                        </table>
                    </div>
                    
                    <div class='overlay' id="common-names-overlay">
                        <table summary="Vernacular names" class="listing fullwidth">
                            <thead>
                            <tr>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Vernacular Name')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                                    <img src="http://www.eea.europa.eu/arrowUp.gif"
                                         height="6" width="9"></th>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Language')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                                    <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                         height="6" width="9"></th>
                                <th scope="col" style="cursor: pointer;"><img
                                        src="http://www.eea.europa.eu/arrowBlank.gif"
                                        height="6" width="9">
                                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
                                          ${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}

                                    <img src="http://www.eea.europa.eu/arrowBlank.gif"
                                         height="6" width="9"></th>
                            </tr>
                            </thead>
                            <tbody>
                            
                            
                            <c:forEach items="${actionBean.vernNames}" var="vern" varStatus="loop">
                                <c:set var="ref" value="-1"></c:set>
                                <c:if test="${!empty vern.idDc}">
                                    <c:set var="ref" value="${vern.idDc}"></c:set>
                                </c:if>
                                <tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
                                    <td xml:lang="${vern.languageCode}">
                                          ${eunis:treatURLSpecialCharacters(vern.name)}
                                    </td>
                                    <td>
                                          ${vern.language}
                                    </td>
                                    <td>
                                          <a class="link-plain" href="references/${ref}">${eunis:getAuthorAndUrlByIdDc(ref)}</a>
                                    </td>
                                </tr>
                            </c:forEach>


                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="visualClear"></div>
                <!-- END quick facts -->
</stripes:layout-definition>