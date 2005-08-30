<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : List of values for references
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator, java.util.Vector,
                java.util.Enumeration,
               ro.finsiel.eunis.search.Utilities,
                net.sf.jrf.domain.PersistentObject,
                ro.finsiel.eunis.search.species.speciesByReferences.ReferencesForSpecies,
                ro.finsiel.eunis.search.References"%><%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>List of values</title>
  </head>
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.ReferencesBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>

    <script language="JavaScript" type="text/javascript">
    <!--
      function setLine(val,fromWhere,dateVal) {
       if (fromWhere == "author") window.opener.document.eunis.author.value=val;
        if (fromWhere == "date") {
         if (dateVal == 0) window.opener.document.eunis.date.value=val;
         if (dateVal == 1) window.opener.document.eunis.date.value=val;
         if (dateVal == 2) window.opener.document.eunis.date1.value=val;
        }
        if (fromWhere == "title") window.opener.document.eunis.title.value=val;
        if (fromWhere == "editor") window.opener.document.eunis.editor.value=val;
        if (fromWhere == "publisher") window.opener.document.eunis.publisher.value=val;
        window.close();
      }
    // -->
    </script>
  <%
    WebContentManagement contentManagement = SessionManager.getWebContent();

    // Set the database connection parameters
    String SQL_DRV="";
    String SQL_URL="";
    String SQL_USR="";
    String SQL_PWD="";

    SQL_DRV = application.getInitParameter("JDBC_DRV");
    SQL_URL = application.getInitParameter("JDBC_URL");
    SQL_USR = application.getInitParameter("JDBC_USR");
    SQL_PWD = application.getInitParameter("JDBC_PWD");
    // dateVal - what date form field was used
    String dateVal = (request.getParameter("dateVal") == null ? "0" : request.getParameter("dateVal"));

    boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);

    References references = new References(request.getParameter("author"),
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
                                SQL_DRV,
                                SQL_URL,
                                SQL_USR,
                                SQL_PWD);
    // Set references list
    references.setReferencesList((request.getParameter("fromWhere")==null?"":request.getParameter("fromWhere")),
                                 !expandFullNames);
    //get references list
    List results = references.getReferencesList();
      // forWhat - Search is made for this criterion
      String forWhat = "";
      // by author
      if (!(request.getParameter("author") == null ? "" : request.getParameter("author")).equalsIgnoreCase(""))
         {
            forWhat += Utilities.prepareHumanString(" - AUTHOR",
                                                    (request.getParameter("author") == null ? "" : request.getParameter("author")),
                                                    Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"),
                                                                                 Utilities.OPERATOR_CONTAINS));
            forWhat += " <br />";
         }
  // by date
  String date = request.getParameter("date");
  String date1 = request.getParameter("date1");
    if(
        (
          ( null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
           ||
          ( null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
        )
        &&
        null != request.getParameter("relationOpDate")
      )
    {
       Integer relationOpForDate = Utilities.checkedStringToInt(request.getParameter("relationOpDate"),Utilities.OPERATOR_IS);
       if(relationOpForDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0)
         {
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
      if (!(request.getParameter("title") == null ? "" : request.getParameter("title")).equalsIgnoreCase(""))
        {
          forWhat += Utilities.prepareHumanString(" - TITLE",
                                                  (request.getParameter("title") == null ? "" : request.getParameter("title")),
                                                   Utilities.checkedStringToInt(request.getParameter("relationOpTitle"),
                                                                                Utilities.OPERATOR_CONTAINS));
          forWhat += " <br />";
        }
      // by editor
      if (!(request.getParameter("editor") == null ? "" : request.getParameter("editor")).equalsIgnoreCase(""))
         {
           forWhat += Utilities.prepareHumanString(" - EDITOR",
                                                   (request.getParameter("editor") == null ? "" : request.getParameter("editor")),
                                                    Utilities.checkedStringToInt(request.getParameter("relationOpEditor"),
                                                                                 Utilities.OPERATOR_CONTAINS));
           forWhat += " <br />";
         }
      // by publisher
      if (!(request.getParameter("publisher") == null ? "" : request.getParameter("publisher")).equalsIgnoreCase(""))
         {
           forWhat += Utilities.prepareHumanString(" - PUBLISHER",
                                                   (request.getParameter("publisher") == null ? "" : request.getParameter("publisher")),
                                                    Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"),
                                                                                 Utilities.OPERATOR_CONTAINS));
           forWhat += " <br />";
         }

%>
<body>
<%
  if (results != null && results.size() > 0)
  {
    out.print(Utilities.getTextMaxLimitForPopup(contentManagement,(results == null ? 0 : results.size())));
  }
  // if result list is not empty, will display the title of the popup
  if (results != null && results.size() > 0)
  {
    String listOfWhat = "";
    // fromWhere - can be 'author', 'date', 'editor', 'publisher' or 'title'
    if(request.getParameter("fromWhere") != null)
    {
      listOfWhat = request.getParameter("fromWhere")+"s";
      if (request.getParameter("fromWhere").equalsIgnoreCase("date")) listOfWhat = "years";
    }
%>
    <h6>
      <%=contentManagement.getContent("species_references-choice_02")%>&nbsp;<%=listOfWhat%>&nbsp;for
    </h6>
    <strong>
      <%=contentManagement.getContent("species_references-choice_03")%>
      <%=forWhat.equalsIgnoreCase("") ? "" : "with following characteristics"%>&nbsp;:
    </strong>
    <br />

<%
   }
%>
    <strong><%=forWhat%></strong>
    <br />

      <%
        int j=0;
        // Display the result list
        if (results.size()>0)
        {
        if (results.size()==1&&((String) results.get(0)).equalsIgnoreCase(""))
          {
      %>
          <strong>
            <%=contentManagement.getContent("species_references-choice_04")%> <%=request.getParameter("fromWhere")%>.
          </strong>
          <br />
      <%
          }
          else
          {
      %>
            <div id="tab">
            <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
              <th class="resultHeader">
                Values
              </th>
      <%
            for(int i =0;i<results.size();i++)
            {
              String n = (String) results.get(i);
              if(!Utilities.formatString(n,"").equalsIgnoreCase(""))
              {
      %>
        <tr>
          <td style="background-color:<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="Choose this value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(Utilities.formatString(n))%>','<%=request.getParameter("fromWhere")%>','<%=dateVal%>');"><%=Utilities.formatString(n)%></a>
          </td>
       </tr>
 <%           }
            }
 %>
              </table>
              </div>
<%
         }
      }
      else
      {
 %>
              <strong>
                <%=contentManagement.getContent("species_references-choice_05")%>.
              </strong>
              <br />
       <%
        }
       %>

   <br />
   <form action="">
   <label for="button" class="noshow"><%=contentManagement.getContent("species_references-choice_06",false)%></label>
   <input id="button" title="<%=contentManagement.getContent("species_references-choice_06",false)%>" type="button" value="<%=contentManagement.getContent("species_references-choice_06",false)%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
   </form>
   <%=contentManagement.writeEditTag("species_references-choice_06")%>
  </body>
</html>