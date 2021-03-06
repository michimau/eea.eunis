<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<%
    String btrail = "eea#" + application.getInitParameter( "EEA_HOME" ) + ",home#index.jsp,references";
%>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="References" bookmarkPageName="references" btrail="<%= btrail %>">

    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <!-- MAIN CONTENT value="${actionBean.defaultFilterValue}"-->

        <h2>References:</h2>
        <stripes:form action="/references" method="get" name="f">
            <stripes:text size="38"
                name="filterPhrase"
                onfocus="if(this.value=='${actionBean.defaultFilterValue}')this.value='';"
                onblur="if(this.value=='')this.value='${actionBean.defaultFilterValue}';"
                title="${actionBean.defaultFilterValue}"
                />
             <stripes:submit   value="Filter" name="filterPrase2" />
         </stripes:form>
         <br/>
         <display:table name="${actionBean.refs}" class="listing fullwidth table-inline" sort="external" id="listItem" htmlId="listItem" requestURI="/references" decorator="eionet.eunis.util.decorators.ReferencesTableDecorator">
             <display:column property="idRef" title="ID" sortable="true" headerClass="nosort"/>
             <display:column property="refTitle" title="Title" sortable="true" headerClass="nosort"/>
             <display:column property="author" title="Author" sortable="true" decorator="eionet.eunis.util.decorators.ReplaceTagsColumnDecorator" headerClass="nosort"/>
             <display:column property="refYear" title="Year" sortable="true" headerClass="nosort"/>
         </display:table>

        <!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>
