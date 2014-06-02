<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>
NATURA 2000 is the ecological network for the conservation of wild animals and plant
species and natural habitats of Community importance within the Union. It consists of
sites classified under the Birds Directive and the Habitats Directive (the Nature Directives).

<h3>NATURA 2000 site under</h3>
<table style="width: 600px" class="designations-table">
    <colgroup><col/><col style=" text-align: right;"/></colgroup>
    <tr><td style="width: 400px">Birds Directive <span class="discreet">2009/147/EC</span>     (SPA)</td>
        <td>
            <c:choose>
                <c:when test="${actionBean.siteType eq 'A' or actionBean.siteType eq 'C'}">
                    <img width="15" height="16" title="Yes" style="vertical-align:middle" src="images/mini/check_green.gif" alt="Under Birds directive">
                    </td></tr><tr><td><ul><li>Date classified as Special Protection Area (SPA)</li></ul></td>
                     <td>
                         <c:choose>
                             <c:when test="${not empty actionBean.spaDate}"><fmt:formatDate value="${actionBean.spaDate}" pattern="${actionBean.dateFormat}"/></c:when>
                             <c:otherwise>Not available</c:otherwise>
                         </c:choose>
                </c:when>
                <c:otherwise>
                    <img width="15" height="16" title="No" style="vertical-align:middle" src="images/mini/invalid.gif" alt="Not under Birds directive">
                </c:otherwise>
            </c:choose>
        </td>
    </tr>

    <tr><td colspan="2" style="border-bottom: solid 1px #ECECEC;"><div style="height:4px; overflow: hidden;">&nbsp;</div></td></tr>

    <tr><td style="padding-top: 4px;">Habitats Directive <span class="discreet">92/43/EEC</span> (SCI)</td>
        <td style="padding-top: 4px;">
            <c:choose>
                <c:when test="${(actionBean.siteType eq 'B' or actionBean.siteType eq 'C')}">
                    <img width="15" height="16" title="Yes" style="vertical-align:middle" src="images/mini/check_green.gif" alt="Under Habitats directive">
                    </td></tr><tr><td><ul><li>
                      Date proposed as Site of Community Importance (SCI)</li></ul></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty actionBean.sciProposedDate}"><fmt:formatDate value="${actionBean.sciProposedDate}" pattern="${actionBean.dateFormat}"/></c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </td>
                    </tr><tr><td><ul><li>
                      Date confirmed as Site of Community Importance</li></ul></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty actionBean.sciConfirmedDate}"><fmt:formatDate value="${actionBean.sciConfirmedDate}" pattern="${actionBean.dateFormat}"/></c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </td>
                </c:when>
                <c:otherwise>
                    <img width="15" height="16" title="No" style="vertical-align:middle" src="images/mini/invalid.gif" alt="Not under Habitats directive">
                </c:otherwise>
            </c:choose>
        </td>
     </tr>

    <tr><td colspan="2" style="border-bottom: solid 1px #ECECEC;"><div style="height:4px; overflow: hidden;">&nbsp;</div></td></tr>
    <c:if test="${not empty actionBean.sacDate}">
    <tr>
        <td style="padding-top: 4px;">Date designated as Special Area of Conservation (SAC)</td>
        <td style="padding-top: 4px;">
            <c:choose>
                <c:when test="${not empty actionBean.sacDate}"><fmt:formatDate value="${actionBean.sacDate}" pattern="${actionBean.dateFormat}"/></c:when>
                <c:otherwise>Not available</c:otherwise>
            </c:choose>
        </td>
    </tr>

    <tr><td colspan="2" style="border-bottom: solid 1px #ECECEC;"><div style="height:4px; overflow: hidden;">&nbsp;</div></td></tr>
    </c:if>
    <tr>
        <td style="padding-top: 4px;">Date of Standard data form update</td>
        <td style="padding-top: 4px;">
            <c:choose>
                <c:when test="${not empty actionBean.updateDate}"><fmt:formatDate value="${actionBean.updateDate}" pattern="${actionBean.dateFormat}"/></c:when>
                <c:otherwise>Not available</c:otherwise>
            </c:choose>
        </td>
    </tr>

</table>

</stripes:layout-definition>