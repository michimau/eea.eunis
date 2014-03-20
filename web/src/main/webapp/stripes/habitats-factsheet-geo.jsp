<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
	<script type="text/javascript">
	//<![CDATA[
		dojo.require("esri.map");
		dojo.require("esri.tasks.geometry");

		var layer_dist, layer_range, map, n2000layer, cddalayer, bio_regions_layer, river_basin_districts_layer;
		function init() {

			var initExtent =  new esri.geometry.Extent({"xmin":-3222779.52198856,"ymin": 2736409.05279762,"xmax":7105006.15070147,"ymax": 11615622.1895779,"spatialReference":{"wkid":3857}})

			map = new esri.Map("map",{extent:initExtent});
			map.addLayer(new esri.virtualearth.VETiledLayer({
		          bingMapsKey: 'AngrFRWkKXOKP4DuIx_T3wGWalupu63oFfJcDJHqa5_QA34tELFodeuc97CMw5us',
		          mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD}));

			n2000layer = new esri.layers.GraphicsLayer();

			filterNatura2000('${actionBean.factsheet.code2000}');

		    cddalayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://bio.discomap.eea.europa.eu/arcgis/rest/services/ProtectedSites/CDDA_Dyna_WM/MapServer");

		    bio_regions_layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/BiogeographicalRegions2008_Dyna_WGS84/MapServer");
            bio_regions_layer.opacity = 0.5;

            river_basin_districts_layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Water/RiverBasinDistrict_Dyna_WGS84/MapServer");
            river_basin_districts_layer.opacity = 0.6;

		    // Distribution layer
		    var imageParameters_dist = new esri.layers.ImageParameters();
		    var layerDefs_dist = [];
		    layerDefs_dist[5] = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";
		    imageParameters_dist.layerDefinitions = layerDefs_dist;
		    imageParameters_dist.layerIds = [5];
		    imageParameters_dist.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
		    imageParameters_dist.transparent = true;
		    layer_dist = new esri.layers.ArcGISDynamicMapServiceLayer("http://bio.discomap.eea.europa.eu/arcgis/rest/services/Article17/Article17_Distribution_WM/MapServer", {"imageParameters":imageParameters_dist});

			// Species Range layer
			var imageParameters_range = new esri.layers.ImageParameters();
			var layerDefs_range = [];
			layerDefs_range[2] = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";
			imageParameters_range.layerDefinitions = layerDefs_range;
		    imageParameters_range.layerIds = [2];
		    imageParameters_range.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
		    imageParameters_range.transparent = true;
		    layer_range = new esri.layers.ArcGISDynamicMapServiceLayer("http://bio.discomap.eea.europa.eu/arcgis/rest/services/Article17/Article17_Distribution_WM/MapServer", {"imageParameters":imageParameters_range});

			map.addLayer(layer_dist);
			initLayers();
      	}

		function initLayers() {

			var query = new esri.tasks.Query();
		    query.where = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";

		    // distribution layer
		    var queryTask = new esri.tasks.QueryTask("http://bio.discomap.eea.europa.eu/arcgis/rest/services/Article17/Article17_Distribution_WM/MapServer/5");
		    queryTask.execute(query, showResults);

		    // range layer
		    queryTask = new esri.tasks.QueryTask("http://bio.discomap.eea.europa.eu/arcgis/rest/services/Article17/Article17_Distribution_WM/MapServer/2");
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
	        layersWithData.push('bio_regions');
	        layersWithData.push('river_basin');
	        genList();
	      }
	      processedLayers++;
	    }

		function genList() {
 			var nameList = {
				"distribution": "Distribution",
				"range": "Range",
				"natura": "Natura 2000 sites",
				"cdda": "Nationally designated sites",
				"bio_regions":"Bio-geographical regions",
				"river_basin":"River basin districts"
			};

			var descList = {
				"distribution": "Distribution reported under Article 17, Habitats Directive",
				"range": "Range reported under Article 17, Habitats Directive",
				"natura": "",
				"cdda": "",
				"bio_regions":"",
				"river_basin":""
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
				} else if (id == 'bio_regions') {
					map.addLayer(bio_regions_layer);
				} else if (id == 'river_basin') {
					map.addLayer(river_basin_districts_layer);
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
				} else if (id == 'bio_regions') {
					map.removeLayer(bio_regions_layer);
				} else if (id == 'river_basin') {
					map.removeLayer(river_basin_districts_layer);
				}
			}
		}

		function filterNatura2000(habitatcode){
	        //build query task
	        var queryTask = new esri.tasks.QueryTask("http://bio.discomap.eea.europa.eu/arcgis/rest/services/ProtectedSites/Natura2000_Dyna_WM/MapServer/12");

	        //build query filter
	        var query = new esri.tasks.Query();
	        query.returnGeometry = false;
	        query.outFields = ["SITECODE"];
	        query.where = "HABITATCODE  = '" + habitatcode + "'";
	        //Can listen for onComplete event to process results or can use the callback option in the queryTask.execute method.
	        dojo.connect(queryTask, "onComplete", function(featureSet) {
	            var i,j,chunk = 70;
	            for (i=0,j=featureSet.features.length; i<j; i+=chunk) {
	                addGraphics(featureSet.features.slice(i,i+chunk));
	            }

	        });
	        queryTask.execute(query);
	    }

	    var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,
	                new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new dojo.Color([255,0,0]), 2),
	                new dojo.Color([255,0,0,0.75]));

	    function addGraphics(habitatcodes){
	        var ArrayhabitatsCode = new Array();
	        for (var i = 0; i < habitatcodes.length; i++){
	            ArrayhabitatsCode.push(habitatcodes[i].attributes.SITECODE);
	        }
	        //build query task
	        var queryTask = new esri.tasks.QueryTask("http://bio.discomap.eea.europa.eu/arcgis/rest/services/ProtectedSites/Natura2000_Dyna_WM/MapServer/0");

	        //build query filter
	        var query = new esri.tasks.Query();
	        query.returnGeometry = true;
	        query.outFields = ["SITECODE", "SITENAME"];
	        query.where = "SITECODE  IN (" + "'" + ArrayhabitatsCode.join("','") + "')";
	        //Can listen for onComplete event to process results or can use the callback option in the queryTask.execute method.
	        dojo.connect(queryTask, "onComplete", function(featureSet) {
	            dojo.forEach(featureSet.features, function(feature){
	                n2000layer.add(new esri.Graphic(feature.geometry, sfs, feature.attributes, new esri.InfoTemplate("Natura 2000 site", "<span style='font-weight:bold'>Site code</span>: ${SITECODE}<br><span style='font-weight:bold'>Site name</span>: ${SITENAME}")));
	            });
	        });
	        queryTask.execute(query);
	    }

      	dojo.addOnLoad(init);
	//]]>
	</script>
	<h2>
   		${eunis:cmsPhrase(cm, 'Distribution map from Article 17')}
	</h2>
	<div style="position:relative; width: 100%; height:400px;">
		<div id="map" class="claro" style="float:left; width:600px; height:400px; border:1px solid #000; margin: 1em 0.5em 1em 0"></div>
		<div style="float:left; width:220px;">
			<br />
			<b>Additional layers:</b><br />
			<div id="layers"></div>
		</div>
	</div>
</stripes:layout-definition>
