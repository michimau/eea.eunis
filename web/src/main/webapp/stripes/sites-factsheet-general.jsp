<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>

    <%-- The main picture section --%>

    <c:if test="${actionBean.pic!=null && not empty actionBean.pic.filename}">
        <div class="naturepic-plus-container naturepic-right">
            <div class="naturepic-plus">
                <div class="naturepic-image">
                    <a href="javascript:openpictures('${actionBean.pic.domain}/pictures.jsp?idobject=${actionBean.idsite}&amp;natureobjecttype=Sites',600,600)">
                        <img src="${actionBean.pic.path}/${actionBean.pic.filename}" alt="${actionBean.pic.description}" class="scaled" style="${actionBean.pic.style}"/>
                    </a>
                </div>
		        <div class="naturepic-note">
                    <c:out value="${actionBean.pic.description}"/>
		        </div>
		        <c:if test="${!empty actionBean.pic.source}">
                    <div class="naturepic-source-copyright">
                        ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
                        <c:choose>
                            <c:when test="${!empty actionBean.pic.sourceUrl}">
                                <a href="${eunis:treatURLSpecialCharacters(actionBean.pic.sourceUrl)}">${actionBean.pic.source}</a>
                            </c:when>
                            <c:otherwise>
                                ${actionBean.pic.source}
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${!empty actionBean.pic.license}">
                            &nbsp;(${actionBean.pic.license})
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>

    <%-- The site identification and designation information section --%>

    <div class="allow-naturepic">
        <h2>
            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Site identification')}"/>
        </h2>
        <table summary="layout" class="datatable fullwidth">
            <col style="width:40%"/>
            <col style="width:60%"/>
            <tbody>
	            <tr>
	                <td>
	                    <%-- Code in database --%>
	                    <strong><c:out value="${actionBean.sourceDbName}"/></strong>
	                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'code in database')}"/>
	                </td>
	                <td>
	                    <strong><c:out value="${actionBean.idsite}"/></strong>
	                </td>
	            </tr>
	            <tr class="zebraeven">
	                <%-- Surface area --%>
	                <td>
	                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Surface area (ha)')}"/>
	                </td>
	                <td>
	                    ${eunis:formatAreaExt(actionBean.factsheet.siteObject.area, 0, 2, '&nbsp;', null)}&nbsp;
	                </td>
	            </tr>
	            <c:if test="${actionBean.lengthApplicable && actionBean.factsheet.siteObject.length!=null}">
	                <tr>
	                    <%-- Length --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Length (m)')}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.factsheet.siteObject.length}"/>&nbsp;
	                    </td>
	                </tr>
	            </c:if>
	            <tr class="zebraeven">
	                <%-- Complex name --%>
	                <td>
	                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Complex name')}"/>
	                </td>
	                <td>
	                    <c:out value="${actionBean.factsheet.siteObject.complexName}"/>
	                </td>
	            </tr>
	            <tr>
	                <%-- District name --%>
	                <td>
	                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'District name')}"/>
	                </td>
	                <td>
	                    <c:out value="${actionBean.factsheet.siteObject.districtName}"/>
	                </td>
	            </tr>
	            <c:if test="${actionBean.compilationDateDisplayValue != null}">
	                <tr class="zebraeven">
	                    <%-- Date form compilation date --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Date form compilation date')}"/>&nbsp;<c:out value="${actionBean.compilationDateFormat}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.compilationDateDisplayValue}"/>
	                    </td>
	                </tr>
	            </c:if>
	            <c:if test="${actionBean.updateDateDisplayValue != null}">
	                <tr>
	                    <%-- Date form compilation date --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Date form update')}"/>&nbsp;<c:out value="${actionBean.updateDateFormat}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.updateDateDisplayValue}"/>
	                    </td>
	                </tr>
	            </c:if>
	            <c:if test="${actionBean.dateProposedDisplayValue != null}">
	                <tr class="zebraeven">
	                    <%-- Date proposed --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Date proposed')}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.dateProposedDisplayValue}"/>
	                    </td>
	                </tr>
	            </c:if>
	            <c:if test="${actionBean.dateConfirmedDisplayValue != null}">
	                <tr>
	                    <%-- Date confirmed --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Date confirmed')}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.dateConfirmedDisplayValue}"/>
	                    </td>
	                </tr>
	            </c:if>
	            <c:if test="${actionBean.dateFirstDesignationApplicable}">
	                <tr class="zebraeven">
	                    <%-- Date first designation --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Date first designation')}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.factsheet.dateFirstDesignation}"/>
	                    </td>
	                </tr>
	            </c:if>
	            <c:if test="${actionBean.siteDesignationDateDisplayValue != null}">
	                <tr>
	                    <%-- Site designation date --%>
	                    <td>
	                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Site designation date')}"/>
	                    </td>
	                    <td>
	                        <c:out value="${actionBean.siteDesignationDateDisplayValue}"/>
	                    </td>
	                </tr>
	            </c:if>
            </tbody>
        </table>

        <c:if test="${not empty actionBean.designations}">
            <%-- Designation information --%>
            <h2>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Designation information')}"/>
            </h2>
            <table summary="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'designation_information'))}" class="listing fullwidth">
                <thead>
                    <tr>
                        <th scope="col">
                            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Source data set')}"/>
                        </th>
                        <th scope="col">
                            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Designation code')}"/>
                        </th>
                        <th scope="col">
                            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name (Original)')}"/>
                        </th>
                        <th scope="col">
                            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name (English)')}"/>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${!actionBean.natura2000SiteAndTypeC}">
                            <c:set var="designation" value="${actionBean.designations[0]}"/>
                            <tr class="zebraeven">
                                <td>
                                    <c:out value="${designation.dataSource}"/>
                                </td>
                                <td>
                                    <c:out value="${eunis:formatString(designation.idDesignation, '&nbsp;')}"/>
                                </td>
                                <td>
                                    <c:if test="${not empty designation.description}">
                                        <a title="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'open_designation_factsheet'))}" href="designations/${designation.idGeoscope}:${designation.idDesignation}?fromWhere=original">
                                            <c:out value="${designation.description}"/>
                                        </a>
                                        ${eunis:cmsTitle(actionBean.contentManagement, 'open_designation_factsheet')}
                                    </c:if>
                                    <c:if test="${empty designation.description}">&nbsp;</c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty designation.descriptionEn}">
                                        <a title="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'open_designation_factsheet'))}" href="designations/${designation.idGeoscope}:${designation.idDesignation}?fromWhere=en">
                                            <c:out value="${designation.descriptionEn}"/>
                                        </a>
                                        ${eunis:cmsTitle(actionBean.contentManagement, 'open_designation_factsheet')}
                                    </c:if>
                                    <c:if test="${empty designation.descriptionEn}">&nbsp;</c:if>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${actionBean.chm62edtDesignations}" var="designation">
                                <tr>
                                    <td>
                                        <c:out value="${designation.originalDataSource}"/>
                                    </td>
                                    <td>
                                        <c:out value="${eunis:formatString(designation.idDesignation, '&nbsp;')}"/>
                                    </td>
                                    <td>
                                        <c:if test="${not empty designation.description}">
	                                        <a title="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'open_designation_factsheet'))}" href="designations/${designation.idGeoscope}:${designation.idDesignation}?fromWhere=original">
	                                            <c:out value="${designation.description}"/>
	                                        </a>
	                                        ${eunis:cmsTitle(actionBean.contentManagement, 'open_designation_factsheet')}
	                                    </c:if>
	                                    <c:if test="${empty designation.description}">&nbsp;</c:if>
                                    </td>
                                    <td>
	                                    <c:if test="${not empty designation.descriptionEn}">
	                                        <a title="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'open_designation_factsheet'))}" href="designations/${designation.idGeoscope}:${designation.idDesignation}?fromWhere=en">
	                                            <c:out value="${designation.descriptionEn}"/>
	                                        </a>
	                                        ${eunis:cmsTitle(actionBean.contentManagement, 'open_designation_factsheet')}
	                                    </c:if>
	                                    <c:if test="${empty designation.descriptionEn}">&nbsp;</c:if>
	                                </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </c:if>
    </div>

    <%-- The external links section --%>

    <h2>
        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'External links')}"/>
    </h2>
    <div id="linkcollection">

        <div>
	        <a title="${fn:escapeXml(eunis:cms(actionBean.contentManagement, 'google_pictures'))}" href="http://images.google.com/images?q=${actionBean.factsheet.siteObject.name}">
	            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Pictures on Google')}"/>
	        </a>
        </div>
        <c:if test="${actionBean.typeCDDA}">
            <div>
                <a href="http://www.protectedplanet.net/sites/${actionBean.factsheet.siteObject.idSite}">
                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Protected Planet')}"/>
                </a>
            </div>
        </c:if>
        <c:if test="${actionBean.typeNatura2000}">
            <div>
                <a rel="nofollow" href="http://natura2000.eea.europa.eu/Natura2000/SDFPublic.aspx?site=${actionBean.factsheet.siteObject.idSite}">
                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 factsheet')}"/>
                </a>
            </div>
            <div>
                <a href="http://natura2000.eea.europa.eu/N2KGisViewer.html#siteCode=${actionBean.factsheet.siteObject.idSite}">
                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Natura 2000 mapviewer')}"/>
                </a>
            </div>
        </c:if>
        <c:forEach items="${actionBean.links}" var="link" varStatus="loop">
            <div>
                <c:choose>
                    <c:when test="${!empty link.url}">
                        <a href="${eunis:treatURLSpecialCharacters(link.url)}">
                            <c:out value="${link.name}"/>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${link.name}"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>
    </div>

    <%-- The location information section --%>

    <c:set var="country" value="${fn:trim(eunis:formatString(actionBean.factsheet.country,''))}"/>
    <c:set var="parentCountry" value="${fn:trim(eunis:formatString(actionBean.factsheet.parentCountry,''))}"/>

    <h2 style="clear:left">
        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Location information')}"/>
    </h2>

    <table class="datatable fullwidth">
        <tr>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Country')}"/>
            </td>
            <td colspan="2">
                <c:choose>
                    <c:when test="${eunis:isCountry(country)}">
                        <a href="${pageContext.request.contextPath}/countries/${actionBean.countryObject.eunisAreaCode}?DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=true&amp;DB_CORINE=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="${eunis:cms(actionBean.contentManagement, 'open_the_statistical_data_for')} ${country}">
                            <c:out value="${country}"/>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${country}"/>
                    </c:otherwise>
                </c:choose>
            </td>
            <c:choose>
                <c:when test="${country != parentCountry}">
                    <td colspan="2">
                        <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Parent country')}"/>
                    </td>
                    <td>
                        <c:out value="${parentCountry}"/>
                    </td>
                </c:when>
                <c:otherwise>
                    <td colspan="2">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </c:otherwise>
            </c:choose>
        </tr>

        <c:if test="${!actionBean.typeCDDAInternational}">
            <tr>
                <td>
                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Regional administrative codes')}"/>
                </td>
                <td colspan="5">
                    <c:if test="${not empty actionBean.regionCodes}">
	                    <c:forEach items="${actionBean.regionCodes}" var="region" varStatus="regionLoop">
	                        <c:if test="${regionLoop.index > 0}"><br/></c:if>
	                        <c:out value="${empty region.regionDescription ? 'NUTS' : region.regionDescription}"/> code <c:out value="${eunis:formatString(region.regionCode,'')}"/>, <c:out value="${eunis:formatString(region.regionName,'')}"/>, cover:<c:out value="${eunis:formatString(region.regionCover,'')}"/>%
	                    </c:forEach>
                    </c:if>
                    <c:if test="${empty actionBean.regionCodes && not empty actionBean.factsheet.siteObject.nuts}">
                        NUTS code <c:out value="${eunis:formatString(actionBean.factsheet.siteObject.nuts,'')}"/>
                    </c:if>
                </td>
            </tr>
        </c:if>

        <c:if test="${not empty actionBean.bioRegionsMap}">
            <tr>
                <td colspan="6">
                    <table border="1" cellpadding="1" cellspacing="1" width="90%" style="border-collapse:collapse">
                        <tr bgcolor="#EEEEEE">
                            <td colspan="12">
                                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Site biogeographic regions')}"/>
                            </td>
                        </tr>
                        <tr>
	                        <td>
                                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic region')}"/>
	                        </td>
				            <td>
                                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Alpine')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Anatolian')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Arctic')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Atlantic')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Boreal')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Continental')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Macaronesia')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Mediterranean')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Pannonian')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Black Sea')}"/>
				            </td>
				            <td>
				                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Steppic')}"/>
				            </td>
                        </tr>
                        <tr bgcolor="#EEEEEE">
                            <td>
                                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Presence')}"/>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['alpine'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_alpine_regions')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_alpine_regions')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['alpine'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['anatol'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_anatolian_regions')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_anatolian_regions')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['anatol'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['arctic'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_arctic_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_arctic_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['arctic'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['atlantic'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_atlantic_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_atlantic_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['atlantic'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['boreal'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_boreal_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_boreal_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['boreal'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['continent'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_continental_regions')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_continental_regions')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['continent'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['macarones'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_macaronesian_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_macaronesian_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['macarones'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['mediterranean'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_mediterranean_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_mediterranean_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['mediterranean'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['pannonic'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_pannonian_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_pannonian_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['pannonic'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['pontic'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_blacksea_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_blacksea_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['pontic'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${actionBean.bioRegionsMap['steppic'] != null}">
                                    <img alt="${eunis:cms(actionBean.contentManagement, 'present_steppic_region')}" src="images/mini/check.gif" style="vertical-align:middle" />
                                    ${eunis:cmsAlt(actionBean.contentManagement, 'present_steppic_region')}
                                </c:if>
                                <c:if test="${actionBean.bioRegionsMap['steppic'] != null}">
                                    &nbsp;
                                </c:if>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </c:if>

        <c:set var="altMin" value="${actionBean.factsheet.siteObject.altMin}"/>
        <c:set var="altMax" value="${actionBean.factsheet.siteObject.altMax}"/>
        <c:set var="altMean" value="${actionBean.factsheet.siteObject.altMean}"/>
        <c:if test="${actionBean.typeCorine}">
            <c:set var="altMin" value="${altMin == '-99' ? '' : altMin}"/>
            <c:set var="altMax" value="${altMin == '-99' ? '' : altMax}"/>
            <c:set var="altMean" value="${altMin == '-99' ? '' : altMean}"/>
        </c:if>

        <tr>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Minimum Altitude(m)')}"/>
            </td>
            <td>
                <c:out value="${eunis:formatString(altMin,'')}"/>
            </td>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Mean Altitude(m)')}"/>
            </td>
            <td>
                <c:out value="${eunis:formatString(altMean,'')}"/>
            </td>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Maximum Altitude(m)')}"/>
            </td>
            <td>
                <c:out value="${eunis:formatString(altMax,'')}"/>
            </td>
        </tr>
        <tr>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Longitude')}"/>
            </td>
            <td>
                ${actionBean.longitudeFormatted}
            </td>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Latitude')}"/>
            </td>
            <td colspan="3">
                ${actionBean.latitudeFormatted}
            </td>
        </tr>
	    <tr>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Longitude (decimal deg.)')}"/>
            </td>
            <td>
                ${eunis:formatArea(actionBean.factsheet.siteObject.longitude, 0, 6, null)}
            </td>
            <td>
                <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Latitude (decimal deg.)')}"/>
            </td>
            <td>
                ${eunis:formatArea(actionBean.factsheet.siteObject.latitude, 0, 6, null)}
            </td>
            <td colspan="2">
                <a href="http://maps.google.com/maps?ll=${actionBean.factsheet.siteObject.latitude},${actionBean.factsheet.siteObject.longitude}&amp;z=13">View in Google Maps</a>
            </td>
        </tr>

        <c:if test="${actionBean.biogeoRegionsApplicable}">
            <tr>
                <td>
                    <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic regions')}"/>
                </td>
                <td colspan="5">
                    <c:forEach items="${actionBean.factsheet.biogeoregion}" var="bioRegion">
                        <c:out value="${bioRegion.value}"/><br/>
                    </c:forEach>
                </td>
            </tr>
        </c:if>
    </table>

    <c:set var="picsQueryString" value="idobject=${actionBean.idsite}&amp;natureobjecttype=Sites"/>
    <c:if test="${not empty actionBean.factsheet.picturesForSites}">
        <a href="javascript:openpictures('${initParam.DOMAIN_NAME}/pictures.jsp?${picsQueryString}',600,600)">
            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'View pictures')}"/>
        </a>
    </c:if>

    <c:if test="${actionBean.uploadPicturesPermission}">
        <a href="javascript:openpictures('${initParam.DOMAIN_NAME}/pictures-upload.jsp?operation=upload&amp;${picsQueryString}',600,600)">
            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Upload pictures')}"/>
        </a>
    </c:if>

</stripes:layout-definition>
