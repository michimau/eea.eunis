<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<script type="text/javascript">
		dojo.require("esri.map");
		function init() {
        	var initialExtent = new esri.geometry.Extent({"xmin":-3549139.09145218,"ymin":4871361.38436808,"xmax":5129676.02317436,"ymax":11227551.8207187,"spatialReference":{"wkid":102100}});

        	var map = new esri.Map("map", {extent: initialExtent});
        	var tiledMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer("http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer");
        	map.addLayer(tiledMapServiceLayer);

        	//Use the ImageParameters to set map service layer definitions and map service visible layers before adding to the client map.
        	var imageParameters = new esri.layers.ImageParameters();

        	//layer.setLayerDefinitions takes an array.  The index of the array corresponds to the layer id.
        	//In the sample below I add an element in the array at 3,4, and 5.
        	//Those array elements correspond to the layer id within the remote ArcGISDynamicMapServiceLayer
        	var layerDefs = [];
        	layerDefs[1] = "Type = 'species' and Assesment = '${actionBean.scientificName}'";
        	imageParameters.layerDefinitions = layerDefs;

        	//I want layers 5,4, and 3 to be visible
        	imageParameters.layerIds = [1];
        	imageParameters.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
        	imageParameters.transparent = true;

        	//construct ArcGISDynamicMapServiceLayer with imageParameters from above
        	var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters});

        	map.addLayer(dynamicMapServiceLayer);
      	}
      	dojo.addOnLoad(init);
	</script>
	<c:if test="${actionBean.showGeoDistribution}">
		<h2>
	    	${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical distribution')}
	  	</h2>
    	<table summary="layout" border="0" cellpadding="3" cellspacing="0" width="90%">
    		<tr>
    			<td>
    				<div id="map" style="width:450px; height:300px; border:1px solid #000;"></div>
    			</td>
    		</tr>
    	</table>
    	<br />
    	<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical distribution')}" class="listing fullwidth">
    		<thead>
      			<tr>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Country/Area')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Biogeographic region')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
          				${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
    			<c:forEach items="${actionBean.bioRegions}" var="region" varStatus="loop">
    				<c:set var="country" value="nbsp;"></c:set>
    				<c:if test="${!empty region.country}">
    					<c:set var="country" value="${region.country.areaNameEnglish}"></c:set>
    				</c:if>
    				<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
						<td>
							<c:choose> 
								<c:when test="${eunis:isCountry(region.country)}">
									<a href="sites-statistical-result.jsp?country=${eunis:treatURLSpecialCharacters(country)}&amp;DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=true&amp;DB_CORINE=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="${eunis:cms(actionBean.contentManagement, 'open_the_statistical_data_for')} ${eunis:treatURLSpecialCharacters(country)}">${eunis:treatURLSpecialCharacters(country)}</a>
          							${eunis:cmsTitle(actionBean.contentManagement, 'open_the_statistical_data_for')}
								</c:when>
						  		<c:otherwise>
									${eunis:treatURLSpecialCharacters(country)}
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							${eunis:treatURLSpecialCharacters(region.region)}&nbsp;
				        </td>
				        <td>
				          	${eunis:treatURLSpecialCharacters(region.status)}&nbsp;
				        </td>
				        <td>
							<a href="references/${region.reference}">${eunis:getAuthorAndUrlByIdDc(region.reference)}</a>
				        </td>
    			</c:forEach>
    		</tbody>
    	</table>
	</c:if>
</stripes:layout-definition>
