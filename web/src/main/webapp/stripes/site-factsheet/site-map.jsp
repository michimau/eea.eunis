<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<div class="right-area protected-sites-map">
    <h3>Protected sites</h3>
    <div id="sites-map" class="map-view" style="width:500px; height:400px; border:2px solid #050505;">
		<iframe id="protectionMap" src="http://discomap.eea.europa.eu/map/Filtermap/?webmap=0b2680c2bc544431a9a97119aa63d707&SiteCode=${actionBean.idsite}" width="500" height="400"></iframe>
    </div>
</div>

</stripes:layout-definition>