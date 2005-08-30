<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Relation with habitats for a site' - part of site's factsheet
--%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
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
      Chm62edtReportAttributesPersist attribute = null;
%>
<%

        if (!habit1Eunis.isEmpty() || !habit1NotEunis.isEmpty())
        {
%>
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Ecological information: Habitats within site</div>
        <strong><%=contentManagement.getContent("sites_factsheet_114")%></strong>
        <table summary="<%=contentManagement.getContent("sites_factsheet_114", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats1" style="border-collapse:collapse">
          <tr bgcolor="#DDDDDD">
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 0, 'habitats1', false);">Code</a>
            </th>
            <th class="resultHeader" align="right">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 1, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_115")%></a>
            </th>
            <th class="resultHeader" style="text-align : right">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 2, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_116")%></a>
            </th>
            <th class="resultHeader" align="right">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 3, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_117")%></a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 4, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_118")%></a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 5, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_119")%></a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 7, 6, 'habitats1', false);"><%=contentManagement.getContent("sites_factsheet_120")%></a>
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
                  <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getIdHabitat()%></a>
                </td>
                <td>
                  <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getHabitatDescription()%></a>
                </td>
              <td align="right">
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
              <td align="right">
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
            Chm62edtSitesAttributesPersist attribute2 = null;
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
              <td align="right">
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
              <td>
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
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_166")%></div>
        <table summary="<%=contentManagement.getContent("sites_factsheet_166", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats2" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 3, 0, 'habitats2', false);"><%=contentManagement.getContent("sites_factsheet_122")%></a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 3, 1, 'habitats2', false);"><%=contentManagement.getContent("sites_factsheet_167")%></a>
            </th>
            <th class="resultHeader" style="text-align : right;">
              <a title="Sort results by this column" href="javascript:sortTable( 3, 2, 'habitats2', false);"><%=contentManagement.getContent("sites_factsheet_169")%></a>
            </th>
          </tr>
<%
          attribute = null;
          if (!habits2Eunis.isEmpty())
          {
            for (int i = 0; i < habits2Eunis.size(); i++)
            {
              SiteHabitatsPersist habitat = (SiteHabitatsPersist)habits2Eunis.get(i);
%>
                <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
                    <td>
                     <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getIdHabitat()%></a>
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
            Chm62edtSitesAttributesPersist  attribute2 = null;
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
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Ecological information: Habitats within site</div>
        <table summary="Ecological information: Habitats within site" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitats" style="border-collapse:collapse">
          <tr bgcolor="#DDDDDD">
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 0, 'habitats', false);">Habitat type english name</a>
            </th>
            <th class="resultHeader" align="right">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 1, 'habitats', false);">Cover (%)</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 2, 'habitats', false);">Representativity</a>
            </th>
            <th class="resultHeader" align="right">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 3, 'habitats', false);">Surface (ha)</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 4, 'habitats', false);">Conservation</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 5, 'habitats', false);">Global</a>
            </th>
          </tr>
<%
        Chm62edtReportAttributesPersist attribute = null;
        for (int i = 0; i < habitats.size(); i++)
        {
          SiteHabitatsPersist habitat = (SiteHabitatsPersist)habitats.get(i);%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td>
              <a title="Habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getHabitatDescription()%></a>&nbsp;
            </td>
            <td align="right">
              <%attribute = factsheet.findSiteAttributes("COVER", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatDecimal( attribute.getValue(), 2) : "&nbsp;"%>
            </td>
            <td>
              <%attribute = factsheet.findSiteAttributes("REPRESENTATIVITY", habitat.getIdReportAttributes());%>
              <%=(null != attribute) ? Utilities.formatString(attribute.getValue()) : "&nbsp;"%>
            </td>
            <td align="right">
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
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Habitat types not in EUNIS</div>
        <table summary="Habitat types not in EUNIS" border="1" cellpadding="1" cellspacing="1" width="100%" id="habitatsNonEUNIS" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              Habitat type code
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
