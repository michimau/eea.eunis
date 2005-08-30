<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Main site factsheet page
--%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<%@page contentType="text/html"%>
  <head>
    <jsp:include page="header-page.jsp" />
<%
  // Request parameters
  // - idsite - ID of the site
  String siteid = request.getParameter("idsite");
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement contentManagement = SessionManager.getWebContent();

  List results = null;
  String pdfURL = "javascript:openLink('sites-factsheet-pdf.jsp?idsite=" + siteid + "')";

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  if(null == factsheet.getIDNatureObject()) {
  %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=contentManagement.getContent("sites_factsheet_title", false)%>
    </title>
    <jsp:include page="header-page.jsp" />
  </head>

  <body>
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Factsheet" />
  </jsp:include>
  <table summary="layout" width="100%" border="0">
    <tr>
      <td>
        <br />
        <br />
        <p>
          <%=contentManagement.getContent("sites_factsheet_error")%>
          <strong>'<%=factsheet.getIDSite()%>'</strong>
        </p>
        <br />
        <br />
      </td>
    </tr>
  </table>
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="sites-factsheet.jsp" />
  </jsp:include>
  </body>
  </html>
  <%
      return;
    }
%>

    <title>
      <%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_factsheet_title", false )%> <%=factsheet.getSiteObject().getName()%>
    </title>
    <script language="JavaScript" type="text/javascript" src="script/sort-table.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/utils.js"></script>
		<script language="JavaScript" type="text/javascript" src="script/tabs/listener.js"></script>
		<script language="JavaScript" type="text/javascript" src="script/tabs/tabs.js"></script>
    <script language="JavaScript" src="script/overlib.js" type="text/javascript"></script>
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
    <div id="content">
    <div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="Home#index.jsp,Sites#sites.jsp,Factsheet"/>
      <jsp:param name="printLink" value="<%=pdfURL%>"/>
      <jsp:param name="mapLink" value="show"/>
    </jsp:include>
<%
  String []tabs = { "General information", "Fauna and Flora", "Designation information", "Habitat types", "Related sites", "Other info" };

  String []dbtabs = { "GENERAL_INFORMATION", "FAUNA_FLORA", "DESIGNATION", "HABITATS", "SITES", "OTHER" };

  if(factsheet.exists())
  {
%>
    <img id="loading" src="images/loading.gif" alt="Loading" title="Loading" />
    <div id="title" style="width : 740px; text-align : center; background-color : #EEEEEE; border : 1px solid black;">
      <span class="fontLarge">
        <strong>
          <%=factsheet.getSiteObject().getName()%>
        </strong>
      </span>
      <br />
      <strong>
      <%
        String sdb = SitesSearchUtility.translateSourceDB(factsheet.getSiteObject().getSourceDB());
      %>
      <strong><%=contentManagement.getContent("sites_factsheet_01")%> <%=sdb%> <%=contentManagement.getContent("sites_factsheet_02")%></strong>
      </strong>
    </div>
    <br />

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
              <a title="Open <%=tabs[ i ]%>" href="sites-factsheet.jsp?tab=<%=i%>&amp;idsite=<%=siteid%>"><%=tabs[ i ]%></a>
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
      <div style="width : 740px;">
        <a title="Open pictures for this site" href="javascript:openpictures('pictures.jsp?<%=url%>',600,600)"><%=contentManagement.getContent("sites_factsheet_163")%></a>
      </div>
<%
    }
    else if (SessionManager.isAuthenticated())
    {
%>
      <br />
      <br />
      <div style="width : 740px;">
        <a title="Upload pictures for this site" href="javascript:openpictures('pictures-upload.jsp?operation=upload&amp;<%=url%>',600,600)"><%=contentManagement.getContent("sites_factsheet_164")%></a>
      </div>
<%
    }
  }
  else
  {
%>
    <br />
    <br />
    <%=contentManagement.getContent( "sites_factsheet_164" )%>
    <br />
<%
  }
%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="sites-factsheet.jsp" />
    </jsp:include>
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
    </div>
  </body>
</html>
<%
  out.flush();
%>