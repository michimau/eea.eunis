<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value=""></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}">

    <%-- Header layout component --%>

    <stripes:layout-component name="head">
        <script src="<%=request.getContextPath()%>/script/sites-statistical.js" type="text/javascript"></script>
        <script src="<%=request.getContextPath()%>/script/sortable.js" type="text/javascript"></script>

        <script type="text/javascript">
            //<![CDATA[
	        var errRefineMessage = "${eunis:cms(actionBean.contentManagement, 'enter_refine_criteria_correctly')}.";
	        // Used in refine search ; check if criteria are empty
	        function checkRefineSearch(noCriteria)
	        {
	          if(noCriteria == 0)
	          {
	            Name = trim(document.resultSearch.criteriaSearch.value);
	            if (Name == "")
	            {
	              alert(errRefineMessage);
	              return false;
	            } else {
	              return true;
	            }
	          } else {
	            isSomeoneEmplty = 0;
	            for (i = 0; i <= noCriteria; i++)
	            {
	              if (trim(document.resultSearch.criteriaSearch[i].value) == "")
	              {
	                isSomeoneEmplty = 1;
	              }
	            }
	            if (isSomeoneEmplty == 1)
	            {
	              alert(errRefineMessage);
	              return false;
	            } else {
	              return true;
	            }
	          }
	        }
            //]]>
        </script>

    </stripes:layout-component>

    <%-- Main contents layout component --%>

    <stripes:layout-component name="contents">

        <c:if test="${actionBean.country == null}">
            <div class="error-msg">
                ${eunis:cmsPhrase(actionBean.contentManagement, "The requested country could not be found!")}
            </div>
        </c:if>

        <c:if test="${actionBean.country != null}">

            <img alt="${eunis:cms(actionBean.contentManagement,'loading_data')}" id="loading" src="images/loading.gif" />
	        <h1>
	            ${eunis:cmsPhrase(actionBean.contentManagement, "Statistical information for:")}&nbsp;${actionBean.nameForTitle}
	        </h1>

            <br clear="all"/>

	        <div id="tabbedmenu">
	            <ul>
	                <c:forEach items="${actionBean.tabs}" var="tab">
	                    <li ${tab eq actionBean.currTab ? 'id="currenttab"' : ''}>
	                        <c:if test="${tab eq actionBean.currTab}">
	                            <a href="javascript:window.location.reload()" onclick="return false;" title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${tab.title}">${tab.title}</a>
	                        </c:if>
	                        <c:if test="${!(tab eq actionBean.currTab)}">
		                        <stripes:link beanclass="${actionBean.class.name}" title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${tab.title}">
		                            <stripes:param name="eunisAreaCode" value="${actionBean.country.eunisAreaCode}"/>
		                            <stripes:param name="tab" value="${tab.displayName}"/>
		                            <c:if test="${tab == 'DESIG_TYPES' && actionBean.currTab == 'GENERAL'}">
	                                    <stripes:param name="yearMin" value="${actionBean.statisticsBean.yearMin}"/>
										<stripes:param name="yearMax" value="${actionBean.statisticsBean.yearMax}"/>
										<stripes:param name="designation" value="${actionBean.statisticsBean.designation}"/>
										<stripes:param name="designationCat" value="${actionBean.statisticsBean.designationCat}"/>
										<stripes:param name="DB_NATURA2000" value="${actionBean.statisticsBean.DB_NATURA2000}"/>
										<stripes:param name="DB_CORINE" value="${actionBean.statisticsBean.DB_CORINE}"/>
										<stripes:param name="DB_DIPLOMA" value="${actionBean.statisticsBean.DB_DIPLOMA}"/>
										<stripes:param name="DB_CDDA_NATIONAL" value="${actionBean.statisticsBean.DB_CDDA_NATIONAL}"/>
										<stripes:param name="DB_BIOGENETIC" value="${actionBean.statisticsBean.DB_BIOGENETIC}"/>
										<stripes:param name="DB_EMERALD" value="${actionBean.statisticsBean.DB_EMERALD}"/>
										<stripes:param name="DB_CDDA_INTERNATIONAL" value="${actionBean.statisticsBean.DB_CDDA_INTERNATIONAL}"/>
		                            </c:if>
		                            <c:if test="${tab == 'SPECIES'}">
		                                <stripes:param name="country" value="${actionBean.country.idCountry}"/>
	                                    <stripes:param name="countryName" value="${actionBean.country.areaNameEnglish}"/>
	                                    <stripes:param name="region" value="any"/>
	                                    <stripes:param name="regionName" value="any"/>
		                            </c:if>
		                            <c:if test="${tab == 'HABITAT_TYPES'}">
		                                <stripes:param name="country" value="${actionBean.country.areaNameEnglish}"/>
	                                    <stripes:param name="region" value=""/>
	                                    <stripes:param name="database" value="2"/>
	                                    <stripes:param name="showScientificName" value="true"/>
	                                    <stripes:param name="showVernacularName" value="true"/>
		                            </c:if>
		                            <c:out value="${tab.title}"/>
		                        </stripes:link>
	                        </c:if>
	                    </li>
	                </c:forEach>
	            </ul>
	        </div>

	        <br style="clear:both;" clear="all"/>
	        <br/>
			<c:if test="${actionBean.currTab == 'GENERAL'}">
	            <stripes:layout-render name="/stripes/countries-factsheet/country-factsheet-general.jsp"/>
			</c:if>
	        <c:if test="${actionBean.currTab == 'DESIG_TYPES'}">
	            <stripes:layout-render name="/stripes/countries-factsheet/country-factsheet-desig-types.jsp"/>
	        </c:if>
	        <c:if test="${actionBean.currTab == 'SPECIES'}">
	            <stripes:layout-render name="/stripes/countries-factsheet/country-factsheet-species.jsp"/>
	        </c:if>
	        <c:if test="${actionBean.currTab == 'HABITAT_TYPES'}">
	            <stripes:layout-render name="/stripes/countries-factsheet/country-factsheet-habitat-types.jsp"/>
	        </c:if>

	        <c:forEach items="${actionBean.tabs}" var="tab">
	            ${eunis:cmsMsg(actionBean.contentManagement, tab)}
	            ${eunis:br(actionBean.contentManagement)}
	        </c:forEach>

	        ${eunis:br(actionBean.contentManagement)}
	        ${eunis:cmsMsg(actionBean.contentManagement, 'species_factsheet_title')}
	        ${eunis:br(actionBean.contentManagement)}
	        ${eunis:cmsMsg(actionBean.contentManagement, 'show')}
	        ${eunis:br(actionBean.contentManagement)}
	        ${eunis:cmsMsg(actionBean.contentManagement, 'loading_data')}
	        ${eunis:br(actionBean.contentManagement)}

	        <script type="text/javascript">
	            //<![CDATA[
	            try {
	                var ctrl_loading = document.getElementById( "loading" );
	                ctrl_loading.style.display = "none";
	            }
	            catch ( e ){}

	            // Writes a warning if the page is called as a popup. Works only in IE
	            if (history.length == 0 && document.referrer != '') {
	                c = document.getElementById('content');
	                w = document.createElement('div');
	                w.className = "note-msg";
	                w.innerHTML = "<strong>Notice</strong> <p>This page was opened as a new window. The back button has been disabled by the referring page. Close the window to exit.</p>";
	                c.insertBefore(w, c.firstChild);
	            }
	            //]]>
	        </script>

        </c:if>

    </stripes:layout-component>
    <%-- End of main contents layout component --%>

    <stripes:layout-component name="foot">
    </stripes:layout-component>
</stripes:layout-render>
