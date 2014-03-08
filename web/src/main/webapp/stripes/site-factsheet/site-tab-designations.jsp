<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

<c:choose>
    <c:when test="${ actionBean.typeNatura2000 }">
        <stripes:layout-render name="/stripes/site-factsheet/site-tab-designations-natura.jsp"/>
    </c:when>
    <c:when test="${actionBean.typeCDDA}">
        <stripes:layout-render name="/stripes/site-factsheet/site-tab-designations-cdda.jsp"/>
    </c:when>
    <c:otherwise>
        No information reported
    </c:otherwise>
</c:choose>
</stripes:layout-definition>