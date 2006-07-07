<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : List of values (popup) used for 'Advanced search' and 'Combined search' functions.
  - Request params :
      * ctl - ID of the control
      * lov - List of value type
      * natureobject - The nature object type
      * val - value/part of the value which is part of the search.
      * oper - Relation operator between criteria and value
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.sql.Connection,
                 java.sql.Statement,
                 java.sql.DriverManager,
                 java.sql.ResultSet"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
    <title><%=cm.cms("list_of_values")%></title>
  <%
    // Request parameters
    String ctl = request.getParameter("ctl");
    String lov = request.getParameter("lov");

    /*
    if(lov.equalsIgnoreCase("LifeForm")) {
      lov = "Life_Form";
    }
    if(lov.equalsIgnoreCase("LightIntensity")) {
      lov = "Light_Intensity";
    }
    if(lov.equalsIgnoreCase("DistributionStatus")) {
      lov = "Distribution_Status";
    }
    if(lov.equalsIgnoreCase("HumanActivity")) {
      lov = "Human_Activity";
    }
    */

    String natureobject = request.getParameter("natureobject");
    String val = request.getParameter("val");
    if(val == null  || val.equalsIgnoreCase("enter value here...")) {
      val="";
    }
    String oper = request.getParameter("oper");
    //System.out.println("oper = " + oper);
    //System.out.println("val = " + val);
    if(oper.equalsIgnoreCase("Equal") && val.equalsIgnoreCase("")) {
      oper="Contains";
      val="%";
    }
//    out.println("ctl="+ctl+"<br />");
//    out.println("lov="+lov+"<br />");
//    out.println("val="+val+"<br />");
//    out.println("natureobject="+natureobject+"<br />");
//    out.println("oper="+oper+"<br />");
  %>

  <script language="JavaScript" type="text/javascript">
  <!--
    function setValue(v) {
      window.opener.setCurrentSelected("");
      window.opener.document.criteria['<%=ctl%>'].focus();
      window.opener.document.criteria['<%=ctl%>'].value=v;
      window.opener.document.criteria['<%=ctl%>'].blur();
      window.close();
    }
  // -->
  </script>
  </head>
  <body>
