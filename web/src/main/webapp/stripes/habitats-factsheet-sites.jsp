<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
	<c:if test="${!empty actionBean.sites || !empty actionBean.sitesForSubtypes}">
		<c:if test="${0==1 and !empty actionBean.mapIds}">
			<form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
		    	<input type="hidden" name="sites" value="${actionBean.mapIds}" />
		    	<input type="submit" name="Show map" id="ShowMap" value="${eunis:cms(cm, 'show_map')}" title="${eunis:cms(cm, 'show_map')}" class="standardButton" />
		    	${eunis:cmsTitle(cm, 'show_map')}
		  	</form>	
	  	</c:if>
	  	<div class="dropshadow figure-right" style="float:right; width: 20em">
  			<div class="shadowed">
				<a href="habitats-factsheet-sites-kml.jsp?idHabitat=${actionBean.idHabitat}">
					${eunis:cmsPhrase(cm, 'See sites in Google Earth')}
				</a> ${eunis:cmsPhrase(cm, '(KML file, pre-requires Google Earth installed)')}
  			</div>
		</div>
		<h2>
    		${eunis:cmsPhrase(cm, 'Sites for which this habitat type is recorded')}
		</h2>
		<display:table summary="${eunis:cms(cm, 'habitat_sites')}" name="${actionBean.sites}" class="sortable" pagesize="50" sort="list" id="listItem" htmlId="listItem" requestURI="/habitats/${actionBean.idHabitat}/sites" decorator="eionet.eunis.util.decorators.HabitatsSitesTableDecorator" style="width: 100%">
			<display:column property="id" title="Site code" sortable="true"/>
			<display:column property="source" title="Source data set" sortable="true"/>
			<display:column property="area" title="Country" sortable="true" sortProperty="areaNameEn"/>
			<display:column property="siteName" title="Site name" sortable="true" sortProperty="name"/>
		</display:table>
		${eunis:cmsMsg(cm, 'habitat_sites')}
		<c:if test="${!empty actionBean.sitesForSubtypes}">
			<br />
  			<h2>
    			${eunis:cmsPhrase(cm, 'Sites for habitat subtypes')}
  			</h2>
  			<display:table summary="${eunis:cms(cm, 'habitat_related_sites')}" name="${actionBean.sitesForSubtypes}" class="sortable" pagesize="50" sort="list" id="listItem" htmlId="listItem" requestURI="/habitats/${actionBean.idHabitat}/sites" decorator="eionet.eunis.util.decorators.HabitatsSitesTableDecorator" style="width: 100%">
				<display:column property="id" title="Site code" sortable="true"/>
				<display:column property="source" title="Source data set" sortable="true"/>
				<display:column property="area" title="Country" sortable="true" sortProperty="areaNameEn"/>
				<display:column property="siteName" title="Site name" sortable="true" sortProperty="name"/>
			</display:table>
				${eunis:br(actionBean.contentManagement)}
				${eunis:cmsMsg(cm, 'habitat_related_sites')}
				${eunis:br(actionBean.contentManagement)}
		</c:if>
	</c:if>
</stripes:layout-definition>
