<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
	<script type="text/javascript">
		dojo.require("esri.map");

		var layer_dist, layer_range, map, n2000layer, cddalayer;
		function init() {

			var initExtent =  new esri.geometry.Extent({"xmin":-15.03125,"ymin":40.015625,"xmax":40.03125,"ymax":60.015625,"spatialReference":{"wkid":4326}});
			map = new esri.Map("map",{extent:initExtent});
			map.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"));

			n2000layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000Solid_Cach_WM/MapServer");
			cddalayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/CDDA_Dyna_WGS84/MapServer");

			// Distribution layer
			var imageParameters_dist = new esri.layers.ImageParameters();
			var layerDefs_dist = [];
			layerDefs_dist[0] = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";
			imageParameters_dist.layerDefinitions = layerDefs_dist;
			imageParameters_dist.layerIds = [0];
			imageParameters_dist.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
			imageParameters_dist.transparent = true;
			layer_dist = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_dist});

			// Species Range layer
			var imageParameters_range = new esri.layers.ImageParameters();
			var layerDefs_range = [];
			layerDefs_range[1] = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";
			imageParameters_range.layerDefinitions = layerDefs_range;
			imageParameters_range.layerIds = [1];
			imageParameters_range.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
			imageParameters_range.transparent = true;
			layer_range = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_range});

			map.addLayer(layer_dist);
			initLayers();
      	}

		function initLayers() {
			var query = new esri.tasks.Query();
			query.where = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";

			// distribution layer
			var queryTask = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer/0");
			queryTask.execute(query, showResults);

			// range layer
			queryTask = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer/1");
			queryTask.execute(query, showResults);
		}

		var layersWithData = [];
		var processedLayers = 0;
		function showResults(results) {
			if (results.features.length > 0) {
				if (processedLayers == 0) {
					layersWithData.push('distribution');
				} else if (processedLayers == 1) {
					layersWithData.push('range');
				}
			}
			if (processedLayers == 1) {
				layersWithData.push('natura');
				layersWithData.push('cdda');
				genList();
			}
			processedLayers++;
		}

		function genList() {
 			var nameList = {
				"distribution": "Distribution",
				"range": "Range",
				"natura": "Natura 2000 sites",
				"cdda": "Nationally designated sites"
			};

			var descList = {
				"distribution": "Distribution reported under Article 17, Habitats Directive",
				"range": "Range reported under Article 17, Habitats Directive",
				"natura": "",
				"cdda": ""
			};

			var dl = document.createElement ("dl");
			for (var i = 0; i < layersWithData.length; i++) {
				var term = layersWithData[i];
				var dt = document.createElement ("dt");
				var dd = document.createElement ("dd");

				var checked = "";
				if (term == 'distribution') {
					checked = "checked=\"checked\"";
				}

				dt.innerHTML = 	"<label for=\"" + term + "\">" +
								"<input type=\"checkbox\" class=\"list_item\" id=\"" + term + "\" onclick=\"updateLayerVisibility('" + term + "');\" " + checked + "/>" +
								nameList[term] +
							"</label>";
				dd.innerHTML = descList[term];

				dl.appendChild (dt);
				dl.appendChild (dd);
			}

			var container = document.getElementById ("layers");
			container.appendChild (dl);
		}

		function updateLayerVisibility(id) {
			var input = document.getElementById(id);
			if (input.checked) {
				if (id == 'distribution') {
					map.addLayer(layer_dist);
				} else if (id == 'range') {
					map.addLayer(layer_range);
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
   		${eunis:cmsPhrase(cm, 'Distribution map from Article 17')}
	</h2>
	<div style="position:relative; width: 100%; height:400px;">
		<div id="map" style="float:left; width:600px; height:400px; border:1px solid #000; margin: 1em 0.5em 1em 0"></div>
		<div style="float:left; width:220px;">
			<br />
			<b>Additional layers:</b><br />
			<div id="layers"></div>
		</div>
	</div>
</stripes:layout-definition>