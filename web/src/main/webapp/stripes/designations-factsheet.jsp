<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${actionBean.pageTitle}">
	<stripes:layout-component name="head">
		<script language="JavaScript" type="text/javascript">
		    //<![CDATA[
		    function MM_openBrWindow(theURL,winName,features) { //v2.0
		      window.open(theURL,winName,features);
		    }
		    function openLink(URL)
		    {
		      eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
		    }
		    //]]>
		    </script>
		    <script language="JavaScript" src="<%=request.getContextPath()%>/script/sortable.js" type="text/javascript"></script>
	</stripes:layout-component>
	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
			<c:choose>
				<c:when test="${!empty actionBean.factsheet}">
					<h1 class="documentFirstHeading">${eunis:cmsPhrase(actionBean.contentManagement, 'Designation type')}: ${actionBean.fromWho}</h1>
					<div class="documentActions">
				  		<h5 class="hiddenStructure">${eunis:cmsPhrase(actionBean.contentManagement, 'Document Actions') }</h5>
				  		<ul>
				    		<li>
				      			<a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
				            		alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
				            		title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" /></a>
				    		</li>
				    		<li>
				      			<a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
				             		alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
				             		title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" /></a>
						    </li>
				  		</ul>
				  	</div>
				  	<h2>${eunis:cmsPhrase(actionBean.contentManagement, 'General information')}</h2>
				  	<table class="datatable fullwidth">
				  		<%--Code--%>
                  		<tr>
                    		<td width="30%">
                      			${eunis:cmsPhrase(actionBean.contentManagement, 'Code')}
                    		</td>
                    		<td width="70%">
                      			<strong>
                        			${eunis:formatString(actionBean.factsheet.idDesignation, "&amp;nbsp")}
                      			</strong>
                    		</td>
                  		</tr>
                  		<!--Source data set-->
                  		<tr class="zebraeven">
                    		<td>
                    			${eunis:cmsPhrase(actionBean.contentManagement, 'Source data set')}
                    		</td>
                    		<td>
                      			<strong>
                        			${actionBean.factsheet.originalDataSource}
                      			</strong>
                    		</td>
                  		</tr>
                  		<tr>
                    		<td>
                    			${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical coverage')}
                    		</td>
                    		<td>
                    			<c:choose>
									<c:when test="${actionBean.isCountry}">
										<a href="sites-statistical-result.jsp?country=${actionBean.country}&amp;DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=false&amp;DB_CORINE=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="${eunis:cms(actionBean.contentManagement, 'open_the_statistical_data_for')} ${actionBean.country}">
											<strong>${actionBean.country}</strong>
										</a>
										${eunis:cmsTitle(actionBean.contentManagement, 'open_the_statistical_data_for')}
									</c:when>
									<c:otherwise>
										${actionBean.country}
									</c:otherwise>
								</c:choose>
                    		</td>
                  		</tr>
                  		<tr class="zebraeven">
	                    	<td>
	                      		${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name in original language')}
	                    	</td>
	                    	<td>
	                      		<c:choose>
									<c:when test="${actionBean.fromWhere == 'original'}">
										<strong>${eunis:formatString(actionBean.factsheet.description, "")}</strong>
									</c:when>
									<c:otherwise>
										${eunis:formatString(actionBean.factsheet.description, "")}
									</c:otherwise>
								</c:choose>
	                    	</td>
	                  	</tr>
	                  	<tr>
	                    	<td>
	                      		${eunis:cmsPhrase(actionBean.contentManagement, 'Designation name in English')}
	                    	</td>
	                    	<td>
	                      		<c:choose>
									<c:when test="${actionBean.fromWhere == 'en'}">
										<strong>${eunis:formatString(actionBean.factsheet.descriptionEn, "")}</strong>
									</c:when>
									<c:otherwise>
										${eunis:formatString(actionBean.factsheet.descriptionEn, "")}
									</c:otherwise>
								</c:choose>
	                    	</td>
	                  	</tr>
	                  	<tr class="zebraeven">
	                    	<td>
	                      		${eunis:cmsPhrase(actionBean.contentManagement, 'Designation abbreviation')}
	                    	</td>
	                    	<td>
	                      		${eunis:formatString(actionBean.factsheet.idDesignation, "")}
	                    	</td>
	                  	</tr>
	                  	<tr>
                    		<td>
                    			${eunis:cmsPhrase(actionBean.contentManagement, 'CDDA sites')}
                    		</td>
                    		<td>
                      			${eunis:formatString(actionBean.cddacount, "")}
                    		</td>
                    	</tr>
                    	<tr class="zebraeven">
                    		<td>
                    			${eunis:cmsPhrase(actionBean.contentManagement, 'Area reference (ha)')}
                    		</td>
                    		<td>
                      			${eunis:formatDecimal(actionBean.factsheet.referenceArea, 5)}
                    		</td>
                  		</tr>
                  		<tr>
                    		<td>
                      			${eunis:cmsPhrase(actionBean.contentManagement, 'Total area(ha)')}
                    		</td>
                    		<td>
                      			${eunis:formatDecimal(actionBean.factsheet.totalArea, 5)}
                    		</td>
                  		</tr>
				  	</table>
				  	<c:if test="${!empty actionBean.factsheet.nationalLaw || !empty actionBean.factsheet.nationalCategory
				  					|| !empty actionBean.factsheet.nationalLawReference || !empty actionBean.factsheet.nationalLawAgency}">
				  		<h2>
                  			${eunis:cmsPhrase(actionBean.contentManagement, 'National information')}
                		</h2>
                		<table summary="layout" class="datatable fullwidth">
                  			<tr>
                    			<td width="30%">
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'National Law')}
                    			</td>
                    			<td width="70%">
                      				${eunis:formatString(actionBean.factsheet.nationalLaw, "")}
                    			</td>
                  			</tr>
                  			<tr class="zebraeven">
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'National Category')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.nationalCategory, "")}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Reference for National Law')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.nationalLawReference, "")}
                    			</td>
                  			</tr>
                   			<tr class="zebraeven">
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'National Law Agency')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.nationalLawAgency, "")}
                    			</td>
                  			</tr>
                  		</table>
				  	</c:if>
				  	<c:if test="${!empty actionBean.factsheet.dataSource || !empty actionBean.factsheet.referenceNumber
				  					|| !empty actionBean.factsheet.referenceDate || !empty actionBean.factsheet.remark
				  					|| !empty actionBean.factsheet.remarkSource}">
				  		<h2>
				  			${eunis:cmsPhrase(actionBean.contentManagement, 'References')}
				  		</h2>
				  		<table summary="layout" class="datatable fullwidth">
                  			<tr>
                    			<td width="30%">
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
                    			</td>
                    			<td width="70%">
                      				${eunis:formatString(actionBean.factsheet.dataSource, "")}
                    			</td>
                  			</tr>
                  			<tr class="zebraeven">
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Number of reference')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.referenceNumber, "")}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Reference date')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.referenceDate, "")}
                    			</td>
                  			</tr>
                  			<tr class="zebraeven">
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Remark')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.remark, "")}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Source remark')}
                    			</td>
                    			<td>
                      				${eunis:formatString(actionBean.factsheet.remarkSource, "")}
                    			</td>
                  			</tr>
                  		</table>
				  	</c:if>
				  	<c:if test="${!empty actionBean.reference}">
				  		 <h2>
                  			${eunis:cmsPhrase(actionBean.contentManagement, 'Designation references')}
                		</h2>
                		<table summary="layout" class="datatable fullwidth">
                  			<tr>
                    			<td width="30%">
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Author:')}
                    			</td>
                    			<td width="70%">
                      				${actionBean.reference.author}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Editor:')}
                    			</td>
                    			<td>
                      				${actionBean.reference.editor}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Date:')}
                    			</td>
                    			<td>
                      				${actionBean.reference.date}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td>
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Title:')}
                    			</td>
                    			<td>
                      				${actionBean.reference.title}
                    			</td>
                  			</tr>
                  			<tr>
                    			<td width="20%">
                      				${eunis:cmsPhrase(actionBean.contentManagement, 'Publisher:')}
                    			</td>
                    			<td width="80%">
                      				${actionBean.reference.publisher}
                    			</td>
                  			</tr>
                  		</table>
                  		<br/>
				  	</c:if>
				  	<c:choose>
						<c:when test="${actionBean.showSites}">
						  	<c:choose>
								<c:when test="${!empty actionBean.sites}">
							  		<h2>
					                  	${eunis:cmsPhrase(actionBean.contentManagement, 'Related sites for this designation')}
					                </h2>
					                <c:if test="${!empty actionBean.siteIds}">
					                	<form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
						                  	<input type="hidden" name="sites" value="${actionBean.siteIds}" />
						                  	<input id="showMap" type="submit" title="${eunis:cms(actionBean.contentManagement, 'show_map')}" name="Show map" value="${eunis:cms(actionBean.contentManagement, 'show_map')}" class="submitSearchButton" />
						                </form>
					                </c:if>
					                <table summary="${eunis:cms(actionBean.contentManagement, 'sites')}" class="listing fullwidth">
			                  			<thead>
			                    			<tr>
			                      				<th scope="col">
			                        				${eunis:cmsPhrase(actionBean.contentManagement, 'Site code (in source data set)')}
			                      				</th>
			                      				<th scope="col">
			                        				${eunis:cmsPhrase(actionBean.contentManagement, 'Source data set')}
			                      				</th>
			                      				<th scope="col">
			                        				${eunis:cmsPhrase(actionBean.contentManagement, 'Geographical coverage')}
			                      				</th>
			                      				<th scope="col">
			                        				${eunis:cmsPhrase(actionBean.contentManagement, 'Site name')}
			                      				</th>
			                    			</tr>
			                  			</thead>
			                  			<tbody>
			                  				<c:forEach items="${actionBean.sites }" var="site" varStatus="loop">
			                  					<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
			                    					<td>
			                      						${eunis:formatString(site.idSite, "")}
			                    					</td>
			                    					<td>
				                      					${eunis:translateSourceDB(site.sourceDB)}
			                    					</td>
			                    					<td>
			                      						${eunis:formatString(site.country, "")}
			                    					</td>
			                    					<td>
			                      						<a href="sites/${site.idSite}">${eunis:formatString(site.name, "")}</a>
			                    					</td>
			                  					</tr>
			                  				</c:forEach>
			                  			</tbody>
			                  		</table>
						  		</c:when>
						  		<c:otherwise>
									<br />
					                <strong>
					                  	${eunis:cmsPhrase(actionBean.contentManagement, 'This designation has not related sites.')}
					                </strong>
								</c:otherwise>
							</c:choose>
						</c:when>
				  		<c:otherwise>
				  			<c:if test="${actionBean.hasSites}">
								<a title="${eunis:cms(actionBean.contentManagement, 'show_sites_in_page')}" href="designations/${actionBean.idGeo}:${actionBean.idDesig}?showSites=true&amp;fromWhere=${actionBean.fromWhere}">
									${eunis:cmsPhrase(actionBean.contentManagement, 'Show sites for this designation type')}
								</a>
								${eunis:cmsTitle(actionBean.contentManagement, 'show_sites_in_page')}
	                			<br />
	                			<br />
	                			<strong>
	                  				${eunis:cmsPhrase(actionBean.contentManagement, 'Warning: This might take a long time.')}
	                			</strong>
	                		</c:if>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<br />
                	<br />
                	<strong>
                  		${eunis:cmsPhrase(actionBean.contentManagement, 'The requested designation does not exists.')}
                	</strong>
                	<br />
                	<br	/>
				</c:otherwise>
			</c:choose>
			${eunis:cmsMsg(actionBean.contentManagement, 'sites_designations-factsheet_title')}
            ${eunis:br(actionBean.contentManagement)}
            ${eunis:cmsMsg(actionBean.contentManagement, 'loading_data')}
            ${eunis:br(actionBean.contentManagement)}
            ${eunis:cmsMsg(actionBean.contentManagement, 'sites')}
            ${eunis:br(actionBean.contentManagement)}

		<!-- END MAIN CONTENT -->
		</stripes:layout-component>
		<stripes:layout-component name="foot">
			<!-- start of the left (by default at least) column -->
				<div id="portal-column-one">
	            	<div class="visualPadding">
	              		<jsp:include page="/inc_column_left.jsp">
	                		<jsp:param name="page_name" value="designations/${actionBean.idGeo}:${actionBean.idDesig}" />
	              		</jsp:include>
	            	</div>
	          	</div>
	          	<!-- end of the left (by default at least) column -->
		</stripes:layout-component>
</stripes:layout-render>