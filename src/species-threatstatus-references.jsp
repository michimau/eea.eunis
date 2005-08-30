<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species threat status' - references.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <%@ page import="java.util.*,
                   ro.finsiel.eunis.jrfTables.*,
                   ro.finsiel.eunis.search.Utilities,
                   ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("species_threatstatus-references_title", false )%>
    </title>
  </head>
<body style="background-color:#ffffff">
<div id="content">
    <%
      // References list for a species threat status
      List references = new DcIndexDcSourceDomain().findWhere("DC_INDEX.ID_DC ='"+request.getParameter("iddc")+"'");
      if (references != null && references.size() > 0)
      {
    %>
      <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0">
      <tr style="background-color:#CCCCCC">
        <td colspan="5" style="text-align:left">
          <span style="color:#000000">
            <%=contentManagement.getContent("species_threatstatus-references_01")%>
          </span>
          <span style="color:#000000">
            <strong>
              <%=request.getParameter("spname")%>
            </strong>
          </span>
          <span style="color:#000000">
            <%=contentManagement.getContent("species_threatstatus-references_02")%>
          </span>
          <span style="color:#000000"><strong><%=request.getParameter("threatst")%></strong>:</span>
        </td>
      </tr>
      <tr style="background-color:#EEEEEE">
        <td width="183">
          <strong>
            <%=contentManagement.getContent("species_threatstatus-references_03")%>
          </strong>
        </td>
        <td width="122">
          <strong>
            <%=contentManagement.getContent("species_threatstatus-references_04")%>
          </strong>
        </td>
        <td width="126">
          <strong>
            <%=contentManagement.getContent("species_threatstatus-references_05")%>
          </strong>
        </td>
        <td width="219">
          <strong>
            <%=contentManagement.getContent("species_threatstatus-references_06")%>
          </strong>
        </td>
        <td width="84" style="text-align:center">
          <strong>
            <%=contentManagement.getContent("species_threatstatus-references_07")%>
          </strong>
        </td>
      </tr>
      <%
        for (int i = 0;i<references.size();i++)
        {
          DcIndexDcSourcePersist aRef = ((DcIndexDcSourcePersist) references.get(i));
      %>
          <tr style="background-color:<%=(i%2==0 ? "#EEEEEE" : "#FFFFFF")%>">
            <td width="183"><%=Utilities.formatString(aRef.getTitle(),"&nbsp;")%></td>
            <td width="122"><%=Utilities.formatString(aRef.getSource(),"&nbsp;")%></td>
            <td width="126"><%=Utilities.formatString(aRef.getEditor(),"&nbsp;")%></td>
            <td width="219"><%=Utilities.formatString(aRef.getPublisher(),"&nbsp;")%></td>
            <td width="84" style="text-align:center"><%=Utilities.formatReferencesDate(aRef.getCreated())%>&nbsp;</td>
          </tr>
      <%
        }
      %>
      </table>
    <%
      }
      else
      {
    %>
        <%=contentManagement.getContent("species_threatstatus-references_08")%>
    <%
      }
    %>
    <p style="text-align:left">
      <label for="button" class="noshow"><%=contentManagement.getContent("species_threatstatus-references_09", false )%></label>  
      <input id="button" title="Close window" type="button" onclick="javascript:window.close();" value="<%=contentManagement.getContent("species_threatstatus-references_09", false )%>" name="button" class="inputTextField" />
      <%=contentManagement.writeEditTag( "species_threatstatus-references_09" )%>
    </p>
    </div>
  </body>
</html>