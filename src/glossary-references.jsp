<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup which shows the references for a glossary entry (from 'glossary' results search function).
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // id - ID_DC from CHM62EDT_GLOSSARY table
  int id = Utilities.checkedStringToInt( request.getParameter("idDc"), -1 );
  // List of glossary references
  List l1 = new DcIndexDcSourceDomain().findWhere("DC_INDEX.ID_DC="+id);
  if (l1.size() > 0)
  {
%>
      <table summary="layout" width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse : collapse; background-color : #DDDDDD;">
        <tr>
          <td width="183">
            <strong>
              <%=cm.cmsText( "title" )%>
            </strong>
          </td>
          <td width="122">
            <strong>
              <%=cm.cmsText( "author" )%>
            </strong>
          </td>
          <td width="126">
            <strong>
              <%=cm.cmsText( "editor" )%>
            </strong>
          </td>
          <td width="219">
            <strong>
              <%=cm.cmsText( "publisher" )%>
            </strong>
          </td>
          <td width="84" align="center">
            <strong>
              <%=cm.cmsText( "published" )%>
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
        <tr>
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
        <%=cm.cmsText( "generic_glossary-references_07" )%>
      <br />
<%
      }
    }
  }
%>