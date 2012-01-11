<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
		<script type="text/javascript">
			dojo.require("esri.map");

			dojo.declare("my.FAODistLayer", esri.layers.DynamicMapServiceLayer, {

				constructor: function() {
					this.initialExtent = this.fullExtent = new esri.geometry.Extent({"xmin":-232.03125,"ymin":-116.015625,"xmax":232.03125,"ymax":116.015625,"spatialReference":{"wkid":4326}});
					this.spatialReference = new esri.SpatialReference({wkid:4326});

					this.loaded = true;
					this.opacity = 0.4;
					this.onLoad(this);
				},

				getImageUrl: function(extent, width, height, callback) {
					var params = {
						request:"GetMap",
						transparent:true,
						format:"image/png",
						version:"1.1.1",
						layers:"fifao:SPECIES_DIST",
						styles: "",
						exceptions: "application/vnd.ogc.se_inimage",
						cql_filter: "ALPHACODE='${actionBean.faoCode}'",

						//changing values
						bbox:extent.xmin + "," + extent.ymin + "," + extent.xmax + "," + extent.ymax,
						srs: "EPSG:" + extent.spatialReference.wkid,
						width: width,
						height: height
					};

					callback("http://www.fao.org/figis/geoserver/wms?" + dojo.objectToQuery(params));
				}
			})

			var layer_dist, layer_range, map, n2000layer, cddalayer, visible = [];
			var faoDistLayer;
			function init() {
				var initExtent =  new esri.geometry.Extent({"xmin":-15.03125,"ymin":40.015625,"xmax":40.03125,"ymax":60.015625,"spatialReference":{"wkid":4326}});
				map = new esri.Map("map",{extent:initExtent});
				map.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"));

				n2000layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000Solid_Cach_WM/MapServer");
				cddalayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/CDDA_Dyna_WGS84/MapServer");

				faoDistLayer = new my.FAODistLayer();

				// Species Distribution layer
				var imageParameters_dist = new esri.layers.ImageParameters();
				var layerDefs_dist = [];
				layerDefs_dist[0] = "Type = 'species' and Assesment = '${actionBean.scientificName}'";
				imageParameters_dist.layerDefinitions = layerDefs_dist;
				imageParameters_dist.layerIds = [0];
				imageParameters_dist.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
				imageParameters_dist.transparent = true;
				layer_dist = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_dist});
				map.addLayer(layer_dist);

				// Species Range layer
				var imageParameters_range = new esri.layers.ImageParameters();
				var layerDefs_range = [];
				layerDefs_range[1] = "Type = 'species' and Assesment = '${actionBean.scientificName}'";
				imageParameters_range.layerDefinitions = layerDefs_range;
				imageParameters_range.layerIds = [1];
				imageParameters_range.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
				imageParameters_range.transparent = true;
				layer_range = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_range});
			}

			function updateLayerVisibility(id) {
				var input = document.getElementById(id);
				if (input.checked) {
					if (id == 'distribution') {
						map.addLayer(layer_dist);
					} else if (id == 'range') {
						map.addLayer(layer_range);
					} else if (id == 'fao') {
						map.addLayer(faoDistLayer);
					} else if (id == 'natura') {
						map.addLayer(n2000layer);
					} else if (id == 'cdda') {
						map.addLayer(cddalayer);
					}
				} else {
					if (id == 'distribution') {
						map.removeLayer(layer_dist);
					} else if (id == 'range') {
						map.removeLayer(layer_range);
					} else if (id == 'fao') {
						map.removeLayer(faoDistLayer);
					} else if (id == 'natura') {
						map.removeLayer(n2000layer);
					} else if (id == 'cdda') {
						map.removeLayer(cddalayer);
					}
				}
			}
			dojo.addOnLoad(init);
		</script>
		<h2>
	    	${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical information')}
	  	</h2>
		<div style="position:relative; width: 840px; height:400px;">
			<div id="map" style="position:absolute;width:600px; height:400px; border:1px solid #000; margin: 1em"></div>
			<div style="position:absolute; top:0; right: 0;">
				<br />
				<b>Additional layers:</b><br /><br />
				<label for="distribution">
					<input type="checkbox" class="list_item" id="distribution" onclick="updateLayerVisibility('distribution');" checked="checked"/>
					Distribution
				</label>
				<br />
				<label for="range">
					<input type="checkbox" class="list_item" id="range" onclick="updateLayerVisibility('range');"/>
					Range
				</label>
				<br />
				<label for="natura">
					<input type="checkbox" class="list_item" id="natura" onclick="updateLayerVisibility('natura');"/>
					Natura 2000 sites
				</label>
				<br />
				<label for="cdda">
					<input type="checkbox" class="list_item" id="cdda" onclick="updateLayerVisibility('cdda');"/>
					Nationally designated sites
				</label>
				<br />
				<c:if test="${not empty actionBean.faoCode}">
					<label for="fao">
						<input type="checkbox" class="list_item" id="fao" onclick="updateLayerVisibility('fao');"/>
						FAO distribution
					</label>
				</c:if>
			</div>
		</div>
		<c:if test="1 == 0">
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
								<c:when test="${eunis:isCountry(region.country.areaNameEnglish)}">
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
