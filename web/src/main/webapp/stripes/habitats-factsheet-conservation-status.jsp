<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>



    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'Conservation status')}</h2>

    <c:if test="${empty actionBean.conservationStatusQueryResultRows }">
       <div class="system-msg">
           Found no external data on the conservation status of this habitat.
       </div>
    </c:if>

    <c:if test="${not empty actionBean.conservationStatusQueryResultRows}">
       <c:forEach items="${actionBean.conservationStatusQueries}" var="query">
           <div style="margin-top:20px">
	           <p style="font-weight:bold">${eunis:cmsPhrase(actionBean.contentManagement, query.title)}:</p>
	           <c:set var="queryId" value="${query.id}"/>
               <div style="overflow-x:auto ">
	              <display:table name="actionBean.conservationStatusQueryResultRows.${queryId}" class="sortable" pagesize="30" sort="list" requestURI="/habitats/${actionBean.idHabitat}/conservation_status" style="margin-top:20px">
 	                   <c:forEach var="cl" items="${actionBean.conservationStatusQueryResultCols[queryId]}">
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
