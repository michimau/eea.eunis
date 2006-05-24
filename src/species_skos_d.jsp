<%
  response.setContentType("text/xml;charset=UTF-8");

  String start = request.getParameter("start");
  if(start==null || start.length()==0) {
    start="0";
  }
  int start_from = new Integer(start).intValue();

  String size = request.getParameter("size");
  if(size==null || size.length()==0) {
    size="1";
  }
  int nr = new Integer(size).intValue();
  if(nr==0) {
    nr=10;
  }

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  java.sql.Connection con = null;
  java.sql.Statement ps = null;
  java.sql.Statement psNames = null;
  java.sql.ResultSet rs = null;
  java.sql.ResultSet rsNames = null;

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

  out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "\n");
  out.print("<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\">" + "\n");
  try {
    String strSQL = "SELECT a.ID_SPECIES,a.SCIENTIFIC_NAME,b.COMMON_NAME FROM CHM62EDT_SPECIES AS a";
    strSQL = strSQL + " LEFT OUTER JOIN CHM62EDT_GROUP_SPECIES b ON a.ID_GROUP_SPECIES = b.ID_GROUP_SPECIES";
    strSQL = strSQL + " LIMIT " + start_from + "," + nr;

    ps = con.createStatement();
    rs = ps.executeQuery(strSQL);

    String spec_id;
    String spec_scientific_name;
    String spec_group;
    java.util.HashMap languages = new java.util.HashMap();
    String spec_lang;
    String spec_name;

    while(rs.next()) {
      spec_id = rs.getString("ID_SPECIES");
      spec_scientific_name = rs.getString("SCIENTIFIC_NAME");
      spec_scientific_name = spec_scientific_name.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");
      spec_group = rs.getString("COMMON_NAME");
      spec_group = spec_group.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");

      out.print("<skos:Concept rdf:about=\""+"http://eunis.eea.eu.int/species/"+spec_id+"\">" + "\n");

      out.print("  <skos:prefLabel xml:lang=\"la\">" + "\n");
      out.print("    " + spec_scientific_name + "\n");
      out.print("  </skos:prefLabel>" + "\n");

      //insert vernacular names
      String strSQLNames = "SELECT distinct e.code ,c.value";
      strSQLNames = strSQLNames + " from chm62edt_species as a";
      strSQLNames = strSQLNames + " inner join chm62edt_reports as b on a.id_nature_object = b.id_nature_object";
      strSQLNames = strSQLNames + " inner join chm62edt_report_attributes as c on (b.id_report_attributes = c.id_report_attributes and c.name='VERNACULAR_NAME')";
      strSQLNames = strSQLNames + " inner join chm62edt_report_type as d on (b.id_report_type = d.id_report_type and d.lookup_type='language')";
      strSQLNames = strSQLNames + " inner join chm62edt_language as e on d.id_lookup = e.id_language";
      strSQLNames = strSQLNames + " where A.ID_SPECIES = " + spec_id;

      psNames = con.createStatement();
      rsNames = psNames.executeQuery(strSQLNames);

      languages.clear();

      while(rsNames.next()) {
        spec_lang = rsNames.getString("code");
        spec_name = rsNames.getString("value");
        spec_name = spec_name.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&apos;");

        if(!languages.containsKey(spec_lang)) {

          out.print("  <skos:prefLabel xml:lang=\""+spec_lang+"\">" + "\n");
          out.print("    " + spec_name + "\n");
          out.print("  </skos:prefLabel>" + "\n");

          languages.put(spec_lang, null);
        } else {
          out.print("  <skos:altLabel xml:lang=\""+spec_lang+"\">" + "\n");
          out.print("    " + spec_name + "\n");
          out.print("  </skos:altLabel>" + "\n");
        }
      }

      rsNames.close();
      psNames.close();

      out.print("  <skos:definition xml:lang=\"en\">" + "\n");
      out.print("    " + spec_scientific_name + " belongs to the " + spec_group + " group." + "\n");
      out.print("  </skos:definition>" + "\n");

      out.print("</skos:Concept>" + "\n");
    }

    rsNames.close();
    psNames.close();

    con.close();

    out.print("</rdf:RDF>");

  } catch (Exception e) {
    e.printStackTrace();
  }%>
