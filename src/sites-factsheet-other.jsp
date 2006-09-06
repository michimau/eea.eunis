<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Other information about a site' - part of site's factsheet
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
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
  WebContentManagement cm = SessionManager.getWebContent();
  try
  {
  String siteid = request.getParameter("idsite");
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  int type = factsheet.getType();

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  // Human activity.
  if (SiteFactsheet.TYPE_CORINE == type ||
      SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type)
  {
    //not a NATURA2000 factsheet
    List activities = factsheet.findHumanActivity();
    //System.out.println( "activities.size() = " + activities.size() );
    if (activities.size() > 0)
    {
%>
  <br />
  <h2>
    <%=cm.cmsText("human_activities")%>
  </h2>
  <table summary="<%=cm.cms("human_activities")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("activity")%>
        </th>
        <th>
          <%=cm.cmsText("inside_outside")%>
        </th>
        <th>
          <%=cm.cmsText("intensity")%>
        </th>
        <th style="text-align : right;">
          <%=cm.cmsText("cover_percent")%>
        </th>
        <th>
          <%=cm.cmsText("influence")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < activities.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        HumanActivityPersist activity = (HumanActivityPersist)activities.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.formatString(activity.getActivityName())%>&nbsp;
        </td>
        <td>
<%
        HumanActivityAttributesPersist humanActivityAttribute;
        String ActivityLocation = "&nbsp;";
        humanActivityAttribute = factsheet.findHumanActivityAttribute("IN_OUT", i);
        if( humanActivityAttribute != null )
        {
          ActivityLocation = humanActivityAttribute.getAttributeValue();
        }
        if(ActivityLocation.equalsIgnoreCase("I")) ActivityLocation = "Inside";
        if(ActivityLocation.equalsIgnoreCase("O")) ActivityLocation = "Outside";
%>
              <%=SiteFactsheet.TYPE_CORINE != type ? ActivityLocation : "&nbsp;"%>
        </td>
        <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INTENSITY", i );
        String ActivityIntensity = null;
        if(null != humanActivityAttribute)
        {
          ActivityIntensity = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityIntensity = " + ActivityIntensity);
          ActivityIntensity = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INTENSITY WHERE ID_ACTIVITY_INTENSITY = '" + ActivityIntensity+"'");
          if( ActivityIntensity.length() == 0 ) ActivityIntensity = Utilities.formatString( humanActivityAttribute.getAttributeValue(), "&nbsp;" );
        }
%>
          <%=(null != ActivityIntensity && SiteFactsheet.TYPE_CORINE != type) ? ActivityIntensity : "&nbsp;"%>&nbsp;
        </td>
        <td style="text-align: right;">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("COVER");
%>
          <%=(null != humanActivityAttribute) ? humanActivityAttribute.getAttributeValue() : "&nbsp;"%>&nbsp;
        </td>
        <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INFLUENCE", i);
        String ActivityInfluence = null;
        if(null != humanActivityAttribute) {
          ActivityInfluence = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityInfluence = " + ActivityInfluence);
          ActivityInfluence = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INFLUENCE WHERE ID_ACTIVITY_INFLUENCE = '" + ActivityInfluence+"'");
          if( ActivityInfluence.length() == 0 ) ActivityInfluence = Utilities.formatString( humanActivityAttribute.getAttributeValue(), "&nbsp;" );
        }
%>
          <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityInfluence : "&nbsp;"%>&nbsp;
        </td>
      </tr>
<%
      }
%>
    <tbody>
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
  <h2>
    <%=cm.cmsText("human_activities")%>
  </h2>
  <table summary="<%=cm.cms("human_activities")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("sites_factsheet_other_activitycode")%>
        </th>
        <th>
          <%=cm.cmsText("description")%>
        </th>
        <th>
          <%=cm.cmsText("location")%>
        </th>
        <th>
          <%=cm.cmsText("intensity")%>
        </th>
        <th style="text-align : right;">
          <%=cm.cms("cover_percent")%>
        </th>
        <th>
          <%=cm.cms("influence")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      for (int i = 0; i < activities.size(); i++)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
        HumanActivityPersist activity = (HumanActivityPersist)activities.get(i);
%>
      <tr<%=cssClass%>>
        <td>
          <%=Utilities.formatString(activity.getActivityCode())%>&nbsp;
        </td>
        <td>
          <%=Utilities.formatString(activity.getActivityName())%>&nbsp;
        </td>
        <td>
<%
        HumanActivityAttributesPersist humanActivityAttribute;
        humanActivityAttribute = factsheet.findHumanActivityAttribute("IN_OUT", i );
        String ActivityLocation = humanActivityAttribute.getAttributeValue();
        if(ActivityLocation.equalsIgnoreCase("I")) ActivityLocation = "Inside";
        if(ActivityLocation.equalsIgnoreCase("O")) ActivityLocation = "Outside";
%>
          <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityLocation : "&nbsp;"%>&nbsp;
        </td>
        <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INTENSITY", i );
        String ActivityIntensity = null;
        if(null != humanActivityAttribute)
        {
          ActivityIntensity = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityIntensity = " + ActivityIntensity);
          ActivityIntensity = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INTENSITY WHERE ID_ACTIVITY_INTENSITY = '" + ActivityIntensity+"'");
          if( ActivityIntensity.length() == 0 ) ActivityIntensity = Utilities.formatString( humanActivityAttribute.getAttributeValue(), "&nbsp;" );
        }
%>

          <%=null != humanActivityAttribute ? ActivityIntensity : "&nbsp;"%>&nbsp;
        </td>
        <td style="text-align: right;">
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("COVER", i );
        String ActivityCover = null;
        if(null != humanActivityAttribute) {
          ActivityCover = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityCover = " + ActivityCover);
        }
%>
          <%=(null != humanActivityAttribute) ? Utilities.formatDecimal( ActivityCover, 5 )  : "&nbsp;"%>
        </td>
        <td>
<%
        humanActivityAttribute = factsheet.findHumanActivityAttribute("INFLUENCE", i);
        String ActivityInfluence = null;
        if(null != humanActivityAttribute) {
          ActivityInfluence = humanActivityAttribute.getAttributeValue();
          //System.out.println("ActivityInfluence = " + ActivityInfluence);
          ActivityInfluence = sqlc.ExecuteSQL("SELECT NAME FROM CHM62EDT_ACTIVITY_INFLUENCE WHERE ID_ACTIVITY_INFLUENCE = '" + ActivityInfluence+"'");
          if( ActivityInfluence.length() == 0 ) ActivityInfluence = Utilities.formatString( humanActivityAttribute.getAttributeValue(), "&nbsp;" );
        }
%>
          <%=(null != humanActivityAttribute && SiteFactsheet.TYPE_CORINE != type) ? ActivityInfluence : "&nbsp;"%>&nbsp;
        </td>
      </tr>
<%
      }
%>
    </tbody>
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
  <h2>
    <%=cm.cmsText("reference_to_maps")%>
  </h2>
  <table summary="<%=cm.cms("reference_to_maps")%>" class="datatable" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("number")%>
        </th>
        <th>
          <%=cm.cmsText("scale")%>
        </th>
        <th>
          <%=cm.cmsText("projection")%>
        </th>
        <th>
          <%=cm.cmsText("details")%>
        </th>
      </tr>
    </thead>
    <tbody>
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
    </tbody>
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
  <h2>
    <%=cm.cmsText("reference_to_photos")%>
  </h2>
  <table summary="<%=cm.cms("reference_to_photos")%>" class="datatable" width="90%">
    <thead>
      <tr>
        <th>
            <%=cm.cmsText("type")%>
        </th>
        <th>
          <%=cm.cmsText("number")%>
        </th>
        <th>
          <%=cm.cmsText("location")%>
        </th>
        <th>
          <%=cm.cmsText("description")%>
        </th>
        <th>
          <%=cm.cmsText("date")%>
        </th>
        <th>
          <%=cm.cmsText("author")%>
        </th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>
          <%=photoType%>
        </td>
        <td>
          <%=photoNumber%>
        </td>
        <td>
          <%=Utilities.formatString(photoLocation, "&nbsp;")%>
        </td>
        <td>
          <%=Utilities.formatString(photoDescription, "&nbsp;")%></td>
        <td>
          <%=Utilities.formatString(photoDate, "&nbsp;")%>
        </td>
        <td>
          <%=Utilities.formatString(photoAuthor, "&nbsp;")%>
        </td>
      </tr>
    <tbody>
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
  <h2>
    <%=cm.cmsText("sites_factsheet_144")%>
  </h2>
  <table class="datatable" width="90%">
    <tbody>
<%
  if (SiteFactsheet.TYPE_CDDA_NATIONAL == type)
  {
%>
      <tr class="zebraeven">
        <td>
          <%=cm.cmsText("iucn_management")%>
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
      <tr>
        <td>
          <%=cm.cmsText("site_typology")%>
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
      <tr class="zebraeven">
        <td>
          <%=cm.cmsText("reference_document_number")%>
        </td>
        <td>
          <%=referenceDocNumber%>&nbsp;
        </td>
      </tr>
      <tr>
        <td>
          <%=cm.cmsText("reference_document_source")%>
        </td>
        <td>
          <%=referenceDocSource%>&nbsp;
        </td>
      </tr>
<%
  }
%>
    </tbody>
  </table>
<%
      }

  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
%>
<%=cm.cmsMsg("human_activities")%>
<%=cm.br()%>
<%=cm.cmsMsg("reference_to_maps")%>
<%=cm.br()%>
<%=cm.cmsMsg("reference_to_photos")%>
