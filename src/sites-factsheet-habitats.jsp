<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Relation with habitats for a site' - part of site's factsheet
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.List,
                 java.util.ArrayList,
                 ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 ro.finsiel.eunis.jrfTables.Chm62edtReportAttributesPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SiteHabitatsPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement cm = SessionManager.getWebContent();
  int type = factsheet.getType();

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

    List habit1Eunis = new ArrayList();
    List habit1NotEunis = new ArrayList();
    List habits2Eunis = new ArrayList();
    List habits2NotEunis = new ArrayList();

    List habitats = new ArrayList();
    List sitesSpecificHabitats = new ArrayList();

    if( type == SiteFactsheet.TYPE_NATURA2000 || type == SiteFactsheet.TYPE_EMERALD )
    {
      habit1Eunis = factsheet.findHabit1Eunis();
      habit1NotEunis = factsheet.findHabit1NotEunis();
      habits2Eunis = factsheet.findHabit2Eunis();
      habits2NotEunis = factsheet.findHabit2NotEunis();
    }
    else
    {
      habitats = factsheet.findSitesHabitatsByIDNatureObject();
      sitesSpecificHabitats = factsheet.findSitesSpecificHabitats();
    }

    if( ( SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD && ( !habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty() || !habits2Eunis.isEmpty() || !habits2NotEunis.isEmpty() ) )
          || ( !habitats.isEmpty() || !sitesSpecificHabitats.isEmpty() ) )
    {
      // List of habitats related to site
    if( SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD &&
            ( !habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty() || !habits2Eunis.isEmpty() || !habits2NotEunis.isEmpty() ) )
    {
      Chm62edtReportAttributesPersist attribute;
%>
<%

        if (!habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty())
        {
%>
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("sites_factsheet_habitats_habwithinsite")%></div>
        <strong><%=cm.cmsText("sites_factsheet_114")%></strong>
        <table summary="<%=cm.cms("sites_factsheet_114")%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats1" class="sortable">
          <tr>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_habwithinsite_code")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_115")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_116")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_117")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_118")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_119")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_120")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
          </tr>
          <%
          if (!habit1Eunis.isEmpty())
          {
            //System.out.println("habit1Eunis = " + habit1Eunis.size());
            for (int i = 0; i < habit1Eunis.size(); i++)
            {
              SiteHabitatsPersist habitat = (SiteHabitatsPersist)habit1Eunis.get(i);%>
              <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
                <td>
                  <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getIdHabitat()%></a>
                  <%=cm.cmsTitle("open_habitat_factsheet")%>
                </td>
                <td>
                  <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getHabitatDescription()%></a>
                  <%=cm.cmsTitle("open_habitat_factsheet")%>
                </td>
              <td style="text-align:right">
                <%attribute = factsheet.findSiteAttributes("COVER", habitat.getIdReportAttributes());%>
                <%=(null != attribute) ? Utilities.formatDecimal( attribute.getValue(), 2 ) : "&nbsp;"%>
              </td>
              <td>
              <%
                attribute = factsheet.findSiteAttributes("REPRESENTATIVITY", habitat.getIdReportAttributes());
                String attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_REPRESENTATIVITY WHERE ID_REPRESENTATIVITY ='"+attribute.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Representativity')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%></a>
               </span>
              </td>
              <td  style="text-align:right">
                <%
                attribute = factsheet.findSiteAttributes("RELATIVE_SURFACE", habitat.getIdReportAttributes());
                attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_RELATIVE_SURFACE WHERE ID_RELATIVE_SURFACE ='"+attribute.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Relative surface')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%></a>
               </span>
              </td>
              <td>
               <%
                attribute = factsheet.findSiteAttributes("CONSERVATION", habitat.getIdReportAttributes());
                attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_NATURA2000_CONSERVATION_CODE WHERE ID_CONSERVATION_CODE ='"+attribute.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Conservation')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%></a>
               </span>
              </td>
              <td>
              <%
                attribute = factsheet.findSiteAttributes("GLOBAL", habitat.getIdReportAttributes());
                attVal = "";
                if(!"".equals((null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_GLOBAL WHERE ID_GLOBAL ='"+attribute.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Global')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute) ? ((null !=attribute.getValue()) ? attribute.getValue() : "") : ""%></a>
               </span>
              </td>
            </tr>
          <%
            }
          }
          if (!habit1NotEunis.isEmpty())
          {
            Chm62edtSitesAttributesPersist attribute2;
            for (int i = 0; i < habit1NotEunis.size(); i++)
            {
              Chm62edtSitesAttributesPersist habitat = (Chm62edtSitesAttributesPersist)habit1NotEunis.get(i);
              String habCode = habitat.getName();
              habCode = (habCode == null ? "" : habCode.substring(habCode.lastIndexOf("_")+1));
          %>
              <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
                <td>
                  <%=habCode%>
                </td>
                <td>
                  <%attribute2 = factsheet.findHabit1NotEunisAttributes("NAME_EN_"+habCode);%>
                  <%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%>&nbsp;
                </td>
              <td  style="text-align:right">
                <%attribute2 = factsheet.findHabit1NotEunisAttributes("COVER_"+habCode);%>
                <%=(null != attribute2) ? Utilities.formatDecimal(attribute2.getValue(), 2) : "&nbsp;"%>
              </td>
              <td>
              <%
                attribute2 = factsheet.findHabit1NotEunisAttributes("REPRESENTATIVITY_"+habCode);
                String attVal = "";
                if(!"".equals((null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_REPRESENTATIVITY WHERE ID_REPRESENTATIVITY ='"+attribute2.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Representativity')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%></a>
               </span>
              </td>
              <td style="text-align:right">
                <%
                attribute2 = factsheet.findHabit1NotEunisAttributes("RELATIVE_SURFACE_"+habCode);
                attVal = "";
                if(!"".equals((null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_RELATIVE_SURFACE WHERE ID_RELATIVE_SURFACE ='"+attribute2.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Relative surface')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%></a>
               </span>
              </td>
              <td>
              <%
                attribute2 = factsheet.findHabit1NotEunisAttributes("CONSERVATION_"+habCode);
                attVal = "";
                if(!"".equals((null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_NATURA2000_CONSERVATION_CODE WHERE ID_CONSERVATION_CODE ='"+attribute2.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Conservation')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%></a>
               </span>
              </td>
              <td>
              <%
                attribute2 = factsheet.findHabit1NotEunisAttributes("GLOBAL_"+habCode);
                attVal = "";
                if(!"".equals((null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""))
                  attVal = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_GLOBAL WHERE ID_GLOBAL ='"+attribute2.getValue()+"'");
               %>
               <span onmouseover="showtooltipWithMsgAndTitle('<%=attVal%>','Global')" onmouseout="hidetooltip()">
                 <a href="#" onclick="return false;"><%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%></a>
               </span>
              </td>
            </tr>
          <%
            }
             }
          %>
        </table>
        <br />
<%
        }
        if (!habits2Eunis.isEmpty() || !habits2NotEunis.isEmpty())
        {
%>
        <br />
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("sites_factsheet_166")%></div>
        <table summary="<%=cm.cms("sites_factsheet_166")%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats2" class="sortable">
          <tr>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_122")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_167")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right;" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_169")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
          </tr>
<%
          if (!habits2Eunis.isEmpty())
          {
            for (int i = 0; i < habits2Eunis.size(); i++)
            {
              SiteHabitatsPersist habitat = (SiteHabitatsPersist)habits2Eunis.get(i);
%>
                <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
                    <td>
                     <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getIdHabitat()%></a>
                     <%=cm.cmsTitle("open_habitat_factsheet")%>
                   </td>
                    <td>
                      <%String val = habitat.getHabitatDescription();%>
                      <%=(null != val) ? Utilities.formatString(val) : ""%>&nbsp;
                    </td>
                    <td align="right">
                      <%attribute = factsheet.findSiteAttributes("COVER", habitat.getIdReportAttributes());%>
                      <%=(null != attribute) ? Utilities.formatDecimal(attribute.getValue(), 2) : "&nbsp;"%>
                    </td>
                  </tr>
<%
            }
          }
          if (!habits2NotEunis.isEmpty())
          {
            Chm62edtSitesAttributesPersist attribute2;
            for (int i = 0; i < habits2NotEunis.size(); i++)
            {
              Chm62edtSitesAttributesPersist habitat = (Chm62edtSitesAttributesPersist)habits2NotEunis.get(i);
              String habCode = habitat.getName();
              habCode = (habCode == null ? "" : habCode.substring(habCode.lastIndexOf("_")+1));
%>
                <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
                    <td><%=habCode%></td>
                    <td>
                      <%attribute2 = factsheet.findHabit2NotEunisAttributes("NAME_EN_"+habCode);%>
                      <%=(null != attribute2) ? Utilities.formatString(attribute2.getValue()) : ""%>&nbsp;
                    </td>
                    <td align="right">
                      <%attribute2 = factsheet.findHabit2NotEunisAttributes("COVER_"+habCode);%>
                      <%=(null != attribute2) ? Utilities.formatDecimal(attribute2.getValue(), 2) : ""%>&nbsp;
                    </td>
                  </tr>
<%
            }
          }
%>
        </table>
        <br />
<%
      }
    }
    else
    {
      // List of habitats related to site not Natura2000
      if (!habitats.isEmpty() || !sitesSpecificHabitats.isEmpty())
      {
%>
        <br />
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;">
          <%=cm.cmsText("sites_factsheet_habitats_habitatswithinsite")%>
        </div>
        <table summary="<%=cm.cms("sites_factsheet_habitats_habitatswithinsite")%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats" class="sortable">
          <tr>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_name")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right;" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_cover")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_representativity")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th style="text-align : right;" title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_surface")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_conservation")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
            <th title="<%=cm.cms("sort_results_on_this_column")%>">
              <%=cm.cmsText("sites_factsheet_habitats_global")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </th>
          </tr>
<%
        Chm62edtReportAttributesPersist attribute;
        for (int i = 0; i < habitats.size(); i++)
        {
          SiteHabitatsPersist habitat = (SiteHabitatsPersist)habitats.get(i);%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td>
              <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getHabitatDescription()%></a>&nbsp;
              <%=cm.cmsTitle("open_habitat_factsheet")%>
            </td>
            <td  style="text-align:right">
              <%attribute = factsheet.findSiteAttributes("COVER", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatDecimal( attribute.getValue(), 2) : "&nbsp;"%>
            </td>
            <td>
              <%attribute = factsheet.findSiteAttributes("REPRESENTATIVITY", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatString(attribute.getValue()) : "&nbsp;"%>
            </td>
            <td  style="text-align:right">
              <%attribute = factsheet.findSiteAttributes("SURFACE", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatString(attribute.getValue()) : "&nbsp;"%>
            </td>
            <td>
              <%attribute = factsheet.findSiteAttributes("CONSERVATION", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatString(attribute.getValue()) : "&nbsp;"%>
            </td>
            <td>
              <%attribute = factsheet.findSiteAttributes("GLOBAL", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatString(attribute.getValue()) : "&nbsp;"%>
            </td>
          </tr>
<%
        }
%>
        </table>
<%
        if (sitesSpecificHabitats.size() > 0)
        {
%>
        <br />
        <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("sites_factsheet_habitats_habitatsnoteunis")%></div>
        <table summary="<%=cm.cms("sites_factsheet_habitats_habitatsnoteunis")%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitatsNonEUNIS" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              <%=cm.cms("sites_factsheet_habitats_habitatscode")%>
            </th>
          </tr>
<%
          for (int i = 0; i < sitesSpecificHabitats.size(); i++)
          {
              Chm62edtSitesAttributesPersist habitat = (Chm62edtSitesAttributesPersist)sitesSpecificHabitats.get(i);
%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td><%=habitat.getValue()%></td>
          </tr>
<%
          }
%>
        </table>
<%
        }
      }
    }
  }
%>
<%=cm.cmsMsg("sites_factsheet_114")%>
<%=cm.br()%>
<%=cm.cmsMsg("sites_factsheet_166")%>