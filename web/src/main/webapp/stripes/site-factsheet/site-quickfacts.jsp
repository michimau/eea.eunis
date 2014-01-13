<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet"%>
	<div class="right-area quickfacts">
		<h3>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h3>
		<div class="bold">
            <p><span class="quickfact-number">${ actionBean.typeTitle } site</span> (code ${ actionBean.idsite })</p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Since')} <span class="quickfact-number">${ (actionBean.siteDesignationDateDisplayValue) }</span></p>
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Country')} <span class="quickfact-number">${ (actionBean.country) }</span></p>
			<c:if test="${not empty actionBean.regionCode}">
			    <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Region')}  <span class="quickfact-number">${ actionBean.regionName }</span> (${ actionBean.regionCode})</p>
            </c:if>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Surface area is')} <span class="quickfact-number">${ actionBean.surfaceAreaKm2 } km<sup>2</sup></span> (${eunis:formatAreaExt(actionBean.factsheet.siteObject.area, 0, 2, '&nbsp;', null)} ha)</p>
            <c:if test="${actionBean.marineAreaPercentage !=0 }">
                <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Marine area is')} <span class="quickfact-number">${actionBean.marineAreaPercentage}%</span></p>
            </c:if>
            <c:if test="${not empty actionBean.biogeographicRegion}">
                <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It is in the')} <span class="quickfact-number">${ (actionBean.biogeographicRegion) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'biogeographical region')}</p>
            </c:if>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN management category')} <span class="quickfact-number">
            <c:choose>
                <c:when test="${not empty actionBean.iucnCategory }">${ actionBean.iucnCategory }</c:when>
                <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
            </c:choose>
            </span></p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It protects')} <span class="quickfact-number">${ (actionBean.habitatsCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'Nature Directives’ habitat types')}</p>
            <p>${eunis:cmsPhrase(actionBean.contentManagement, 'It protects')} <span class="quickfact-number">${ (actionBean.protectedSpeciesCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'Nature Directives’ species')}</p>
<br>
			<c:if test="${ actionBean.typeNatura2000 }">
                <p>${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}: <a href="http://natura2000.eea.europa.eu/Natura2000/SDFPublic.aspx?site=${actionBean.siteName}" target="_BLANK">Natura 2000 Standard Data Form</a></p>
				<input onclick="displayMoreResourcesSite();" id="more-resources" class="searchButton" type="button" value="Other resources">
				<div id="more-resources-container" class="more-resources-container" style="display: none;">
					<p><a href="http://ec.europa.eu/environment/nature/legislation/habitatsdirective/docs/Int_Manual_EU28.pdf" target="_BLANK">Interpretation manual for habitat types</a></p>
					<p><a href="http://natura2000.eea.europa.eu" target="_BLANK">Natura 2000 map viewer</a></p>
					<p><a href="http://www.protectedplanet.net" target="_BLANK">Protected planet map viewer</a></p>
					<p><a href="http://www.eea.europa.eu/data-and-maps/data/natura-3" target="_BLANK">Data download</a></p>
				</div>
            </c:if>
		</div>
	</div>
</stripes:layout-definition>