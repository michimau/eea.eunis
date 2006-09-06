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
  String idSpecies = request.getParameter("idSpecies");
   // Set SQL string
  String sql="";
  sql+="    SELECT";
  sql+="      `CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` AS `TYPE`,";
  sql+="      `DC_SOURCE`.`SOURCE`,";
  sql+="      `DC_SOURCE`.`EDITOR`,";
  sql+="      `DC_DATE`.`CREATED`,";
  sql+="      `DC_TITLE`.`TITLE`,";
  sql+="      `DC_PUBLISHER`.`PUBLISHER`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
  sql+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
  sql+="    WHERE";
  sql+="      (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONSERVATION_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))";
  sql+="    AND (`CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies+")";
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Synonyms' AS `TYPE`,";
  sql+="      `DC_SOURCE`.`SOURCE`,";
  sql+="      `DC_SOURCE`.`EDITOR`,";
  sql+="      `DC_DATE`.`CREATED`,";
  sql+="      `DC_TITLE`.`TITLE`,";
  sql+="      `DC_PUBLISHER`.`PUBLISHER`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
  sql+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES_LINK` = "+idSpecies;
  sql+="    AND `CHM62EDT_SPECIES`.`ID_SPECIES` <> "+idSpecies;
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Species' AS `TYPE`,";
  sql+="      `DC_SOURCE`.`SOURCE`,";
  sql+="      `DC_SOURCE`.`EDITOR`,";
  sql+="      `DC_DATE`.`CREATED`,";
  sql+="      `DC_TITLE`.`TITLE`,";
  sql+="      `DC_PUBLISHER`.`PUBLISHER`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
  sql+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies;
  sql+="    UNION";
  sql+="    SELECT";
  sql+="      'Taxonomy' AS `TYPE`,";
  sql+="      `DC_SOURCE`.`SOURCE`,";
  sql+="      `DC_SOURCE`.`EDITOR`,";
  sql+="      `DC_DATE`.`CREATED`,";
  sql+="      `DC_TITLE`.`TITLE`,";
  sql+="      `DC_PUBLISHER`.`PUBLISHER`";
  sql+="    FROM";
  sql+="      `CHM62EDT_SPECIES`";
  sql+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
  sql+="      INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
  sql+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
  sql+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
  sql+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
  sql+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
  sql+="    WHERE `CHM62EDT_SPECIES`.`ID_SPECIES` = "+idSpecies;
  sql+="    GROUP BY CHM62EDT_SPECIES.ID_NATURE_OBJECT,DC_INDEX.ID_DC,DC_SOURCE.SOURCE,DC_SOURCE.EDITOR,DC_TITLE.TITLE,DC_PUBLISHER.PUBLISHER,DC_DATE.CREATED";
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
    <%=cm.getText( "references" )%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet-references_09_Sum")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th width="25%">
          <%=cm.cmsText("title")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th width="25%">
          <%=cm.cmsText("author")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th width="15%">
          <%=cm.cmsText("editor")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th width="15%" style="text-align:right">
          <%=cm.cmsText("date")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
<%--        <td width="10%" align="center">--%>
<%--          <%=cm.cmsText("published")%>--%>
<%--        </td>--%>
        <th width="10%">
          <%=cm.cmsText("source")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
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
      String cssClass = i++ % 2 == 0 ? "" : " class=\"zebraeven\"";
      if(rs.getString(1) == null) source="&nbsp;"; else source=ro.finsiel.eunis.search.Utilities.FormatDatabaseFieldName(rs.getString(1));
      if(rs.getString(2) == null) author="&nbsp;"; else author=rs.getString(2);
      if(rs.getString(3) == null) editor="&nbsp;"; else editor=rs.getString(3);
      if(rs.getString(4) == null || rs.getString(4).equals(""))
      {
        date="&nbsp;";
      } else {
        date = Utilities.formatReferencesDate(rs.getDate(4));
      }
      if(rs.getString(5) == null) title="&nbsp;"; else title=rs.getString(5);
      //if(rs.getString(6) == null) publisher="&nbsp;"; else publisher=rs.getString(6);

%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.treatURLSpecialCharacters(title)%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(author)%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(editor)%>
        </td>
        <td style="text-align:right">
          <%=date%>
        </td>
<%--        <td>--%>
<%--          <%=publisher%>--%>
<%--        </td>--%>
        <td>
          <%=Utilities.treatURLSpecialCharacters(source)%>
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
<br />
