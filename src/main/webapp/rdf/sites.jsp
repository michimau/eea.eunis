<%@ page contentType="application/rdf+xml;charset=UTF-8"%>
<%!

public String escape(String x)
{
    return x.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");
}

public String create_property(String column_name, String value)
{
    if (value != null && !value.equals(""))
        return("<"+column_name.toLowerCase()+">" + escape(value) + "</"+column_name.toLowerCase()+">\n");
    else return "";
}

  String prefix = "http://eunis.eea.europa.eu/sites/";
  String localname = "ID_SITE";
  String rdftype = "rdf:Description";
  String strSQL = "SELECT ID_SITE FROM chm62edt_sites ORDER BY ID_SITE";

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  java.sql.Connection con = null;
  java.sql.Statement ps = null;
  java.sql.ResultSet rs = null;
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
  out.println("         xmlns:cr=\"http://cr.eionet.europa.eu/ontologies/contreg.rdf#\"");
  out.println("         xmlns=\"http://eunis.eea.europa.eu/rdf/sites-schema.rdf#\">");
  try {

    ps = con.createStatement();
    rs = ps.executeQuery(strSQL);
    java.sql.ResultSetMetaData rsmd = rs.getMetaData();
    int numberOfColumns = rsmd.getColumnCount();

    while(rs.next()) {
      out.println("<" + rdftype + " rdf:about=\"" + prefix + escape(rs.getString(localname)) + "\"/>");
    }

    out.println("</rdf:RDF>");

    con.close();


  } catch (Exception e) {
    e.printStackTrace();
  }
%>
