<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Habitat factsheet.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.List" %>
<%--
    This is the habitat factsheet.
    Request parameters:
      - idHabitat - The ID of the habitat which the factsheet will display. Integer
      - printVer - If printable version or not. For the printable version, some pictures are removed. true / false.
      - mini - true/false - Specifies if only shows the most importat parts of factsheet (uppermost part with general info)
--%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,factsheet";
  /// INPUT PARAMS: idHabitat
  String idHabitat = request.getParameter("idHabitat");
  int tab = Utilities.checkedStringToInt(request.getParameter("tab"), 0);
// Mini factsheet shows only the uppermost part of the factsheet with generic information.
  boolean isMini = Utilities.checkedStringToBoolean(request.getParameter("mini"), false);
  HabitatsFactsheet factsheet = new HabitatsFactsheet(idHabitat);
  String []tabs = {"General information", "Geographical distribution", "Legal instruments", "Habitat types", "Sites", "Species", "Other info"};

  String []dbtabs = {"GENERAL_INFORMATION", "GEOGRAPHICAL_DISTRIBUTION", "LEGAL_INSTRUMENTS", "HABITATS", "SITES", "SPECIES", "OTHER"};

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");
  WebContentManagement cm = SessionManager.getWebContent();
  String metaDescription = "";
  if( factsheet != null )
  {
    metaDescription = factsheet.getMetaHabitatDescription();
  }
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp">
    <jsp:param name="metaDescription" value="<%=metaDescription%>" />
  </jsp:include>
  <script language="JavaScript" type="text/javascript" src="script/habitats-result.js"></script>
  <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("factsheet_for")%>
    <%=factsheet.getHabitat().getScientificName()%>
  </title>
  <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
  function openpictures( URL, width, height )
  {
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width="+width+",height="+height+",left=100,top=0');");
  }
  function openLink(URL)
  {
    eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
  }
  //]]>
  </script>
