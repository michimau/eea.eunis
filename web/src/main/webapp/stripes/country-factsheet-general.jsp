<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>

    <h2>
        ${eunis:cmsPhrase(actionBean.contentManagement, actionBean.indeedCountry ? 'Country information' : 'Area information')}
    </h2>

    <%-- Main country information table. --%>
    <table class="datatable">
        <col style="width:25%"/>
        <col style="width:25%"/>
        <col style="width:25%"/>
        <col style="width:25%"/>
        <tr>
            <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "Original country name:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.areaName,"&nbsp;")}
            </td>
            <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "Capital:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.capital,"&nbsp;")}
            </td>
        </tr>
        <tr>
            <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "English country name:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.areaNameEnglish,"&nbsp;")}
            </td>
            <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "Surface(km2):")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.surface,"&nbsp;")}
            </td>
	    </tr>
        <tr>
   		    <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "ISO Three Letter Code:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.iso3l,"&nbsp;")}
            </td>
             <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "Population number:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.population,"&nbsp;")}
            </td>
        </tr>
        <tr>
            <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "ISO Two Letter Code:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.iso2l,"&nbsp;")}
            </td>
             <th scope="row">
                ${eunis:cmsPhrase(actionBean.contentManagement, "Population density:")}
            </th>
            <td>
                ${eunis:formatString(actionBean.country.popDensity,"&nbsp;")}
            </td>

        </tr>
    </table>

    <%-- The regions found in this country. --%>
    <c:if test="${not empty actionBean.countryRegions}">
        <h2>
            ${eunis:cmsPhrase(actionBean.contentManagement, "Biogeographic regions:")}
        </h2>
        <table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic regions:')}" class="listing">
            <thead>
                <tr>
                    <th>
                        ${eunis:cmsPhrase(actionBean.contentManagement, "Biogeographic region name")}
                    </th>
                    <th style="text-align: right;">
                        ${eunis:cmsPhrase(actionBean.contentManagement, "Percentage(%)")}
                    </th>
                </tr>
            </thead>
            <tbody>
	        <c:forEach items="${actionBean.countryRegions}" var="region" varStatus="regionsLoop">
                <tr class="${(regionsLoop.index % 2 == 0) ? 'zebraodd' : 'zebraeven'}">
                    <td>
                        ${eunis:formatString(region.name,"&nbsp;")}
                    </td>
                    <td style="text-align:right">
                        ${eunis:formatString(region.percentage,"&nbsp;")}
                    </td>
                </tr>
	        </c:forEach>
	        </tbody>
        </table>
    </c:if>

    <%-- The sites found in this country. --%>
    <p>${eunis:cmsPhrase(actionBean.contentManagement, "Total number of sites:")} ${actionBean.nrOfSites}</p>

    <c:if test="${not empty actionBean.countrySitesFactsheets}">
        <table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Sites')}" class="datatable">
            <thead>
                <tr>
                    <th scope="row">
                        ${eunis:cmsPhrase(actionBean.contentManagement, "Source data set")}
                    </th>
                    <c:forEach items="${actionBean.countrySitesFactsheets}" var="sitesFactsheet" varStatus="sitesFactsheetsLoop">
                        <th scope="col">
                            <c:if test="${empty sitesFactsheet.sourceDB}">n/a</c:if>
                            <c:if test="${not empty sitesFactsheet.sourceDB}">
                                <c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesFactsheet.sourceDB, 'CDDA_NATIONAL', 'CDDA National')}"/>
                                <c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'CDDA_INTERNATIONAL', 'CDDA International')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'NATURA2000', 'Natura 2000')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'CORINE', 'Corine')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'DIPLOMA', 'European diploma')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'BIOGENETIC', 'Biogenetic reserves')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'NATURENET', 'NatureNet')}"/>
								<c:set var="sitesSourceDbTranslated" value="${fn:replace(sitesSourceDbTranslated, 'EMERALD', 'Emerald')}"/>
                                <c:out value="${sitesSourceDbTranslated}"/>
                            </c:if>
                        </th>
                    </c:forEach>
                </tr>
            </thead>
            <tbody>
                ${actionBean.sitesCountryFactsheetRowsHtml}
            </tbody>
        </table>
    </c:if>

</stripes:layout-definition>
