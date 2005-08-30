<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - Popup for list of values in search page. Also used in "Sites by designation types" function
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator,
                ro.finsiel.eunis.search.Utilities,
                java.util.Vector,
                ro.finsiel.eunis.search.SortListString,
                ro.finsiel.eunis.WebContentManagement"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain"%>
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist"%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.designations.DesignationsDomain"%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.designations.DesignationsPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();

  // getSearchString() - String to be searched
  String searchString = Utilities.formatString ( request.getParameter("searchString"), "" );
  Integer relationOp = Utilities.checkedStringToInt(request.getParameter("relationOp"),Utilities.OPERATOR_CONTAINS);

  // Contains true values if proper sourceDB checkbox was check
  boolean[] source_db =
  {
        request.getParameter( "DB_NATURA2000" ) != null && request.getParameter( "DB_NATURA2000" ).equalsIgnoreCase( "true" ),
        request.getParameter("DB_CORINE") != null && request.getParameter("DB_CORINE").equalsIgnoreCase("true") ? true : false,
        request.getParameter("DB_DIPLOMA") != null && request.getParameter("DB_DIPLOMA").equalsIgnoreCase("true") ? true : false,
        request.getParameter("DB_CDDA_NATIONAL") != null && request.getParameter("DB_CDDA_NATIONAL").equalsIgnoreCase("true") ? true : false,
        request.getParameter("DB_CDDA_INTERNATIONAL") != null && request.getParameter("DB_CDDA_INTERNATIONAL").equalsIgnoreCase("true") ? true : false,
        request.getParameter("DB_BIOGENETIC") != null && request.getParameter("DB_BIOGENETIC").equalsIgnoreCase("true") ? true : false,
        false,
        request.getParameter("DB_EMERALD") != null && request.getParameter("DB_EMERALD").equalsIgnoreCase("true") ? true : false
  };
  // List of sites source data set
  String[] db = {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic", "NatureNet", "Emerald"};
 // Execute de query
  StringBuffer sql= new StringBuffer("");
  if (!searchString.equalsIgnoreCase(""))
  {
    sql.append(Utilities.prepareSQLOperator("(J.DESCRIPTION",searchString,relationOp));
    sql.append(" OR "+Utilities.prepareSQLOperator("J.DESCRIPTION_EN",searchString,relationOp)+" OR "
                +Utilities.prepareSQLOperator("J.DESCRIPTION_FR",searchString,relationOp)+")");
  }
  sql = Utilities.getConditionForSourceDB(sql, source_db, db, "S");
  List designations = new DesignationsDomain().findWhere(sql + " GROUP BY J.DESCRIPTION,J.DESCRIPTION_EN");
  Vector v = new Vector();
  if (designations != null && designations.size() > 0)
  {
    for (int i = 0; i < designations.size(); i++)
    {
      DesignationsPersist designation = (DesignationsPersist)designations.get(i);
      // for designation
      if (Utilities.ifStringCorespund(designation.getDescription(),searchString,relationOp) &&
          !Utilities.ifStringAppear(v,designation.getDescription().trim()))
      {
        if (designation.getDescription().trim().length()>0)
         {
            v.addElement(designation.getDescription().trim());
         }
      }
      // for english designation
      if(Utilities.ifStringCorespund(designation.getDescriptionEn(),searchString,relationOp)&&
              !Utilities.ifStringAppear(v,designation.getDescriptionEn().trim()))
      {
        if (designation.getDescriptionEn().trim().length()>0)
          {
            v.addElement(designation.getDescriptionEn().trim());
          }
      }
      // for french designation
      if(Utilities.ifStringCorespund(designation.getDescriptionFr(),searchString,relationOp) &&
              !Utilities.ifStringAppear(v,designation.getDescriptionFr().trim()))
      {
        if (designation.getDescriptionFr().trim().length()>0)
        {
          v.addElement(designation.getDescriptionFr().trim());
        }
      }
    }
  }
  SortListString sorter = new SortListString();
  v = sorter.sort( v, false );
  int nr = v.size() >= Utilities.MAX_POPUP_RESULTS ? Utilities.MAX_POPUP_RESULTS : v.size();
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=contentManagement.getContent("sites_designations-choice_title", false )%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val)
      {
        window.opener.document.eunis.searchString.value=val;
        window.close();
      }
      function editContent( idPage )
      {
        var url = "web-content-inline-editor.jsp?idPage=" + idPage;
        window.open( url ,"", "width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0");
      }
      // -->
    </script>
  </head>
  <body>
<%
  if ( v.size() > 0 )
  {
    out.print( Utilities.getTextMaxLimitForPopup( contentManagement, v.size() ) );
%>
    <h6>List of values for:</h6>
<%
    if( searchString.equalsIgnoreCase( "" ) )
    {
%>
      All designations
<%
    }
    else
    {
%>
    <u>
      <%=contentManagement.getContent("sites_designations-choice_01")%>
    </u>
    <em>
      <%=Utilities.ReturnStringRelatioOp(relationOp)%>
    </em>
    <strong>
      <%=searchString%>
    </strong>
<%
    }
%>
    <br />
    <br />
    <div id="tab">
      <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int j=0;
    for ( int i = 0; i < nr; i++ )
    {
      String description = ( String ) v.get( i );
%>
        <tr>
          <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="Click link to select the value" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(description)%>');"><%=description%></a>
          </td>
        </tr>
<%
    }
%>
      </table>
    </div>
<%
//    if ( request.getParameter("displayWarning") == null || !request.getParameter("displayWarning").equalsIgnoreCase("no") )
//    {
//      out.print( Utilities.getTextWarningForPopup( v.size() ) );
//    }
  }
  else
  {
%>
    <strong>
      <%=contentManagement.getContent("sites_designations-choice_02")%>
    </strong>
<%
  }
%>
    <br />
    <form action="">
      <label for="close" class="noshow">Close window</label>
      <input id="close" name="close"  title="Close window" type="button" value="Close" onclick="javascript:window.close()" class="inputTextField" />
    </form>
  </body>
</html>