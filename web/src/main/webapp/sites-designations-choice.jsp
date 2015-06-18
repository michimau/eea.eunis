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
<%@ page import="ro.finsiel.eunis.search.SourceDb" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // getSearchString() - String to be searched
  String searchString = Utilities.formatString ( request.getParameter("searchString"), "" );
  Integer relationOp = Utilities.checkedStringToInt(request.getParameter("relationOp"),Utilities.OPERATOR_CONTAINS);

    SourceDb sourceDb = SourceDb.noDatabase();

    sourceDb.add(SourceDb.Database.NATURA2000,
        request.getParameter("DB_NATURA2000") != null && request.getParameter("DB_NATURA2000").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CORINE,
        request.getParameter("DB_CORINE") != null && request.getParameter("DB_CORINE").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.DIPLOMA,
        request.getParameter("DB_DIPLOMA") != null && request.getParameter("DB_DIPLOMA").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CDDA_NATIONAL,
        request.getParameter("DB_CDDA_NATIONAL") != null && request.getParameter("DB_CDDA_NATIONAL").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.CDDA_INTERNATIONAL,
        request.getParameter("DB_CDDA_INTERNATIONAL") != null && request.getParameter("DB_CDDA_INTERNATIONAL").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.BIOGENETIC,
        request.getParameter("DB_BIOGENETIC") != null && request.getParameter("DB_BIOGENETIC").equalsIgnoreCase("true"));
    sourceDb.add(SourceDb.Database.EMERALD,
        request.getParameter("DB_EMERALD") != null && request.getParameter("DB_EMERALD").equalsIgnoreCase("true"));

 // Execute de query
  StringBuffer sql= new StringBuffer("");
  if (!searchString.equalsIgnoreCase(""))
  {
    sql.append(Utilities.prepareSQLOperator("(J.DESCRIPTION",searchString,relationOp));
    sql.append(" OR "+Utilities.prepareSQLOperator("J.DESCRIPTION_EN",searchString,relationOp)+" OR "
                +Utilities.prepareSQLOperator("J.DESCRIPTION_FR",searchString,relationOp)+")");
  }
  sql = Utilities.getConditionForSourceDB(sql, sourceDb, "S");
  List designations = new DesignationsDomain().findWhere(sql + " GROUP BY J.DESCRIPTION,J.DESCRIPTION_EN");
  Vector v = new Vector();
//  System.out.println( "designations = " + designations.size() );
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
      <%=cm.cmsPhrase("List of values")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
      function setLine(val)
      {
        window.opener.document.eunis.searchString.value=val;
        window.close();
      }
      //]]>
    </script>
  </head>
  <body>
<%
  if ( v.size() > 0 )
  {
    out.print( Utilities.getTextMaxLimitForPopup( cm, v.size() ) );
%>
    <h2>
      <%=cm.cmsPhrase("List of values for:")%>
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
      <%=cm.cms("designation_name")%>
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
      <table summary="<%=cm.cmsPhrase("List of values")%>" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    int j=0;
    for ( int i = 0; i < nr; i++ )
    {
      String description = ( String ) v.get( i );
%>
        <tr>
          <td bgcolor="<%=(0 == (j++ % 2)) ? "#EEEEEE" : "#FFFFFF"%>">
            <a title="<%=cm.cmsPhrase("Click link to select the value")%>" href="javascript:setLine('<%=Utilities.treatURLSpecialCharacters(description)%>');"><%=description%></a>
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
      <%=cm.cmsPhrase("No results were found.")%>
    </strong>
<%
  }
%>
    <br />
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    </form>
  </body>
</html>
