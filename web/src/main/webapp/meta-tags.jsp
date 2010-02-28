<%@ page import="ro.finsiel.eunis.search.Utilities"%>
<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : EUNIS meta tags
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
  String description = Utilities.formatString( request.getParameter( "metaDescription" ),
    "European nature information system web site, EUNIS database, Biological Diversity, European Environment, Species, Habitat types, Sites, Designations" );
%>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />

<meta name="description" content="<%=description%>" /> <!-- Used by google -->

<meta name="keywords" content="European, Nature, Information, EUNIS, Database, Biological, Diversity, Environment, Species, Habitat types, Sites, Designations" />

<link rel="start" title="Home" href="/" />

<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="expires" content="-1" />
