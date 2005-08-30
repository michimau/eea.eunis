<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Other information about a site' - part of site's factsheet
--%>
<%@ page import="ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityPersist,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.HumanActivityAttributesPersist,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities"%>
<%-- Human activity --%>
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

  // Human activity.
  if (SiteFactsheet.TYPE_EMERALD == type || SiteFactsheet.TYPE_CORINE == type ||
      SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type)
  {
    //not a NATURA2000 factsheet
    List activities = factsheet.findHumanActivity();
    //System.out.println( "activities.size() = " + activities.size() );
    if (activities.size() > 0)
    {
%>
        <br />
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_129")%></div>
        <table summary="<%=contentManagement.getContent("sites_factsheet_129", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="human" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_130")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_131")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_132")%>
            </th>
            <th class="resultHeader" align="right">
              <%=contentManagement.getContent("sites_factsheet_116")%>
            </th>
            <th class="resultHeader" align="left">
              <%=contentManagement.getContent("sites_factsheet_133")%>
            </th>
          </tr>
<%
      for (int i = 0; i < activities.size(); i++)
      {
        HumanActivityPersist activity = (HumanActivityPersist)activities.get(i);
%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td>
              <%=Utilities.formatString(activity.getActivityName())%>&nbsp;
            </td>
            <td>
<%
        HumanActivityAttributesPersist humanActivityAttribute;
        humanActivityAttribute = factsheet.findHumanActivityAttribute("IN_OUT");
%>
              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? humanActivityAttribute.getAttributeValue() : "&nbsp;"%>&nbsp;
            </td>
            <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INTENSITY");
%>
              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? humanActivityAttribute.getAttributeValue() : "&nbsp;"%>&nbsp;
            </td>
            <td align="right">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("COVER");
%>
              <%=(null != humanActivityAttribute) ? humanActivityAttribute.getAttributeValue() : "&nbsp;"%>&nbsp;
            </td>
            <td align="left">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INFLUENCE");
%>
              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? humanActivityAttribute.getAttributeValue() : "&nbsp;"%>&nbsp;
            </td>
          </tr>
<%
      }
%>
        </table>
<%
    }
  }
  // Human activity.
  if (SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD )
  {
    //a NATURA2000 factsheet
    List activities = factsheet.findHumanActivity();
    if (activities.size() > 0)
    {
%>
        <br />
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_129")%></div>
        <table summary="<%=contentManagement.getContent("sites_factsheet_129", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" id="human" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 0, 'human', false);">Activity code</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 1, 'human', false);">Description</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 2, 'human', false);">Location</a>
            </th>
            <th class="resultHeader">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 3, 'human', false);">Intensity</a>
            </th>
            <th class="resultHeader" align="right">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 4, 'human', false);">Cover(%)</a>
            </th>
            <th class="resultHeader" align="left">
              <a title="Sort results by this column" href="javascript:sortTable( 6, 5, 'human', false);">Influence</a>
            </th>
          </tr>
<%
      for (int i = 0; i < activities.size(); i++)
      {
        HumanActivityPersist activity = (HumanActivityPersist)activities.get(i);
%>
          <tr bgcolor="<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
            <td>
              <%=Utilities.formatString(activity.getActivityCode())%>&nbsp;
            </td>
            <td>
              <%=Utilities.formatString(activity.getActivityName())%>&nbsp;
            </td>
            <td>
<%
        HumanActivityAttributesPersist humanActivityAttribute;
        humanActivityAttribute = factsheet.findHumanActivityAttribute("IN_OUT");
        String ActivityLocation = humanActivityAttribute.getAttributeValue();
        if(ActivityLocation.equalsIgnoreCase("I")) ActivityLocation = "Inside";
        if(ActivityLocation.equalsIgnoreCase("O")) ActivityLocation = "Outside";
%>
              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityLocation : "&nbsp;"%>&nbsp;
            </td>
            <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INTENSITY");
        String ActivityIntensity = null;
        if(null != humanActivityAttribute)
        {
          ActivityIntensity = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityIntensity = " + ActivityIntensity);
          ActivityIntensity = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INTENSITY WHERE ID_ACTIVITY_INTENSITY = '" + ActivityIntensity+"'");
        }
%>

              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityIntensity : "&nbsp;"%>&nbsp;
            </td>
            <td align="right">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("COVER");
        String ActivityCover = null;
        if(null != humanActivityAttribute) {
          ActivityCover = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityCover = " + ActivityCover);
        }
%>
              <%=(null != humanActivityAttribute) ? Utilities.formatDecimal( ActivityCover, 5 )  : "&nbsp;"%>
            </td>
            <td align="left">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INFLUENCE");
        String ActivityInfluence = null;
        if(null != humanActivityAttribute) {
          ActivityInfluence = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityInfluence = " + ActivityInfluence);
          ActivityInfluence = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INFLUENCE WHERE ID_ACTIVITY_INFLUENCE = '" + ActivityInfluence+"'");
        }
%>
              <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityInfluence : "&nbsp;"%>&nbsp;
            </td>
          </tr>
<%
      }
%>
        </table>
