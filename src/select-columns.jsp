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
            location = "home_location#index.jsp,species_location#species.jsp,species_advanced_search_location#species-advanced.jsp,select_columns_location";
            resultsPage = "species-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home_location#index.jsp,combined_search_location#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-species.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("habitats")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "home_location#index.jsp,habitats_location#habitats.jsp,habitats_advanced_search#habitats-advanced.jsp,select_columns_location";
            resultsPage = "habitats-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home_location#index.jsp,combined_search_location#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-habitats.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("sites")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "home_location#index.jsp,sites_location#sites.jsp,sites_advanced_search_location#sites-advanced.jsp,select_columns_location";
            resultsPage = "sites-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "home_location#index.jsp,combined_search_location#combined-search.jsp,select_columns_location";
            resultsPage = "combined-search-results-sites.jsp";
          }
        }
      }
    %>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
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
              <select class="inputTextField" id="list1" size="10" name="list1" style="width : 300px;">
<%
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("species"))
  {
%>
                <option value="showGroup"><%=cm.cms("select_columns_showGroup")%></option>
                <option value="showOrder"><%=cm.cms("select_columns_showOrder")%></option>
                <option value="showFamily"><%=cm.cms("select_columns_showFamily")%></option>
                <option value="showScientificName"><%=cm.cms("select_columns_showScientificName")%></option>
                <option value="showVernacularName"><%=cm.cms("select_columns_showVernacularName")%></option>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("habitats"))
  {
%>
                <option value="showLevel"><%=cm.cms("select_columns_showLevel")%></option>
                <option value="showEUNISCode"><%=cm.cms("select_columns_showEUNISCode")%></option>
                <option value="showANNEXCode"><%=cm.cms("select_columns_showANNEXCode")%></option>
                <option value="showScientificName"><%=cm.cms("select_columns_showScientificNameHab")%></option>
                <option value="showPriority"><%=cm.cms("select_columns_showPriority")%></option>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("sites"))
  {
%>
                <option value="showSourceDB"><%=cm.cms("select_columns_showSourceDB")%></option>
                <option value="showCountry"><%=cm.cms("select_columns_showCountry")%></option>
                <option value="showDesignationType"><%=cm.cms("select_columns_showDesignationType")%></option>
                <option value="showName"><%=cm.cms("select_columns_showName")%></option>
                <option value="showCoordinates"><%=cm.cms("select_columns_showCoordinates")%></option>
                <option value="showSize"><%=cm.cms("select_columns_showSize")%></option>
                <option value="showDesignationYear"><%=cm.cms("select_columns_showDesignationYear")%></option>
                <option value="showLength"><%=cm.cms("select_columns_showLength")%></option>
                <option value="showMinAltitude"><%=cm.cms("select_columns_showMinAltitude")%></option>
                <option value="showMaxAltitude"><%=cm.cms("select_columns_showMaxAltitude")%></option>
                <option value="showMeanAltitude"><%=cm.cms("select_columns_showMeanAltitude")%></option>
<%
  }
%>
              </select>
              <%=cm.cmsLabel("select_columns_available_label")%>
<%
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("species"))
  {
%>
              <%=cm.cmsInput("select_columns_showGroup")%>
              <%=cm.cmsInput("select_columns_showOrder")%>
              <%=cm.cmsInput("select_columns_showFamily")%>
              <%=cm.cmsInput("select_columns_showScientificName")%>
              <%=cm.cmsInput("select_columns_showVernacularName")%>
              <%=cm.cmsInput("select_columns_showPriority")%>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("habitats"))
  {
%>
              <%=cm.cmsInput("select_columns_showLevel")%>
              <%=cm.cmsInput("select_columns_showEUNISCode")%>
              <%=cm.cmsInput("select_columns_showANNEXCode")%>
              <%=cm.cmsInput("select_columns_showScientificNameHab")%>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("sites"))
  {
%>
              <%=cm.cmsInput("select_columns_showSourceDB")%>
              <%=cm.cmsInput("select_columns_showCountry")%>
              <%=cm.cmsInput("select_columns_showDesignationType")%>
              <%=cm.cmsInput("select_columns_showName")%>
              <%=cm.cmsInput("select_columns_showCoordinates")%>
              <%=cm.cmsInput("select_columns_showSize")%>
              <%=cm.cmsInput("select_columns_showDesignationYear")%>
              <%=cm.cmsInput("select_columns_showLength")%>
              <%=cm.cmsInput("select_columns_showMinAltitude")%>
              <%=cm.cmsInput("select_columns_showMaxAltitude")%>
              <%=cm.cmsInput("select_columns_showMeanAltitude")%>
<%
  }
%>
            </td>
            <td width="20%" valign="middle" align="center">
              <input type="button" title="<%=cm.cms("select_columns_add_title")%>" value="  <%=cm.cms("select_columns_add_value")%>  " onclick="move(this.form.list1,this.form.displayedColumns)" id="B1" name="B1" class="inputTextField" />
              <%=cm.cmsTitle("select_columns_add_title")%>
              <%=cm.cmsInput("select_columns_add_value")%>
              <br />
              <br />
              <input type="button" title="<%=cm.cms("select_columns_remove_title")%>" value="  <%=cm.cms("select_columns_remove_value")%>  " onclick="move(this.form.displayedColumns,this.form.list1)" id="B2" name="B2" class="inputTextField" />
              <%=cm.cmsTitle("select_columns_remove_title")%>
              <%=cm.cmsInput("select_columns_remove_value")%>
              <br />
              <br />
              <input type="button" title="<%=cm.cms("select_all_columns_add_title")%>" value="  <%=cm.cms("select_all_columns_add_value")%>  " onclick="moveAll(this.form.list1, this.form.displayedColumns)" id="B3" name="B3" class="inputTextField" />
              <%=cm.cmsTitle("select_all_columns_add_title")%>
              <%=cm.cmsInput("select_all_columns_add_value")%>
              <br />
              <br />
              <input type="button" title="<%=cm.cms("select_all_columns_remove_title")%>" value="  <%=cm.cms("select_all_columns_remove_value")%>  " onclick="moveAll(this.form.displayedColumns,this.form.list1)" id="B4" name="B4" class="inputTextField" />
              <%=cm.cmsTitle("select_all_columns_remove_title")%>
              <%=cm.cmsInput("select_all_columns_remove_value")%>
            </td>
            <td width="40%">
              <label for="displayedColumns"><%=cm.cmsText("select_columns_selected_label")%>:</label>
              <br />
              <select class="inputTextField" style="width : 300px" id="displayedColumns" size="10" name="displayedColumns"></select>
            </td>
          </tr>
        </table>
        <br />
        <input type="submit" title="<%=cm.cms("select_columns_proceed_title")%>" id="proceed" name="Search" value="<%=cm.cms("select_columns_proceed_value")%>" class="inputTextField" />
        <%=cm.cmsTitle("select_columns_proceed_title")%>
        <%=cm.cmsInput("select_columns_proceed_value")%>
      </form>

      <%=cm.cmsMsg("select_columns_page_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="select-columns.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>