</head>
<body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
<%
  if(null == factsheet.getHabitat())
  {
%>
                <div style="width: 100%;">
                  <br />
                  <br />
                  <p>
                    <%=cm.cmsPhrase("Sorry, no habitat type has been found in the database with Habitat type ID=")%>
                    <strong>'<%=idHabitat%>'</strong>
                  </p>
                  <br />
                  <br />
                </div>
                <%=cm.br()%>
                <%=cm.cmsMsg("factsheet_for")%>
                <%=cm.br()%>
<%
  }
  else
  {
    String printLink = "javascript:openlink('habitats-factsheet-pdf.jsp?idHabitat=" + idHabitat + "')";
    if(!isMini)
    {
%>
                <img id="loading" alt="<%=cm.cms("loading_data")%>" src="images/loading.gif" />
<%
    }
    String habitatType = cm.cmsPhrase("Annex I Habitat type");
    if(factsheet.isEunis())
    {
      habitatType = cm.cmsPhrase("EUNIS Habitat type");
    }
    String code = "";
    if(factsheet.isEunis())
    {
      code = factsheet.getEunisHabitatCode();
    }
    else
    {
      code = factsheet.getCode2000();
    }
                %>
                  <h1 class="documentFirstHeading">
                    <%=factsheet.getHabitatScientificName()%>
                  </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                  </ul>
                </div>
<%--
                  <strong>
                    ( <%=habitatType%> - <%=code%> )
                  </strong>
--%>                  
                
<%
    if(!isMini)
    {
%>
                <div id="tabbedmenu">
                  <ul>
                    <%
                      SQLUtilities sqlUtilities = new SQLUtilities();
                      sqlUtilities.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

                      String currentTab = "";
                      for(int i = 0; i < tabs.length; i++)
                      {
                        currentTab = "";
                        if(tab == i) currentTab = " id=\"currenttab\"";

                        if(!sqlUtilities.TabPageIsEmpy(factsheet.idNatureObject.toString(),"HABITATS",dbtabs[i]))
                        {
                          %>
                          <li<%=currentTab%>>
                            <a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="habitats-factsheet.jsp?tab=<%=i%>&amp;idHabitat=<%=idHabitat%>"><%=tabs[i]%></a>
                            <%=cm.cmsTitle("show")%>
                          </li>
                          <%
                        }
                      }
                    %>
                  </ul>
                </div>
                <br clear="all" />
<%
    }
%>
                <br />
<%
    if(tab == 0)
    {
%>
                <%-- General information --%>
                <jsp:include page="habitats-factsheet-general.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 1)
    {
%>
                <%-- Geographical distribution --%>
                <jsp:include page="habitats-factsheet-geographical.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 2)
    {
%>
                <%-- Legal instruments --%>
                <jsp:include page="habitats-factsheet-legal.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 3)
    {
%>
                <%-- Related habitat types --%>
                <jsp:include page="habitats-factsheet-related.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 4)
    {
%>
                <%-- Related sites --%>
                <jsp:include page="habitats-factsheet-sites.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 5)
    {
%>
                <%-- Related species --%>
                <jsp:include page="habitats-factsheet-species.jsp">
                  <jsp:param name="idHabitat" value="<%=idHabitat%>" />
                </jsp:include>
<%
    }
    if(tab == 6)
    {
      // Other information.
      Integer[] dictionary = {
        HabitatsFactsheet.OTHER_INFO_ALTITUDE,
        HabitatsFactsheet.OTHER_INFO_DEPTH,
        HabitatsFactsheet.OTHER_INFO_CLIMATE,
        HabitatsFactsheet.OTHER_INFO_GEOMORPH,
        HabitatsFactsheet.OTHER_INFO_SUBSTRATE,
        HabitatsFactsheet.OTHER_INFO_LIFEFORM,
        HabitatsFactsheet.OTHER_INFO_COVER,
        HabitatsFactsheet.OTHER_INFO_HUMIDITY,
        HabitatsFactsheet.OTHER_INFO_WATER,
        HabitatsFactsheet.OTHER_INFO_SALINITY,
        HabitatsFactsheet.OTHER_INFO_EXPOSURE,
        HabitatsFactsheet.OTHER_INFO_CHEMISTRY,
        HabitatsFactsheet.OTHER_INFO_TEMPERATURE,
        HabitatsFactsheet.OTHER_INFO_LIGHT,
        HabitatsFactsheet.OTHER_INFO_SPATIAL,
        HabitatsFactsheet.OTHER_INFO_TEMPORAL,
        HabitatsFactsheet.OTHER_INFO_IMPACT,
        HabitatsFactsheet.OTHER_INFO_USAGE
      };

      if(factsheet.isEunis())
      {
%>
                <script language="JavaScript" type="text/javascript">
                  function otherInfo(info)
                  {
                    var ctrl_info = document.getElementById("otherInfo" + info);
                    try
                      {
                        if(ctrl_info.style.display == "none")
                          {
                            ctrl_info.style.display = "block";
                          }
                          else
                          {
                            ctrl_info.style.display = "none";
                          }
                      }
                      catch( e )
                        {
                          alert("<%=cm.cms("error_expanding_node")%>");
                        }
                  }
                  function otherInfoAll(expand)
                  {
                    for(i = 0; i < <%=dictionary.length%>; i++)
                    {
                      var ctrl_info = document.getElementById("otherInfo" + i);
                      try
                        {
                          if(expand)
                            {
                              ctrl_info.style.display = "block";
                            }
                            else
                            {
                              ctrl_info.style.display = "none";
                            }
                        }
                        catch( e )
                          {
                          }
                    }
                  }
                </script>
                <a href="javascript:otherInfoAll(true);" title="Expand all characteristic information">Expand All</a> |
                <a href="javascript:otherInfoAll(false);" title="Collapse all characteristic information">Collapse All</a>
                <br />
                <br />
                <table summary="layout" border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
<%
        SQLUtilities sqlUtil = new SQLUtilities();
        sqlUtil.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
        for(int i = 0; i < dictionary.length; i++)
        {
          Integer dictionaryType = dictionary[i];
          String title = factsheet.getOtherInfoDescription(dictionaryType);
          String SQL = factsheet.getSQLForOtherInfo(dictionaryType);
          String noElements = sqlUtil.ExecuteSQL(SQL);
%>
                  <tr bgcolor="<%=(0 == (i % 2) ?  "#fafafa" : "#fafafa")%>">
                    <td>
<%
          if("0".equals(noElements) || "".equals(noElements))
          {
%>
                      <span style="color:#808080"><%=title%> (no records)</span>
<%
          }
          else
          {
%>
                      <a title="<%=cm.cms("habitat_other_information")%>" href="javascript:otherInfo(<%=dictionaryType%>)"><%=title%></a><%=cm.cmsTitle("habitat_other_information")%> (<%=noElements%> <%=cm.cmsPhrase("records")%>)

                      <div id="otherInfo<%=dictionaryType%>" style="padding-left : 25px; display : none;">
                        <jsp:include page="habitats-factsheet-other.jsp">
                          <jsp:param name="idHabitat" value="<%=factsheet.getIdHabitat()%>" />
                          <jsp:param name="infoID" value="<%=dictionaryType%>" />
                        </jsp:include>
                      </div>
<%
          }
%>
                    </td>
                  </tr>
<%
        }
%>
                </table>
<%
      }
    }
%>
                <br />
<%
    // Pictures of habitat
    List list = factsheet.getPicturesForHabitats();
    String picsURL = "idobject=" + factsheet.getIdHabitat() + "&amp;natureobjecttype=Habitats";
    if(null != list && list.size() > 0)
    {
%>
                <a title="<%=cm.cms("habitat_open_pictures")%>" href="javascript:openpictures('pictures.jsp?<%=picsURL%>',600,600)"><%=cm.cmsPhrase("View pictures")%></a>
                <%=cm.cmsTitle("habitat_open_pictures")%>
<%
    }
    else if(SessionManager.isAuthenticated() && SessionManager.isUpload_pictures_RIGHT())
    {
%>
                <br />
                <br />
                <a title="<%=cm.cms("upload_pictures")%>" href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=picsURL%>',600,600)"><%=cm.cmsPhrase("Upload pictures")%></a>
                <%=cm.cmsTitle("upload_pictures")%>
                <br />
                <br />
<%
    }
    out.flush();
    if(!isMini)
    {
%>
                <%=cm.br()%>
                <%=cm.cmsMsg("factsheet_for")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading_data")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("error_expanding_node")%>
                <%=cm.br()%>
<%
    }
  }
%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="habitats-factsheet.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
    <script language="JavaScript" type="text/javascript">
      try
      {
        var ctrl_loading = document.getElementById("loading");
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
    </script>
  </body>
</html>
