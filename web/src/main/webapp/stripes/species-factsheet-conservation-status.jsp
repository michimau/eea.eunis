<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Conservation status')}</h2>

    <c:if test="${ !actionBean.conservationStatusQueriesExists || empty actionBean.conservationStatusResultRows }">
       <div class="system-msg">
           Found no external data on the conservation status of this species.
       </div>
    </c:if>

    <c:if test="${not empty actionBean.conservationStatusResultRows && actionBean.conservationStatusQueriesExists eq true}">
       <c:forEach items="${actionBean.queries}" var="query">
           <div style="margin-top:20px">
	           <p style="font-weight:bold">${eunis:cmsPhrase(actionBean.contentManagement, query.title)}:</p>
	           <c:set var="queryId" value="${query.id}"/>
               <div style="overflow-x:auto ">
	              <display:table name="actionBean.conservationStatusResultRows.${queryId}" class="sortable" pagesize="30" sort="list" requestURI="/species/${actionBean.idSpecies}/conservation_status" style="margin-top:20px">
	                   <c:forEach var="cl" items="${actionBean.conservationStatusResultCols[queryId]}">
	                           <display:column property="${cl.property}"
	                               title="${cl.property}"
	                               sortable="${cl.sortable}"
	                               decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator" />
	                   </c:forEach>
	               </display:table>
	           </div>
            </div>

       </c:forEach>
    </c:if>

</stripes:layout-definition>
