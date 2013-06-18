<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>


	<div class="right-area quickfacts">
		<h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Quick facts')}</h2>
		<div class="bold">

			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Country')} <span class="quickfact-number">${ (actionBean.country) }</span></p>
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Designated as protected site')} <span class="quickfact-number">${ (actionBean.siteDesignationDateDisplayValue) }</span></p>
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Surface area is ')} <span class="quickfact-number">${ actionBean.surfaceAreaKm2 } km<sup>2</sup></span> (${eunis:formatAreaExt(actionBean.factsheet.siteObject.area, 0, 2, '&nbsp;', null)} ha)</p>
			
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'It protects approximately')} <span class="quickfact-number">${ (actionBean.habitatsCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'habitats and')}</p>
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Protecting')} <span class="quickfact-number">${ (actionBean.protectedSpeciesCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'species of a total')} <span class="quickfact-number">${ (actionBean.totalSpeciesCount) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'reported in this site')}</p>
		
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'It belongs to the')} <span class="quickfact-number">${ (actionBean.biogeographicRegion) }</span> ${eunis:cmsPhrase(actionBean.contentManagement, 'biogeographical region')}</p>
			
			
			
			<c:set var="altMin" value="${actionBean.factsheet.siteObject.altMin}"/>
        	<c:set var="altMax" value="${actionBean.factsheet.siteObject.altMax}"/>
        	<c:set var="altMean" value="${actionBean.factsheet.siteObject.altMean}"/>
	        <c:if test="${actionBean.typeCorine}">
	            <c:set var="altMin" value="${altMin == '-99' ? '' : altMin}"/>
	            <c:set var="altMax" value="${altMin == '-99' ? '' : altMax}"/>
	            <c:set var="altMean" value="${altMin == '-99' ? '' : altMean}"/>
	        </c:if>

			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Minimum altitude')} <span class="quickfact-number">${eunis:formatString(altMin,'')} m</span></p>
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Mean altitude')} <span class="quickfact-number">${eunis:formatString(altMean,'')} m</span></p>
			
			<p>${eunis:cmsPhrase(actionBean.contentManagement, 'Maximum altitude')} <span class="quickfact-number">${eunis:formatString(altMax,'')} m</span></p>
		
		</div>
	</div>

</stripes:layout-definition>