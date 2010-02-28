<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Document - ${actionBean.dcTitle.title}">
	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
				<h1 class="documentFirstHeading">${actionBean.dcTitle.title}</h1>
				<div class="documentActions">
					<h5 class="hiddenStructure">${eunis:cms(actionBean.contentManagement, 'Document Actions')}</h5>
					${eunis:cmsTitle(actionBean.contentManagement, 'Document Actions')}
					<ul>
						<li>
							<a href="javascript:this.print();">
								<img
									src="http://webservices.eea.europa.eu/templates/print_icon.gif"
									alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
									title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" />
							</a>
						</li>
					</ul>
				</div>
				<h2>Document information:</h2>
					<table width="90%" class="datatable">
						<col style="width:20%"/>
                  		<col style="width:80%"/>
						<tr>
							<td>Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcTitle.title)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Alternative title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcTitle.alternative)}</strong></td>
						</tr>
						<tr>
							<td>Source</td>
							<td><strong>${eunis:replaceTags(actionBean.dcSource.source)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Editor</td>
							<td><strong>${eunis:replaceTags(actionBean.dcSource.editor)}</strong></td>
						</tr>
						<tr>
							<td>Journal Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcSource.journalTitle)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Book Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcSource.bookTitle)}</strong></td>
						</tr>
						<tr>
							<td>Journal Issue</td>
							<td><strong>${actionBean.dcSource.journalIssue}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>ISBN</td>
							<td><strong>${actionBean.dcSource.isbn}</strong></td>
						</tr>
						<tr>
							<td>GEO Level</td>
							<td><strong>${actionBean.dcSource.geoLevel}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>URL</td>
							<td><a href="${eunis:replaceTags2(actionBean.dcSource.url, true, true)}">${eunis:replaceTags2(actionBean.dcSource.url, true, true)}</a></td>
						</tr>
						<c:if test="${!empty actionBean.dcDate}">
							<tr>
								<td>Created</td>
								<td><strong>${actionBean.dcDate.created}</strong></td>
							</tr>
						</c:if>
						<c:if test="${!empty actionBean.dcPublisher}">
							<tr class="zebraeven">
								<td>Publisher</td>
								<td><strong>${eunis:replaceTags(actionBean.dcPublisher.publisher)}</strong></td>
							</tr>
						</c:if>
					</table>

		<!-- END MAIN CONTENT -->
		</stripes:layout-component>
		<stripes:layout-component name="foot">
			<!-- start of the left (by default at least) column -->
				<div id="portal-column-one">
	            	<div class="visualPadding">
	              		<jsp:include page="/inc_column_left.jsp">
	                		<jsp:param name="page_name" value="documents/${actionBean.iddoc}" />
	              		</jsp:include>
	            	</div>
	          	</div>
	          	<!-- end of the left (by default at least) column -->
			</div>
			<!-- end of the main and left columns -->
			<div class="visualClear"><!-- --></div>
		</stripes:layout-component>
</stripes:layout-render>