<%
  // Set the database connection parameters
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  String SQL="";
  Connection con = null;
  Statement ps = null;
  ResultSet rs = null;

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
    con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
  }
  catch(Exception e) {
    e.printStackTrace();
    return;
  }

  // Create SQL string
  if(lov.equalsIgnoreCase("Altitude") ||
     lov.equalsIgnoreCase("Chemistry") ||
     lov.equalsIgnoreCase("Water") ||
     lov.equalsIgnoreCase("Usage") ||
     lov.equalsIgnoreCase("Ph") ||
     lov.equalsIgnoreCase("Climate") ||
     lov.equalsIgnoreCase("Cover") ||
     lov.equalsIgnoreCase("Depth") ||
     lov.equalsIgnoreCase("Geomorph") ||
     lov.equalsIgnoreCase("Humidity") ||
     lov.equalsIgnoreCase("Life_Form") ||
     lov.equalsIgnoreCase("Light_Intensity") ||
     lov.equalsIgnoreCase("Distribution_Status") ||
     lov.equalsIgnoreCase("Human_Activity") ||
     lov.equalsIgnoreCase("Motivation") ||
     lov.equalsIgnoreCase("Marine") ||
     lov.equalsIgnoreCase("Geology") ||
     lov.equalsIgnoreCase("Salinity") ||
     lov.equalsIgnoreCase("Spatial") ||
     lov.equalsIgnoreCase("Temperature") ||
     lov.equalsIgnoreCase("Influences") ||
     lov.equalsIgnoreCase("Substrate") ||
     lov.equalsIgnoreCase("Temporal") ||
     lov.equalsIgnoreCase("Tidal")) {

   if(oper.equalsIgnoreCase("Equal")) {
     SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+lov.toUpperCase()+" WHERE NAME='"+ val + "' ORDER BY ID_"+lov.toUpperCase();
   } else {
     if(oper.equalsIgnoreCase("Contains")) {
       SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+lov.toUpperCase()+" WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_"+lov.toUpperCase();
     } else {
       if(oper.equalsIgnoreCase("Between")) {
         SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+lov.toUpperCase()+" WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_"+lov.toUpperCase();
       } else {
         SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+lov.toUpperCase()+" ORDER BY ID_"+lov.toUpperCase();
       }
     }
   }
 }

  String splitLov = "";
  if(lov.equalsIgnoreCase("LifeForm")) {
    splitLov = "Life_Form";
  }
  if(lov.equalsIgnoreCase("LightIntensity")) {
    splitLov = "Light_Intensity";
  }
  if(lov.equalsIgnoreCase("DistributionStatus")) {
    splitLov = "Distribution_Status";
  }
  if(lov.equalsIgnoreCase("HumanActivity")) {
    splitLov = "Human_Activity";
  }

  if(lov.equalsIgnoreCase("LifeForm") ||
     lov.equalsIgnoreCase("LightIntensity") ||
     lov.equalsIgnoreCase("DistributionStatus") ||
     lov.equalsIgnoreCase("HumanActivity")) {
   if(oper.equalsIgnoreCase("Equal")) {
     SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+splitLov.toUpperCase()+" WHERE NAME='"+ val + "' ORDER BY ID_"+splitLov.toUpperCase();
   } else {
     if(oper.equalsIgnoreCase("Contains")) {
       SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+splitLov.toUpperCase()+" WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_"+splitLov.toUpperCase();
     } else {
       if(oper.equalsIgnoreCase("Between")) {
         SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+splitLov.toUpperCase()+" WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_"+splitLov.toUpperCase();
       } else {
         SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_"+splitLov.toUpperCase()+" ORDER BY ID_"+splitLov.toUpperCase();
       }
     }
   }
  }

  if(lov.equalsIgnoreCase("LegalInstrument")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT `DC_TITLE`.`TITLE`,`DC_TITLE`.`ALTERNATIVE` FROM  `DC_INDEX` INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`REFERENCE` = `DC_TITLE`.`ID_DC`) WHERE `DC_TITLE`.`TITLE`='"+ val + "' ORDER BY `DC_TITLE`.`TITLE`";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT `DC_TITLE`.`TITLE`,`DC_TITLE`.`ALTERNATIVE` FROM  `DC_INDEX` INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`REFERENCE` = `DC_TITLE`.`ID_DC`) WHERE `DC_TITLE`.`TITLE` LIKE '%"+ val + "%' ORDER BY `DC_TITLE`.`TITLE`";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT `DC_TITLE`.`TITLE`,`DC_TITLE`.`ALTERNATIVE` FROM  `DC_INDEX` INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`REFERENCE` = `DC_TITLE`.`ID_DC`) WHERE `DC_TITLE`.`TITLE` LIKE '%"+ val + "%' ORDER BY `DC_TITLE`.`TITLE`";
        } else {
          SQL="SELECT DISTINCT `DC_TITLE`.`TITLE`,`DC_TITLE`.`ALTERNATIVE` FROM  `DC_INDEX` INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`REFERENCE` = `DC_TITLE`.`ID_DC`) ORDER BY `DC_TITLE`.`TITLE`";
        }
      }
    }
  }
  if(lov.equalsIgnoreCase("InternationalThreatStatus")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME='"+ val + "' ORDER BY NAME";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
        } else {
          SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS ORDER BY NAME";
        }
      }
    }
  }
  if(lov.equalsIgnoreCase("ThreatStatus")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME='"+ val + "' ORDER BY NAME";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
        } else {
          SQL="SELECT DISTINCT NAME, DESCRIPTION FROM CHM62EDT_CONSERVATION_STATUS ORDER BY NAME";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("LegalInstruments")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME,ID_CLASS_CODE FROM CHM62EDT_CLASS_CODE WHERE NAME='"+ val + "' AND LEGAL<>0 ORDER BY NAME";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME,ID_CLASS_CODE FROM CHM62EDT_CLASS_CODE WHERE NAME LIKE '%"+ val + "%' AND LEGAL<>0 ORDER BY NAME";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME,ID_CLASS_CODE FROM CHM62EDT_CLASS_CODE WHERE NAME LIKE '%"+ val + "%' AND LEGAL<>0 ORDER BY NAME";
        } else {
          SQL="SELECT DISTINCT NAME,ID_CLASS_CODE FROM CHM62EDT_CLASS_CODE WHERE LEGAL<>0 ORDER BY NAME";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Abundance")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT DESCRIPTION,CODE FROM CHM62EDT_"+lov.toUpperCase()+" WHERE DESCRIPTION='"+ val + "' ORDER BY DESCRIPTION";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT DESCRIPTION,CODE FROM CHM62EDT_"+lov.toUpperCase()+" WHERE DESCRIPTION LIKE '%"+ val + "%' ORDER BY DESCRIPTION";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT DESCRIPTION,CODE FROM CHM62EDT_"+lov.toUpperCase()+" WHERE DESCRIPTION LIKE '%"+ val + "%' ORDER BY DESCRIPTION";
        } else {
          SQL="SELECT DISTINCT DESCRIPTION,CODE FROM CHM62EDT_"+lov.toUpperCase()+" ORDER BY ID_"+lov.toUpperCase();
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("InfoQuality")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_INFO_QUALITY WHERE DESCRIPTION='"+ val + "' ORDER BY ID_INFO_QUALITY";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_INFO_QUALITY WHERE DESCRIPTION LIKE '%"+ val + "%' ORDER BY ID_INFO_QUALITY";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_INFO_QUALITY WHERE DESCRIPTION LIKE '%"+ val + "%' ORDER BY ID_INFO_QUALITY";
        } else {
          SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_INFO_QUALITY ORDER BY ID_INFO_QUALITY";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Trend")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_TREND WHERE STATUS='"+ val + "' ORDER BY ID_"+lov.toUpperCase();
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_TREND WHERE STATUS LIKE '%"+ val + "%' ORDER BY ID_"+lov.toUpperCase();
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_TREND WHERE STATUS LIKE '%"+ val + "%' ORDER BY ID_"+lov.toUpperCase();
        } else {
          SQL="SELECT DISTINCT STATUS,DESCRIPTION FROM CHM62EDT_TREND ORDER BY STATUS";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("RegionCode")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_REGION_CODES WHERE NAME='"+ val + "' ORDER BY ID_REGION_CODE";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_REGION_CODES WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_REGION_CODE";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_REGION_CODES WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_REGION_CODE";
        } else {
          SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_REGION_CODES ORDER BY ID_REGION_CODE";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("HumanActivity")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_HUMAN_ACTIVITY WHERE NAME='"+ val + "' ORDER BY ID_HUMAN_ACTIVITY";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_HUMAN_ACTIVITY WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_HUMAN_ACTIVITY";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_HUMAN_ACTIVITY WHERE NAME LIKE '%"+ val + "%' ORDER BY ID_HUMAN_ACTIVITY";
        } else {
          SQL="SELECT DISTINCT NAME,DESCRIPTION FROM CHM62EDT_HUMAN_ACTIVITY ORDER BY ID_HUMAN_ACTIVITY";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Group")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT COMMON_NAME,SCIENTIFIC_NAME FROM CHM62EDT_GROUP_SPECIES WHERE COMMON_NAME='"+ val + "' ORDER BY COMMON_NAME";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT COMMON_NAME,SCIENTIFIC_NAME FROM CHM62EDT_GROUP_SPECIES WHERE COMMON_NAME LIKE '%"+ val + "%' ORDER BY COMMON_NAME";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT COMMON_NAME,SCIENTIFIC_NAME FROM CHM62EDT_GROUP_SPECIES WHERE COMMON_NAME LIKE '%"+ val + "%' ORDER BY COMMON_NAME";
        } else {
          SQL="SELECT DISTINCT COMMON_NAME,SCIENTIFIC_NAME FROM CHM62EDT_GROUP_SPECIES ORDER BY COMMON_NAME";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Country")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT AREA_NAME_EN,EUNIS_AREA_CODE FROM CHM62EDT_COUNTRY WHERE SELECTION <> 0 AND AREA_NAME_EN='"+ val + "' ORDER BY AREA_NAME_EN";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT AREA_NAME_EN,EUNIS_AREA_CODE FROM CHM62EDT_COUNTRY WHERE SELECTION <> 0 AND AREA_NAME_EN LIKE '%"+ val + "%' ORDER BY AREA_NAME_EN";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT AREA_NAME_EN,EUNIS_AREA_CODE FROM CHM62EDT_COUNTRY WHERE SELECTION <> 0 AND AREA_NAME_EN LIKE '%"+ val + "%' ORDER BY AREA_NAME_EN";
        } else {
          SQL="SELECT DISTINCT AREA_NAME_EN,EUNIS_AREA_CODE FROM CHM62EDT_COUNTRY WHERE SELECTION <> 0 ORDER BY AREA_NAME_EN";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("SpeciesStatus")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT DESCRIPTION,SHORT_DEFINITION FROM CHM62EDT_SPECIES_STATUS WHERE NAME='"+ val + "' ORDER BY DESCRIPTION";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT DESCRIPTION,SHORT_DEFINITION FROM CHM62EDT_SPECIES_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY DESCRIPTION";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT DESCRIPTION,SHORT_DEFINITION FROM CHM62EDT_SPECIES_STATUS WHERE NAME LIKE '%"+ val + "%' ORDER BY DESCRIPTION";
        } else {
          SQL="SELECT DISTINCT DESCRIPTION,SHORT_DEFINITION FROM CHM62EDT_SPECIES_STATUS ORDER BY DESCRIPTION";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Biogeoregion")) {
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT NAME,CODE FROM CHM62EDT_BIOGEOREGION WHERE NAME='"+ val + "' ORDER BY NAME";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME,CODE FROM CHM62EDT_BIOGEOREGION WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL="SELECT DISTINCT NAME,CODE FROM CHM62EDT_BIOGEOREGION WHERE NAME LIKE '%"+ val + "%' ORDER BY NAME";
        } else {
          SQL="SELECT DISTINCT NAME,CODE FROM CHM62EDT_BIOGEOREGION ORDER BY NAME";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Author")) {
    if(natureobject.equalsIgnoreCase("Species")) {
      String SQLWhere="";
      if(oper.equalsIgnoreCase("Equal")) {
        SQLWhere=" (`DC_SOURCE`.`SOURCE` = '"+ val + "')";
      } else {
        if(oper.equalsIgnoreCase("Contains")) {
          SQLWhere=" (`DC_SOURCE`.`SOURCE` LIKE '%"+ val + "%')";
        } else {
          if(oper.equalsIgnoreCase("Between")) {
            SQLWhere=" (`DC_SOURCE`.`SOURCE` = '"+ val + "')";
          } else {
            SQLWhere=" (`DC_SOURCE`.`SOURCE` LIKE '%"+ val + "%')";
          }
        }
      }
      SQL+="    SELECT";
      SQL+="      `DC_SOURCE`.`SOURCE`,";
      SQL+="      `DC_SOURCE`.`EDITOR`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE";
      SQL+="      (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONS_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))";
      SQL+="    AND "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_SOURCE`.`SOURCE`,";
      SQL+="      `DC_SOURCE`.`EDITOR`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_SOURCE`.`SOURCE`,";
      SQL+="      `DC_SOURCE`.`EDITOR`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_SOURCE`.`SOURCE`,";
      SQL+="      `DC_SOURCE`.`EDITOR`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    GROUP BY DC_SOURCE.SOURCE,DC_SOURCE.EDITOR";
      SQL+="    ORDER BY `DC_SOURCE`.`SOURCE`";
      SQL+="    LIMIT 0,100";
    }
    if(natureobject.equalsIgnoreCase("Habitat")) {
      String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";

      SQL="SELECT DISTINCT `DC_SOURCE`.`SOURCE`,`DC_SOURCE`.`EDITOR` FROM `CHM62EDT_HABITAT`";
      SQL+=" INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+=" INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+=" INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      if(oper.equalsIgnoreCase("Equal")) {
        SQL+=" WHERE "+isGoodHabitat+" AND (`DC_SOURCE`.`SOURCE` = '"+ val + "') ORDER BY `DC_SOURCE`.`SOURCE`";
      } else {
        if(oper.equalsIgnoreCase("Contains")) {
          SQL+=" WHERE "+isGoodHabitat+" AND (`DC_SOURCE`.`SOURCE` LIKE '%"+ val + "%') ORDER BY `DC_SOURCE`.`SOURCE`";
        } else {
          if(oper.equalsIgnoreCase("Between")) {
            SQL+=" WHERE "+isGoodHabitat+" AND (`DC_SOURCE`.`SOURCE` = '"+ val + "') ORDER BY `DC_SOURCE`.`SOURCE`";
          } else {
            SQL+=" WHERE "+isGoodHabitat+" AND (`DC_SOURCE`.`SOURCE` LIKE '%"+ val + "%') ORDER BY `DC_SOURCE`.`SOURCE`";
          }
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Title")) {
    if(natureobject.equalsIgnoreCase("Species")) {
      String SQLWhere="";
      if(oper.equalsIgnoreCase("Equal")) {
        SQLWhere=" (`DC_TITLE`.`TITLE` = '"+ val + "')";
      } else {
        if(oper.equalsIgnoreCase("Contains")) {
          SQLWhere=" (`DC_TITLE`.`TITLE` LIKE '%"+ val + "%')";
        } else {
          if(oper.equalsIgnoreCase("Between")) {
            SQLWhere=" (`DC_TITLE`.`TITLE` = '"+ val + "')";
          } else {
            SQLWhere=" (`DC_TITLE`.`TITLE` LIKE '%"+ val + "%')";
          }
        }
      }
      SQL+="    SELECT";
      SQL+="      `DC_TITLE`.`TITLE`,";
      SQL+="      `DC_TITLE`.`ALTERNATIVE`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_REPORTS` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_REPORTS`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_REPORTS`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE";
      SQL+="      (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` IN ('DISTRIBUTION_STATUS','LANGUAGE','CONS_STATUS','SPECIES_GEO','LEGAL_STATUS','SPECIES_STATUS','POPULATION_UNIT','TREND'))";
      SQL+="    AND "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_TITLE`.`TITLE`,";
      SQL+="      `DC_TITLE`.`ALTERNATIVE`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_TITLE`.`TITLE`,";
      SQL+="      `DC_TITLE`.`ALTERNATIVE`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    UNION";
      SQL+="    SELECT";
      SQL+="      `DC_TITLE`.`TITLE`,";
      SQL+="      `DC_TITLE`.`ALTERNATIVE`";
      SQL+="    FROM";
      SQL+="      `CHM62EDT_SPECIES`";
      SQL+="      INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_SPECIES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+="      INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
      SQL+="      INNER JOIN `DC_INDEX` ON (`CHM62EDT_TAXONOMY`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_PUBLISHER` ON (`DC_INDEX`.`ID_DC` = `DC_PUBLISHER`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
      SQL+="      INNER JOIN `DC_DATE` ON (`DC_INDEX`.`ID_DC` = `DC_DATE`.`ID_DC`)";
      SQL+="    WHERE "+SQLWhere;
      SQL+="    GROUP BY DC_SOURCE.SOURCE,DC_SOURCE.EDITOR";
      SQL+="    ORDER BY `DC_TITLE`.`TITLE`";
      SQL+="    LIMIT 0,100";
    }

    if(natureobject.equalsIgnoreCase("Habitat")) {
      String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";

      SQL="SELECT DISTINCT `DC_TITLE`.`TITLE`,`DC_TITLE`.`ALTERNATIVE` FROM `CHM62EDT_HABITAT`";
      SQL+=" INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
      SQL+=" INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
      SQL+=" INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
      if(oper.equalsIgnoreCase("Equal")) {
        SQL+=" WHERE "+isGoodHabitat+" AND  (`DC_TITLE`.`TITLE` = '"+ val + "') ORDER BY `DC_TITLE`.`TITLE`";
      } else {
        if(oper.equalsIgnoreCase("Contains")) {
          SQL+=" WHERE "+isGoodHabitat+" AND  (`DC_TITLE`.`TITLE` LIKE '%"+ val + "%') ORDER BY `DC_TITLE`.`TITLE`";
        } else {
          if(oper.equalsIgnoreCase("Between")) {
            SQL+=" WHERE "+isGoodHabitat+" AND  (`DC_TITLE`.`TITLE` = '"+ val + "') ORDER BY `DC_TITLE`.`TITLE`";
          } else {
            SQL+=" WHERE "+isGoodHabitat+" AND  (`DC_TITLE`.`TITLE` LIKE '%"+ val + "%') ORDER BY `DC_TITLE`.`TITLE`";
          }
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("Taxonomy")) {
//    System.out.println("oper = " + oper);
    SQL="SELECT DISTINCT `CHM62EDT_TAXONOMY`.`NAME`,`CHM62EDT_TAXONOMY`.`LEVEL` FROM `CHM62EDT_SPECIES`";
    SQL+=" INNER JOIN `CHM62EDT_TAXONOMY` ON (`CHM62EDT_SPECIES`.`ID_TAXONOMY` = `CHM62EDT_TAXONOMY`.`ID_TAXONOMY`)";
    if(oper.equalsIgnoreCase("Equal")) {
      SQL+=" WHERE (`CHM62EDT_TAXONOMY`.`NAME` = '"+ val + "') ORDER BY `CHM62EDT_TAXONOMY`.`NAME`";
    } else {
      if(oper.equalsIgnoreCase("Contains")) {
        SQL+=" WHERE (`CHM62EDT_TAXONOMY`.`NAME` LIKE '%"+ val + "%') ORDER BY `CHM62EDT_TAXONOMY`.`NAME`";
      } else {
        if(oper.equalsIgnoreCase("Between")) {
          SQL+=" WHERE (`CHM62EDT_TAXONOMY`.`NAME` = '"+ val + "') ORDER BY `CHM62EDT_TAXONOMY`.`NAME`";
        } else {
          SQL+=" WHERE (`CHM62EDT_TAXONOMY`.`NAME` = '"+ val + "') ORDER BY `CHM62EDT_TAXONOMY`.`NAME`";
        }
      }
    }
  }

  if(lov.equalsIgnoreCase("SourceDatabase")) {
    if(natureobject.equalsIgnoreCase("Habitat")) {
      out.println("<a title=\"Click here to select the value\"  href=\"javascript:setValue('EUNIS')\">EUNIS</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Annex I')\">Annex I</a><br />");
      out.println("<br />");
    }
    if(natureobject.equalsIgnoreCase("Sites")) {
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Corine biotopes')\">Corine biotopes</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Cdda National')\">Cdda National</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Cdda International')\">Cdda International</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Biogenetic reserves')\">Biogenetic reserves</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('European Diploma')\">European Diploma</a><br />");
      out.println("<a title=\"Click here to select the value\" href=\"javascript:setValue('Emerald')\">Emerald</a><br />");
      out.println("<br />");
    }
  }

  if(lov.equalsIgnoreCase("ScientificName")) {
    if(natureobject.equalsIgnoreCase("Species")) {
      SQL="SELECT DISTINCT SCIENTIFIC_NAME,ID_SPECIES FROM CHM62EDT_SPECIES";
      SQL+=" WHERE SCIENTIFIC_NAME LIKE '%"+val+"%'";
      SQL+=" ORDER BY SCIENTIFIC_NAME";
      SQL+=" LIMIT 0,100";
      if(oper.equalsIgnoreCase("Equal")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,ID_SPECIES FROM CHM62EDT_SPECIES";
        SQL+=" WHERE SCIENTIFIC_NAME = '"+val+"'";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,ID_SPECIES FROM CHM62EDT_SPECIES";
        SQL+=" WHERE SCIENTIFIC_NAME LIKE '%"+val+"%'";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Between")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,ID_SPECIES FROM CHM62EDT_SPECIES";
        SQL+=" WHERE SCIENTIFIC_NAME LIKE '%"+val+"%'";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
    }
    if(natureobject.equalsIgnoreCase("Habitat")) {
       String isGoodHabitat = " IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',RIGHT(CHM62EDT_HABITAT.CODE_2000,2),1) <> IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '','00',2) AND IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',LENGTH(CHM62EDT_HABITAT.CODE_2000),1) = IF(TRIM(CHM62EDT_HABITAT.CODE_2000) <> '',4,1) ";

      SQL="SELECT DISTINCT SCIENTIFIC_NAME,CONCAT(IF(CODE_ANNEX1 IS NULL,'',CODE_ANNEX1),IF(EUNIS_HABITAT_CODE IS NULL,'',EUNIS_HABITAT_CODE)) FROM CHM62EDT_HABITAT";
      SQL+=" WHERE  "+isGoodHabitat+" AND  SCIENTIFIC_NAME LIKE '%"+val+"%' AND CHM62EDT_HABITAT.ID_HABITAT<>'-1' AND CHM62EDT_HABITAT.ID_HABITAT<>'10000' ";
      SQL+=" ORDER BY SCIENTIFIC_NAME";
      SQL+=" LIMIT 0,100";
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,CONCAT(IF(CODE_ANNEX1 IS NULL,'',CODE_ANNEX1),IF(EUNIS_HABITAT_CODE IS NULL,'',EUNIS_HABITAT_CODE)) FROM CHM62EDT_HABITAT";
        SQL+=" WHERE  "+isGoodHabitat+" AND SCIENTIFIC_NAME LIKE '%"+val+"%'  AND CHM62EDT_HABITAT.ID_HABITAT<>'-1' AND CHM62EDT_HABITAT.ID_HABITAT<>'10000' ";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Equal")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,CONCAT(IF(CODE_ANNEX1 IS NULL,'',CODE_ANNEX1),IF(EUNIS_HABITAT_CODE IS NULL,'',EUNIS_HABITAT_CODE)) FROM CHM62EDT_HABITAT";
        SQL+=" WHERE  "+isGoodHabitat+" AND SCIENTIFIC_NAME = '"+val+"'  AND CHM62EDT_HABITAT.ID_HABITAT<>'-1' AND CHM62EDT_HABITAT.ID_HABITAT<>'10000' ";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Between")) {
        SQL="SELECT DISTINCT SCIENTIFIC_NAME,CONCAT(IF(CODE_ANNEX1 IS NULL,'',CODE_ANNEX1),IF(EUNIS_HABITAT_CODE IS NULL,'',EUNIS_HABITAT_CODE)) FROM CHM62EDT_HABITAT";
        SQL+=" WHERE  "+isGoodHabitat+" AND SCIENTIFIC_NAME LIKE '%"+val+"%'  AND CHM62EDT_HABITAT.ID_HABITAT<>'-1' AND CHM62EDT_HABITAT.ID_HABITAT<>'10000' ";
        SQL+=" ORDER BY SCIENTIFIC_NAME";
        SQL+=" LIMIT 0,100";
      }
    }
  }

  if(lov.equalsIgnoreCase("Name")) {
    if(natureobject.equalsIgnoreCase("Sites")) {
      SQL="SELECT DISTINCT NAME,ID_SITE FROM CHM62EDT_SITES";
      SQL+=" WHERE NAME LIKE '%"+val+"%'";
      SQL+=" ORDER BY NAME";
      SQL+=" LIMIT 0,100";
      if(oper.equalsIgnoreCase("Equal")) {
        SQL="SELECT DISTINCT NAME,ID_SITE FROM CHM62EDT_SITES";
        SQL+=" WHERE NAME = '"+val+"'";
        SQL+=" ORDER BY NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Contains")) {
        SQL="SELECT DISTINCT NAME,ID_SITE FROM CHM62EDT_SITES";
        SQL+=" WHERE NAME LIKE '%"+val+"%'";
        SQL+=" ORDER BY NAME";
        SQL+=" LIMIT 0,100";
      }
      if(oper.equalsIgnoreCase("Between")) {
        SQL="SELECT DISTINCT NAME,ID_SITE FROM CHM62EDT_SITES";
        SQL+=" WHERE NAME LIKE '%"+val+"%'";
        SQL+=" ORDER BY NAME";
        SQL+=" LIMIT 0,100";
      }
    }
  }

  if(lov.equalsIgnoreCase("VernacularName")){
    SQL="SELECT DISTINCT CHM62EDT_REPORT_ATTRIBUTES.VALUE,' ' FROM CHM62EDT_REPORTS ";
    SQL+=" INNER JOIN `CHM62EDT_SPECIES` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`)";
    SQL+=" INNER JOIN `CHM62EDT_REPORT_ATTRIBUTES` ON (`CHM62EDT_REPORTS`.`ID_REPORT_ATTRIBUTES` = `CHM62EDT_REPORT_ATTRIBUTES`.`ID_REPORT_ATTRIBUTES`)";
    SQL+=" WHERE (`CHM62EDT_REPORT_ATTRIBUTES`.`NAME` = 'VERNACULAR_NAME')";
    SQL+=" AND (CHM62EDT_REPORT_ATTRIBUTES.VALUE LIKE '%"+val+"%')";
    SQL+=" LIMIT 0,100";
    if(oper.equalsIgnoreCase("Contains")) {
      SQL="SELECT DISTINCT CHM62EDT_REPORT_ATTRIBUTES.VALUE,' ' FROM CHM62EDT_REPORTS ";
      SQL+=" INNER JOIN `CHM62EDT_SPECIES` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`)";
      SQL+=" INNER JOIN `CHM62EDT_REPORT_ATTRIBUTES` ON (`CHM62EDT_REPORTS`.`ID_REPORT_ATTRIBUTES` = `CHM62EDT_REPORT_ATTRIBUTES`.`ID_REPORT_ATTRIBUTES`)";
      SQL+=" WHERE (`CHM62EDT_REPORT_ATTRIBUTES`.`NAME` = 'VERNACULAR_NAME')";
      SQL+=" AND (CHM62EDT_REPORT_ATTRIBUTES.VALUE LIKE '%"+val+"%')";
      SQL+=" LIMIT 0,100";
    }
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT CHM62EDT_REPORT_ATTRIBUTES.VALUE,' ' FROM CHM62EDT_REPORTS ";
      SQL+=" INNER JOIN `CHM62EDT_SPECIES` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`)";
      SQL+=" INNER JOIN `CHM62EDT_REPORT_ATTRIBUTES` ON (`CHM62EDT_REPORTS`.`ID_REPORT_ATTRIBUTES` = `CHM62EDT_REPORT_ATTRIBUTES`.`ID_REPORT_ATTRIBUTES`)";
      SQL+=" WHERE (`CHM62EDT_REPORT_ATTRIBUTES`.`NAME` = 'VERNACULAR_NAME')";
      SQL+=" AND (CHM62EDT_REPORT_ATTRIBUTES.VALUE = '"+val+"')";
      SQL+=" LIMIT 0,100";
    }
    if(oper.equalsIgnoreCase("Between")) {
      SQL="SELECT DISTINCT CHM62EDT_REPORT_ATTRIBUTES.VALUE,' ' FROM CHM62EDT_REPORTS ";
      SQL+=" INNER JOIN `CHM62EDT_SPECIES` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_SPECIES`.`ID_NATURE_OBJECT`)";
      SQL+=" INNER JOIN `CHM62EDT_REPORT_ATTRIBUTES` ON (`CHM62EDT_REPORTS`.`ID_REPORT_ATTRIBUTES` = `CHM62EDT_REPORT_ATTRIBUTES`.`ID_REPORT_ATTRIBUTES`)";
      SQL+=" WHERE (`CHM62EDT_REPORT_ATTRIBUTES`.`NAME` = 'VERNACULAR_NAME')";
      SQL+=" AND (CHM62EDT_REPORT_ATTRIBUTES.VALUE LIKE '%"+val+"%')";
      SQL+=" LIMIT 0,100";
    }
  }
  if(lov.equalsIgnoreCase("Designation")){
    SQL="SELECT DISTINCT `CHM62EDT_DESIGNATIONS`.`DESCRIPTION`,`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION`";
    SQL+=" FROM CHM62EDT_DESIGNATIONS ";
    SQL+=" INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION` = `CHM62EDT_SITES`.`ID_DESIGNATION` AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = `CHM62EDT_SITES`.`ID_GEOSCOPE`)";
    SQL+=" WHERE";
    SQL+=" (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` LIKE '%"+val+"%')";
    if(oper.equalsIgnoreCase("Contains")) {
      SQL="SELECT DISTINCT `CHM62EDT_DESIGNATIONS`.`DESCRIPTION`,`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION`";
      SQL+=" FROM CHM62EDT_DESIGNATIONS ";
      SQL+=" INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION` = `CHM62EDT_SITES`.`ID_DESIGNATION` AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = `CHM62EDT_SITES`.`ID_GEOSCOPE`)";
      SQL+=" WHERE";
      SQL+=" (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` LIKE '%"+val+"%')";
    }
    if(oper.equalsIgnoreCase("Equal")) {
      SQL="SELECT DISTINCT `CHM62EDT_DESIGNATIONS`.`DESCRIPTION`,`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION`";
      SQL+=" FROM CHM62EDT_DESIGNATIONS ";
      SQL+=" INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION` = `CHM62EDT_SITES`.`ID_DESIGNATION` AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = `CHM62EDT_SITES`.`ID_GEOSCOPE`)";
      SQL+=" WHERE";
      SQL+=" (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` = '"+val+"')";
    }
    if(oper.equalsIgnoreCase("Between")) {
      SQL="SELECT DISTINCT `CHM62EDT_DESIGNATIONS`.`DESCRIPTION`,`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION`";
      SQL+=" FROM CHM62EDT_DESIGNATIONS ";
      SQL+=" INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION` = `CHM62EDT_SITES`.`ID_DESIGNATION` AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = `CHM62EDT_SITES`.`ID_GEOSCOPE`)";
      SQL+=" WHERE";
      SQL+=" (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` LIKE '%"+val+"%')";
    }
  }

  try {
    // Execute SQL statement
    if(SQL.length()>0 && !lov.equalsIgnoreCase("SourceDatabase")) {
      //System.out.println("SQL = " + SQL);
      ps = con.createStatement();
      rs = ps.executeQuery(SQL);

      if(!rs.isBeforeFirst()) {
        out.println("<strong>"+cm.cms("no_results_found_1")+"</strong>");
        out.println("<br />");
      } else {
        %>
        <h2><%=cm.cmsText("list_of_values")%>:</h2>
        <br />
        <strong>
        <%=cm.cmsText("warning_first_100_values")%>
        </strong>
        <br />
        <br />
        <u><%=ro.finsiel.eunis.search.Utilities.SplitString(lov)%></u>
        <em><%=oper%></em>
        <strong><%=val.length()==0?"%":val%></strong>
        <br />
        <br />
        <div id="tab">
        <table summary="layout" class="datatable">
          <tr>
            <th>
              Value
            </th>
            <th>
              Code
            </th>
          </tr>
<%
        int cnt = 0;
        while(rs.next())
        {
          String cssClass = cnt++ % 2 == 0 ? "" : " class=\"zebraeven\"";
%>
          <tr<%=cssClass%>>
            <td>
            <%
            out.println("<a title=\"" + cm.cms("click_link_to_select_value") + "\" href=\"javascript:setValue('"+rs.getString(1)+"')\">"+rs.getString(1)+"</a>");
            %>
            </td>
            <td>
            <%
            if(rs.getString(2) != null && rs.getString(2).length()>0) {
              out.println(rs.getString(2));
            } else {
              out.println("&nbsp;");
            }
            %>
            </td>
          </tr>
          <%
        }
        %>
        </table>
        </div>
        <%
      }
      rs.close();
      ps.close();
      con.close();
    } else {
        if(!lov.equalsIgnoreCase("SourceDatabase")) {
          out.println("<strong>"+cm.cms("no_list_of_values_available")+"</strong>");
          out.println("<br />");
        }
    }
  } catch (Exception e) {
    e.printStackTrace();
    //System.out.println(e.toString());
    out.println("<strong>"+cm.cms("could_not_retrieve_list_of_values")+"</strong>");
    out.println("<br />");
  }
%>
    <br />
    <form action="">
      <input type="button" title="<%=cm.cms("close_window")%>" value="<%=cm.cms("close_btn")%>" onclick="javascript:window.close()" name="btnclose" id="btnclose" class="standardButton" />
      <%=cm.cmsInput("close_btn")%>
    </form>
    <%=cm.br()%>
    <%=cm.cmsMsg("list_of_values")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("no_list_of_values_available")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("could_not_retrieve_list_of_values")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("click_link_to_select_value")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("no_results_found_1")%>
  </body>
</html>
