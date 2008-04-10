<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Template page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement cm = SessionManager.getWebContent();
      String eeaHome = application.getInitParameter( "EEA_HOME" );
      String btrail = "eea#" + eeaHome + ",home#index.jsp,category_location#category.jsp";
    %>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                    <li>
                      <a href="help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <img alt="Loading image" id="loading" src="images/loading.gif" />
                <h1>Heading of level 1 - Page title</h1>
                <div class="documentDescription">
                  This is the description or introduction for this page. It is styled as teaser.
                </div>
                <p>
                  Here is 2<sup>nd</sup> paragraph. Lorem ipsum dolor
                  <span class="link-html"><a href="unvisitedpage.html">unvisited link</a></span>,
                  consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut
                  labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
                  accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no
                  sea takimata sanctus est Lorem ipsum dolor sit amet.
                  Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
                  invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
                  vero eos et accusam et justo duo dolores et ea rebum.
                </p>
                <blockquote>
                  <p>
                    This is a long quotation. This is a long quotation. This is a long
                    quotation. This is a long quotation. This is a long quotation.
                    (that is marked&nbsp; up with &lt;blockquote&gt;)
                  </p>
                  <p class="source">by John What</p>
                </blockquote>
                <h2>
                  Heading of level 2
                </h2>
                <p>
                  Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut
                  labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
                  accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no
                  sea takimata sanctus est Lorem ipsum dolor sit amet.
                </p>
                <h3>
                  Heading of level 3
                </h3>
                <h4>
                  Heading of level 4
                </h4>
                <h5>
                  Heading of level 5
                </h5>
                <h6>
                  Heading of level 6
                </h6>
                <hr>
                <h2>
                  Rounded corners boxes
                </h2>
                <p>
                  Here you see an example of how to apply background with rounded corners to a div tag.
                </p>
                <div style="padding-top: 0pt; padding-bottom: 0pt;" class="roundedBox lightBGC"><b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b></b>
                <h4>Light rounded box</h4>
                <p>This text appears on a rounded corners light background color</p>
                <b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b></b></div>

                <div style="padding-top: 0pt; padding-bottom: 0pt;" class="roundedBox mediumBGC"><b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b></b>
                <h4>Dark rounded box</h4>
                <p>This text appears on a rounded corners dark background color</p>
                <b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b></b></div>
                <h2>
                  Scope / Local search
                </h2>
                <div style="padding-top: 0pt; padding-bottom: 0pt;" class="localSearch roundedBox lightBGC"><b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b></b>
                <h4>
                  Search on data set and application
                </h4>
                <form method="get" action="available.asp" id="form2" name="form2">
                <input name="type" value="search" type="hidden">

                <div class="field">
                  <label>Title</label>
                      <div class="formHelp">Enter one or more keywords for a search. Use of AND/OR is supported.</div>

                      <div></div>
                  <input name="search" value="" size="30" maxlength="50" tabindex="1" type="text">
                      <input value="Search" class="searchButton" id="Submit2" name="Submit2" tabindex="2" type="submit">
                    </div>

                </form>
                <b style="background-color: transparent;" class="artop"><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx4"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx3"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx2"></b><b style="border-color: rgb(255, 255, 255); background-color: transparent;" class="rx1"></b></b></div>
                <h2>
                  CSS3 Multicolumn (Firefox only)
                </h2>
                <div id="multicolumn">
                  <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nulla at turpis eget nibh ultricies dignissim. Duis luctus euismod turpis. Mauris augue. Aliquam facilisis semper elit. Pellentesque semper hendrerit arcu. Phasellus eleifend commodo justo. Aliquam orci urna, imperdiet sit amet, posuere in, lobortis et, risus. Integer interdum nonummy erat. Nullam tellus. Sed accumsan. Vestibulum orci ipsum, eleifend vitae, mollis vel, mollis sed, purus. Suspendisse mollis elit eu magna. Morbi egestas. Nunc leo ipsum, blandit ac, viverra quis, porttitor quis, dui. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus scelerisque ipsum ut justo. Pellentesque et ligula eu massa sagittis rutrum. In urna nibh, eleifend vel, suscipit ut, sagittis id, nunc.</p>
                  <p>Nam ut sapien sed pede pulvinar rutrum. Nunc eu elit sed augue aliquet tincidunt. Morbi rutrum. Vestibulum dui turpis, lobortis quis, euismod sed, consectetuer sit amet, nunc. Nam mi. Fusce at nisl eu tortor bibendum eleifend. Sed ac metus. Phasellus nec elit. Morbi tortor nulla, tristique a, adipiscing at, consectetuer et, nisi. Nunc vel sapien sed risus hendrerit egestas. Vivamus turpis arcu, placerat eu, congue vel, commodo ut, nisl.</p>
                </div>

                <h2>
                  Auto-Link-Icons
                </h2>
                <p>
                  Link types are automatically detected on client side by a javascript which will add the necessary class icon before the link. Here you see some examples:
                </p>
                <h3>
                  Icons based on protocols
                </h3>
                <p>
                  <a href="http://www.externalsite.eu">external link</a>,
                  <a href="https://www.externalsite.eu">secure link</a>,
                  <a href="ftp://externalsite.eu">FTP link</a>,
                  <a href="callto://externalsite.eu">callto link</a>,
                  <a href="mailto:any@any.eu">mailto link</a>
                  <br>
                  <strong>Test links</strong>: <a href="https://www.eea.europa.eu">new EEA domain link</a>,
                  <a href="https://www.eea.europa.eu/document.pdf">PDF on new EEA domain link</a>,
                  <a href="https://reports.eea.eu.int/document.ppt">Presentation on old EEA domain</a>
                </p>
                <h3>
                  Some popular file extensions
                </h3>
                <p>
                  <a href="document.pdf">PDF document</a>,
                  <a href="doc.doc">Word document</a>,
                  <a href="pres.zip">Zip archive</a>,
                  <a href="doc.xls">Excel link</a>,
                  <a href="download.asp?fileid=456&amp;filetype=.pdf">Fake PDF file extension</a> (just add file extension in the URL as query at the end!),
                </p>
                <p>
                  There are more icons detected, see <a href="all_icons">list of all icons available</a>
                </p>
                <hr>
                <h2>Lists</h2>

                <h3>Ordered list:</h3>
                <ol>
                 <li>Apples</li>
                 <li>Bananas</li>

                 <li>Lemons</li>
                 <li>Oranges</li>
                </ol>

                <h3>Unordered list:</h3>
                <ul>
                 <li>Apples</li>
                 <li>Bananas</li>
                 <li>Lemons</li>

                 <li>Oranges</li>
                </ul>


                <h3>A nested undordered list:</h3>
                <ul>
                  <li>Coffee</li>
                  <li>Tea
                    <ul>
                    <li>Black tea</li>
                    <li>Green tea
                      <ul>

                      <li>China</li>
                      <li>Africa</li>
                      </ul>
                    </li>
                    </ul>
                  </li>
                  <li>Milk</li>

                </ul>
                <h3>A nested ordered list:</h3>
                <ol>
                  <li>Coffee</li>
                  <li>Tea
                    <ol>
                    <li>Black tea</li>
                    <li>Green tea
                      <ol>
                      <li>China</li>

                      <li>Africa</li>
                      </ol>
                    </li>
                    </ol>
                  </li>
                  <li>Milk</li>
                </ol>
                <h3>
                  Terms, glossary, definition lists and other tags used for explanations:
                </h3>
                <dl>
                  <dt>Coffee</dt>
                  <dd>Black hot drink</dd>
                  <dt>Milk</dt>
                  <dd>White cold drink</dd>
                </dl>
                <p>
                  Abbreviations: <abbr title="United Nations">UN</abbr>
                  <br>
                  Acronyms: <acronym title="World Wide Web">WWW</acronym>
                  <br>
                  Links to EEA glossary, Gemet or other terminologies webpages: <a class="explain" href="#" title="Ozone depletion">Ozone depletion</a>
                </p>
                <h3>
                  Other various tags
                </h3>
                <p>
                  The pre tag is good for displaying formulas, computer code or other already formatted text:
                </p>
                <pre class="roundedBox">
                  for i = 1 to 10
                    print i
                    next i
                </pre>
                <h2>
                  Tables
                </h2>
                <h3>
                  Zebra static content listing
                </h3>
                <table id="your-zebra-content-id" class="datatable" summary="Static Content listing">
                  <thead>
                    <tr>
                      <th>&nbsp;Title&nbsp;</th>
                      <th>&nbsp;Size&nbsp;</th>
                      <th>&nbsp;Modified&nbsp;</th>
                      <th>&nbsp;State&nbsp;</th>
                      <th>&nbsp;Other&nbsp;</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                         Title 1
                      </td>
                      <td>
                        10 kB
                      </td>
                      <td>2006-01-10 10:20</td>
                      <td>
                        Published
                      </td>
                      <td>
                        Blabla
                      </td>
                     </tr>
                    <tr class="zebraeven">
                      <td>
                          Title 2
                      </td>
                      <td>
                        20 kB
                      </td>
                      <td>2006-03-13 10:20</td>
                      <td>
                        Unpublished
                      </td>
                      <td>
                        Blabla2
                      </td>
                     </tr>
                    <tr>
                      <td>
                         Title 3
                      </td>
                      <td>
                        50 kB
                      </td>
                      <td>2006-02-10 10:20</td>
                      <td>
                        Unpublished
                      </td>
                      <td>
                        Blabla3
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td>
                        Title 4
                      </td>
                      <td>
                        20 kB
                      </td>
                    <td>2006-03-13 10:20</td>
                      <td>
                        Unpublished
                      </td>
                      <td>
                        Blabla2
                      </td>
                    </tr>
                  </tbody>
                </table>
                <h3>
                  Simple sortable table, client-side
                </h3>
                <p>
                  In order to have a client-side sortable table via javascript you just need to add the class "listing" to the table. See source code.
                </p>
                <table id="your-table-id" class="listing" summary="Content listing">
                  <thead>
                    <tr>
                      <th style="cursor: pointer;"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">&nbsp;Title&nbsp;<img src="http://webservices.eea.europa.eu/templates/arrowUp.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">&nbsp;Size&nbsp;<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">&nbsp;Modified&nbsp;<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">&nbsp;State&nbsp;<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                      <th class="nosort">&nbsp;Non sortable column&nbsp;</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        Title 1
                      </td>
                      <td>
                        10 kB
                      </td>
                      <td>
                        2006-01-10 10:20
                      </td>
                      <td>
                        Published
                      </td>
                      <td>
                        Blabla
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td>
                        Title 2
                      </td>
                      <td>
                        20 kB
                      </td>
                      <td>2006-03-13 10:20</td>
                      <td>
                        Unpublished
                      </td>
                      <td>
                        Blabla2
                      </td>
                     </tr>
                     <tr>
                       <td>
                        Title 3
                      </td>
                      <td>
                        50 kB
                      </td>
                      <td>2006-02-10 10:20</td>
                      <td>
                        Unpublished
                      </td>
                      <td>
                        Blabla3
                      </td>
                    </tr>
                  </tbody>
                </table>
                <h3>
                  Complex sortable datatable, client-side
                </h3>
                <p>
                  The example is copied and adjusted from <span class="link-html"><a href="http://reports.eea.eu.int/GH-98-96-518-EN-C/en/page007.html">http://reports.eea.eu.int/GH-98-96-518-EN-C/en/page007.html</a></span>
                </p>
                <table id="your-sortable-datatable-id" class="listing" summary="sortable complex table">
                  <col style="width: 11em;">
                  <col style="width: 6em;">
                  <col style="width: 6em;">
                  <col style="width: 6em;">
                  <thead>
                    <tr>
                      <th scope="col" class="scope-col nosort"></th>
                      <th scope="col" class="scope-col nosort" colspan="3">(Mio t CO<sub>2</sub>)</th>
                    </tr>
                    <tr>
                      <th style="cursor: pointer;" scope="col" class="scope-col"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">COUNTRY<img src="http://webservices.eea.europa.eu/templates/arrowUp.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;" scope="col" class="scope-col number"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">1985<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;" scope="col" class="scope-col number"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">1990<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                      <th style="cursor: pointer;" scope="col" class="scope-col number"><img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9">1994<img src="http://webservices.eea.europa.eu/templates/arrowBlank.gif" height="6" width="9"></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td scope="row" class="scope-row">Austria</td>
                      <td class="number">54</td>
                      <td class="number">58</td>
                      <td class="number">57</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Belgium</td>
                      <td class="number">105</td>
                      <td class="number">111</td>
                      <td class="number">117</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Denmark</td>
                      <td class="number">61</td>
                      <td class="number">53</td>
                      <td class="number">63</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Finland</td>
                      <td class="number">48</td>
                      <td class="number">53</td>
                      <td class="number">61</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">France</td>
                      <td class="number">378</td>
                      <td class="number">368</td>
                      <td class="number">349</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Germany</td>
                      <td class="number">1088</td>
                      <td class="number">992</td>
                      <td class="number">897</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Greece</td>
                      <td class="number">58</td>
                      <td class="number">73</td>
                      <td class="number">78</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Ireland</td>
                      <td class="number">26</td>
                      <td class="number">31</td>
                      <td class="number">32</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Italy</td>
                      <td class="number">350</td>
                      <td class="number">402</td>
                      <td class="number">393</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Luxembourg</td>
                      <td class="number">12</td>
                      <td class="number">12</td>
                      <td class="number">12</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Netherlands</td>
                      <td class="number">145</td>
                      <td class="number">157</td>
                      <td class="number">164</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Portugal</td>
                      <td class="number">26</td>
                      <td class="number">40</td>
                      <td class="number">45</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Spain</td>
                      <td class="number">183</td>
                      <td class="number">209</td>
                      <td class="number">229</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">Sweden</td>
                      <td class="number">60</td>
                      <td class="number">52</td>
                      <td class="number">56</td>
                    </tr>
                    <tr>
                      <td scope="row" class="scope-row">United Kingdom</td>
                      <td class="number">556</td>
                      <td class="number">579</td>
                      <td class="number">550</td>
                    </tr>
                    <tr class="sum">
                      <td scope="row" class="scope-row">EU15 total</td>
                      <td class="number">3150</td>
                      <td class="number">3190</td>
                      <td class="number">3103</td>
                    </tr>
                  </tbody>
                </table>
                <h3>
                  Sortable server-side
                </h3>
                <p>
                  In the server-side sortable table the arrow images are in the HTML (not in CSS or via Javascript). You do not need to use the
                  class "listing".
                </p>
                <table class="sortable" summary="sortable server-side table">
                  <thead>
                    <tr>
                      <th class="sorted" scope="col"><a title="Sorted A..Z - Click to reverse" rel="nofollow" href="#">Id<img src="/styles/sortup.gif" alt="" height="12" width="12"></a></th>
                      <th scope="col"><a title="Sortable" rel="nofollow" href="#">Title<img src="/styles/sortnot.gif" alt="" height="12" width="12"></a></th>
                      <th scope="col"><a title="Sortable" rel="nofollow" href="#">Period<img src="/styles/sortnot.gif" alt="" height="12" width="12"></a></th>
                      <th scope="col"><span title="Not sortable">Not sortable</span></th>
                    </tr>
                  </thead>
                  <tbody>
                      <tr class="zebraeven">
                        <td>A</td>
                        <td>Greek Period</td>
                        <td>1000 BC - 323 BC</td>
                        <td>Filler 1</td>
                      </tr>
                      <tr>
                        <td>B</td>
                        <td>Roman Age</td>
                        <td>500 BC - 600</td>
                        <td>Filler 2</td>
                      </tr>
                      <tr class="zebraeven">
                        <td>C</td>
                        <td>Middle Ages</td>
                        <td>600 - 1350</td>
                        <td>Filler 3</td>
                      </tr>
                      <tr>
                        <td>D</td>
                        <td>Renaissance</td>
                        <td>1380 - 1480</td>
                        <td>Filler 4</td>
                      </tr>
                      <tr class="zebraeven">
                        <td>E</td>
                        <td>Colonial Expansion</td>
                        <td>1480 - 1580</td>
                        <td>Filler 5</td>
                      </tr>
                      <tr>
                        <td>F</td>
                        <td>Enlightenment</td>
                        <td>1740 - 1800</td>
                        <td>Filler 6</td>
                      </tr>
                      <tr class="zebraeven">
                        <td>G</td>
                        <td>Unification/Union</td>
                        <td>1957 - </td>
                        <td>Filler 7</td>
                      </tr>
                    </tbody>
                  </table>
                  <div class="discussion">
                  </div>
                <%
                      out.flush();
                %>
                  <script language="JavaScript" type="text/javascript">
                  //<![CDATA[
                    var load = document.getElementById( "loading" );
                    load.style.display="none";
                  //]]>
                  </script>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="template1.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
<%
  out.flush();
%>
