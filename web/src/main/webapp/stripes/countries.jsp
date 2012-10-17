<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Countries and areas">

    <stripes:layout-component name="contents">

        <!-- MAIN CONTENT -->

            <h2>Countries and areas:</h2>
            <display:table name="${actionBean.resultList}" class="sortable" sort="list" id="listItem" htmlId="listItem" requestURI="/countries">
                <display:column property="eunisAreaCode" title="EUNIS area code" sortable="true"/>
                <display:column sortProperty="areaNameEnglish" title="English name" sortable="true">
                   <stripes:link beanclass="${actionBean.factsheetBeanClassName}" title="Go to factsheet">
                       <stripes:param name="eunisAreaCode" value="${listItem.eunisAreaCode}"/>
                       <c:out value="${not empty listItem.areaNameEnglish ? listItem.areaNameEnglish : 'n/a'}"/>
                   </stripes:link>
                </display:column>
                <display:column property="areaName" title="Original name" sortable="true"/>
                <display:column property="iso2l" title="ISO-2 code" sortable="true"/>
                <display:column property="iso3l" title="ISO-2 code" sortable="true"/>
                <display:column sortProperty="indeedCountry" title="Type" sortable="true">
                    <c:out value="${listItem.indeedCountry ? 'country' : 'other'}"/>
                </display:column>
            </display:table>

        <!-- END MAIN CONTENT -->

    </stripes:layout-component>
    <stripes:layout-component name="foot">
        <!-- start of the left (by default at least) column -->
            <div id="portal-column-one">
                <div class="visualPadding">
                    <jsp:include page="/inc_column_left.jsp">
                        <jsp:param name="page_name" value="countries" />
                    </jsp:include>
                </div>
            </div>
            <!-- end of the left (by default at least) column -->
    </stripes:layout-component>
</stripes:layout-render>
