<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show habitats' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain, ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesForHabitats,
                java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=cm.cms("list_of_values")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
   function setLine(val,fromWhere,witchDateUse) {
    if (fromWhere == "author") window.opener.document.eunis.author.value=val;
     if (fromWhere == "date") {
      if (witchDateUse == 0) window.opener.document.eunis.date.value=val;
      if (witchDateUse == 1) window.opener.document.eunis.date.value=val;
      if (witchDateUse == 2) window.opener.document.eunis.date1.value=val;
     }
     if (fromWhere == "title") window.opener.document.eunis.title.value=val;
     if (fromWhere == "editor") window.opener.document.eunis.editor.value=val;
     if (fromWhere == "publisher") window.opener.document.eunis.publisher.value=val;
     window.close();
   }
 //]]>
  </script>
</head>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
<%
  // Request parameters
  String witchDateUse = (request.getParameter("witchDateUse") == null ? "0" : request.getParameter("witchDateUse"));
  boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);

  ReferencesForHabitats ref = new ReferencesForHabitats(
    request.getParameter("author"),
    Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"),
                                 Utilities.OPERATOR_CONTAINS),
    request.getParameter("date"),
    request.getParameter("date1"),
    Utilities.checkedStringToInt(request.getParameter("relationOpDate"),
                                 Utilities.OPERATOR_IS),
    request.getParameter("title"),
    Utilities.checkedStringToInt(request.getParameter("relationOpTitle"),
                                 Utilities.OPERATOR_CONTAINS),
    request.getParameter("publisher"),
    Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"),
                                 Utilities.OPERATOR_CONTAINS),
    request.getParameter("editor"),
    Utilities.checkedStringToInt(request.getParameter("relationOpEditor"),
                                 Utilities.OPERATOR_CONTAINS),
    Utilities.checkedStringToInt(request.getParameter("database"),
                                 RefDomain.SEARCH_BOTH),
    Utilities.checkedStringToInt(request.getParameter("source"),
                                 RefDomain.SOURCE));

  // Set references list
  ref.setReferencesList((request.getParameter("fromWhere") == null ? "" : request.getParameter("fromWhere")),
                        !expandFullNames);
  //get references list
  List results = ref.getReferencesList();

  // forWhat - Search is made for this criterion
  String forWhat = "";

  // by author
  if(!(request.getParameter("author") == null ? "" : request.getParameter("author")).equalsIgnoreCase("")) {
    forWhat += Utilities.prepareHumanString(" - AUTHOR",
                                            (request.getParameter("author") == null ? "" : request.getParameter("author")),
                                            Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"),
                                                                         Utilities.OPERATOR_CONTAINS));
    forWhat += " <br />";
  }

  // by date
  String date = Utilities.formatString(request.getParameter("date"), "");
  String date1 = Utilities.formatString(request.getParameter("date1"), "");
  if(((!date.equalsIgnoreCase("")) || (!date1.equalsIgnoreCase(""))) &&
    null != request.getParameter("relationOpDate")) {

    Integer relationOpForDate = Utilities.checkedStringToInt(request.getParameter("relationOpDate"), Utilities.OPERATOR_IS);
    if(relationOpForDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
      if(date == null || (date != null && date.equalsIgnoreCase("")))
        relationOpForDate = Utilities.OPERATOR_SMALLER_OR_EQUAL;
      if(date1 == null || (date1 != null && date1.equalsIgnoreCase("")))
        relationOpForDate = Utilities.OPERATOR_GREATER_OR_EQUAL;
      if(date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase(""))
        relationOpForDate = Utilities.OPERATOR_BETWEEN;
    }

    forWhat += Utilities.prepareHumanString(" - YEAR", (date == null || date.equalsIgnoreCase("") ? date1 : date), date, date1, relationOpForDate);

    forWhat += " <br />";
  }

  // by title
  if(!(request.getParameter("title") == null ? "" : request.getParameter("title")).equalsIgnoreCase("")) {
    forWhat += Utilities.prepareHumanString(" - TITLE",
                                            (request.getParameter("title") == null ? "" : request.getParameter("title")),
                                            Utilities.checkedStringToInt(request.getParameter("relationOpTitle"),
                                                                         Utilities.OPERATOR_CONTAINS));
    forWhat += " <br />";
  }

  // by editor
  if(!(request.getParameter("editor") == null ? "" : request.getParameter("editor")).equalsIgnoreCase("")) {
    forWhat += Utilities.prepareHumanString(" - EDITOR",
                                            (request.getParameter("editor") == null ? "" : request.getParameter("editor")),
                                            Utilities.checkedStringToInt(request.getParameter("relationOpEditor"),
                                                                         Utilities.OPERATOR_CONTAINS));
    forWhat += " <br />";
  }

  // by publisher
  if(!(request.getParameter("publisher") == null ? "" : request.getParameter("publisher")).equalsIgnoreCase("")) {
    forWhat += Utilities.prepareHumanString(" - PUBLISHER",
                                            (request.getParameter("publisher") == null ? "" : request.getParameter("publisher")),
                                            Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"),
                                                                         Utilities.OPERATOR_CONTAINS));
    forWhat += " <br />";
  }
