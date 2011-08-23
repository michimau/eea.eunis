<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - references.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.sql.*,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String idSpecies = request.getParameter("mainIdSpecies");
   // Set SQL string
  String sql="";
  sql+="    SELECT";
  sql+="      `CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` AS `TYPE`,";
  sql+="      `DC_INDEX`.`SOURCE`,";
  sql+="      `DC_INDEX`.`EDITOR`,";
  sql+="      `DC_INDEX`.`CREATED`,";
  sql+="      `DC_INDEX`.`TITLE`,";
  sql+="      `DC_INDEX`.`PUBLISHER`,";
  sql+="      `DC_INDEX`.`ID_DC`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="    WHERE";
  sql+="      (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))";
  sql+="    AND (`CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies+")";
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Synonyms' AS `TYPE`,";
  sql+="      `DC_INDEX`.`SOURCE`,";
  sql+="      `DC_INDEX`.`EDITOR`,";
  sql+="      `DC_INDEX`.`CREATED`,";
  sql+="      `DC_INDEX`.`TITLE`,";
  sql+="      `DC_INDEX`.`PUBLISHER`,";
  sql+="      `DC_INDEX`.`ID_DC`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES_LINK` = "+idSpecies;
  sql+="    AND `CHM62EDT_SPECIES`.`ID_SPECIES` <> "+idSpecies;
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Species' AS `TYPE`,";
  sql+="      `DC_INDEX`.`SOURCE`,";
  sql+="      `DC_INDEX`.`EDITOR`,";
  sql+="      `DC_INDEX`.`CREATED`,";
  sql+="      `DC_INDEX`.`TITLE`,";
  sql+="      `DC_INDEX`.`PUBLISHER`,";
  sql+="      `DC_INDEX`.`ID_DC`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies;
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Taxonomy' AS `TYPE`,";
  sql+="      `DC_INDEX`.`SOURCE`,";
  sql+="      `DC_INDEX`.`EDITOR`,";
  sql+="      `DC_INDEX`.`CREATED`,";
  sql+="      `DC_INDEX`.`TITLE`,";
  sql+="      `DC_INDEX`.`PUBLISHER`,";
  sql+="      `DC_INDEX`.`ID_DC`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies;
  sql+="    GROUP BY CHM62EDT_SPECIES.ID_NATURE_OBJECT,DC_INDEX.ID_DC,DC_INDEX.SOURCE,DC_INDEX.EDITOR,DC_INDEX.TITLE,DC_INDEX.PUBLISHER,DC_INDEX.CREATED";
  try
  {
    // Set the database connection parameters
    String SQL_DRV = application.getInitParameter("JDBC_DRV");
    String SQL_URL = application.getInitParameter("JDBC_URL");
    String SQL_USR = application.getInitParameter("JDBC_USR");
    String SQL_PWD = application.getInitParameter("JDBC_PWD");

    Class.forName(SQL_DRV);
    Connection con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
    Statement ps = con.createStatement();
    ResultSet rs = ps.executeQuery(sql);
%>
  <h2>
    <%=cm.cmsPhrase( "References" )%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet-references_09_Sum")%>" class="listing fullwidth">
    <col style="width: 30%"/>
    <col style="width: 25%"/>
    <col style="width: 25%"/>
    <col style="width: 5%"/>
    <%-- <col style="width: 10%"/> --%>
    <col style="width: 15%"/>
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Title")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Author")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Editor")%>
        </th>
        <th style="text-align:right">
          <%=cm.cmsPhrase("Date")%>
        </th>
<%--        <td width="10%" align="center">--%>
<%--          <%=cm.cmsPhrase("Published")%>--%>
<%--        </td>--%>
        <th scope="col">
          <%=cm.cmsPhrase("Source")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    int i = 0;
    String source;
    String author;
    String editor;
    String date;
    String title;
    //String publisher;
    rs.beforeFirst();
    // Display results.
    while(rs.next())
    {
      String cssClass = i++ % 2 == 0 ? "zebraodd" : "zebraeven";
      if(rs.getString(1) == null) source="&nbsp;"; else source=Utilities.treatURLSpecialCharacters(ro.finsiel.eunis.search.Utilities.FormatDatabaseFieldName(rs.getString(1)));
      if(rs.getString(2) == null) author="&nbsp;"; else author=Utilities.treatURLSpecialCharacters(rs.getString(2));
      if(rs.getString(3) == null) editor="&nbsp;"; else editor=Utilities.treatURLSpecialCharacters(rs.getString(3));
      if(rs.getString(4) == null || rs.getString(4).equals(""))
      {
        date="&nbsp;";
      } else {
        date = Utilities.formatReferencesDate(rs.getDate(4));
      }
      if(rs.getString(5) == null) title="&nbsp;"; else title=Utilities.treatURLSpecialCharacters(rs.getString(5));
      //if(rs.getString(6) == null) publisher="&nbsp;"; else publisher=rs.getString(6);

%>
      <tr class="<%=cssClass%>">
        <td>
          <a href="references/<%=rs.getString(7)%>"><%=title%></a>
        </td>
        <td>
          <%=author%>
        </td>
        <td>
          <%=editor%>
        </td>
        <td class="number">
          <%=date%>
        </td>
<%--        <td>--%>
<%--          <%=publisher%>--%>
<%--        </td>--%>
        <td>
          <%=source%>
        </td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
<%
    ps.close();
    rs.close();
    con.close();
  }
  catch(Exception e)
  {
    System.out.println("Error executing SQL for Species references: "+sql);
    e.printStackTrace();
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-references_09_Sum")%>
<br />
