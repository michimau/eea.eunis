<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick habitat, show species' function - Popup for list of values in search page.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.habitats.HabitateSearchCriteria,
                 java.util.List,
                 java.util.Vector,
                 ro.finsiel.eunis.jrfTables.species.habitats.ScientificNameDomain,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title><%=contentManagement.getContent("species_habitats-choice_title", false )%></title>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.habitats.HabitateBean" scope="request">
    <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <script language="JavaScript" type="text/javascript">
  <!--
    function setLine(val) {
      window.opener.document.eunis.scientificName.value = val;
      window.close();
    }

      function editContent( idPage )
      {
        var url = "web-content-inline-editor.jsp?idPage=" + idPage;
        window.open( url ,'', 'width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0');
      }

  // -->
  </script>
  <%
    Integer relationOp = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    Integer searchAttribute = Utilities.checkedStringToInt(formBean.getSearchAttribute(), HabitateSearchCriteria.SEARCH_NAME);
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), ScientificNameDomain.SEARCH_EUNIS);
    List results = new Vector();
    // List of values (in accordance with searchAttribute)
    results = new ScientificNameDomain().findPopupLOV(new HabitateSearchCriteria(searchAttribute,
                                                                                          formBean.getScientificName(),
                                                                                          relationOp),
                                                                         database,
                                                                         searchAttribute,
                                                                         SessionManager.getShowEUNISInvalidatedSpecies());
  %>
  </head>
  <body>
  <%
      if (results != null && results.size() > 0)
      {
        out.print(Utilities.getTextMaxLimitForPopup(contentManagement,(results == null ? 0 : results.size())));
      }
    %>
    <%
      if (results != null && !results.isEmpty())
      {
        HabitateSearchCriteria habitatSearch = new HabitateSearchCriteria(searchAttribute,formBean.getScientificName(),relationOp);
    %>
        <h6>List of values for:</h6>
        <u><%=habitatSearch.getHumanMappings().get(searchAttribute)%></u>
    <%
        if (null != formBean.getScientificName() && null != relationOp)
        {
    %>
        <em><%=Utilities.ReturnStringRelatioOp(relationOp)%></em >
        <strong><%=formBean.getScientificName()%></strong>
    <%
        }
    %>
        <br />
        <br />
        <div id="tab">
        <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
        <%
          String rowBgColor = "";
          String value = "";
          // Display results.
          for(int i =0;i < results.size(); i++)
          {
            rowBgColor = (0 == (i % 2)) ? "#FFFFFF" : "#EEEEEE";
              value = (String)results.get(i);
        %>
            <tr style="background-color:<%=rowBgColor%>">
              <td>
                <a title="Choose this value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(value)%>');"><%=value%></a>
              </td>
            </tr>
        <%
          }
        %>
        </table>
        </div>
    <%
          //out.print(Utilities.getTextMaxLimitForPopup((results == null ? 0 : results.size())));
       }
      else
        {
    %>
       <strong><%=contentManagement.getContent("species_habitats-choice_01")%>.</strong> <br />
     <%
        }
     %>
      <br />
      <form action="">
        <label for="button" class="noshow"><%=contentManagement.getContent("species_habitats-choice_02", false )%></label>  
        <input id="button" title="Close window" type="button" value="<%=contentManagement.getContent("species_habitats-choice_02", false )%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
      </form>
      <%=contentManagement.writeEditTag( "species_habitats-choice_02" )%>
  </body>
</html>