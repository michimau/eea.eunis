<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Document - ${actionBean.dcIndex.title}" bookmarkPageName="references/${actionBean.idref}">
    <stripes:layout-component name="head">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eea_search.css">
    </stripes:layout-component>
	<stripes:layout-component name="contents">
			<!-- MAIN CONTENT -->
				<h1 class="documentFirstHeading">${actionBean.dcIndex.title}</h1>
				<br clear="all" />
				<div id="tabbedmenu">
                  <ul>
	              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
              		<c:choose>
              			<c:when test="${dataTab.id eq actionBean.tab}">
	              			<li id="currenttab">
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
	              				href="references/${actionBean.idref}/${dataTab.id}">${dataTab.value}</a>
	              			</li>
              			</c:when>
              			<c:otherwise>
              				<li>
	              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
	              				 href="references/${actionBean.idref}/${dataTab.id}">${dataTab.value}</a>
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
	                <h2>Reference information:</h2>
					<table width="90%" class="datatable">
						<col style="width:20%"/>
						<col style="width:80%"/>
						<tr>
							<th scope="row">Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.title)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Alternative title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.alternative)}</td>
						</tr>
						<tr>
							<th scope="row">Source</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.source)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Editor</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.editor)}</td>
						</tr>
						<tr>
							<th scope="row">Journal Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.journalTitle)}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Book Title</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.bookTitle)}</td>
						</tr>
						<tr>
							<th scope="row">Journal Issue</th>
							<td>${actionBean.dcIndex.journalIssue}</td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">ISBN</th>
							<td>${actionBean.dcIndex.isbn}</td>
						</tr>
						<tr>
							<th scope="row">URL</th>
							<td><a href="${eunis:replaceTags(actionBean.dcIndex.url)}">${eunis:replaceTags(actionBean.dcIndex.url)}</a></td>
						</tr>
						<tr class="zebraeven">
							<th scope="row">Created</th>
							<td>${actionBean.dcIndex.created}</td>
						</tr>
						<tr>
							<th scope="row">Publisher</th>
							<td>${eunis:replaceTags(actionBean.dcIndex.publisher)}</td>
						</tr>
						<c:if test="${!empty actionBean.dcAttributes}">
							<c:forEach items="${actionBean.dcAttributes}" var="attr" varStatus="loop">
								<tr ${loop.index % 2 != 0 ? '' : 'class="zebraeven"'}>
									<th scope="row">${attr.label}</th>
									<c:choose>
				              			<c:when test="${attr.type == 'reference'}">
					              			<td><a href="${eunis:replaceTags(attr.value)}">${eunis:replaceTags(attr.objectLabel)}</a></td>
				              			</c:when>
				              			
				              			<c:when test="${attr.type == 'localref'}">
					              			<td><a href="references/${eunis:replaceTags(attr.value)}">${eunis:replaceTags(attr.objectLabel)}</a></td>
				              			</c:when>
				              			
				              			<c:otherwise>
				              				<td>${eunis:replaceTags(attr.objectLabel)}</td>
				              			</c:otherwise>
				              		</c:choose>
								</tr>
							</c:forEach>
						</c:if>
					</table>
	            </c:if>
	            <c:if test="${actionBean.tab == 'species'}">
	            	<h2>List of species scientific names related to this reference:</h2>
	            	
	            	<form name="eunis" method="post" action="">
	            	<b>Species are listed: </b> 
	            	<input type="radio" name="listing" value="1" ${actionBean.listing eq 1 ? "checked " : "" }>by species group
	            	<input type="radio" name="listing" value="2" ${actionBean.listing eq 2 ? "checked " : "" }>ascending by name
	            	<input type="submit" name="listingform" value="Update">
	            	</form>
	            	
	            	<c:if test="${actionBean.listing eq 1 }">
		            	<c:forEach items="${actionBean.speciesGrouped}" var="speciesgroup" varStatus="outerloop">
		            		<h3>${speciesgroup.groupCommonName} - ${speciesgroup.groupScientificName}</h3>
							<ol>
			            	<c:forEach items="${speciesgroup.referenceSpecies}" var="spe" varStatus="loop">
			            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
		                            <a href="species/${spe.id}">${spe.name}<c:if test="${not empty spe.author}">, ${spe.author}</c:if></a>
		                        </li>
			            	</c:forEach>
							</ol>
						</c:forEach>
					</c:if>

					<c:if test="${actionBean.listing eq 2 }">
						<ol>
						<c:forEach items="${actionBean.speciesByName}" var="spe" varStatus="loop">
		            		<li style="background-color: ${loop.index % 2 == 0 ? '#FFFFFF' : '#EEEEEE'}">
	                            <a href="species/${spe.id}">${spe.name}<c:if test="${not empty spe.author}">, ${spe.author}</c:if></a>
	                        </li>
		            	</c:forEach>
                        </ol>
					</c:if>					
					
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
		</stripes:layout-component>
</stripes:layout-render>
