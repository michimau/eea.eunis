<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<div class="right-area protected-sites-map">
    <h3>${actionBean.siteName}</h3>
    <div id="sites-map" class="map-view" style="width:99.0%; height:400px; border:2px solid #050505;">
		<iframe id="protectionMap" src="http://discomap.eea.europa.eu/map/Filtermap/?webmap=0b2680c2bc544431a9a97119aa63d707&SiteCode=${actionBean.idsite}" width="100%" height="400"></iframe>
    </div>
    <a class="interactive-map-more" href="javascript:void(0);" onclick="changeSiteTab();">Interactive map</a>
    
    <div style="width:99.0%; height:100px;">
    </div>
    <a target="_BLANK" class="interactive-map-more" href="http://images.google.com/images?q=${actionBean.siteName}">More images</a>
</div>

</stripes:layout-definition>