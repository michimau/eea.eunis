<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>
The Nationally designated areas inventory, also known as CDDA, began in 1995
under the CORINE programme of the European Commission. It is now one of the
agreed annual Eionet priority data flows maintained by the European Environment
Agency.


<h3>
    ${eunis:cmsPhrase(actionBean.contentManagement, 'National designation')}
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
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Date')}
        </th>
    </tr>
    </thead>
    <tbody>

    <c:forEach items="${actionBean.sitesDesigc}" var="desig">
        <tr>
            <td>
                <a href="designations/${desig.idGeoscope}:${desig.idDesignation}?fromWhere=en">${desig.description}</a>
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
                <c:choose>
                    <c:when test="${not empty actionBean.siteDesignationDateDisplayValue}">
                        <fmt:formatDate value="${ (actionBean.siteDesignationDateDisplayValue) }" pattern="${actionBean.dateFormat}"/>
                    </c:when>
                    <c:otherwise>${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}</c:otherwise>
                </c:choose>
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