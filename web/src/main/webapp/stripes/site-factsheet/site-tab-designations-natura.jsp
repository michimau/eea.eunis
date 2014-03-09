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
                </c:when>
                <c:otherwise>
                    <img width="15" height="16" title="No" style="vertical-align:middle" src="images/mini/invalid.gif" alt="Not under Habitats directive">
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</table>
<h3>NATURA 2000 site since</h3>
<table style="width: 600px">
    <tr>
        <td style="width: 400px">Date classified as Special Protection Area (SPA)</td>
        <td><fmt:formatDate value="${actionBean.spaDate}" pattern="${actionBean.dateFormat}"/></td>
    </tr>
    <tr>
        <td>Date proposed as Site of Community Importance (SCI)</td>
        <td><fmt:formatDate value="${actionBean.proposedDate}" pattern="${actionBean.dateFormat}"/></td>
    </tr>
    <tr>
        <td>Date designated as Special Area of Conservation (SAC)</td>
        <td><fmt:formatDate value="${actionBean.sacDate}" pattern="${actionBean.dateFormat}"/></td>
    </tr>
    <tr>
        <td>Date of Standard data form update</td>
        <td><fmt:formatDate value="${actionBean.updateDate}" pattern="${actionBean.dateFormat}"/></td>
    </tr>
</table>

<h3>
    ${eunis:cmsPhrase(actionBean.contentManagement, 'National designations overlapping the NATURA 2000 site')}
</h3>
<c:choose>
<c:when test="${not empty actionBean.sitesDesigc}">
<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'sites_factsheet_designations_national')}" class="listing fullwidth  table-inline">
    <thead>
    <tr>
        <th title="${eunis:cmsPhrase(actionBean.contentManagement, 'Sort results on this column')}" style="text-align: left;">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name (Original)')}
        </th>
        <th title="${eunis:cmsPhrase(actionBean.contentManagement, 'Sort results on this column')}" style="text-align: left;">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name (English)')}
        </th>
        <th title="${eunis:cmsPhrase(actionBean.contentManagement, 'Sort results on this column')}" style="text-align: left;">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Category')}
        </th>
        <th style="text-align : right;" title="${eunis:cmsPhrase(actionBean.contentManagement, 'Sort results on this column')}">
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Cover(%)')}
        </th>
    </tr>
    </thead>
    <tbody>

    <c:forEach items="${actionBean.sitesDesigc}" var="desig">
        <tr>
            <td>
                <a href="designations/${desig.idGeoscope}:${desig.idDesignation}?fromWhere=en">${desig.description}</a>&nbsp;
            </td>
            <td>
                <a href="designations/${desig.idGeoscope}:${desig.idDesignation}?fromWhere=en">${desig.descriptionEn}</a>
            </td>
            <td>
                <c:choose>
                    <c:when test="${desig.nationalCategory eq 'A'}">
                        Designation types used with the intention to protect fauna, flora, habitats and landscapes (the latter as far as relevant for fauna, flora and for habitat protection)
                        (Code ${desig.nationalCategory})
                    </c:when>
                    <c:when test="${desig.nationalCategory eq 'B'}">
                        Statutes under sectorial, particularly forestry, legislative and administrative acts providing an adequate protection relevant for fauna, flora and habitat conservation
                        (Code ${desig.nationalCategory})
                    </c:when>
                    <c:when test="${desig.nationalCategory eq 'C'}">
                        Private statute providing durable protection for fauna, flora or habitats
                        (Code ${desig.nationalCategory})
                    </c:when>
                    <c:otherwise>
                        ${desig.nationalCategory}
                    </c:otherwise>
                </c:choose>

            </td>
            <td style="text-align : right">
                <fmt:formatNumber value=" ${desig.overlap}" type="number" pattern="#"/>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</c:when>
<c:otherwise>
    ${eunis:cmsPhrase(actionBean.contentManagement, 'No information reported')}
</c:otherwise>
</c:choose>

</stripes:layout-definition>