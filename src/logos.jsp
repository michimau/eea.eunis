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
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,services#services.jsp,logos_location"/>
      </jsp:include>
      <h1>
        <%=cm.cmsText("logos_title")%>
      </h1>
      <br />
      <%=cm.cmsText("logos_description")%>
      <table width="100%" summary="Logos">
        <tr>
          <th class="resultHeader">
            <%=cm.cmsText("logos_header_image")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("logos_header_local")%>
          </th>
          <th class="resultHeader">
            <%=cm.cmsText("logos_header_website")%>
          </th>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_large.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
          </td>
          <td>
            <label for="large_hor_jpg">Large / Horizontal / JPEG</label>
            <br />
            <textarea class="inputTextField" id="large_hor_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.jpg" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_hor_jpg1">Large / Horizontal / JPEG</label>
            <br />
            <textarea class="inputTextField" id="large_hor_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.jpg" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_large.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
          </td>
          <td>
            <label for="large_hor_gif">Large / Horizontal / GIF</label>
            <br />
            <textarea class="inputTextField" id="large_hor_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.gif" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_hor_gif1">Large / Horizontal / GIF</label>
            <br />
            <textarea class="inputTextField" id="large_hor_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.gif" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_large.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 120px; height : 60px;" />
          </td>
          <td>
            <label for="large_hor_png">Large / Horizontal / PNG</label>
            <br />
            <textarea class="inputTextField" id="large_hor_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_large.png" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_hor_png1">Large / Horizontal / PNG</label>
            <br />
            <textarea class="inputTextField" id="large_hor_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_large.png" style="width : 120px; height : 60px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_small.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
          </td>
          <td>
            <label for="small_hor_jpg">Small / Horizontal / JPEG</label>
            <br />
            <textarea class="inputTextField" id="small_hor_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.jpg" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_hor_jpg1">Small / Horizontal / JPEG</label>
            <br />
            <textarea class="inputTextField" id="small_hor_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.jpg" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_small.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
          </td>
          <td>
            <label for="small_hor_gif">Small / Horizontal / GIF</label>
            <br />
            <textarea class="inputTextField" id="small_hor_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.gif" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_hor_gif1">Small / Horizontal / GIF</label>
            <br />
            <textarea class="inputTextField" id="small_hor_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.gif" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_hor_small.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 50px; height : 25px;" />
          </td>
          <td>
            <label for="small_hor_png">Small / Horizontal / PNG</label>
            <br />
            <textarea class="inputTextField" id="small_hor_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_hor_small.png" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_hor_png1">Small / Horizontal / PNG</label>
            <br />
            <textarea class="inputTextField" id="small_hor_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_hor_small.png" style="width : 50px; height : 25px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_large.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
          </td>
          <td>
            <label for="large_ver_jpg">Large / Vertical / JPEG</label>
            <br />
            <textarea class="inputTextField" id="large_ver_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.jpg" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_ver_jpg1">Large / Vertical / JPEG</label>
            <br />
            <textarea class="inputTextField" id="large_ver_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.jpg" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_large.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
          </td>
          <td>
            <label for="large_ver_gif">Large / Vertical / GIF</label>
            <br />
            <textarea class="inputTextField" id="large_ver_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.gif" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_ver_gif1">Large / Vertical / GIF</label>
            <br />
            <textarea class="inputTextField" id="large_ver_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.gif" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_large.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 60px; height : 120px;" />
          </td>
          <td>
            <label for="large_ver_png">Large / Vertical / PNG</label>
            <br />
            <textarea class="inputTextField" id="large_ver_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_large.png" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="large_ver_png1">Large / Vertical / PNG</label>
            <br />
            <textarea class="inputTextField" id="large_ver_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_large.png" style="width : 60px; height : 120px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_small.jpg" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
          </td>
          <td>
            <label for="small_ver_jpg">Small / Vertical / JPEG</label>
            <br />
            <textarea class="inputTextField" id="small_ver_jpg" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.jpg" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_ver_jpg1">Small / Vertical / JPEG</label>
            <br />
            <textarea class="inputTextField" id="small_ver_jpg1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.jpg" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_small.gif" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
          </td>
          <td>
            <label for="small_ver_gif">Small / Vertical / GIF</label>
            <br />
            <textarea class="inputTextField" id="small_ver_gif" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.gif" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_ver_gif1">Small / Vertical / GIF</label>
            <br />
            <textarea class="inputTextField" id="small_ver_gif1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.gif" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
        <tr>
          <td>
            <img src="images/logos/eunis_ver_small.png" alt="European Nature Information System" title="European Nature Information System" style="vertical-align : middle; width : 25px; height : 50px;" />
          </td>
          <td>
            <label for="small_ver_png">Small / Vertical / PNG</label>
            <br />
            <textarea class="inputTextField" id="small_ver_png" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="eunis_ver_small.png" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
          <td>
            <label for="small_ver_png1">Small / Vertical / PNG</label>
            <br />
            <textarea class="inputTextField" id="small_ver_png1" style="width : 250px;" rows="3" cols="80">&lt;a href="<%=domainPrefix%>" alt="European Nature Information System" title="European Nature Information System"&gt;&lt;img src="<%=domainPrefix%>/images/logos/eunis_ver_small.png" style="width : 25px; height : 50px; border : 0px;"&gt;&lt;/a&gt;</textarea>
          </td>
        </tr>
      </table>

      <%=cm.cmsMsg("logos_page_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="logos.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>
