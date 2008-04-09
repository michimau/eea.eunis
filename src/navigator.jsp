<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Page result navigator
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
        ro.finsiel.eunis.session.ThemeWrapper,
        ro.finsiel.eunis.session.ThemeManager,
        ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  // INPUT VARIABLES. This must exist in your including JSP !!! If you DO NOT, compilation error would occurr. I think
  // this is good since all pages would 'speak same language' so would appear discrepancies. For example all Form Beans
  // will have to be named formBean or this code would not work etc etc etc...you know what I mean :))
  // AbstractFormBean formBean  - The form bean (I use currentPage from it for example)
  // int pagesCount             - Total number of 'pages'
  // String pageName            - Currently using jsp - the JSP where this page is included.
  // int guid                   - Global Unique Identifier - This is a plain number 0, 1, 2...used to be incremented
  //                              each time the page is included into a page because of the <form name='UNIQUE NAME">
  //                              pre-requisite (in plain english: There cannot be two forms in a page with the 
  //                              same name!). Cannot declare here due to compilation!
  // Vector navigatorFormFields - This Vector would contain the form fields you want to be spitted out :) on the page
  //                              For example let's suppose that you want to pass: "country", "region", "pageSize" ...
  //                              Then you construct a variable: Vector navigatorFormFields =
  //                              new Vector("country", "region", "pageSize") in your JSP. This is the only way I can
  //                              then safely re-query, and the request parameters would preserve from page to page when
  //                              submiting the form to change page (one declared below).
  WebContentManagement cm = SessionManager.getWebContent();
  int pagesCountNavigator = Utilities.checkedStringToInt(request.getParameter("pagesCount"), 0);
  int currentPageNavigator = Utilities.checkedStringToInt(request.getParameter("currentPage"), 0);
  String pageNameNavigator = request.getParameter("pageName");
  int guidNavigator = Utilities.checkedStringToInt(request.getParameter("guid"), 1);
  String toURLParam = request.getParameter("toURLParam");
  String toFORMParam = request.getParameter("toFORMParam");
  if (currentPageNavigator < 0) currentPageNavigator = 0;
  if (currentPageNavigator > pagesCountNavigator) currentPageNavigator = pagesCountNavigator - 1;
  String jpgFirst = "first_blue.jpg";
  String jpgLast = "last_blue.jpg";
  String jpgNext = "next_blue.jpg";
  String jpgPrev = "prev_blue.jpg";

  ThemeWrapper theme = SessionManager.getThemeManager().getCurrentTheme();
  if ( theme.equals( ThemeManager.FRESH_ORANGE ) )
  {
    jpgFirst = "first_orange.jpg";
    jpgLast = "last_orange.jpg";
    jpgNext = "next_orange.jpg";
    jpgPrev = "prev_orange.jpg";
  }
  if ( theme.equals( ThemeManager.CHERRY ) )
  {
    jpgFirst = "first_cherry.jpg";
    jpgLast = "last_cherry.jpg";
    jpgNext = "next_cherry.jpg";
    jpgPrev = "prev_cherry.jpg";
  }
  if ( theme.equals( ThemeManager.NATURE_GREEN ) )
  {
    jpgFirst = "first_green.jpg";
    jpgLast = "last_green.jpg";
    jpgNext = "next_green.jpg";
    jpgPrev = "prev_green.jpg";
  }
  if ( theme.equals( ThemeManager.BLACKWHITE ) )
  {
    jpgFirst = "first_bw.jpg";
    jpgLast = "last_bw.jpg";
    jpgNext = "next_bw.jpg";
    jpgPrev = "prev_bw.jpg";
  }


  if (pagesCountNavigator > 1)
  {
%>
  <br class="brClear" />
  <form name="changePage<%=guidNavigator%>" action="<%=pageNameNavigator%>" method="get" onsubmit="decrement<%=guidNavigator%>();">
    <table width="100%" border="0" cellpadding="0" cellspacing="3" bgcolor="#FFFFFF" summary="layout">
      <tr>
        <td width="20%" valign="middle">&nbsp;
<%
  // Go to the first page
  if (currentPageNavigator > 1)
  {
%>
          <a title="<%=cm.cms("first_page")%>" href="<%=pageNameNavigator + "?" + toURLParam%>&amp;currentPage=0"><img src="images/navigator/<%=jpgFirst%>" width="28" height="28" style="vertical-align:middle" border="0" title="<%=cm.cms("first_page")%>" alt="<%=cm.cms("first_page")%>" /></a>
          <%=cm.cmsTitle("first_page")%>
          <%=cm.cmsAlt("first_page")%>
<%
  }
  // Show previous page
  if (currentPageNavigator > 0)
  {
%>
          <a title="<%=cm.cms("previous_page")%>" href="<%=pageNameNavigator + "?" + toURLParam%>&amp;currentPage=<%=currentPageNavigator - 1%>"><img src="images/navigator/<%=jpgPrev%>" width="28" height="28" style="vertical-align:middle" border="0" title="<%=cm.cms("previous_page")%>" alt="<%=cm.cms("previous_page")%>" /></a>
          <%=cm.cmsTitle("previous_page")%>
          <%=cm.cmsAlt("previous_page")%>
<%
  }
%>
        </td>
<%
  // Always display currenyPage + 1, because page numbering is 0-based and user should see normal (page 1, 2 etc.)
%>
        <td width="35%" align="center" valign="middle">
          <strong>
            <%=cm.cmsPhrase("Current page")%>: <%=(currentPageNavigator + 1 > pagesCountNavigator) ? currentPageNavigator : currentPageNavigator + 1%> / <%=pagesCountNavigator%>
          </strong>
        </td>
        <td width="35%" align="center" valign="middle">
          <label for="currentPage<%=guidNavigator%>"><%=cm.cmsPhrase("Go to page")%>:</label>
          <input title="<%=cm.cms("navigator_goto_page_title")%>" class="inputTextFieldCenter" id="currentPage<%=guidNavigator%>" name="currentPage" type="text" size="3" value="<%=(currentPageNavigator + 1 > pagesCountNavigator) ? currentPageNavigator : currentPageNavigator + 1%>" />
          <input title="<%=cm.cms("change_page")%>" class="searchButton" type="submit" id="submit<%=guidNavigator%>" name="Submit" value="<%=cm.cms("change_page")%>" /><%=toFORMParam%>
          <%=cm.cmsInput("change_page")%>
        </td>
        <td width="16%" align="right" valign="middle">
<%
  // Show next page
  if (currentPageNavigator < pagesCountNavigator - 1)
  {
%>
          <a title="<%=cm.cms("next_page")%>" href="<%=pageNameNavigator + "?" + toURLParam%>&amp;currentPage=<%=currentPageNavigator + 1%>"><img src="images/navigator/<%=jpgNext%>" width="28" height="28" style="vertical-align:middle" border="0" title="<%=cm.cms("next_page")%>" alt="<%=cm.cms("next_page")%>" /></a>
          <%=cm.cmsTitle("next_page")%>
          <%=cm.cmsAlt("next_page")%>
<%
  }
  // Go to the last page
  if (currentPageNavigator < pagesCountNavigator - 2)
  {
%>
          <a title="<%=cm.cms("last_page")%>" href="<%=pageNameNavigator + "?" + toURLParam%>&amp;currentPage=<%=pagesCountNavigator - 1%>"><img src="images/navigator/<%=jpgLast%>" width="28" height="28" style="vertical-align:middle" border="0" title="<%=cm.cms("last_page")%>" alt="<%=cm.cms("last_page")%>" /></a>
          <%=cm.cmsTitle("last_page")%>
          <%=cm.cmsAlt("last_page")%>
<%
  }
%>
        </td>
      </tr>
    </table>
  </form>
  <script language="JavaScript" type="text/javascript">
    //<![CDATA[
      function decrement<%=guidNavigator%>() {
        var res<%=guidNavigator%> = parseInt(document.changePage<%=guidNavigator%>.currentPage.value);
        // Adjust the page so that we don't overflow.
        if (document.changePage<%=guidNavigator%>.currentPage.value > <%=pagesCountNavigator%>) {
          document.changePage<%=guidNavigator%>.currentPage.value = <%=pagesCountNavigator%> - 1;
          return;
        }
        document.changePage<%=guidNavigator%>.currentPage.value = res<%=guidNavigator%> - 1;
      }
    //]]>
  </script>
<%
  }
%>
