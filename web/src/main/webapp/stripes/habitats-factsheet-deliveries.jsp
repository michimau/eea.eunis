<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<h2>
		${eunis:cmsPhrase(actionBean.contentManagement, 'Deliveries')}
	</h2>
	<c:choose>
        <c:when test="${not empty actionBean.deliveries && not empty actionBean.deliveries.rows}">
            <display:table name="${actionBean.deliveries.rows}" class="listing fullwidth" defaultsort="3" defaultorder="descending" pagesize="30" sort="list" id="listItem" htmlId="listItem" requestURI="/habitats/${actionBean.idHabitat}/${actionBean.tab}" decorator="eionet.eunis.util.decorators.DeliveriesTableDecorator">
                <display:column property="envelope" title="Envelope" sortable="true" sortProperty="envelopeLabel"/>
                <display:column property="file" title="File" sortable="true" sortProperty="fileLabel"/>
                <display:column property="released" title="Released" sortable="true" format="{0,date,yyyy-MM-dd}"/>
                <display:column property="coverage" title="Coverage" sortable="true"/>
            </display:table>
        </c:when>
        <c:otherwise>
            ${eunis:cmsPhrase(actionBean.contentManagement, 'No deliveries for this habitat')}
        </c:otherwise>
    </c:choose>
</stripes:layout-definition>