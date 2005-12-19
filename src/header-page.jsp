<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Common header
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.session.ThemeWrapper,
                 ro.finsiel.eunis.session.ThemeManager"%>
<jsp:include page="meta-tags.jsp"/>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<script type="text/javascript" language="JavaScript" src="script/msg-<%=SessionManager.getCurrentLanguage()%>.js"></script>
<script type="text/javascript" language="JavaScript" src="script/header.js"></script>
<script type="text/javascript" language="JavaScript" src="script/utils.js"></script>
<%
  // Select stylesheet
  ThemeWrapper currentTheme = SessionManager.getThemeManager().getCurrentTheme();
  if ( currentTheme.equals( ThemeManager.FRESH_ORANGE ) )
  {
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/css_fresh_orange.css" />
<%
  }
  else if ( currentTheme.equals( ThemeManager.NATURE_GREEN ) )
  {
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/css_nature_green.css" />
<%
  }
  else if ( currentTheme.equals( ThemeManager.CHERRY ) )
  {
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/css_cherry.css" />
<%
  }
  else if ( currentTheme.equals( ThemeManager.BLACKWHITE ) )
  {
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/css_black_white.css" />
<%
  }
  else
  {
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/css_sky_blue.css" />
<%
  }
%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/print.css" media="print" />
