<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>


<script type="text/javascript">
		//<![CDATA[
			dojo.require("esri.map");
			dojo.require("esri.tasks.geometry");

			dojo.declare("my.GBIFLayer", esri.layers.DynamicMapServiceLayer, {

				constructor: function() {
					this.initialExtent = this.fullExtent = new esri.geometry.Extent({"xmin":-3222779.52198856,"ymin": 2736409.05279762,"xmax":7105006.15070147,"ymax": 11615622.1895779,"spatialReference":{"wkid":3857}})
                    this.spatialReference = new esri.SpatialReference({wkid:3857});

					this.loaded = true;
					this.onLoad(this);
				},

				getImageUrl: function(extent, width, height, callback) {
					var params = {
						request:"GetMap",
						transparent:true,
						format:"image/png",
						version:"1.1.1",
						layers:"gbif:tabDensityLayer",
						styles: "",
						exceptions: "application%2Fvnd.ogc.se_inimage",
						filter: "<Filter><PropertyIsEqualTo><PropertyName>url</PropertyName><Literal><![CDATA[http://data.gbif.org/maplayer/taxon/${actionBean.gbifCode}]]></Literal></PropertyIsEqualTo></Filter>",

						//changing values
						bbox:extent.xmin + "," + extent.ymin + "," + extent.xmax + "," + extent.ymax,
						srs: "EPSG:" + extent.spatialReference.wkid,
						width: width,
						height: height
					};
					callback("http://ogc.gbif.org/wms?" + dojo.objectToQuery(params));
				}
			})

			dojo.declare("my.FAODistLayer", esri.layers.DynamicMapServiceLayer, {

				constructor: function() {
					this.initialExtent = this.fullExtent = new esri.geometry.Extent({"xmin":-3222779.52198856,"ymin": 2736409.05279762,"xmax":7105006.15070147,"ymax": 11615622.1895779,"spatialReference":{"wkid":3857}})
                    this.spatialReference = new esri.SpatialReference({wkid:3857});

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

			var layer_dist, layer_range, report_map, n2000layer, cddalayer, bio_regions_layer, river_basin_districts_layer,visible = [];
			var faoDistLayer, gbifLayer;

			var symbol = new esri.symbol.SimpleFillSymbol();
		    symbol.setColor(new dojo.Color([150,150,150,1]));

			function init() {
				var initExtent =  new esri.geometry.Extent({"xmin":-3222779.52198856,"ymin": 2736409.05279762,"xmax":7105006.15070147,"ymax": 11615622.1895779,"spatialReference":{"wkid":3857}})
				report_map = new esri.Map("report-map",{extent:initExtent});

			    veTileLayer = new esri.virtualearth.VETiledLayer({
			    bingMapsKey: 'AgnYuBP56hftjLZf07GVhxQrm61_oH1Gkw2F1H5_NSWjyN5s1LKylQ1S3kMDTHb_',
			    mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD});
			    report_map.addLayer(veTileLayer);

			    n2000layer = new esri.layers.GraphicsLayer();

                cddalayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/CDDA_Dyna_WGS84/MapServer");

                bio_regions_layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/BiogeographicalRegions2008_Dyna_WGS84/MapServer");
                bio_regions_layer.opacity = 0.5;

                river_basin_districts_layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Water/RiverBasinDistrict_Dyna_WGS84/MapServer");
                river_basin_districts_layer.opacity = 0.6;

                //Add species parameter to filter Natura 2000
                filterNatura2000('${actionBean.scientificName}')

                faoDistLayer = new my.FAODistLayer();
                gbifLayer = new my.GBIFLayer();
                gbifLayer.opacity = 0.5;

                // Species Distribution layer
                var imageParameters_dist = new esri.layers.ImageParameters();
                var layerDefs_dist = [];
                var isDistributionLayerExist = ${actionBean.distributionLayer};
                if(isDistributionLayerExist){
	                layerDefs_dist[4] = "Type = 'species' and Assesment = '${actionBean.scientificName}'";
	                imageParameters_dist.layerDefinitions = layerDefs_dist;
	                imageParameters_dist.layerIds = [4];
	                imageParameters_dist.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
	                imageParameters_dist.transparent = true;
	                layer_dist = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_dist});
                }

                // Species Range layer
                var imageParameters_range = new esri.layers.ImageParameters();
                var layerDefs_range = [];
                var isRangeLayerExist = ${actionBean.rangeLayer};
                if (isRangeLayerExist){
	                layerDefs_range[1] = "Type = 'species' and Assesment = '${actionBean.scientificName}'";
	                imageParameters_range.layerDefinitions = layerDefs_range;
	                imageParameters_range.layerIds = [1];
	                imageParameters_range.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
	                imageParameters_range.transparent = true;
	                layer_range = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Article17_Dyna_WGS84/MapServer", {"imageParameters":imageParameters_range});
                }
                report_map.addLayer(gbifLayer);
			}

			///////////////////

            var objIDs;
		    function filterNatura2000(specie){
		        //build query task
                var queryTask = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000_Dyna_WM/MapServer/9");

                //build query filter
                var query = new esri.tasks.Query();
                query.returnGeometry = false;
                query.outFields = ["OBJECTID"];
                query.where = "LATINNAME = '" + specie + "'";

                //Can listen for onComplete event to process results or can use the callback option in the queryTask.execute method.
                dojo.connect(queryTask, "onComplete", function(featureSet) {
                    dojo.forEach(featureSet.features,function(feature){

                        var speciesTable = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000_Dyna_WM/MapServer/9");

                        var relatedQuery = new esri.tasks.RelationshipQuery();
                        relatedQuery.outFields = ["OBJECTID"];
                        relatedQuery.relationshipId = 5;
                        relatedQuery.objectIds = [featureSet.features[0].attributes.OBJECTID];
                        dojo.connect(speciesTable, "onExecuteRelationshipQueryComplete", function(relatedFeatureSets) {
                            objIDs = new Array();

                            dojo.forEach(relatedFeatureSets[featureSet.features[0].attributes.OBJECTID].features, function(feature){
                                objIDs.push(feature.attributes.OBJECTID);
                            });
                            processResults(objIDs);

                        });
                        speciesTable.executeRelationshipQuery(relatedQuery);
                    });
                });
                queryTask.execute(query);
            }

		    var i = 0;
		    function processResults(){
		        var arrayObjectIds = new Array();
		        var j=0;
		        for (i; j<4; i++){
		            if (i >= objIDs.length){
		                break;
		            }
		            arrayObjectIds.push(objIDs[i]);

		            j++;
		        }
		        if (arrayObjectIds.length > 0){
		            addGraphics(arrayObjectIds);
		        }else{
		            return;
		        }
		    }

		    var sfs = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID,
		    	    new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_NULL, new dojo.Color([255,0,0]), 2),
		    	    new dojo.Color([255,0,0,0.75]));

		    function addGraphics(objIDs){
		        var queryTask = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000_Dyna_WM/MapServer/11");

		        var relatedQuery = new esri.tasks.RelationshipQuery();
		        relatedQuery.outFields = ["SITECODE", "SITENAME"];
		        relatedQuery.returnGeometry = true;
		        relatedQuery.relationshipId = 6;

		        relatedQuery.objectIds = objIDs;
		        dojo.connect(queryTask, "onExecuteRelationshipQueryComplete", function(relatedFeatureSets) {
                    dojo.forEach(objIDs, function(id){
                        dojo.forEach(relatedFeatureSets[id].features, function(feature){
                            n2000layer.add(new esri.Graphic(feature.geometry, sfs, feature.attributes, new esri.InfoTemplate("Natura 2000 site", "<span style='font-weight:bold'>Site code</span>: ${SITECODE}<br><span style='font-weight:bold'>Site name</span>: ${SITENAME}")));
                        });
                    });
                    processResults();
                });
		        queryTask.executeRelationshipQuery(relatedQuery);
            }

			////////////////////

			function updateLayerVisibility(id) {
				var input = document.getElementById(id);
				if (input.checked) {
					if (id == 'distribution') {
						report_map.addLayer(layer_dist);
					} else if (id == 'range') {
						report_map.addLayer(layer_range);
					} else if (id == 'fao') {
						report_map.addLayer(faoDistLayer);
					} else if (id == 'natura') {
						report_map.addLayer(n2000layer);
					} else if (id == 'cdda') {
						report_map.addLayer(cddalayer);
					} else if (id == 'bio_regions') {
						report_map.addLayer(bio_regions_layer);
					} else if (id == 'river_basin') {
						report_map.addLayer(river_basin_districts_layer);
					} else if (id == 'gbif') {
						report_map.addLayer(gbifLayer);
					}
				} else {
					if (id == 'distribution') {
						report_map.removeLayer(layer_dist);
					} else if (id == 'range') {
						report_map.removeLayer(layer_range);
					} else if (id == 'fao') {
						report_map.removeLayer(faoDistLayer);
					} else if (id == 'natura') {
						report_map.removeLayer(n2000layer);
					} else if (id == 'cdda') {
						report_map.removeLayer(cddalayer);
					} else if (id == 'bio_regions') {
						report_map.removeLayer(bio_regions_layer);
					} else if (id == 'river_basin') {
						report_map.removeLayer(river_basin_districts_layer);
					} else if (id == 'gbif') {
						report_map.removeLayer(gbifLayer);
					}
				}
			}
			dojo.addOnLoad(init);
		//]]>
		</script>





                <!-- species reported -->
                <div class="reported-areas">
                    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Areas where this species has been reported')}</h2>
                    <div class="left-area reported-areas-fieldset">
                        <fieldset>
                            <legend><strong>Select layer</strong></legend>

							<c:if test="${not empty actionBean.gbifCode}">
								<label for="gbif">
									<input type="checkbox" class="list_item" id="gbif" onclick="updateLayerVisibility('gbif');" checked="checked"/>
									GBIF observations
								</label>
								<p class="discreet">Map depicts density of specimen and observational data. Source: <a href="http://data.gbif.org/species/${actionBean.gbifCode}">GBIF</a></p>
							</c:if>


							<c:if test="${actionBean.distributionLayer}">
									<label for="distribution">
										<input type="checkbox" class="list_item" id="distribution" onclick="updateLayerVisibility('distribution');"/>
										Distribution
									</label>
								<p class="discreet">Distribution reported under Article 17, Habitats Directive</p>
							</c:if>
							<c:if test="${actionBean.rangeLayer}">
									<label for="range">
										<input type="checkbox" class="list_item" id="range" onclick="updateLayerVisibility('range');"/>
										Range
									</label>
								<p class="discreet">Range reported under Article 17, Habitats Directive</p>
							</c:if>
							
							<label for="natura">
								<input type="checkbox" class="list_item" id="natura" onclick="updateLayerVisibility('natura');"/>
								Natura 2000 sites
							</label>
							<p class="discreet">&nbsp;</p>
							</fieldset>
							
							
							<fieldset>
	                            <legend><strong>Base map - not species related</strong></legend>
									<label for="cdda">
										<input type="checkbox" class="list_item" id="cdda" onclick="updateLayerVisibility('cdda');"/>
										Nationally designated sites
									</label>
									<p class="discreet">&nbsp;</p>
	
									<label for="bio_regions">
										<input type="checkbox" class="list_item" id="bio_regions" onclick="updateLayerVisibility('bio_regions');"/>
										Bio-geographical regions
									</label>
									<p class="discreet">&nbsp;</p>
	
									<label for="river_basin">
										<input type="checkbox" class="list_item" id="river_basin" onclick="updateLayerVisibility('river_basin');"/>
										River basin districts
									</label>
									<p class="discreet">&nbsp;</p>
	
								<c:if test="${not empty actionBean.faoCode}">
										<label for="fao">
											<input type="checkbox" class="list_item" id="fao" onclick="updateLayerVisibility('fao');"/>
											FAO distribution
										</label>
										<p class="discreet">Source: the <a href="http://www.fao.org/figis/geoserver/factsheets/species.html">FAO Aquatic Species Distribution Map Viewer</a> © FAO</p>
								</c:if>                                
							</fieldset>
                    </div>


                    <div class="right-area reported-areas-map">
                        <div class="map-view" id="report-map" style="width:600px; height:400px;">
                        </div>
                        <p>Map depicts reported distribution of species by Member States</br>
						<a href="#">Source: Art 17 Habitat Directive</a>
						</p>
                    </div>
                </div>
                <!-- END species reported -->
</stripes:layout-definition>
