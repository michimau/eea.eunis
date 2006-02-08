<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - Popup for list of values in search page. Also used in "Sites by designation types" function
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.List,
                ro.finsiel.eunis.search.Utilities,
                java.util.Vector,
                ro.finsiel.eunis.search.SortListString,
                ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.designations.DesignationsDomain"%>
<%@ page import="ro.finsiel.eunis.jrfTables.sites.designations.DesignationsPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
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
  System.out.println( "designations = " + designations.size() );
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=cm.cms("sites_designations-choice_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
      function setLine(val)
      {
        window.opener.document.eunis.searchString.value=val;
        window.close();
      }
      // -->
    </script>
  </head>
  <body>
<%
  if ( v.size() > 0 )
  {
    out.print( Utilities.getTextMaxLimitForPopup( cm, v.size() ) );
%>
    <h2>
      <%=cm.cmsText("list_of_values_for")%>
    </h2>
<%
    if( searchString.equalsIgnoreCase( "" ) )
    {
%>
      <%=cm.cms("sites_designations_choice_alldesignations")%>
<%
    }
    else
    {
%>
    <u>
      <%=cm.cms("sites_designations-choice_01")%>
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
      <table summary="<%=cm.cms("list_of_values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int j=0;
    for ( int i = 0; i < nr; i++ )
    {
      String description = ( String ) v.get( i );
%>
        <tr>
          <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cms("click_link_to_select_value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(description)%>');"><%=description%></a>
            <%=cm.cmsTitle("click_link_to_select_value")%>
          </td>
        </tr>
<%
    }
%>
      </table>
    </div>
<%
  }
  else
  {
%>
    <strong>
      <%=cm.cmsText("sites_designations-choice_02")%>
    </strong>
<%
  }
%>
    <br />
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_value")%>" title="<%=cm.cms("close_window_title")%>" id="button2" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close_window_title")%>
      <%=cm.cmsInput("close_window_value")%>
    </form>
    <%=cm.cmsMsg("sites_designations-choice_title")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("list_of_values")%>
  </body>
</html>