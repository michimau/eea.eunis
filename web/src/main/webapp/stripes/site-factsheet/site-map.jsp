<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<div class="left-area protected-sites-map">
    <img src="http://maps.eea.europa.eu/Printmap/v1/Image.ashx?webmap=0b2680c2bc544431a9a97119aa63d707&width=480&height=400&zoomto=True&SiteCode=${actionBean.idsite}" style="width: 480px; height: 400px;">

    <c:choose>
    <c:when test="${actionBean.typeDiploma}">
        <a class="interactive-map-more discreet" href="http://maps.google.com/maps?ll=${actionBean.factsheet.siteObject.latitude},${actionBean.factsheet.siteObject.longitude}&amp;z=13">View in Google Maps</a>
    </c:when>
    <c:otherwise>
        <a class="interactive-map-more discreet" href="${ actionBean.pageUrl }#interactive_map" onclick="if($('#interactive_map ~ h2').attr('class').indexOf('current')==-1) $('#interactive_map ~ h2').click(); ">Interactive map</a>
        <div style="width:99.0%; height:20px;">
        </div>
        <a target="_BLANK" class="interactive-map-more" href="http://images.google.com/images?q=${actionBean.siteName}">More images</a>
    </c:otherwise>

    </c:choose>
</div>

</stripes:layout-definition>