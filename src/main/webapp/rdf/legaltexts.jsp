<%@ page contentType="application/rdf+xml;charset=UTF-8"%>
<%!

public String escape(String x)
{
    return x.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");
}

public String create_literal_property(String column_name, String value)
{
    if (value != null && !value.equals(""))
        return("<"+column_name+">" + escape(value) + "</"+column_name+">\n");
    else return "";
}

public String create_resource_property(String column_name, String value)
{
    if (value != null && !value.equals(""))
        return("<"+column_name+" rdf:resource=\"" + escape(value) + "\"/>\n");
    else return "";
}

  String prefix = "http://eunis.eea.europa.eu/legaltexts/";
  String localname = "ID_DC";
  String rdftype = "LegalText";
  String strSQL = "select distinct chm62edt_reports.id_dc as id_dc, title, alternative, url as sourceDocument from chm62edt_reports, chm62edt_report_type,dc_title,dc_source where chm62edt_reports.ID_REPORT_TYPE = chm62edt_report_type.ID_REPORT_TYPE and LOOKUP_TYPE = \"LEGAL_STATUS\" and chm62edt_reports.id_dc = dc_title.id_dc and chm62edt_reports.id_dc = dc_source.id_dc";


%>
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  java.sql.Connection con = null;
  java.sql.Statement ps = null;
  java.sql.ResultSet rs = null;
  String cname;

  try
  {
    Class.forName(SQL_DRV);
  }
  catch (ClassNotFoundException e)
  {
    e.printStackTrace();
    return;
  }

  try {
    con = java.sql.DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }

//  out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
  out.println("<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"");
  out.println("         xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"");
  out.println("         xmlns=\"http://eunis.eea.europa.eu/rdf/legaltexts-schema.rdf#\">");
  try {

    ps = con.createStatement();
    rs = ps.executeQuery(strSQL);
    java.sql.ResultSetMetaData rsmd = rs.getMetaData();
    int numberOfColumns = rsmd.getColumnCount();

    while(rs.next()) {
      out.println("<" + rdftype + " rdf:about=\"" + prefix + escape(rs.getString(localname)) + "\">");

      for(int cn=1; cn <= numberOfColumns; cn++) {
          cname = rsmd.getColumnName(cn);
          if (cname.equals("sourceDocument"))
              out.print(create_resource_property(cname, rs.getString(cn)));
          else
              out.print(create_literal_property(cname, rs.getString(cn)));
      }

      out.println("</"+rdftype+">");


    }

    out.println("</rdf:RDF>");

    con.close();


  } catch (Exception e) {
    e.printStackTrace();
  }
%>
