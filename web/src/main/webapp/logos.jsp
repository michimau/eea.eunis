<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : EUNIS Logo
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
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
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("logos_page_title") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
<!-- MAIN CONTENT -->
        <h1>
          <%=cm.cmsPhrase("EUNIS Logo")%>
        </h1>
        <p>
        <%=cm.cmsPhrase("Please use the provided logos to link from your website to EUNIS Database.<br />In order to use them, save the images using right-click and use the link from the text box <br /> or<br /> link directly to our website by using the link provided on third column.")%>
		</p>
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
    </stripes:layout-component>
</stripes:layout-render>
