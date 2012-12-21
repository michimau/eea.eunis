<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Fauna and flora' - part of site's factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib prefix="eunis" uri="http://eunis.eea.europa.eu/jstl/functions"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net" %>

<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteSpeciesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SitesSpeciesReportAttributesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.utilities.EunisUtil,
                 ro.finsiel.eunis.utilities.SQLUtilities, ro.finsiel.eunis.search.Utilities"%>

<jsp:useBean id="actionBean" class="eionet.eunis.stripes.actions.SitesFactsheetActionBean" scope="request" />
<%
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  int type = factsheet.getType();
  String designationDescr = factsheet.getDesignation();
%>

<c:if test="${actionBean.typeNatura2000}">
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
            var sitecode = '${param.idsite}'

            var map;
            var natura2000Layer;
            var clc2006Layer;

            //URL for Natura 2000 REST service in use
            function getSitesMapServiceNatura2000() { return 'http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000_Dyna_WM/MapServer'; }

            function init() {
              map = new esri.Map("map", {logo:false, slider: true, nav: true});

              //Creates a BING Maps object layer to add to the map
              veTileLayer = new esri.virtualearth.VETiledLayer({
                bingMapsKey: 'AgnYuBP56hftjLZf07GVhxQrm61_oH1Gkw2F1H5_NSWjyN5s1LKylQ1S3kMDTHb_',
                mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD
              });

              //Loads BING map
              map.addLayer(veTileLayer);

              //Creates a Natura 2000 layer object based on the site of interest
              var natura2000Layer = new esri.layers.FeatureLayer(getSitesMapServiceNatura2000() + "/0",{
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
              map.addLayer(natura2000Layer);

              loadGeometry(sitecode);
            }

            //Function for zooming into the site of interest
            function loadGeometry(sitecode) {
              var query = new esri.tasks.Query();

              query.where = "SITECODE='" + sitecode + "'"
              query.returnGeometry = true;
              var queryTask = new esri.tasks.QueryTask(getSitesMapServiceNatura2000() + "/0");
              queryTask.execute(query);

              // +++++Listen for QueryTask onComplete event+++++
              dojo.connect(queryTask, "onComplete", function(featureSet) {
              polygon = featureSet.features[0].geometry;
              extent = polygon.getExtent();
              map.setExtent(extent.expand(2), true);
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
            	updateLayerVisibility(layerCheckbox);
            }

            function updateLayerVisibility(layerCheckbox){

                if (layerCheckbox.checked) {
                    if (layerCheckbox.id == 'natura2000') {
                        map.addLayer(natura2000Layer);
                    } else if (layerCheckbox.id == 'clc2006') {
                        map.addLayer(clc2006Layer);
                    }
                } else {
                	if (layerCheckbox.id == 'natura2000') {
                        map.removeLayer(natura2000Layer);
                    } else if (layerCheckbox.id == 'clc2006') {
                        map.removeLayer(clc2006Layer);
                    }
                }
            }

            dojo.addOnLoad(init);
        </script>

        <h2>
            <c:out value="${eunis:cmsPhrase(actionBean.contentManagement, 'Map of site')}"/>
        </h2>
        <label for="clc2006" style="font-weight:bold">Add/remove Corine Landcover 2006 layer:</label>
        <input type="checkbox" class="list_item" id="clc2006" onclick="updateLayerVisibility(this);"/>
        <div id="map" style="width:700px; height:500px; border:2px solid #050505;"></div>
    </c:if>