<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Document">

	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
					<c:if test="${!empty actionBean.dcTitle}">
						<h2>DC_TITLE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcTitle.idDoc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_TITLE</td>
								<td>${actionBean.dcTitle.idTitle}</td>
							</tr>
							<tr>
								<td>Title</td>
								<td>${actionBean.dcTitle.title}</td>
							</tr>
							<tr class="zebraeven">
								<td>Alternative</td>
								<td>${actionBean.dcTitle.alternative}</td>
							</tr>
						</table>
					</c:if>
					<br/>
					<c:if test="${!empty actionBean.dcSource}">
						<h2>DC_SOURCE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcSource.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_TITLE</td>
								<td>${actionBean.dcSource.idSource}</td>
							</tr>
							<tr>
								<td>Source</td>
								<td>${actionBean.dcSource.source}</td>
							</tr>
							<tr class="zebraeven">
								<td>Editor</td>
								<td>${actionBean.dcSource.editor}</td>
							</tr>
							<tr>
								<td>Journal Title</td>
								<td>${actionBean.dcSource.journalTitle}</td>
							</tr>
							<tr class="zebraeven">
								<td>Book Title</td>
								<td>${actionBean.dcSource.bookTitle}</td>
							</tr>
							<tr>
								<td>Journal Issue</td>
								<td>${actionBean.dcSource.journalIssue}</td>
							</tr>
							<tr class="zebraeven">
								<td>ISBN</td>
								<td>${actionBean.dcSource.isbn}</td>
							</tr>
							<tr>
								<td>GEO Level</td>
								<td>${actionBean.dcSource.geoLevel}</td>
							</tr>
							<tr class="zebraeven">
								<td>URL</td>
								<td>${actionBean.dcSource.url}</td>
							</tr>
						</table>
					</c:if>

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