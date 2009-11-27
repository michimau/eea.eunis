<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : EUNIS Logo
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
	request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
	String domainPrefix = Utilities.formatString( application.getInitParameter( "DOMAIN_NAME" ), "http://eunis.eea.europa.eu" );
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,logos_location";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
	WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("logos_page_title")%>
    </title>
  </head>
  <body>
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
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
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
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("EUNIS Logo")%>
                </h1>
                <br />
                <%=cm.cmsPhrase("Please use the provided logos to link from your website to EUNIS Database.<br />In order to use them, save the images using right-click and use the link from the text box <br /> or<br /> link directly to our website by using the link provided on third column. <br />")%>
                <table width="100%" summary="Logos">
                  <tr>
                    <th>
                      <%=cm.cmsPhrase("Image")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Local link (Save image to your site )")%>
                    </th>
                    <th>
                      <%=cm.cmsPhrase("Direct link to website ( Picture on EUNIS website )")%>
                    </th>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_large.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
                    </td>
                    <td>
                      <label for="large_hor_jpg">Large / Horizontal / JPEG</label>
                      <br />
                      <textarea id="large_hor_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.jpg" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_hor_jpg1">Large / Horizontal / JPEG</label>
                      <br />
                      <textarea id="large_hor_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.jpg" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_large.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
                    </td>
                    <td>
                      <label for="large_hor_gif">Large / Horizontal / GIF</label>
                      <br />
                      <textarea id="large_hor_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.gif" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_hor_gif1">Large / Horizontal / GIF</label>
                      <br />
                      <textarea id="large_hor_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.gif" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_large.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
                    </td>
                    <td>
                      <label for="large_hor_png">Large / Horizontal / PNG</label>
                      <br />
                      <textarea id="large_hor_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.png" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_hor_png1">Large / Horizontal / PNG</label>
                      <br />
                      <textarea id="large_hor_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.png" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_small.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
                    </td>
                    <td>
                      <label for="small_hor_jpg">Small / Horizontal / JPEG</label>
                      <br />
                      <textarea id="small_hor_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.jpg" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_hor_jpg1">Small / Horizontal / JPEG</label>
                      <br />
                      <textarea id="small_hor_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.jpg" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_small.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
                    </td>
                    <td>
                      <label for="small_hor_gif">Small / Horizontal / GIF</label>
                      <br />
                      <textarea id="small_hor_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.gif" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_hor_gif1">Small / Horizontal / GIF</label>
                      <br />
                      <textarea id="small_hor_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.gif" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_hor_small.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
                    </td>
                    <td>
                      <label for="small_hor_png">Small / Horizontal / PNG</label>
                      <br />
                      <textarea id="small_hor_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.png" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_hor_png1">Small / Horizontal / PNG</label>
                      <br />
                      <textarea id="small_hor_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.png" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_large.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
                    </td>
                    <td>
                      <label for="large_ver_jpg">Large / Vertical / JPEG</label>
                      <br />
                      <textarea id="large_ver_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.jpg" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_ver_jpg1">Large / Vertical / JPEG</label>
                      <br />
                      <textarea id="large_ver_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.jpg" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_large.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
                    </td>
                    <td>
                      <label for="large_ver_gif">Large / Vertical / GIF</label>
                      <br />
                      <textarea id="large_ver_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.gif" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_ver_gif1">Large / Vertical / GIF</label>
                      <br />
                      <textarea id="large_ver_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.gif" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_large.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
                    </td>
                    <td>
                      <label for="large_ver_png">Large / Vertical / PNG</label>
                      <br />
                      <textarea id="large_ver_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.png" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="large_ver_png1">Large / Vertical / PNG</label>
                      <br />
                      <textarea id="large_ver_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.png" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_small.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
                    </td>
                    <td>
                      <label for="small_ver_jpg">Small / Vertical / JPEG</label>
                      <br />
                      <textarea id="small_ver_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.jpg" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_ver_jpg1">Small / Vertical / JPEG</label>
                      <br />
                      <textarea id="small_ver_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.jpg" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_small.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
                    </td>
                    <td>
                      <label for="small_ver_gif">Small / Vertical / GIF</label>
                      <br />
                      <textarea id="small_ver_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.gif" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_ver_gif1">Small / Vertical / GIF</label>
                      <br />
                      <textarea id="small_ver_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.gif" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <img src="images/logos/eunis_ver_small.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
                    </td>
                    <td>
                      <label for="small_ver_png">Small / Vertical / PNG</label>
                      <br />
                      <textarea id="small_ver_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.png" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                    <td>
                      <label for="small_ver_png1">Small / Vertical / PNG</label>
                      <br />
                      <textarea id="small_ver_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.png" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
                    </td>
                  </tr>
                </table>
                <%=cm.cmsMsg("logos_page_title")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="logos.jsp" />
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
  </body>
</html>
