<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main site factsheet page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Request parameters
  // - idsite - ID of the site
  String siteid = request.getParameter("idsite");
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement cm = SessionManager.getWebContent();
  String pdfURL = "javascript:openLink('sites-factsheet-pdf.jsp?idsite=" + siteid + "')";

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  String metaDescription = "";
  String pageTitle;
  if( factsheet.getIDNatureObject() != null )
  {
    metaDescription = factsheet.getDescription();
    pageTitle = cm.cms("sites_factsheet_title") + " " + factsheet.getSiteObject().getName();
  }
  else
  {
    pageTitle = cm.cmsText("sites_factsheet_error") + "'" + factsheet.getIDSite() + "'";
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp">
      <jsp:param name="metaDescription" value="<%=metaDescription%>" />
    </jsp:include>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%><%=pageTitle%>
    </title>
    <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
    <script language="JavaScript" src="script/sortable.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
    <!--
      function openWindow(theURL,winName,features)
      {
        window.open(theURL,winName,features);
      }

      function openLink(URL)
      {
        eval("page = window.open(URL, '', 'scrollbars=no,toolbar=0,resizable=yes, location=0,width=380,height=350');");
      }

      function openGooglePics(URL)
      {
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
      }

      function openpictures(URL, width, height)
      {
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0,resizable=yes, location=0,width="+width+",height="+height+",left=100,top=0');");
      }

      function openunepwcmc(URL, width, height)
      {
        eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=yes,resizable=yes, location=yes,width="+screen.width+",height="+screen.height+",left=0,top=0');");
      }
    //-->
    </script>
  </head>
  <body>
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
                <br clear="all" />
<!-- MAIN CONTENT -->
<%
  if(null != factsheet.getIDNatureObject())
  {
%>
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,factsheet" />
                  <jsp:param name="printLink" value="<%=pdfURL%>"/>
                  <jsp:param name="mapLink" value="show"/>
                </jsp:include>
<%
    String []tabs = {
            "sites_factsheet_tab_general_informations",
            "sites_factsheet_tab_fauna_flora",
            "designation_information",
            "habitat_types",
            "sites_factsheet_tab_sites",
            "other_info"
    };

    String []dbtabs = {
            "GENERAL_INFORMATION",
            "FAUNA_FLORA",
            "DESIGNATION",
            "HABITATS",
            "SITES",
            "OTHER"
    };
    if(factsheet.exists())
    {
      String sdb = SitesSearchUtility.translateSourceDB(factsheet.getSiteObject().getSourceDB());
%>
                <img id="loading" src="images/loading.gif" alt="<%=cm.cms("loading")%>" title="<%=cm.cms("loading")%>" />
                <div style="width: 100%; text-align: center;">
                  <h1>
                    <%=factsheet.getSiteObject().getName()%>
                  </h1>
                  <br />
                  <strong>
                    <%=cm.cmsText("facthseet_filled_with_data_from")%> <%=sdb%> <%=cm.cmsText("sites_factsheet_02")%>
                  </strong>
                </div>
                <div id="tabbedmenu">
                  <ul>
<%
      SQLUtilities sqlUtilities = new SQLUtilities();
      sqlUtilities.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

      String currentTab = "";
      for ( int i = 0; i < tabs.length; i++ )
      {
        if(!sqlUtilities.TabPageIsEmpy(factsheet.getSiteObject().getIdNatureObject().toString(),"SITES",dbtabs[i]))
        {
          currentTab = "";
          if ( tab == i ) currentTab = " id=\"currenttab\"";
%>
                    <li<%=currentTab%>>
                      <a title="Open <%=cm.cms( tabs[ i ] )%>" href="sites-factsheet.jsp?tab=<%=i%>&amp;idsite=<%=siteid%>"><%=cm.cms( tabs[ i ] )%></a>
                    </li>
<%
        }
      }
%>
                  </ul>
                </div>
                <br class="brClear" />
                <br />
<%
      if ( tab == 0 )
      {
%>
                <jsp:include page="sites-factsheet-general.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      if ( tab == 1 )
      {
%>
                <jsp:include page="sites-factsheet-faunaflora.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      if ( tab == 2 )
      {
%>
                <jsp:include page="sites-factsheet-designations.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      if ( tab == 3 )
      {
%>
                <jsp:include page="sites-factsheet-habitats.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      if ( tab == 4 )
      {
%>
                <jsp:include page="sites-factsheet-related.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      if ( tab == 5 )
      {
%>
                <jsp:include page="sites-factsheet-other.jsp">
                  <jsp:param name="idsite" value="<%=siteid%>" />
                </jsp:include>
<%
      }
      // List of site pictures.
      List list = factsheet.getPicturesForSites();
      String url="idobject="+factsheet.getSiteObject().getIdSite()+"&amp;natureobjecttype=Sites";
      if(null != list && list.size() > 0)
      {
%>
                <br />
                <br />
                <div style="width : 100%;">
                  <a title="<%=cm.cms("sites_factsheet_openpictures")%>" href="javascript:openpictures('pictures.jsp?<%=url%>',600,600)"><%=cm.cmsText("view_pictures")%></a>
                  <%=cm.cmsTitle("sites_factsheet_openpictures")%>
                </div>
<%
      }
      else if (SessionManager.isAuthenticated())
      {
%>
                <br />
                <br />
                <div style="width : 100%;">
                  <a title="<%=cm.cms("sites_factsheet_openpictures")%>" href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=url%>',600,600)"><%=cm.cmsText("upload_pictures")%></a>
                  <%=cm.cmsTitle("sites_factsheet_openpictures")%>
                </div>
<%
      }
    }
    else
    {
%>
                <br />
                <br />
                <%=cm.cmsText( "upload_pictures" )%>
                <br />
<%
    }
    for ( int i = 0; i < tabs.length; i++ )
    {
%>
            <%=cm.cmsMsg(tabs[ i ])%>
            <%=cm.br()%>
<%
    }
%>
                <%=cm.cmsMsg("sites_factsheet_title")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading")%>
<%
  }
  else
  {
%>
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,factsheet" />
                </jsp:include>

                <br />
                <br />
                <p>
                <%=cm.cmsText("sites_factsheet_error")%>
                <strong>'<%=factsheet.getIDSite()%>'</strong>
                </p>
                <br />
                <br />
<%
  }
%>
                <jsp:include page="footer.jsp">
                  <jsp:param name="page_name" value="sites-factsheet.jsp" />
                </jsp:include>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp" />
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
    <script language="JavaScript" type="text/javascript">
      <!--
      try
      {
        var ctrl_loading = document.getElementById( "loading" );
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
      //-->
    </script>
  </body>
</html>
