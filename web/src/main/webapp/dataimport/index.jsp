<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import";
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("Data Import") %>'></c:set>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
                <a name="documentContent"></a>
                <h1>
                  Data import and maintenance
                </h1>
<!-- MAIN CONTENT -->
<!--
		<fieldset><legend>XML Table importers</legend>
                <ul>
                	<li>
                		<a href="<%=domainName%>/dataimport/data-tester.jsp">Data tester</a><br/>
                		The purpose of this page is to test the XML formatted Oracle dumps from the EUNIS maintainer.
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/data-importer.jsp">Data importer</a><br/>
                		The purpose of this page is to import the XML formatted Oracle dumps into EUNIS database.
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/data-exporter.jsp">Data exporter</a><br/>
                		The purpose of this page is to export EUNIS database table into XML formatted Oracle dump.
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/schema-exporter.jsp">Schema exporter</a><br/>
                		The purpose of this page is to create XML schema from EUNIS database table structure.
                	</li>
                </ul>
		</fieldset>
-->
		<fieldset><legend>Maintenance</legend>
                <ul>
                	<li>
                		<a href="<%=domainName%>/dataimport/import-log.jsp">Background actions log</a><br/>
                		Log messages about background data import and post import scripts
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/post-import.jsp">Post import scripts</a><br/>
                		The purpose of this page is to run database scripts after import!
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/updatecountrysites">Update country sites factsheet</a><br/>
                		The purpose of this page is to update "chm62edt_country_sites_factsheet" table.
                	</li>
                </ul>
		</fieldset>
		<fieldset><legend>Dedicated importers</legend>
                <ul>
                	<li>
                		<a href="<%=domainName%>/dataimport/importcdda">Import National CDDA sites and designations</a><br/>
                		The purpose of this page is to import national CDDA sites and designations
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/importhabitats">Import habitats</a><br/>
                		The purpose of this page is to import habitats from XML formatted file into EUNIS database.
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/importredlist">Import Red List</a><br/>
                		The purpose of this page is to import red list information from XML formatted file into EUNIS database.
                	</li>
                	<li>
                		<a href="<%=domainName%>/dataimport/importpagelinks">Import page links</a><br/>
                		The purpose of this page is to import page links from geospecies database.
                	</li>
                </ul>
		</fieldset>
		<fieldset><legend>XML exporters</legend>
				<ul>
                	<li>
                		<a href="<%=domainName%>/dataimport/speciesdump">Generate species XML dump</a><br/>
                		The purpose of this page is to export all species from EUNIS database into XML file
                	</li>
                </ul>
		</fieldset>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>