<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<div class="left-area protected-sites-map">
    <img src="http://maps.eea.europa.eu/Printmap/v1/Image.ashx?webmap=5ce6e47c66ba4c1280532f4f89e6ab8c&width=480&height=400&zoomto=True&SiteCode=${actionBean.idsite}" style="width: 480px; height: 400px;">
    <a class="interactive-map-more" href="${ actionBean.pageUrl }#interactive_map" onclick="if($('#interactive_map ~ h2').attr('class').indexOf('current')==-1) $('#interactive_map ~ h2').click(); ">Interactive map</a>
    <div style="width:99.0%; height:30px;">
    </div>
    <a target="_BLANK" class="interactive-map-more" href="http://images.google.com/images?q=${actionBean.siteName}">More images</a>
</div>

</stripes:layout-definition>