%>
<body>
<%
  if(results != null && results.size() > 0) {
    out.print(Utilities.getTextMaxLimitForPopup(cm, (results == null ? 0 : results.size())));
  }
%>
<%
  // if result list is not empty, will display the title of the popup
  if(results != null && results.size() > 0) {
    String listOfWhat = "";
    // fromWhere - can be 'author', 'date', 'editor', 'publisher' or 'title'
    if(request.getParameter("fromWhere") != null) {
      listOfWhat = request.getParameter("fromWhere") + "s";
      if(request.getParameter("fromWhere").equalsIgnoreCase("date")) listOfWhat = "years dates";
    }
%>
<h2>
  <%=cm.cmsText("list_of")%> <%=listOfWhat%> <%=cm.cms("references")%> <%=forWhat.equalsIgnoreCase("") ? "" : cm.cmsText("with_following_characteristics")%>:
  <br />
  <%=forWhat%>
</h2>
<br />
<br />
<%
  }
%>
<div id="tab">
<table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
  <tr>
    <th>
     <%=cm.cmsText("list_of_values")%>
    </th>
  </tr>
  <%
    int j = 0;
    // Display the result list
    if(results != null && results.size() > 0) {
      // is true if was displayed something not null and != ''
      boolean wasPrintSomething = false;
      for(int i = 0; i < results.size(); i++) {
        HabitatsBooksPersist n = (HabitatsBooksPersist) results.get(i);
        if(request.getParameter("fromWhere").equalsIgnoreCase("author") &&
          !Utilities.formatString(n.getsource(), "").equalsIgnoreCase("")) {
          wasPrintSomething = true;
  %>
  <tr>
    <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.getsource()))%>','<%=request.getParameter("fromWhere")%>','<%=witchDateUse%>');"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.getsource()))%></a>
      <%=cm.cmsTitle("click_link_to_select_value")%>
    </td>
  </tr>
  <%
    }
    if(request.getParameter("fromWhere").equalsIgnoreCase("date") &&
      !Utilities.formatReferencesDate(n.getcreated()).equalsIgnoreCase("")) {
      wasPrintSomething = true;
  %>
  <tr>
    <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.formatReferencesDate(n.getcreated())%>','<%=request.getParameter("fromWhere")%>','<%=witchDateUse%>');"><%=Utilities.formatReferencesDate(n.getcreated())%></a>
      <%=cm.cmsTitle("click_link_to_select_value")%>
    </td>
  </tr>
  <%
    }
    if(request.getParameter("fromWhere").equalsIgnoreCase("title") &&
      !Utilities.formatString(n.gettitle(), "").equalsIgnoreCase("")) {
      wasPrintSomething = true;
  %>
  <tr>
    <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.gettitle()))%>','<%=request.getParameter("fromWhere")%>','<%=witchDateUse%>');"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.gettitle()))%></a>
      <%=cm.cmsTitle("click_link_to_select_value")%>
    </td>
  </tr>
  <%
    }
    if(request.getParameter("fromWhere").equalsIgnoreCase("editor") &&
      !Utilities.formatString(n.geteditor(), "").equalsIgnoreCase("")) {
      wasPrintSomething = true;
  %>
  <tr>
    <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.geteditor()))%>','<%=request.getParameter("fromWhere")%>','<%=witchDateUse%>');"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.geteditor()))%></a>
      <%=cm.cmsTitle("click_link_to_select_value")%>
    </td>
  </tr>
  <%
    }
    if(request.getParameter("fromWhere").equalsIgnoreCase("publisher") && !Utilities.formatString(n.getpublisher(), "").equalsIgnoreCase("")) {
      wasPrintSomething = true;
  %>
  <tr>
    <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
      <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.getpublisher()))%>','<%=request.getParameter("fromWhere")%>','<%=witchDateUse%>');"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(n.getpublisher()))%></a>
      <%=cm.cmsTitle("click_link_to_select_value")%>
    </td>
  </tr>
  <%
      }
    }
    if(!wasPrintSomething) {
  %>
  <tr>
    <td>
      <strong>
        <%=cm.cmsText("no_details_recorded")%> <%=request.getParameter("fromWhere")%>.
      </strong>
    </td>
  </tr>
  <%
    }
  } else {
  %>
  <tr>
    <td>
      <strong>
        <%=cm.cmsText("no_results_found")%>.
      </strong>
    </td>
  </tr>
  <%
    }
  %>
</table>
</div>
<%
  // out.print(Utilities.getTextMaxLimitForPopup((results == null ? 0 : results.size())));
%>
<form action="">
  <input title="<%=cm.cms("close_window")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" id="button" name="button" class="standardButton" />
  <%=cm.cmsInput("close_btn")%>
</form>
<%=cm.cms("list_of_values")%>
<%=cm.br()%>
<%=cm.cmsTitle("list_of_values")%>
</body>
</html>
