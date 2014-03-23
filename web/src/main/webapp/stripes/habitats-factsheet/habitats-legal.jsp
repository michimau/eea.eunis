<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>

    <c:choose>
        <c:when test="${not empty actionBean.legalInfo}">
            <h3>
                ${eunis:cmsPhrase(actionBean.contentManagement, 'Covered by the following habitat types in international legal instruments and agreements')}
            </h3>
            <table summary="${eunis:cms(actionBean.contentManagement, 'habitat_type_legal_instruments')}" class="listing fullwidth">
                <thead>
                <tr>
                    <th width="30%" style="text-align: left;">
                            ${eunis:cmsPhrase(actionBean.contentManagement, 'Legal Instrument')}
                    </th>
                    <th width="50%" style="text-align: left;">
                            ${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type legal name')}
                    </th>
                    <th width="20%" style="text-align: left;">
                            ${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type legal code')}
                    </th>
                </tr>
                </thead>
                <tbody>

                <c:forEach items="${actionBean.legalInfo}" var="legal">
                    <tr>
                        <td>
                               <a href="/references/${legal.idDc}">
                                ${legal.legalName}
                               </a>
                        </td>
                        <td>
                                ${legal.title}
                        </td>
                        <td>
                                ${legal.code}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'Not available')}
        </c:otherwise>
    </c:choose>

</stripes:layout-definition>