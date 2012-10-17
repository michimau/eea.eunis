<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-definition>

    <c:if test="${!actionBean.indeedCountry}">
        <div><p>No designation types found for this area!</p></div>
    </c:if>

    <c:if test="${actionBean.indeedCountry && empty actionBean.designations}">
        <div><p>No designation types found for this country!</p></div>
    </c:if>

    <c:if test="${actionBean.indeedCountry && not empty actionBean.designations}">
        <div>

            <table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'Designations')}" class="listing">
                <thead>
                    <tr>
                        <th>${eunis:cmsPhrase(actionBean.contentManagement, "Source data set")}</th>
						<th>${eunis:cmsPhrase(actionBean.contentManagement, "Designation type name")}</th>
						<th>${eunis:cmsPhrase(actionBean.contentManagement, "English designation type name")}</th>
						<th>${eunis:cmsPhrase(actionBean.contentManagement, "Category")}</th>
						<th>${eunis:cmsPhrase(actionBean.contentManagement, "Total number of sites")}</th>
						<th>${eunis:cmsPhrase(actionBean.contentManagement, "Total area(ha)")}</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${actionBean.designations}" var="designation" varStatus="designationsLoop">

                        <c:set var="designationValue" value="${actionBean.designationsValues[designationsLoop.index]}"/>

                        <tr class="${(designationsLoop.index % 2 == 0) ? 'zebraodd' : 'zebraeven'}">
                            <td>
                                <c:out value="${empty designation.originalDataSource ? 'n/a' : designation.originalDataSource}"/>
                            </td>
                            <td>
                                <c:if test="${not empty designation.description}">
                                    <a href="designations/${designation.idGeoscope}:${designation.idDesignation}"><c:out value="${designation.description}"/></a>
                                </c:if>
                                <c:if test="${not empty designation.description}">&nbsp;</c:if>
                            </td>
                            <td>
                                <c:if test="${not empty designation.descriptionEn}">
                                    <a href="designations/${designation.idGeoscope}:${designation.idDesignation}"><c:out value="${designation.descriptionEn}"/></a>
                                </c:if>
                                <c:if test="${not empty designation.description}">&nbsp;</c:if>
                            </td>
                            <td>
                                ${eunis:formatString(designation.nationalCategory,'&nbsp;')}
                            </td>
                            <td style="text-align:right">
                                ${eunis:formatString(designationValue[0],'&nbsp;')}
                            </td>
                            <td style="text-align:right">
                                ${eunis:formatArea(''+designationValue[1], 0, 2, '&nbsp;')}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

</stripes:layout-definition>
