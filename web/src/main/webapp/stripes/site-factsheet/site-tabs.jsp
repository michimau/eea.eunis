<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<div class="site-tabs">
		<ul class="eea-tabs">
		    <li>Species</li>
		    <li>Habitat types</li>
		    <li>Designation info</li>
		    <li id="interactive-map-item" onclick="loadMapIframe('http://discomap.eea.europa.eu/map/EEABasicviewer/?appid=8c6ce24548b344ae852ab6308ac3c50a');">Interactive map</li>
		</ul>
		<div class="eea-tabs-panels">
		    <div class="eea-tabs-panel">
		        <stripes:layout-render name="/stripes/site-factsheet/site-tab-species.jsp"/>
		    </div>
		    <div class="eea-tabs-panel">
		    	<stripes:layout-render name="/stripes/site-factsheet/site-tab-habitats.jsp"/>
		    </div>
		    <div class="eea-tabs-panel">
		        <stripes:layout-render name="/stripes/site-factsheet/site-tab-designations.jsp"/>
		    </div>
		    <div class="eea-tabs-panel">
		        <iframe id="interactive-map-iframe" height="500" width="950" src="about:blank"></iframe>
		    </div>
		</div>
	</div>
</stripes:layout-definition>