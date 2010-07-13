<%
  response.setContentType("application/xml;charset=UTF-8");

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  java.sql.Connection con = null;
  java.sql.Statement ps = null;
  java.sql.ResultSet rs = null;

  int batch_size = 50000;
  int count;
  int start;

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

  out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
  out.println("<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");
  out.println("<sitemap><loc>http://eunis.eea.europa.eu/sitemap-files.xml</loc></sitemap>");

  try {
    ps = con.createStatement();

    // Species
    rs = ps.executeQuery("SELECT COUNT(*) FROM CHM62EDT_SPECIES WHERE ID_SPECIES=ID_SPECIES_LINK");
    rs.first();
    start = 0;
    count = rs.getInt(1);
    while (count > 0) {
      out.println("<sitemap><loc>" + application.getInitParameter( "DOMAIN_NAME" ) + "/sitemap-species.jsp?start=" + start +
                  "&amp;size=" + batch_size + "</loc></sitemap>");
      count -= batch_size;
      start += batch_size;
    }


    // Sites
    rs = ps.executeQuery("SELECT COUNT(*) FROM CHM62EDT_SITES");
    rs.first();
    start = 0;
    count = rs.getInt(1);
    while (count > 0) {
      out.println("<sitemap><loc>" + application.getInitParameter( "DOMAIN_NAME" ) + "/sitemap-sites.jsp?start=" + start +
                  "&amp;size=" + batch_size + "</loc></sitemap>");
      count -= batch_size;
      start += batch_size;
    }
    
 	// Habitats
    rs = ps.executeQuery("SELECT COUNT(*) FROM CHM62EDT_HABITAT");
    rs.first();
    start = 0;
    count = rs.getInt(1);
    while (count > 0) {
      out.println("<sitemap><loc>" + application.getInitParameter( "DOMAIN_NAME" ) + "/sitemap-habitats.jsp?start=" + start +
                  "&amp;size=" + batch_size + "</loc></sitemap>");
      count -= batch_size;
      start += batch_size;
    }

    con.close();



  } catch (Exception e) {
    response.setContentType("text/plain;charset=UTF-8");
    e.printStackTrace();
  }
  out.println("</sitemapindex>");
%>
