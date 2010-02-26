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
    <%=cm.cmsPhrase("Human Activities")%>
  </h2>
  <table summary="<%=cm.cms("human_activities")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Activity")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Inside/Outside")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Intensity")%>
        </th>
        <th style="text-align : right;">
          <%=cm.cmsPhrase("Cover(%)")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Influence")%>
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
    <%=cm.cmsPhrase("Human Activities")%>
  </h2>
  <table summary="<%=cm.cms("human_activities")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Activity code")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Description")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Location")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Intensity")%>
        </th>
        <th style="text-align: right;">
          <%=cm.cms("cover_percent")%>
        </th>
        <th style="text-align: left;">
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
    <%=cm.cmsPhrase("References to Maps")%>
  </h2>
  <table summary="<%=cm.cms("reference_to_maps")%>" class="datatable fullwidth">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Number")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Scale")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Projection")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Details")%>
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
    <%=cm.cmsPhrase("References to photos")%>
  </h2>
  <table summary="<%=cm.cms("reference_to_photos")%>" class="datatable fullwidth">
    <thead>
      <tr>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Type")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Number")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Location")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Description")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Date")%>
        </th>
        <th style="text-align: left;">
          <%=cm.cmsPhrase("Author")%>
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
    <%=cm.cmsPhrase("Other project specific fields")%>
  </h2>
  <table class="datatable fullwidth">
    <tbody>
<%
  if (SiteFactsheet.TYPE_CDDA_NATIONAL == type)
  {
%>
      <tr class="zebraeven">
        <td>
          <%=cm.cmsPhrase("IUCN management category")%>
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
          <%=cm.cmsPhrase("Site typology")%>
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
          <%=cm.cmsPhrase("Reference document number")%>
        </td>
        <td>
          <%=referenceDocNumber%>&nbsp;
        </td>
      </tr>
      <tr>
        <td>
          <%=cm.cmsPhrase("Reference document source")%>
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
