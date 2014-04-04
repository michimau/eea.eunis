<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>
NATURA 2000 is the ecological network for the conservation of wild animals and plant
species and natural habitats of Community importance within the Union. It consists of
sites classified under the Birds Directive and the Habitats Directive (the Nature Directives).

<h3>NATURA 2000 site under</h3>
<table style="width: 600px">
    <tr><td style="width: 400px">Birds Directive <span class="discreet">2009/147/EC</span>     (SPA)</td>
        <td>
            <c:choose>
                <c:when test="${actionBean.siteType eq 'A' or actionBean.siteType eq 'C'}">
                    <img width="15" height="16" title="Yes" style="vertical-align:middle" src="images/mini/check_green.gif" alt="Under Birds directive">
                    </td></tr><tr><td><ul><li>Date classified as Special Protection Area (SPA)</li></ul></td>
                     <td><fmt:formatDate value="${actionBean.spaDate}" pattern="${actionBean.dateFormat}"/>
                </c:when>
                <c:otherwise>
                    <img width="15" height="16" title="No" style="vertical-align:middle" src="images/mini/invalid.gif" alt="Not under Birds directive">
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr><td>Habitats Directive <span class="discreet">92/43/EEC</span> (SCI or SAC)</td>
        <td>
            <c:choose>
                <c:when test="${actionBean.siteType eq 'B' or actionBean.siteType eq 'C'}">
                    <img width="15" height="16" title="Yes" style="vertical-align:middle" src="images/mini/check_green.gif" alt="Under Habitats directive">
                    </td></tr><tr><td><ul><li>
                      Date proposed as Site of Community Importance (SCI)</li></ul></td>
                        <td><fmt:formatDate value="${actionBean.proposedDate}" pattern="${actionBean.dateFormat}"/></td>
                    </tr>
                    <tr>
                        <td><ul><li>Date designated as Special Area of Conservation (SAC)</li></ul></td>
                        <td><fmt:formatDate value="${actionBean.sacDate}" pattern="${actionBean.dateFormat}"/>

                </c:when>
                <c:otherwise>
                    <img width="15" height="16" title="No" style="vertical-align:middle" src="images/mini/invalid.gif" alt="Not under Habitats directive">
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</table>
<br>
<table style="width: 600px">
    <tr>
        <td style="width: 400px">Date of Standard data form update</td>
        <td><fmt:formatDate value="${actionBean.updateDate}" pattern="${actionBean.dateFormat}"/></td>
    </tr>
</table>


</stripes:layout-definition>