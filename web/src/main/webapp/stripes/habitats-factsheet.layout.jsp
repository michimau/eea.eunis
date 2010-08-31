<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${actionBean.pageTitle }">
	<stripes:layout-component name="head">
		<script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
		<script language="JavaScript" type="text/javascript">
		    //<![CDATA[
		      function openpictures( URL, width, height )
			  {
			    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width="+width+",height="+height+",left=100,top=0');");
			  }
			  function openLink(URL)
			  {
			    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
			  }
		    //]]>
		    </script>
	</stripes:layout-component>
	<stripes:layout-component name="contents">

		<!-- MAIN CONTENT --> 
		<c:choose>
			<c:when test="${actionBean.factsheet.habitat == null}">
				<div class="error-msg">
					${eunis:cmsPhrase(actionBean.contentManagement, ('Sorry, no habitat type has been found in the database'))}
				</div>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${!empty actionBean.factsheet}">
						<c:if test="${!actionBean.mini}">
							<img id="loading" src="images/loading.gif"
								alt="${eunis:cms(actionBean.contentManagement, 'loading')}"
								title="${eunis:cms(actionBean.contentManagement, 'loading')}" />
						</c:if>
						<h1 class="documentFirstHeading">${eunis:replaceTags(actionBean.factsheet.habitatScientificName)}</h1>
						<div class="documentActions">
							<h5 class="hiddenStructure">${eunis:cmsPhrase(actionBean.contentManagement, 'Document Actions')}</h5>
							<ul>
								<li>
									<a href="javascript:this.print();">
										<img
											src="http://webservices.eea.europa.eu/templates/print_icon.gif"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" />
									</a>
								</li>
								<li>
									<a href="javascript:toggleFullScreenMode();">
										<img
											src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" />
									</a>
								</li>
								<li>
									<a href="javascript:openLink('habitats-factsheet-pdf.jsp?idHabitat=${actionBean.idHabitat}')">
										<img
											src="images/pdf.png"
											alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Download page as PDF')}"
											title="${eunis:cmsPhrase(actionBean.contentManagement, 'Download page as PDF')}" />
									</a>
								</li>
							</ul>
						</div>
						<br clear="all" />
						<c:if test="${!actionBean.mini}">
							<div id="tabbedmenu">
								<ul>
									<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
										<c:choose>
											<c:when test="${dataTab.id eq actionBean.tab}">
												<li id="currenttab">
													<a href="habitats/${actionBean.idHabitat}/${dataTab.id}">
														${eunis:cmsPhrase(actionBean.contentManagement, dataTab.value)}
													</a>
												</li>
											</c:when>
											<c:otherwise>
												<li>
													<a href="habitats/${actionBean.idHabitat}/${dataTab.id}">
														${eunis:cmsPhrase(actionBean.contentManagement, dataTab.value)}
													</a>
												</li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</ul>
							</div>
							<br  style="clear:both;" clear="all" />
						</c:if>
						<br />
						<c:if test="${actionBean.tab == 'general'}">
							<jsp:include page="/habitats-factsheet-general.jsp">
								<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'distribution'}">
							<jsp:include page="/habitats-factsheet-geographical.jsp">
								<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'instruments'}">
							<jsp:include page="/habitats-factsheet-legal.jsp">
								<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'habitats'}">
							<jsp:include page="/habitats-factsheet-related.jsp">
								<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'sites'}">
							<stripes:layout-render name="/stripes/habitats-factsheet-sites.jsp"/>
						</c:if>
						<c:if test="${actionBean.tab == 'species'}">
							<jsp:include page="/habitats-factsheet-species.jsp">
								<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							</jsp:include>
						</c:if>
						<c:if test="${actionBean.tab == 'other'}">
							<c:if test="${actionBean.factsheet.eunis}">
								<script language="JavaScript" type="text/javascript">
									function otherInfo(info) {
				                    	var ctrl_info = document.getElementById("otherInfo" + info);
				                    	try {
				                        	if(ctrl_info.style.display == "none") {
				                            	ctrl_info.style.display = "block";
											} else {
				                            	ctrl_info.style.display = "none";
				                          	}
										} catch( e ) {
				                          	alert("${eunis:cmsPhrase(actionBean.contentManagement, 'Error expanding node')}");
				                        }
				                  	}
				                  	function otherInfoAll(expand) {
				                    	for(i = 0; i < ${actionBean.dictionaryLength}; i++) {
					                      	var ctrl_info = document.getElementById("otherInfo" + i);
					                      	try {
												if(expand) {
					                              	ctrl_info.style.display = "block";
					                            } else {
					                              	ctrl_info.style.display = "none";
					                            }
					                        } catch( e ) {}
										}
				                  	}
				                </script>
				                <a href="javascript:otherInfoAll(true);" title="Expand all characteristic information">Expand All</a> |
				                <a href="javascript:otherInfoAll(false);" title="Collapse all characteristic information">Collapse All</a>
				                <br /><br />
				                <ul>
					                <c:forEach items="${actionBean.otherInfo}" var="other" varStatus="loop">
					                	<li>
					                		<c:choose>
								    			<c:when test="${other.noElements == '0' || other.noElements == ''}">
													<span style="color:#808080">${other.title} (no records)</span>
								    			</c:when>
								    			<c:otherwise>
								    				<a href="javascript:otherInfo(${other.dictionaryType})">${other.title}</a>${eunis:cmsPhrase(actionBean.contentManagement, 'Habitat type other information')} (${other.noElements} ${eunis:cmsPhrase(actionBean.contentManagement, 'records')})
							                      	<div id="otherInfo${other.dictionaryType}" style="padding-left : 25px; display : none;">
							                        	<jsp:include page="/habitats-factsheet-other.jsp">
							                          		<jsp:param name="idHabitat" value="${actionBean.idHabitat}" />
							                          		<jsp:param name="infoID" value="${other.dictionaryType}" />
							                        	</jsp:include>
							                      	</div>
								    			</c:otherwise>
								    		</c:choose>
					                	</li>
					                </c:forEach>
				                </ul>
							</c:if>
						</c:if>
					</c:when>
					<c:otherwise>
		                <br />
					</c:otherwise>
				</c:choose>
				<c:if test="${!actionBean.mini}">
	                 ${eunis:cmsMsg(actionBean.contentManagement, 'factsheet_for')}
	                 ${eunis:br(actionBean.contentManagement)}
	                 ${eunis:cmsMsg(actionBean.contentManagement, 'loading_data')}
	                 ${eunis:br(actionBean.contentManagement)}
	                 ${eunis:cmsMsg(actionBean.contentManagement, 'error_expanding_node')}		
                 </c:if>	
			</c:otherwise>
		</c:choose> 
		<!-- END MAIN CONTENT -->
		<script language="JavaScript" type="text/javascript">
	      	//<![CDATA[
			try {
				var ctrl_loading = document.getElementById("loading");
        		ctrl_loading.style.display = "none";
      		} catch ( e ){}
	      	//]]>
	    </script>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
				<div class="visualPadding">
					<jsp:include page="/inc_column_left.jsp">
						<jsp:param name="page_name" value="habitats" />
					</jsp:include>
				</div>
			</div>
          	<!-- end of the left (by default at least) column -->
		<!-- end of the main and left columns -->
		<!-- start of right (by default at least) column -->
		<div id="portal-column-two">
			<div class="visualPadding">
				<jsp:include page="/right-dynamic.jsp">
					<jsp:param name="mapLink" value="show" />
				</jsp:include>
			</div>
		</div>
		<!-- end of the right (by default at least) column -->
		<div class="visualClear"><!-- --></div>
	</stripes:layout-component>
</stripes:layout-render>

