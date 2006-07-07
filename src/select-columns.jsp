<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Select displayed columns in results of advances/combined search
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.Vector"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("select_columns_page_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
      <!--
        function move(fbox,tbox) {
          for(var i=0; i<fbox.options.length; i++) {
            if(fbox.options[i].selected && fbox.options[i].value != "") {
              var no = new Option();
              no.value = fbox.options[i].value;
              no.text = fbox.options[i].text;
              tbox.options[tbox.options.length] = no;
              fbox.options[i].value = "";
              fbox.options[i].text = "";
            }
          }
          BumpUp(fbox);
        }

        function BumpUp(box)  {
          for(var i=0; i<box.options.length; i++) {
            if(box.options[i].value == "")  {
              for(var j=i; j<box.options.length-1; j++)  {
                box.options[j].value = box.options[j+1].value;
                box.options[j].text = box.options[j+1].text;
              }
              var ln = i;
              break;
            }
          }
          if(ln < box.options.length)  {
            box.options.length -= 1;
            BumpUp(box);
          }
        }

        function moveAll(fbox,tbox) {
          for(var i=0; i<fbox.options.length; i++) {
            if(fbox.options[i].value != "") {
              var no = new Option();
              no.value = fbox.options[i].value;
              no.text = fbox.options[i].text;
              tbox.options[tbox.options.length] = no;
              fbox.options[i].value = "";
              fbox.options[i].text = "";
            }
          }
          BumpUp(fbox);
        }

        function validateForm(box) {
          if (box.options.length == 0) {
            alert("Please add at least one column in the displayed results");
            return false;
          }
          var showColumns="";
          for(var j=0; j < box.options.length; j++)  {
            showColumns += box.options[j].value;
            if (j < box.options.length - 1) showColumns += ",";
          }
          document.eunis.showColumns.value = showColumns;
        }
      // -->
    </script>
    <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
      <jsp:setProperty name="formBean" property="*"/>
    </jsp:useBean>
