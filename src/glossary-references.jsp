<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup which shows the references for a glossary entry (from 'glossary' results search function).
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
      <%=contentManagement.getContent( "generic_glossary-references_title", false )%>
    </title>
  </head>
  <body>
    <div id="content">
<%
  // id - ID_DC from CHM62EDT_GLOSSARY table
  int id = Utilities.checkedStringToInt( request.getParameter("idDc"), -1 );
  // List of glossary references
  List l1 = new DcIndexDcSourceDomain().findWhere("DC_INDEX.ID_DC="+id);
  System.out.println( "l1.size() = " + l1.size() );
  if (l1.size() > 0)
  {
%>
      <h5>
        <%=contentManagement.getContent( "generic_glossary-references_01" )%>
      </h5>
      <br />
      <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr bgcolor="EEEEEE">
          <td width="183">
            <strong>
              <%=contentManagement.getContent( "generic_glossary-references_02" )%>
            </strong>
          </td>
          <td width="122">
            <strong>
              <%=contentManagement.getContent( "generic_glossary-references_03" )%>
            </strong>
          </td>
          <td width="126">
            <strong>
              <%=contentManagement.getContent( "generic_glossary-references_04" )%>
            </strong>
          </td>
          <td width="219">
            <strong>
              <%=contentManagement.getContent( "generic_glossary-references_05" )%>
            </strong>
          </td>
          <td width="84" align="center">
            <strong>
              <%=contentManagement.getContent( "generic_glossary-references_06" )%>
            </strong>
          </td>
        </tr>
<%
    for (int i = 0; i < l1.size(); i++)
    {
      DcIndexDcSourcePersist aRef = ((DcIndexDcSourcePersist) l1.get(i));
      String title=Utilities.formatString(aRef.getTitle());
      String source=Utilities.formatString(aRef.getSource());
      String editor=Utilities.formatString(aRef.getEditor());
      String publisher=Utilities.formatString(aRef.getPublisher());
      String dateRef=Utilities.formatReferencesDate(aRef.getCreated());
      // If one of them is not null
      if((editor+title+publisher+source).trim().length()>0)
      {
%>
        <tr bgcolor="<%out.print(i % 2 == 0 ? "#EEEEEE" : "#FFFFFF");%>">
          <td>
            <%=title%>
          </td>
          <td>
            <%=source%>
          </td>
          <td>
            <%=editor%>
          </td>
          <td>
            <%=publisher%>
          </td>
<%
        if (null!=aRef.getCreated())
        {
          String dt = Utilities.formatReferencesDate(aRef.getCreated());
%>
          <td align="center">
            <%=dt%>
          </td>
<%
        }
        else
        {
%>
          <td align="center">
            &nbsp;
          </td>
<%
        }
%>
        </tr>
      </table>
<%
      }
      else
      {
%>
      <br />
        <%=contentManagement.getContent( "generic_glossary-references_07" )%>
      <br />
<%
      }
    }
  }
  else
  {
%>
      <br />
      <%=contentManagement.getContent( "generic_glossary-references_07" )%>
<%
  }
%>
    <br />
    <label for="button" class="noshow">Close window</label>
    <input title="Close window" type="button" name="button" id="button" value="<%=contentManagement.getContent( "generic_glossary-references_08", false )%>" onclick="javascript:window.close();" class="inputTextField" />
    </div>
  </body>
</html>