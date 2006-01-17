<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - Popup for list of values in search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List, java.util.Iterator, java.util.Vector,
                  ro.finsiel.eunis.search.species.habitats.HabitatePaginator,
                  java.util.Enumeration,
                  ro.finsiel.eunis.search.Utilities,
                  ro.finsiel.eunis.jrfTables.Chm62edtSpeciesDomain,
                  ro.finsiel.eunis.jrfTables.Chm62edtSpeciesPersist,
                  ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
    %>
    <title>
      <%=cm.cms("species_synonyms-choice_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
        function setLine(val) {
          window.opener.document.eunis.scientificName.value=val;
          window.close();
        }
      // -->
  </script>
  </head>
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.synonyms.SynonymsBean" scope="request">
  <jsp:setProperty name="formBean" property="*"/>
  </jsp:useBean>
  <%
    // Request parameters
    Integer oper = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
    String scientificName = Utilities.formatString(formBean.getScientificName(),"");
    // Prepare sql string
    String sql = (Utilities.prepareSQLOperator("SCIENTIFIC_NAME", scientificName, oper)).toString();
    // Not any group
    if (!formBean.getGroupName().equalsIgnoreCase("0"))
    {
      sql += " AND ID_GROUP_SPECIES = '"+ formBean.getGroupName() +"'";
    }
    sql += Utilities.showEUNISInvalidatedSpecies(" AND VALID_NAME",SessionManager.getShowEUNISInvalidatedSpecies());
    sql += " GROUP BY SCIENTIFIC_NAME LIMIT 0, " + Utilities.MAX_POPUP_RESULTS;
    List results = new Vector();
    try {
      // Get the result list
      results = new Chm62edtSpeciesDomain().findWhere(sql);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  %>
  <body style="background-color:#ffffff">
  <%
      if (results != null && results.size() > 0)
      {
        out.print(Utilities.getTextMaxLimitForPopup(cm,(results == null ? 0 : results.size())));
      }
    %>
    <%
      if (results != null && !results.isEmpty())
      {
    %>
        <h2><%=cm.cmsText("list_values_for")%></h2>
        <u>
          <%=cm.cmsText("species_synonyms-choice_01")%>
        </u>
        <em>
            <%=Utilities.ReturnStringRelatioOp(Utilities.checkedStringToInt(formBean.getRelationOp(),Utilities.OPERATOR_CONTAINS))%>
        </em>
        <strong><%=scientificName%></strong>
        <br /><br />
        <div id="tab">
        <table summary="<%=cm.cms("list_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
        <%
          for(int i = 0; i < results.size(); i++)
          {
            Chm62edtSpeciesPersist specie = (Chm62edtSpeciesPersist) results.get(i);
            if (!Utilities.formatString(specie.getScientificName()).equalsIgnoreCase(""))
            {
        %>
            <tr  style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
              <td>
                <a title="<%=cm.cms("choose_this_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getScientificName()))%>');"><%=Utilities.formatString(specie.getScientificName())%></a>
                <%=cm.cmsTitle("choose_this_value")%>
              </td>
            </tr>
        <%
            }
          }
        %>
      </table>
      </div>
      <%

      } else
      {
    %>
        <strong><%=cm.cmsText("species_synonyms-choice_02")%>.</strong>
        <br />
        <br />
    <%
      }
    %>
    <br />
    <form action="">
      <input id="button" title="<%=cm.cms("close")%>" type="button" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close")%>
      <%=cm.cmsInput("close_btn")%>
    </form>

<%=cm.br()%>
<%=cm.cmsMsg("species_synonyms-choice_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("list_values")%>
<%=cm.br()%>

  </body>
</html>