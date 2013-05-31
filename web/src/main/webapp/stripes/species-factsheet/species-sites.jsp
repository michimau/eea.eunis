<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



                <!-- species protection -->
                <a name="protected"></a>
                <h2 class="visualClear" id="protected">This species is being protected in Europe</h2>

                <div id="protected_sites_table" class="left-area protected-sites" style="height: 460px">
                    <h3>Protected Sites (Natura 2000) - Table</h3>
                    <div class="scroll-auto" style="height: 400px">
                    <table id="listItem" summary="List of sites" class="sortable listing">
                        <thead>
                        <tr>
                            <th class="dt_sortable">Site code</th>
                            <th class="dt_sortable">Source data set</th>
                            <th class="dt_sortable">Country</th>
                            <th class="dt_sortable">Site name</th>
                        </tr>
                        </thead>
                        <tbody>

						<c:forEach items="${actionBean.speciesSitesTable}" var="site" varStatus="loop">
							<tr class="${loop.index % 2 == 0 ? 'zebraodd' : 'zebraeven'}">
								<c:choose>
									<c:when test="${ site.natura2000 }">
										<td><a href="javascript:void(0);" onclick="setMapSiteId('${ site.IDSite }');">${ site.IDSite }</a></td>
									</c:when>
									<c:otherwise>
										<td>${ site.IDSite }</td>
									</c:otherwise>
								</c:choose>
								
								
                            	<td>${ site.sourceDB }</td>
                            	<td><a href="${ site.areaUrl }" title="Open factsheet for ${ site.areaNameEn }">${ site.areaNameEn }</a></td>
                            	<td><a href="${ site.siteNameUrl }">${ site.name }</a></td>
							</tr>
						</c:forEach>
						
                        </tbody>
                    </table>
                    </div>
                </div>
                

                <div class="right-area protected-sites-map">
                    <h3>Protected sites - Map</h3>
                    <div id="sites-map" class="map-view" style="width:500px; height:400px; border:2px solid #050505;"></div>
                </div>


				<script type="text/javascript">djConfig = { parseOnLoad:true };</script>
		        <script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.2"></script>
		
		        <script type="text/javascript">
		            dojo.require("dijit.dijit"); // optimize: load dijit layer
		            dojo.require("esri.map");
		            dojo.require("esri.virtualearth.VETiledLayer");
		            dojo.require("esri.tasks.query");
		            dojo.require("esri.tasks.geometry");
		            dojo.require("esri.layers.FeatureLayer");
		            dojo.require("dijit.TooltipDialog");
		
		            //Assig a value to the SITECODE
		            var sitecode = ''
		
		            var sitesMap;
		            var natura2000Layer;
		            var clc2006Layer;
		            
		            
		            function setMapSiteId(id){
		            	
		            	sitecode = id;
		            	
		            	if (sitesMap == null){
		            		initSitesMap();
		            	} else {
			            	natura2000Layer.setDefinitionExpression("SITECODE='" + sitecode + "'");
			            	loadSitesGeometry(sitecode);
		            	}
		            }
		
		            //URL for Natura 2000 REST service in use
		            function getSitesMapServiceNatura2000() { return 'http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000_Dyna_WM/MapServer'; }
		
		            function initSitesMap() {
		            	sitesMap = new esri.Map("sites-map", {logo:false, slider: true, nav: true});
		
		              //Creates a BING Maps object layer to add to the map
		              veTileLayer = new esri.virtualearth.VETiledLayer({
		                bingMapsKey: 'AgnYuBP56hftjLZf07GVhxQrm61_oH1Gkw2F1H5_NSWjyN5s1LKylQ1S3kMDTHb_',
		                mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD
		              });
		
		              //Loads BING map
		              sitesMap.addLayer(veTileLayer);
		
		              //Creates a Natura 2000 layer object based on the site of interest
		              natura2000Layer = new esri.layers.FeatureLayer(getSitesMapServiceNatura2000() + "/0",{
		                mode: esri.layers.FeatureLayer.MODE_SNAPSHOT,
		                outFields: ["*"],
		                opacity:.35
		              });
		              dojo.connect(natura2000Layer,"onMouseOver",showTooltip);
		              dojo.connect(natura2000Layer,"onMouseOut",closeDialog);
		              natura2000Layer.setDefinitionExpression("SITECODE='" + sitecode + "'");
		
		              // Prepare CLC2006 layer
		              clc2006Layer = new esri.layers.ArcGISDynamicMapServiceLayer("http://discomap.eea.europa.eu/ArcGIS/rest/services/Land/CLC2006_Dyna_WM/MapServer", {opacity:0.4});
		
		              // Loads Natura 2000 layer.
		              sitesMap.addLayer(natura2000Layer);
		
		              loadSitesGeometry(sitecode);
		            }
		
		            //Function for zooming into the site of interest
		            function loadSitesGeometry(sitecode) {
		              var query = new esri.tasks.Query();
		
		              query.where = "SITECODE='" + sitecode + "'"
		              query.returnGeometry = true;
		              var queryTask = new esri.tasks.QueryTask(getSitesMapServiceNatura2000() + "/0");
		              queryTask.execute(query);
		
		              // +++++Listen for QueryTask onComplete event+++++
		              dojo.connect(queryTask, "onComplete", function(featureSet) {
		              polygon = featureSet.features[0].geometry;
		              extent = polygon.getExtent();
		              sitesMap.setExtent(extent.expand(2), true);
		              });
		            };
		
		            //Tooltip functionality to sitename and show spatial area
		            function showTooltip(evt){
		            closeDialog();
		            var tipContent = "<b>Name of the site</b>: " + evt.graphic.attributes.SITENAME +
		            "<br/><b>Area</b>: " + Math.round((evt.graphic.attributes.Shape_Area/1000000)*100/100) + " Square Kilometers";
		            var dialog = new dijit.TooltipDialog({
		              id: "tooltipDialog",
		              content: tipContent,
		              style: "position: absolute; padding:2px; background: white; width: 250px; font: normal normal bold 7pt Tahoma;z-index:100"
		              });
		              dialog.startup();
		
		              dojo.style(dialog.domNode, "opacity", 0.8);
		              dijit.placeOnScreen(dialog.domNode, {x: evt.pageX, y: evt.pageY}, ["TL", "BL"], {x: 10, y: 10});
		            }
		
		            function closeDialog() {
		              var widget = dijit.byId("tooltipDialog");
		              if (widget) {
		                  widget.destroy();
		              }
		            }
		
		            function updateLayerVisibilityExt(layerCheckbox){
		
		            	layerCheckbox.checked = !layerCheckbox.checked;
		            	updateSitesLayerVisibility(layerCheckbox);
		            }
		
		            function updateSitesLayerVisibility(layerCheckbox){
		
		                if (layerCheckbox.checked) {
		                    if (layerCheckbox.id == 'natura2000') {
		                    	sitesMap.addLayer(natura2000Layer);
		                    } else if (layerCheckbox.id == 'clc2006') {
		                    	sitesMap.addLayer(clc2006Layer);
		                    }
		                } else {
		                	if (layerCheckbox.id == 'natura2000') {
		                		sitesMap.removeLayer(natura2000Layer);
		                    } else if (layerCheckbox.id == 'clc2006') {
		                    	sitesMap.removeLayer(clc2006Layer);
		                    }
		                }
		            }
		
		            //dojo.addOnLoad(init);
		        </script>


                <!-- END species protection -->
                
                
                
                
                
                
                
</stripes:layout-definition>
