<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
	<c:if test="${!empty actionBean.speciesSites}">
		<br />
		<display:table summary="${eunis:cms(cm, 'species_factsheet_sites_01_Sum')}" name="${actionBean.speciesSites}" class="sortable" pagesize="50" sort="list" id="listItem" htmlId="listItem" requestURI="/species/${actionBean.idSpecies}/sites" decorator="eionet.eunis.util.decorators.SpeciesSitesTableDecorator" style="width: 100%">
			<display:column property="id" title="Site code" sortable="true"/>
			<display:column property="source" title="Source data set" sortable="true"/>
			<display:column property="area" title="Country" sortable="true" sortProperty="areaNameEn"/>
			<display:column property="siteName" title="Site name" sortable="true" sortProperty="name"/>
		</display:table>
	</c:if>
	<br />
  	<br />
	<c:if test="${!empty actionBean.subSpeciesSites}">
		<h2>
    		${eunis:cmsPhrase(cm, 'Sites for subtaxa of this taxon')}
  		</h2>
  		<br />
  		<c:if test="${!empty actionBean.subMapIds}">
	  		<form name="gis2" action="sites-gis-tool.jsp" target="_blank" method="post">
	    		<input type="hidden" name="sites" value="${actionBean.subMapIds}" />
	    		<input id="showMap2" type="submit" title="${eunis:cms(cm, 'show_map')}" name="Show map" value="${eunis:cms(cm, 'show_map')}" class="standardButton" />
	    		${eunis:cmsTitle(cm, 'show_map')}
			    ${eunis:cmsInput(cm, 'show_map')}
	  		</form>
  		</c:if>
		<br />
		<display:table summary="${eunis:cms(cm, 'species_factsheet_sites_02_Sum')}" name="${actionBean.subSpeciesSites}" class="sortable" pagesize="50" sort="list" id="listItem" htmlId="listItem" requestURI="/species/${actionBean.idSpecies}/sites" decorator="eionet.eunis.util.decorators.SpeciesSitesTableDecorator" style="width: 100%">
			<display:column property="id" title="Site code" sortable="true"/>
			<display:column property="source" title="Source data set" sortable="true"/>
			<display:column property="area" title="Country" sortable="true" sortProperty="areaNameEn"/>
			<display:column property="siteName" title="Site name" sortable="true" sortProperty="name"/>
		</display:table>
	</c:if>
  	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(cm, 'species_factsheet_sites_01_Sum')}
	${eunis:br(actionBean.contentManagement)}
	${eunis:cmsMsg(cm, 'species_factsheet_sites_02_Sum')}
	${eunis:br(actionBean.contentManagement)}

</stripes:layout-definition>