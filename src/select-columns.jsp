<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Select displayed columns in results of advances/combined search
--%>
<%@ page import="java.util.Vector"%>
<%@ page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <title><%=application.getInitParameter("PAGE_TITLE")%>Select columns to be displayed within results</title>
    <jsp:include page="header-page.jsp" />
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
            location = "Home#index.jsp,Species#species.jsp,Advanced Search#species-advanced.jsp,Select columns";
            resultsPage = "species-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "Home#index.jsp,Combined Search#combined-search.jsp,Select columns";
            resultsPage = "combined-search-results-species.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("habitats")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "Home#index.jsp,Habitat types#habitats.jsp,Advanced Search#habitats-advanced.jsp,Select columns";
            resultsPage = "habitats-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "Home#index.jsp,Combined Search#combined-search.jsp,Select columns";
            resultsPage = "combined-search-results-habitats.jsp";
          }
        }
        if (searchedDatabase.equalsIgnoreCase("sites")) {
          if (null != origin && origin.equalsIgnoreCase("Advanced")) {
            location = "Home#index.jsp,Sites#sites.jsp,Advanced Search#sites-advanced.jsp,Select columns";
            resultsPage = "sites-advanced-results.jsp";
          }
          if (null != origin && origin.equalsIgnoreCase("Combined")) {
            location = "Home#index.jsp,Combined Search#combined-search.jsp,Select columns";
            resultsPage = "combined-search-results-sites.jsp";
          }
        }
      }
    %>
  </head>
  <body>
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
        <h5>
          Please select the columns to be displayed in search results
        </h5>
        <br />
        <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="layout">
          <tr>
            <td width="40%">
              <label for="list1">Available columns which can be displayed:</label>
              <br />
              <select class="inputTextField" id="list1" size="10" name="list1" style="width : 300px;">
<%
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("species"))
  {
%>
                <option value="showGroup">Group</option>
                <option value="showOrder">Order</option>
                <option value="showFamily">Family</option>
                <option value="showScientificName">Scientific name</option>
                <option value="showVernacularName">Vernacular names</option>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("habitats"))
  {
%>
                <option value="showLevel">Level</option>
                <option value="showEUNISCode">EUNIS Code</option>
                <option value="showANNEXCode">ANNEX I Code</option>
                <option value="showScientificName">Name</option>
                <option value="showPriority">Priority</option>
<%
  }
  if (null != searchedDatabase && searchedDatabase.equalsIgnoreCase("sites"))
  {
%>
                <option value="showSourceDB">Source data set</option>
                <option value="showCountry">Country</option>
                <option value="showDesignationType">Designation type</option>
                <option value="showName">Site name</option>
                <option value="showCoordinates">Coordinates</option>
                <option value="showSize">Size</option>
                <option value="showDesignationYear">Designation year</option>
                <option value="showLength">Length</option>
                <option value="showMinAltitude">Minimum altitude</option>
                <option value="showMaxAltitude">Maximum altitude</option>
                <option value="showMeanAltitude">Mean altitude</option>
<%
  }
%>
              </select>
            </td>
            <td width="20%" valign="middle" align="center">
              <input type="button" title="Add column to the results" value="   &gt;   " onclick="move(this.form.list1,this.form.displayedColumns)" name="B1" class="inputTextField" />
              <br />
              <br />
              <input type="button" title="Remove column from the results" value="   &lt;   " onclick="move(this.form.displayedColumns,this.form.list1)" name="B2" class="inputTextField" />
            </td>
            <td width="40%">
              <label for="displayedColumns">Columns to be displayed in results page:</label>
              <br />
              <select class="inputTextField" style="width : 300px" id="displayedColumns" size="10" name="displayedColumns"></select>
            </td>
          </tr>
        </table>
        <br />
        <input type="submit" title="Proceed to results page" name="Search" value="Proceed to results" class="inputTextField" />
      </form>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="select-columns.jsp" />
      </jsp:include>
    </div>
  </body>
</html>