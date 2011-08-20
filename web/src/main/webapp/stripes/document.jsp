<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Document - ${actionBean.dcIndex.title}">
	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
				<h1 class="documentFirstHeading">${actionBean.dcIndex.title}</h1>
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
				<br clear="all" />
				<div id="tabbedmenu">
                  <ul>
	              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
              		<c:choose>
              			<c:when test="${dataTab.id eq actionBean.tab}">
	              			<li id="currenttab">
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}" 
	              				href="documents/${actionBean.iddoc}/${dataTab.id}">${dataTab.value}</a>
	              			</li>
              			</c:when>
              			<c:otherwise>
              				<li>
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
	              				 href="documents/${actionBean.iddoc}/${dataTab.id}">${dataTab.value}</a>
	              			</li>
              			</c:otherwise>
              		</c:choose>
              		</c:forEach>
                  </ul>
                </div>
                <br style="clear:both;" clear="all" />
                <br />
                <c:if test="${actionBean.tab == 'general'}">
	               	<%-- General information--%>
	                <h2>Document information:</h2>
					<table width="90%" class="datatable">
						<col style="width:20%"/>
                  		<col style="width:80%"/>
						<tr>
							<td>Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.title)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Alternative title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.alternative)}</strong></td>
						</tr>
						<tr>
							<td>Source</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.source)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Editor</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.editor)}</strong></td>
						</tr>
						<tr>
							<td>Journal Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.journalTitle)}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>Book Title</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.bookTitle)}</strong></td>
						</tr>
						<tr>
							<td>Journal Issue</td>
							<td><strong>${actionBean.dcIndex.journalIssue}</strong></td>
						</tr>
						<tr class="zebraeven">
							<td>ISBN</td>
							<td><strong>${actionBean.dcIndex.isbn}</strong></td>
						</tr>
						<tr>
							<td>URL</td>
							<td><a href="${eunis:replaceTags(actionBean.dcIndex.url)}">${eunis:replaceTags(actionBean.dcIndex.url)}</a></td>
						</tr>
						<tr class="zebraeven">
							<td>Created</td>
							<td><strong>${actionBean.dcIndex.created}</strong></td>
						</tr>
						<tr>
							<td>Publisher</td>
							<td><strong>${eunis:replaceTags(actionBean.dcIndex.publisher)}</strong></td>
						</tr>
						<c:if test="${!empty actionBean.dcAttributes}">
							<c:forEach items="${actionBean.dcAttributes}" var="attr" varStatus="loop">
								<tr ${loop.index % 2 != 0 ? '' : 'class="zebraeven"'}>
									<td>${attr.name}</td>
									<c:choose>
				              			<c:when test="${attr.type == 'reference'}">
					              			<td><a href="${eunis:replaceTags(attr.value)}">${eunis:replaceTags(attr.value)}</a></td>
				              			</c:when>
				              			<c:otherwise>
				              				<td><strong>${eunis:replaceTags(attr.value)}</strong></td>
				              			</c:otherwise>
				              		</c:choose>
								</tr>
							</c:forEach>
						</c:if>
					</table>
	            </c:if>
	            <c:if test="${actionBean.tab == 'species'}">
	            	<h2>List of species scientific names related to this reference:</h2>
					<ol>
	            	<c:forEach items="${actionBean.species}" var="spe" varStatus="loop">
	            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
                            <a href="species/${spe.key}">${spe.value}</a>
                        </li>
	            	</c:forEach>
					</ol>
	            </c:if>
	            <c:if test="${actionBean.tab == 'habitats'}">
	            	<h2>List of habitats related to this reference:</h2>
					<ol>
	            	<c:forEach items="${actionBean.habitats}" var="habitat" varStatus="loop">
	            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
                            <a href="habitats/${habitat.key}">${habitat.value}</a>
                        </li>
	            	</c:forEach>
	            	</ol>
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
		</stripes:layout-component>
</stripes:layout-render>