<%
    }
  }
  // References to Maps
  if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type ||
      SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type)
  {
    String mapID = factsheet.getMapID();
    String mapScale = factsheet.getMapScale();
    String mapProjection = factsheet.getMapProjection();
    String mapDetails = factsheet.getMapDetails();
    // If none of the information is available for this site, we don't display the entire table at all.
    // Objects cannot be null because the persistent object returns "" in case of null.
    if (!mapID.equalsIgnoreCase("") &&
            !mapScale.equalsIgnoreCase("") &&
            !mapProjection.equalsIgnoreCase("") &&
            !mapDetails.equalsIgnoreCase(""))
    {
%>
        <br />
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_134")%></div>
        <table summary="<%=contentManagement.getContent("sites_factsheet_134", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_135")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_136")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_137")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_138")%>
            </th>
          </tr>
          <tr>
            <td>
              <%=mapID%>
            </td>
            <td>
              <%=mapScale%>
            </td>
            <td>
              <%=mapProjection%>
            </td>
            <td>
              <%=mapDetails%>
            </td>
          </tr>
        </table>
<%
    }
  }
  // References to Photos
  if (SiteFactsheet.TYPE_NATURA2000 == type ||
          SiteFactsheet.TYPE_EMERALD == type ||
          SiteFactsheet.TYPE_DIPLOMA == type ||
          SiteFactsheet.TYPE_BIOGENETIC == type)
  {
    String photoType = factsheet.getPhotoType().toString();
    String photoNumber = factsheet.getPhotoNumber();
    String photoLocation = factsheet.getPhotoLocation();
    String photoDescription = factsheet.getPhotoDescription();
    String photoDate = factsheet.getPhotoDate();
    String photoAuthor = factsheet.getPhotoAuthor();
    // If none of the information is available for this site, we don't display the entire table at all.
    // Objects cannot be null because the persistent object returns "" in case of null.
    if (!photoType.equalsIgnoreCase("") &&
            !photoNumber.equalsIgnoreCase("") &&
            !photoLocation.equalsIgnoreCase("") &&
            !photoDescription.equalsIgnoreCase("") &&
            !photoDescription.equalsIgnoreCase("") &&
            !photoDate.equalsIgnoreCase("") &&
            !photoAuthor.equalsIgnoreCase(""))
    {
%>
        <br />
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_139")%></div>
        <table summary="<%=contentManagement.getContent("sites_factsheet_139", false )%>" border="1" cellpadding="1" cellspacing="1" width="100%" style="border-collapse:collapse">
          <tr>
            <th class="resultHeader">
                <%=contentManagement.getContent("sites_factsheet_127")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_135")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_140")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_141")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_142")%>
            </th>
            <th class="resultHeader">
              <%=contentManagement.getContent("sites_factsheet_143")%>
            </th>
          </tr>
          <tr bgcolor="#EEEEEE">
            <td>
              <%=photoType%>
            </td>
            <td>
              <%=photoNumber%>
            </td>
            <td>
              <%=photoLocation%>&nbsp;</td>
            <td>
              <%=photoDescription%>&nbsp;</td>
            <td><%=photoDate%>&nbsp;</td>
            <td><%=photoAuthor%>&nbsp;</td>
          </tr>
        </table>
        <br />
<%
        }
      }
      // Other project specific fields
      String category = factsheet.getSiteObject().getIucnat();
      String typology = factsheet.getTypology();
      String referenceDocNumber = factsheet.getReferenceDocumentNumber();
      String referenceDocSource = factsheet.getReferenceDocumentSource();
      // If one of the attributes above are valid, we show the entire table
      // Objects cannot be null because the persistent object returns "" in case of null.
      if ( !category.equalsIgnoreCase("") ||
              !typology.equalsIgnoreCase("") ||
              !referenceDocNumber.equalsIgnoreCase("") ||
              !referenceDocSource.equalsIgnoreCase(""))
      {
%>
        <br />
        <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("sites_factsheet_144")%></div>
        <table border="1" cellpadding="1" cellspacing="1" width="100%" style="border-collapse:collapse" summary="layout">
<%
        if (SiteFactsheet.TYPE_CDDA_NATIONAL == type)
        {
%>
          <tr bgcolor="#EEEEEE">
            <td>
              <%=contentManagement.getContent("sites_factsheet_145")%>
            </td>
            <td>
              <%=Utilities.formatString(category)%>&nbsp;
            </td>
          </tr>
<%
        }
        if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type)
        {
%>
          <tr bgcolor="#FFFFFF">
            <td>
              <%=contentManagement.getContent("sites_factsheet_146")%>
            </td>
            <td>
              <%=Utilities.formatString(typology)%>&nbsp;
            </td>
          </tr>
<%
        }
        if (SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type)
        {
%>
          <tr bgcolor="#EEEEEE">
            <td>
              <%=contentManagement.getContent("sites_factsheet_147")%>
            </td>
            <td>
              <%=referenceDocNumber%>&nbsp;
            </td>
          </tr>
          <tr bgcolor="#FFFFFF">
            <td>
              <%=contentManagement.getContent("sites_factsheet_148")%>
            </td>
            <td>
              <%=referenceDocSource%>&nbsp;
            </td>
          </tr>
<%
        }
%>
        </table>
<%
      }
%>