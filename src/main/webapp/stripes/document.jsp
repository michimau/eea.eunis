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
					<c:if test="${!empty actionBean.dcSource}">
						<br/>
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
					<c:if test="${!empty actionBean.dcIndex}">
						<br/>
						<h2>DC_INDEX:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcIndex.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>COMMENT</td>
								<td>${actionBean.dcIndex.comment}</td>
							</tr>
							<tr>
								<td>REFCD</td>
								<td>${actionBean.dcIndex.refCd}</td>
							</tr>
							<tr class="zebraeven">
								<td>REFERENCE</td>
								<td>${actionBean.dcIndex.reference}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcContributor}">
						<br/>
						<h2>DC_CONTRIBUTOR:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcContributor.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_CONTRIBUTOR</td>
								<td>${actionBean.dcContributor.idContributor}</td>
							</tr>
							<tr>
								<td>CONTRIBUTOR</td>
								<td>${actionBean.dcContributor.contributor}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcCoverage}">
						<br/>
						<h2>DC_COVERAGE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcCoverage.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_COVERAGE</td>
								<td>${actionBean.dcCoverage.idCoverage}</td>
							</tr>
							<tr>
								<td>COVERAGE</td>
								<td>${actionBean.dcCoverage.coverage}</td>
							</tr>
							<tr class="zebraeven">
								<td>SPATIAL</td>
								<td>${actionBean.dcCoverage.spatial}</td>
							</tr>
							<tr>
								<td>TEMPORAL</td>
								<td>${actionBean.dcCoverage.temporal}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcCreator}">
						<br/>
						<h2>DC_CREATOR:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcCreator.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_CREATOR</td>
								<td>${actionBean.dcCreator.idCreator}</td>
							</tr>
							<tr>
								<td>CREATOR</td>
								<td>${actionBean.dcCreator.creator}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcDate}">
						<br/>
						<h2>DC_DATE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcDate.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_DATE</td>
								<td>${actionBean.dcDate.idDate}</td>
							</tr>
							<tr>
								<td>MDATE</td>
								<td>${actionBean.dcDate.mdate}</td>
							</tr>
							<tr class="zebraeven">
								<td>CREATED</td>
								<td>${actionBean.dcDate.created}</td>
							</tr>
							<tr>
								<td>VALID</td>
								<td>${actionBean.dcDate.valid}</td>
							</tr>
							<tr class="zebraeven">
								<td>AVAILABLE</td>
								<td>${actionBean.dcDate.available}</td>
							</tr>
							<tr>
								<td>ISSUED</td>
								<td>${actionBean.dcDate.issued}</td>
							</tr>
							<tr class="zebraeven">
								<td>MODIFIED</td>
								<td>${actionBean.dcDate.modified}</td>
							</tr>
					</table>
					</c:if>
					<c:if test="${!empty actionBean.dcDescription}">
						<br/>
						<h2>DC_DESCRIPTION:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcDescription.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_DESCRIPTION</td>
								<td>${actionBean.dcDescription.idDescription}</td>
							</tr>
							<tr>
								<td>DESCRIPTION</td>
								<td>${actionBean.dcDescription.description}</td>
							</tr>
							<tr class="zebraeven">
								<td>TOC</td>
								<td>${actionBean.dcDescription.toc}</td>
							</tr>
							<tr>
								<td>ABSTRACT</td>
								<td>${actionBean.dcDescription.abstr}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcFormat}">
						<br/>
						<h2>DC_FORMAT:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcFormat.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_FORMAT</td>
								<td>${actionBean.dcFormat.idFormat}</td>
							</tr>
							<tr>
								<td>FORMAT</td>
								<td>${actionBean.dcFormat.format}</td>
							</tr>
							<tr class="zebraeven">
								<td>EXTENT</td>
								<td>${actionBean.dcFormat.extent}</td>
							</tr>
							<tr>
								<td>MEDIUM</td>
								<td>${actionBean.dcFormat.medium}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcIdentifier}">
						<br/>
						<h2>DC_IDENTIFIER:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcIdentifier.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_IDENTIFIER</td>
								<td>${actionBean.dcIdentifier.idIdentifier}</td>
							</tr>
							<tr>
								<td>IDENTIFIER</td>
								<td>${actionBean.dcIdentifier.identifier}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcLanguage}">
						<br/>
						<h2>DC_LANGUAGE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcLanguage.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_LANGUAGE</td>
								<td>${actionBean.dcLanguage.idLanguage}</td>
							</tr>
							<tr>
								<td>LANGUAGE</td>
								<td>${actionBean.dcLanguage.language}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcPublisher}">
						<br/>
						<h2>DC_PUBLISHER:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcPublisher.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_PUBLISHER</td>
								<td>${actionBean.dcPublisher.idPublisher}</td>
							</tr>
							<tr>
								<td>PUBLISHER</td>
								<td>${actionBean.dcPublisher.publisher}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcRelation}">
						<br/>
						<h2>DC_RELATION:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcRelation.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_RELATION</td>
								<td>${actionBean.dcRelation.idRelation}</td>
							</tr>
							<tr>
								<td>RELATION</td>
								<td>${actionBean.dcRelation.relation}</td>
							</tr>
							<tr class="zebraeven">
								<td>IS_VERSION_OF</td>
								<td>${actionBean.dcRelation.isVersionOf}</td>
							</tr>
							<tr>
								<td>HAS_VERSION</td>
								<td>${actionBean.dcRelation.hasVersion}</td>
							</tr>
							<tr class="zebraeven">
								<td>IS_REPLACED_BY</td>
								<td>${actionBean.dcRelation.isReplacedBy}</td>
							</tr>
							<tr>
								<td>IS_REQUIRED_BY</td>
								<td>${actionBean.dcRelation.isRequiredBy}</td>
							</tr>
							<tr class="zebraeven">
								<td>REQUIRES</td>
								<td>${actionBean.dcRelation.requires}</td>
							</tr>
							<tr>
								<td>IS_PART_OF</td>
								<td>${actionBean.dcRelation.isPartOf}</td>
							</tr>
							<tr class="zebraeven">
								<td>HAS_PART</td>
								<td>${actionBean.dcRelation.hasPart}</td>
							</tr>
							<tr>
								<td>IS_REFERENCED_BY</td>
								<td>${actionBean.dcRelation.isReferencedBy}</td>
							</tr>
							<tr class="zebraeven">
								<td>REFERENCES</td>
								<td>${actionBean.dcRelation.references}</td>
							</tr>
							<tr>
								<td>IS_FORMAT_OF</td>
								<td>${actionBean.dcRelation.isFormatOf}</td>
							</tr>
							<tr class="zebraeven">
								<td>HAS_FORMAT</td>
								<td>${actionBean.dcRelation.hasFormat}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcRights}">
						<br/>
						<h2>DC_RIGHTS:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcRights.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_RIGHTS</td>
								<td>${actionBean.dcRights.idRights}</td>
							</tr>
							<tr>
								<td>RIGHTS</td>
								<td>${actionBean.dcRights.rights}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcSubject}">
						<br/>
						<h2>DC_SUBJECT:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcSubject.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_SUBJECT</td>
								<td>${actionBean.dcSubject.idSubject}</td>
							</tr>
							<tr>
								<td>SUBJECT</td>
								<td>${actionBean.dcSubject.subject}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${!empty actionBean.dcType}">
						<br/>
						<h2>DC_TYPE:</h2>
						<table width="90%" class="datatable">
							<col style="width:20%"/>
                      		<col style="width:80%"/>
                      		<tr>
								<td>ID_DC</td>
								<td>${actionBean.dcType.idDc}</td>
							</tr>
							<tr class="zebraeven">
								<td>ID_TYPE</td>
								<td>${actionBean.dcType.idType}</td>
							</tr>
							<tr>
								<td>TYPE</td>
								<td>${actionBean.dcType.type}</td>
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