<%
      String searchedDatabase = formBean.getSearchedNatureObject();
      String origin = formBean.getOrigin();
      //System.out.println("no = " + searchedDatabase);
      //System.out.println("origin = " + origin);
      Vector searchCriteria = new Vector();
      searchCriteria.addElement("searchCriteria");

      // Prepare the strings for the seader-dynamic2.jsp
      String location = "";
      String resultsPage = "";
      if (null != searchedDatabase) {
        if (searchedDatabase.equalsIgnoreCase("species")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "home#index.jsp,species#species.jsp,advanced_search#species-advanced.jsp,select_columns_location";
            resultsPage = "species-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home#index.jsp,combined_search#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-species.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("habitats")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "home#index.jsp,habitat_types#habitats.jsp,habitats_advanced_search#habitats-advanced.jsp,select_columns_location";
            resultsPage = "habitats-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home#index.jsp,combined_search#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-habitats.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("sites")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "home#index.jsp,sites#sites.jsp,advanced_search#sites-advanced.jsp,select_columns_location";
            resultsPage = "sites-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home#index.jsp,combined_search#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-sites.jsp";
          }
        }
      }
    %>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getHeader?site=eunis" )%>
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
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=location%>"/>
                </jsp:include>
            <%
              SessionManager.setExplainedcriteria(request.getParameter("explainedcriteria"));
              SessionManager.setListcriteria(request.getParameter("listcriteria"));

              if(request.getParameter("combinednatureobject2")!=null && SessionManager.getCombinednatureobject2()==null) {
                SessionManager.setCombinednatureobject2(request.getParameter("combinednatureobject2"));
                SessionManager.setCombinedlistcriteria2(request.getParameter("combinedlistcriteria2"));
                SessionManager.setCombinedexplainedcriteria2(request.getParameter("combinedexplainedcriteria2"));
              }

              if(request.getParameter("combinednatureobject3")!=null && SessionManager.getCombinednatureobject3()==null) {
                SessionManager.setCombinednatureobject3(request.getParameter("combinednatureobject3"));
                SessionManager.setCombinedlistcriteria3(request.getParameter("combinedlistcriteria3"));
                SessionManager.setCombinedexplainedcriteria3(request.getParameter("combinedexplainedcriteria3"));
              }
              // Only for sites searches.
              if(request.getParameter("sourcedbcriteria")!=null && SessionManager.getSourcedb()==null) {
                SessionManager.setSourcedb(ro.finsiel.eunis.search.sites.SitesSearchUtility.translateSourceDB(request.getParameter("sourcedbcriteria")));
              }

              SessionManager.setCombinedcombinationtype(request.getParameter("combinedcombinationtype"));
            %>
                  <form name="eunis" method="post" action="<%=resultsPage%>" onsubmit="return validateForm(document.eunis.displayedColumns);">
                    <input type="hidden" id="showColumns" name="showColumns" value="" />
                    <%=formBean.toFORMParam(searchCriteria)%>
                    <h1>
                      <%=cm.cms("select_columns_description")%>
                    </h1>
                    <br />
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
                      <tr>
                        <td width="40%">
                          <label for="list1">
                            <%=cm.cmsText("select_columns_available_label")%>:
                          </label>
                          <br />
                          <select id="list1" size="10" name="list1" style="width : 300px;">
            <%
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("species"))
              {
            %>
                            <option value="showGroup"><%=cm.cms("group")%></option>
                            <option value="showOrder"><%=cm.cms("order_column")%></option>
                            <option value="showFamily"><%=cm.cms("family")%></option>
                            <option value="showScientificName"><%=cm.cms("scientific_name")%></option>
                            <option value="showVernacularName"><%=cm.cms("vernacular_names")%></option>
            <%
              }
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("habitats"))
              {
            %>
                            <option value="showLevel"><%=cm.cms("generic_index_07")%></option>
                            <option value="showEUNISCode"><%=cm.cms("eunis_code")%></option>
                            <option value="showANNEXCode"><%=cm.cms("annex_code")%></option>
                            <option value="showScientificName"><%=cm.cms("name")%></option>
                            <option value="showPriority"><%=cm.cms("priority")%></option>
            <%
              }
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("sites"))
              {
            %>
                            <option value="showSourceDB"><%=cm.cms("source_data_set")%></option>
                            <option value="showCountry"><%=cm.cms("country")%></option>
                            <option value="showDesignationType"><%=cm.cms("designation_type")%></option>
                            <option value="showName"><%=cm.cms("site_name")%></option>
                            <option value="showCoordinates"><%=cm.cms("coordinates")%></option>
                            <option value="showSize"><%=cm.cms("size")%></option>
                            <option value="showDesignationYear"><%=cm.cms("designation_year")%></option>
                            <option value="showLength"><%=cm.cms("length")%></option>
                            <option value="showMinAltitude"><%=cm.cms("min_altitude")%></option>
                            <option value="showMaxAltitude"><%=cm.cms("max_altitude")%></option>
                            <option value="showMeanAltitude"><%=cm.cms("mean_altitude")%></option>
            <%
              }
            %>
                          </select>
                          <%=cm.cmsLabel("select_columns_available_label")%>
            <%
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("species"))
              {
            %>
                          <%=cm.cmsInput("group")%>
                          <%=cm.cmsInput("order_column")%>
                          <%=cm.cmsInput("family")%>
                          <%=cm.cmsInput("scientific_name")%>
                          <%=cm.cmsInput("vernacular_names")%>
                          <%=cm.cmsInput("priority")%>
            <%
              }
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("habitats"))
              {
            %>
                          <%=cm.cmsInput("generic_index_07")%>
                          <%=cm.cmsInput("eunis_code")%>
                          <%=cm.cmsInput("annex_code")%>
                          <%=cm.cmsInput("name")%>
            <%
              }
              if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("sites"))
              {
            %>
                          <%=cm.cmsInput("source_data_set")%>
                          <%=cm.cmsInput("country")%>
                          <%=cm.cmsInput("designation_type")%>
                          <%=cm.cmsInput("site_name")%>
                          <%=cm.cmsInput("coordinates")%>
                          <%=cm.cmsInput("size")%>
                          <%=cm.cmsInput("designation_year")%>
                          <%=cm.cmsInput("length")%>
                          <%=cm.cmsInput("min_altitude")%>
                          <%=cm.cmsInput("max_altitude")%>
                          <%=cm.cmsInput("mean_altitude")%>
            <%
              }
            %>
                        </td>
                        <td width="20%" valign="middle" align="center">
                          <input type="button" title="<%=cm.cms("select_columns_add_title")%>"
                                 value="  <%=cm.cms("select_columns_add_value")%>  " onclick="move(this.form.list1,this.form.displayedColumns)"
                                 id="B1" name="B1" class="standardButton" />
                          <%=cm.cmsTitle("select_columns_add_title")%>
                          <%=cm.cmsInput("select_columns_add_value")%>
                          <br />
                          <br />
                          <input type="button" title="<%=cm.cms("select_columns_remove_title")%>"
                                 value="  <%=cm.cms("select_columns_remove_value")%>  " onclick="move(this.form.displayedColumns,this.form.list1)"
                                 id="B2" name="B2" class="standardButton" />
                          <%=cm.cmsTitle("select_columns_remove_title")%>
                          <%=cm.cmsInput("select_columns_remove_value")%>
                          <br />
                          <br />
                          <input type="button" title="<%=cm.cms("select_all_columns")%>"
                                 value="  <%=cm.cms("select_all_columns_add_value")%>  " onclick="moveAll(this.form.list1, this.form.displayedColumns)"
                                 id="B3" name="B3" class="standardButton" />
                          <%=cm.cmsTitle("select_all_columns")%>
                          <%=cm.cmsInput("select_all_columns_add_value")%>
                          <br />
                          <br />
                          <input type="button" title="<%=cm.cms("remove_all_columns")%>"
                                 value="  <%=cm.cms("select_all_columns_remove_value")%>  " onclick="moveAll(this.form.displayedColumns,this.form.list1)"
                                 id="B4" name="B4" class="standardButton" />
                          <%=cm.cmsTitle("remove_all_columns")%>
                          <%=cm.cmsInput("select_all_columns_remove_value")%>
                        </td>
                        <td width="40%">
                          <label for="displayedColumns"><%=cm.cmsText("select_columns_selected_label")%>:</label>
                          <br />
                          <select style="width : 300px" id="displayedColumns" size="10" name="displayedColumns"></select>
                        </td>
                      </tr>
                    </table>
                    <br />
                    <input type="submit" title="<%=cm.cms("select_columns_proceed_title")%>" id="proceed" name="Search" value="<%=cm.cms("proceed_to_results")%>"
                           class="searchButton" />
                    <%=cm.cmsTitle("select_columns_proceed_title")%>
                    <%=cm.cmsInput("proceed_to_results")%>
                  </form>

                  <%=cm.cmsMsg("select_columns_page_title")%>
                  <jsp:include page="footer.jsp">
                    <jsp:param name="page_name" value="select-columns.jsp" />
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
      <%=cm.readContentFromURL( "http://webservices.eea.europa.eu/templates/getFooter?site=eunis" )%>
    </div>
  </body>
</html>
