<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:set var="cm" value="${actionBean.contentManagement}"/>
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
        	layerDefs[1] = "Type = 'habitat' and Code = '${actionBean.factsheet.code2000}'";
        	imageParameters.layerDefinitions = layerDefs;

        	//I want layer 1 to be visible
        	imageParameters.layerIds = [1];
        	imageParameters.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
        	imageParameters.transparent = true;

        	//construct ArcGISDynamicMapServiceLayer with imageParameters from above
        	var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters});

        	map.addLayer(dynamicMapServiceLayer);
      	}
      	dojo.addOnLoad(init);
	</script>
	<h2>
   		${eunis:cmsPhrase(cm, 'Distribution map from Article 17')}
	</h2>
	<div id="map" style="width:450px; height:300px; border:1px solid #000;"></div>	
</stripes:layout-definition>