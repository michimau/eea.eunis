<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'General information about a site' - part of site's factsheet
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.sites.SitesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.factsheet.sites.SiteFactsheet,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.SitesDesignationsPersist,
                 ro.finsiel.eunis.jrfTables.sites.factsheet.RegionsCodesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesAttributesPersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPicturePersist,
                 ro.finsiel.eunis.jrfTables.Chm62edtNatureObjectPictureDomain,
                 ro.finsiel.eunis.jrfTables.Chm62edtSitesPersist,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsDomain"%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtDesignationsPersist"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String siteid = request.getParameter("idsite");
  int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
  SiteFactsheet factsheet = new SiteFactsheet(siteid);
  WebContentManagement cm = SessionManager.getWebContent();
  int type = factsheet.getType();
  String domainName = application.getInitParameter("DOMAIN_NAME");

  List<Chm62edtNatureObjectPicturePersist> pictureList = new Chm62edtNatureObjectPictureDomain()
          .findWhere("MAIN_PIC = 1 AND ID_OBJECT = '" + factsheet.getIDSite() + "'");
  String mainPictureId = null;
  String pictureDescription = null;
  Integer width = null;
  Integer height = null;
  String source = null;
  if (pictureList != null && !pictureList.isEmpty()) {
      mainPictureId = application.getInitParameter("UPLOAD_DIR_PICTURES_SITES")
        + "/" + pictureList.get(0).getFileName();
      pictureDescription = pictureList.get(0).getDescription();
      width = pictureList.get(0).getMaxWidth();
      height = pictureList.get(0).getMaxHeight();
      source = pictureList.get(0).getSource();
  }
  String picsURL = "idobject=" + factsheet.getIDSite() + "&amp;natureobjecttype=Sites";
  
%>

<% if (mainPictureId != null) { %>
  <div class="naturepic-plus-container naturepic-right">
      <div class="naturepic-plus">
        <div class="naturepic-image">
            <%
            String styleAttr = "max-width:300px; max-height:400px;";
            if(width != null && width.intValue() > 0 && height != null && height.intValue() > 0){
                styleAttr = "max-width: "+width.intValue()+"px; max-height: "+height.intValue()+"px";
            }
            %>
            <a href="javascript:openpictures('<%=domainName%>/pictures.jsp?<%=picsURL%>',600,600)">
            <img src="<%=mainPictureId %>" alt="<%=pictureDescription %>" class="scaled" style="<%=styleAttr%>"/>
            </a>
        </div>
        <div class="naturepic-note">
          <%=pictureDescription %>
        </div>
        <% if(source != null && source.length() > 0){%>
          <div class="naturepic-source-copyright">
        <%=cm.cmsPhrase("Source")%>: <%=source%>
          </div>
        <%}%>
      </div>
  </div>
<% } %>
  <div class="allow-naturepic">

  <h2>
    <%=cm.cmsPhrase("Site identification")%>
  </h2>
  <table summary="layout" class="datatable fullwidth">
    <col style="width:40%"/>
    <col style="width:60%"/>
    <tbody>
      <tr>
        <td>
          <%-- Code in database --%>
          <strong>
            <%=SitesSearchUtility.translateSourceDB(factsheet.getSiteObject().getSourceDB())%>
          </strong>
          <%=cm.cmsPhrase("code in database")%>
        </td>
        <td>
          <strong>
            <%=factsheet.getIDSite()%>
          </strong>
        </td>
      </tr>
      <tr class="zebraeven">
        <%-- Surface area --%>
        <td>
          <%=cm.cmsPhrase("Surface area (ha)")%>
        </td>
        <td>
          <%=Utilities.formatArea(factsheet.getSiteObject().getArea(), 0, 2, "&nbsp;", null)%>&nbsp;
        </td>
      </tr>
<%
      if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_EMERALD == type || SiteFactsheet.TYPE_BIOGENETIC == type)
      {
        if (factsheet.getSiteObject().getLength() != null)
        {
%>
      <tr>
        <%-- Length --%>
        <td>
          <%=cm.cmsPhrase("Length (m)")%>
        </td>
        <td>
          <%=factsheet.getSiteObject().getLength()%>&nbsp;
        </td>
      </tr>
<%
          }
        }
%>
      <tr class="zebraeven">
        <%-- Complex name --%>
        <td>
          <%=cm.cmsPhrase("Complex name")%>
        </td>
        <td>
          <%=factsheet.getSiteObject().getComplexName()%>
        </td>
      </tr>
      <tr>
        <%-- District name --%>
        <td>
          <%=cm.cmsPhrase("District name")%>
        </td>
        <td>
          <%=factsheet.getSiteObject().getDistrictName()%>
        </td>
      </tr>
<%
      if (SiteFactsheet.TYPE_CDDA_NATIONAL != type && SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type)
      {
        String dateformatCompilationDate="";
        String dateformatCompilationDate2="";
        if(SiteFactsheet.TYPE_NATURA2000 != type || type == SiteFactsheet.TYPE_EMERALD )
        {
          if(factsheet.getSiteObject().getCompilationDate().length()==4)
          {
            dateformatCompilationDate="(yyyy)";
          }
          if(factsheet.getSiteObject().getCompilationDate().length()==6)
          {
            dateformatCompilationDate="(yyyyMM)";
          }
          if(factsheet.getSiteObject().getCompilationDate().length()==8)
          {
            dateformatCompilationDate="(yyyyMMdd)";
          }
        }
        else
        {
          if(factsheet.getSiteObject().getCompilationDate().length()==4)
          {
            dateformatCompilationDate2="yyyy";
          }
          if(factsheet.getSiteObject().getCompilationDate().length()==6)
          {
            dateformatCompilationDate2="yyyyMM";
          }
          if(factsheet.getSiteObject().getCompilationDate().length()==8)
          {
            dateformatCompilationDate2="yyyyMMdd";
          }
        }

        String dateformatUpdateDate="";
        String dateformatUpdateDate2="";
         if(SiteFactsheet.TYPE_NATURA2000 != type || type == SiteFactsheet.TYPE_EMERALD )
        {
          if(factsheet.getSiteObject().getUpdateDate().length()==4)
          {
            dateformatUpdateDate="(yyyy)";
          }
          if(factsheet.getSiteObject().getUpdateDate().length()==6)
          {
            dateformatUpdateDate="(yyyyMM)";
          }
          if(factsheet.getSiteObject().getUpdateDate().length()==8)
          {
            dateformatUpdateDate="(yyyyMMdd)";
          }
         }
        else
        {
          if(factsheet.getSiteObject().getUpdateDate().length()==4)
          {
            dateformatUpdateDate2="yyyy";
          }
          if(factsheet.getSiteObject().getUpdateDate().length()==6)
          {
            dateformatUpdateDate2="yyyyMM";
          }
          if(factsheet.getSiteObject().getUpdateDate().length()==8)
          {
            dateformatUpdateDate2="yyyyMMdd";
          }
        }
%>
      <tr class="zebraeven">
        <%-- Date form compilation date --%>
        <td>
          <%=cm.cmsPhrase("Date form compilation date")%> <%=dateformatCompilationDate%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getCompilationDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getCompilationDate(),dateformatCompilationDate2),"MMM yyyy") + (factsheet.getSiteObject().getCompilationDate() == null || factsheet.getSiteObject().getCompilationDate().trim().length()<=0 ? "" :" (" + cm.cmsPhrase("entered in original database as") + " " + factsheet.getSiteObject().getCompilationDate() + ")")%>
        </td>
      </tr>
      <tr>
        <%-- Date form update--%>
        <td>
          <%=cm.cmsPhrase("Date form update")%> <%=dateformatUpdateDate%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getUpdateDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getUpdateDate(),dateformatUpdateDate2),"MMM yyyy") + (factsheet.getSiteObject().getUpdateDate() == null || factsheet.getSiteObject().getUpdateDate().trim().length()<=0 ? "" : " (" + cm.cmsPhrase("entered in original database as") + " " + factsheet.getSiteObject().getUpdateDate() + ")")%>
        </td>
      </tr>
<%
      }
      if ( SiteFactsheet.TYPE_CDDA_NATIONAL != type && SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type && SiteFactsheet.TYPE_CORINE != type )
      {
%>
      <tr class="zebraeven">
        <%-- Date proposed --%>
        <td>
          <%=cm.cmsPhrase("Date proposed")%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getProposedDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getProposedDate(),"yyyyMM"),"MMM yyyy") + (factsheet.getSiteObject().getProposedDate() == null || factsheet.getSiteObject().getProposedDate().trim().length()<=0 ? "" :" (" + cm.cmsPhrase("entered in original database as") + " " + factsheet.getSiteObject().getProposedDate() + ")")%>
        </td>
      </tr>
<%
      }
      if (SiteFactsheet.TYPE_NATURA2000 == type || SiteFactsheet.TYPE_DIPLOMA == type || type == SiteFactsheet.TYPE_EMERALD )
      {
%>
      <tr>
        <%-- Date confirmed --%>
        <td>
          <%=cm.cmsPhrase("Date confirmed")%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getConfirmedDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getConfirmedDate(),"yyyyMM"),"MMM yyyy") + (factsheet.getSiteObject().getConfirmedDate() == null || factsheet.getSiteObject().getConfirmedDate().trim().length()<=0 ? "" :" (" + cm.cmsPhrase("entered in original database as") + " " + factsheet.getSiteObject().getConfirmedDate() + ")")%>
        </td>
      </tr>
<%
      }
      if (SiteFactsheet.TYPE_DIPLOMA == type)
      {
%>
      <tr class="zebraeven">
        <%-- Date first designation --%>
        <td>
          <%=cm.cmsPhrase("Date first designation")%>
        </td>
        <td>
          <%=factsheet.getDateFirstDesignation()%>
        </td>
      </tr>
<%
      }
      if (SiteFactsheet.TYPE_CORINE != type)
      {
%>
      <tr>
        <%-- Site designation date --%>
        <td>
          <%=cm.cmsPhrase("Site designation date")%>
        </td>
        <td>
        <%
          String spaDate = factsheet.getSiteObject().getSpaDate();
          String sacDate = factsheet.getSiteObject().getSacDate();
          String designationDate = factsheet.getSiteObject().getDesignationDate();
          if (null != spaDate && spaDate.length() > 0) out.print(spaDate + ",");
          if (null != sacDate && sacDate.length() > 0) out.print(sacDate + "/");
          if (null != designationDate && designationDate.length() > 0) out.print(designationDate);
        %>
        </td>
      </tr>
<%
      }
%>
    </tbody>
  </table>
<%
      // Site designations
      List designations = SitesSearchUtility.findDesignationsForSitesFactsheet(factsheet.getSiteObject().getIdSite());
      if (designations != null && designations.size()>0)
      {
%>
  <%-- Designation information --%>
  <h2>
    <%=cm.cmsPhrase("Designation information")%>
  </h2>
  <table summary="<%=cm.cms("designation_information")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Source data set")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Designation code")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Designation name (Original)")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Designation name (English)")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
        String SiteType = factsheet.getSiteType();
        if (SiteFactsheet.TYPE_NATURA2000 != type || !SiteType.equalsIgnoreCase("C"))
        {
          SitesDesignationsPersist designation = (SitesDesignationsPersist) designations.get(0);
%>
      <tr class="zebraeven">
        <td>
          <%=designation.getDataSource()%>
        </td>
        <td>
          <%=Utilities.formatString(designation.getIdDesignation(),"&nbsp;")%>
        </td>
        <td>
<%
          if(designation.getDescription() != null && designation.getDescription().trim().length() > 0)
          {
%>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations/<%=designation.getIdGeoscope()%>:<%=designation.getIdDesignation()%>?fromWhere=original"><%=designation.getDescription()%></a>
          <%=cm.cmsTitle("open_designation_factsheet")%>
<%
          }
          else
          {
%>
               &nbsp;
<%
          }
%>
        </td>
        <td>
<%
          if(designation.getDescriptionEn() != null && designation.getDescriptionEn().trim().length() > 0)
          {
%>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations/<%=designation.getIdGeoscope()%>:<%=designation.getIdDesignation()%>?fromWhere=en"><%=designation.getDescriptionEn()%></a>
          <%=cm.cmsTitle("open_designation_factsheet")%>
<%
          }
          else
          {
%>
              &nbsp;
<%
          }
%>
        </td>
      </tr>
<%
        }
        else
        {
          //NATURA 2000 site and type C
          List desigs = new Chm62edtDesignationsDomain().findWhere("ID_DESIGNATION='INBD' OR ID_DESIGNATION='INHD'");
          for(int i=0;i<desigs.size();i++)
          {
            Chm62edtDesignationsPersist desig = (Chm62edtDesignationsPersist) desigs.get(i);
%>
      <tr>
        <td>
          <%=desig.getOriginalDataSource()%>
        </td>
        <td>
          <%=Utilities.formatString(desig.getIdDesignation(),"&nbsp;")%>
        </td>
        <td>
<%
          if(desig.getDescription() != null && desig.getDescription().trim().length() > 0)
          {
%>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations/<%=desig.getIdGeoscope()%>:<%=desig.getIdDesignation()%>?fromWhere=original"><%=desig.getDescription()%></a>
          <%=cm.cmsTitle("open_designation_factsheet")%>
<%
           }
           else
           {
%>
          &nbsp;
<%
           }
%>
        </td>
        <td>
<%
          if(desig.getDescriptionEn() != null && desig.getDescriptionEn().trim().length() > 0)
          {
%>
            <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations/<%=desig.getIdGeoscope()%>:<%=desig.getIdDesignation()%>?fromWhere=en"><%=desig.getDescriptionEn()%></a>
            <%=cm.cmsTitle("open_designation_factsheet")%>
<%
          }
          else
          {
%>
            &nbsp;
<%
          }
%>
        </td>
      </tr>
  <%
          }
        }
  %>
    </tbody>
  </table>
  <%
      }
  %>
  </div>
<!--
  <a name="monitoring"></a>
  <h2>
    <%=cm.cmsPhrase("sites_factsheet_24")%>
  </h2>
  <%-- Monitoring activities --%>
  <textarea rows="1" cols="80"></textarea>
-->
  <h2><%=cm.cmsPhrase("External links")%></h2>
  <div id="linkcollection">

      <div>
        <a title="<%=cm.cms("google_pictures")%>" href="http://images.google.com/images?q=<%=factsheet.getSiteObject().getName()%>"><%=cm.cmsPhrase("Pictures on Google")%></a>
      </div>
<%
      if ( SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type || SiteFactsheet.TYPE_CDDA_NATIONAL == type )
      {
        String level = "nat";
        if ( SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type )
        {
          level = "int";
        }
%>
    <div>
        <a href="http://sea.unep-wcmc.org/wdbpa/sitedetails.cfm?siteid=<%=factsheet.getSiteObject().getIdSite()%>&amp;level=<%=level%>"><%=cm.cmsPhrase("UNEP-WCMC link")%></a>
        </div>
    <div>
        <a href="http://www.wdpa.org/siteSheet.aspx?sitecode=<%=factsheet.getSiteObject().getIdSite()%>"><%=cm.cmsPhrase("WPDA info")%></a>
        </div>
<%
      }
      if (SiteFactsheet.TYPE_NATURA2000 == type)
      {
%>
    <div>
        <a rel="nofollow" href="http://natura2000.eea.europa.eu/Natura2000/SDFPublic.aspx?site=<%=factsheet.getSiteObject().getIdSite()%>"><%=cm.cmsPhrase("Natura 2000 factsheet")%></a>
        </div>
    <div>
        <a href="http://natura2000.eea.europa.eu/N2KGisViewer.html#siteCode=<%=factsheet.getSiteObject().getIdSite()%>"><%=cm.cmsPhrase("Natura 2000 mapviewer")%></a>
        </div>
<%
      }
%>
  </div> <!-- linkcollection -->
<%
      String country = Utilities.formatString(factsheet.getCountry()).trim();
      String parentCountry = Utilities.formatString(factsheet.getParentCountry()).trim();
%>
  <%-- Location information --%>
  <h2 style="clear:left">
    <%=cm.cmsPhrase("Location information")%>
  </h2>
  <table class="datatable fullwidth">
    <tr>
      <td>
        <%=cm.cmsPhrase("Country")%>
      </td>
      <td colspan="2">
<%
      if(Utilities.isCountry(country))
      {
%>
        <a href="sites-statistical-result.jsp?country=<%=country%>&amp;DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=true&amp;DB_CORINE=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_DIPLOMA=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="<%=cm.cms("open_the_statistical_data_for")%> <%=country%>"><%=Utilities.formatString(country,"")%></a>
<%
      }
      else
      {
%>
        <%=Utilities.formatString(country,"")%>
<%
      }
%>
      </td>
<%
      if (!country.equalsIgnoreCase(parentCountry))
      {
%>
      <td colspan="2">
        <%=cm.cmsPhrase("Parent country")%>
      </td>
      <td>
        <%=parentCountry%>
      </td>
<%
      }
      else
      {
%>
      <td colspan="2">
        &nbsp;
      </td>
      <td>
        &nbsp;
      </td>
<%
          }
%>
    </tr>
<%
          if (SiteFactsheet.TYPE_CDDA_INTERNATIONAL != type)
          {
            List regionCodes = factsheet.findAdministrativeRegionCodes();
%>
    <tr>
      <td>
        <%=cm.cmsPhrase("Regional administrative codes")%>
      </td>
      <td colspan="5">
<%
            if(regionCodes.size()>0)
            {
              for (int i = 0;  i < regionCodes.size(); i++)
              {
                RegionsCodesPersist region = (RegionsCodesPersist)regionCodes.get(i);
                String regionDesc = (String) region.getRegionDescription();
                if(regionDesc == null || regionDesc.equals("")){
                    regionDesc = "NUTS";
                }
%>
        <%=regionDesc %> code <%=Utilities.formatString(region.getRegionCode())%>, <%=Utilities.formatString(region.getRegionName())%>, cover:<%=Utilities.formatString(region.getRegionCover())%>%
<%
                  if (regionCodes.size() > 1 && i < regionCodes.size() - 1)
                  {
                    out.print("<br />");
                  }
              }
            } else if(factsheet.getSiteObject().getNuts() != null && !factsheet.getSiteObject().getNuts().equals("")) {
%>
                NUTS code <%=Utilities.formatString(factsheet.getSiteObject().getNuts())%>
<%
            }
%>
      </td>
    </tr>
<%
        }
        // Site biogeographical regions
        if (SiteFactsheet.TYPE_NATURA2000 == type || type == SiteFactsheet.TYPE_EMERALD )
        {
          boolean alpine = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ALPINE"), false);
          boolean anatol1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ANATOL"), false);
          boolean anatol2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ANATOLIAN"), false);
          boolean anatol = anatol1 || anatol2;
          boolean arctic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ARCTIC"), false);
          boolean atlantic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ATLANTIC"), false);
          boolean boreal = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("BOREAL"), false);
          boolean continent1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("CONTINENT"), false);
          boolean continent2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("CONTINENTAL"), false);
          boolean continent = continent1 || continent2; 
          boolean macarones1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MACARONES"), false);
          boolean macarones2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MACARONESIAN"), false);
          boolean macarones = macarones1 || macarones2; 
          boolean mediterranean1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MEDITERRANIAN"), false);
          boolean mediterranean2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MEDITERRANEAN"), false);
          boolean mediterranean = mediterranean1 || mediterranean2; 
          boolean pannonic1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PANNONIC"), false);
          boolean pannonic2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PANNONIAN"), false);
          boolean pannonic = pannonic1 || pannonic2; 
          boolean pontic1 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PONTIC"), false);
          boolean pontic2 = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("BLACK SEA"), false);
          boolean pontic = pontic1 || pontic2; 
          boolean steppic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("STEPPIC"), false);
          if (alpine ||
                  anatol ||
                  arctic ||
                  atlantic ||
                  boreal ||
                  continent ||
                  macarones ||
                  mediterranean ||
                  pannonic ||
                  pontic ||
                  steppic)
          {
%>
    <tr>
      <td colspan="6">
        <table border="1" cellpadding="1" cellspacing="1" width="90%" style="border-collapse:collapse">
          <tr bgcolor="#EEEEEE">
            <td colspan="12">
              <%=cm.cmsPhrase("Site biogeographic regions")%>
            </td>
          </tr>
          <tr>
            <td>
              <%=cm.cmsPhrase("Biogeographic region")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Alpine")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Anatolian")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Arctic")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Atlantic")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Boreal")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Continental")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Macaronesia")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Mediterranean")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Pannonian")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Black Sea")%>
            </td>
            <td>
              <%=cm.cmsPhrase("Steppic")%>
            </td>
          </tr>
          <tr bgcolor="#EEEEEE">
            <td>
              <%=cm.cmsPhrase("Presence")%>
            </td>
            <td>
<%
            if( alpine )
            {
%>
              <img alt="<%=cm.cms("present_alpine_regions")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_alpine_regions")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( anatol )
            {
%>
              <img alt="<%=cm.cms("present_anatolian_regions")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_anatolian_regions")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( arctic )
            {
%>
              <img alt="<%=cm.cms("present_arctic_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_arctic_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( atlantic )
            {
%>
              <img alt="<%=cm.cms("present_atlantic_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_atlantic_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( boreal )
            {
%>
              <img alt="<%=cm.cms("present_boreal_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_boreal_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( continent )
            {
%>
              <img alt="<%=cm.cms("present_continental_regions")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_continental_regions")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( macarones )
            {
%>
              <img alt="<%=cm.cms("present_macaronesian_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_macaronesian_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( mediterranean )
            {
%>
              <img alt="<%=cm.cms("present_mediterranean_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_mediterranean_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( pannonic )
            {
%>
              <img alt="<%=cm.cms("present_pannonian_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_pannonian_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( pontic )
            {
%>
              <img alt="<%=cm.cms("present_blacksea_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_blacksea_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
            <td>
<%
            if( steppic )
            {
%>
              <img alt="<%=cm.cms("present_steppic_region")%>" src="images/mini/check.gif" style="vertical-align:middle" />
              <%=cm.cmsAlt("present_steppic_region")%>
<%
            }
            else
            {
              out.print( "&nbsp;" );
            }
%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
<%
          }
        }
        String altMin = factsheet.getSiteObject().getAltMin();
        String altMax = factsheet.getSiteObject().getAltMax();
        String altMean = factsheet.getSiteObject().getAltMean();
        if (SiteFactsheet.TYPE_CORINE == type) // For CORINE BIOTOPES, -99 means invalide altitude value
        {
          if (altMin != null && altMin.equalsIgnoreCase("-99")) altMin = "";
          if (altMax != null && altMax.equalsIgnoreCase("-99")) altMax = "";
          if (altMean != null && altMean.equalsIgnoreCase("-99")) altMean = "";
        }
%>
    <tr>
      <td>
        <%=cm.cmsPhrase("Minimum Altitude(m)")%>
      </td>
      <td>
      <%=Utilities.formatString(altMin)%>
      </td>
      <td>
        <%=cm.cmsPhrase("Mean Altitude(m)")%>
      </td>
      <td>
        <%=Utilities.formatString(altMean)%>
      </td>
      <td>
        <%=cm.cmsPhrase("Maximum Altitude(m)")%>
      </td>
      <td>
        <%=Utilities.formatString(altMax)%>
      </td>
    </tr>
<%
        String longitude;
        String latitude;
        if ( SiteFactsheet.TYPE_CORINE != type )
        {
          latitude = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLatNS(),
                  factsheet.getSiteObject().getLatDeg(),
                  factsheet.getSiteObject().getLatMin(),
                  factsheet.getSiteObject().getLatSec());
          longitude = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLongEW(),
                  factsheet.getSiteObject().getLongDeg(),
                  factsheet.getSiteObject().getLongMin(),
                  factsheet.getSiteObject().getLongSec());
        }
        else
        {
          latitude = SitesSearchUtility.formatCoordinates("N", factsheet.getSiteObject().getLatDeg(),
                  factsheet.getSiteObject().getLatMin(),
                  factsheet.getSiteObject().getLatSec());
          longitude = SitesSearchUtility.formatCoordinates(factsheet.getSiteObject().getLongEW(),
                  factsheet.getSiteObject().getLongDeg(),
                  factsheet.getSiteObject().getLongMin(),
                  factsheet.getSiteObject().getLongSec());
        }
%>
    <tr>
      <td>
        <%=cm.cmsPhrase("Longitude")%>
      </td>
      <td>
        <%=longitude%>
      </td>
      <td>
        <%=cm.cmsPhrase("Latitude")%>
      </td>
      <td colspan="3">
        <%=latitude%>
      </td>
    </tr>
    <tr>
      <td>
        <%=cm.cmsPhrase("Longitude (decimal deg.)")%>
      </td>
      <td>
        <%=Utilities.formatArea(factsheet.getSiteObject().getLongitude(), 0, 6, null)%>
      </td>
      <td>
        <%=cm.cmsPhrase("Latitude (decimal deg.)")%>
      </td>
      <td>
        <%=Utilities.formatArea(factsheet.getSiteObject().getLatitude(), 0, 6, null)%>
      </td>
      <td colspan="2">
        <a href="http://maps.google.com/maps?ll=<%=factsheet.getSiteObject().getLatitude()%>,<%=factsheet.getSiteObject().getLongitude()%>&amp;z=13">View in Google Maps</a>
      </td>
    </tr>
<%
      if ( SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_CORINE == type )
      {
        List results = factsheet.getBiogeoregion();
%>
    <tr>
      <td><%=cm.cmsPhrase("Biogeographic regions")%></td>
      <td colspan="5">
<%
        for (int i = 0; i < results.size(); i++)
        {
          Chm62edtSitesAttributesPersist persist = (Chm62edtSitesAttributesPersist) results.get(i);
%>
        <%=persist.getValue()%>
        <br />
<%
        }
%>
      </td>
    </tr>
<%
      }
%>
  </table>

<%
    if (SiteFactsheet.TYPE_NATURA2000 == type) {
%>
    <script type="text/javascript">djConfig = { parseOnLoad:true };</script>
    <script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.2"></script>

    <script type="text/javascript">
      dojo.require("dijit.dijit"); // optimize: load dijit layer
      dojo.require("esri.map");
      dojo.require("esri.virtualearth.VETiledLayer");
      dojo.require("esri.tasks.query");
      dojo.require("esri.tasks.geometry");
      dojo.require("esri.layers.FeatureLayer");
      dojo.require("dijit.TooltipDialog");
    
      //Assig a value to the SITECODE    
      var sitecode = '<%=siteid%>'
      
      var map
      
      //URL for Natura 2000 REST service in use
      function getSitesMapService() { return 'http://discomap.eea.europa.eu/ArcGIS/rest/services/Bio/Natura2000Hatch_Cach_WM/MapServer'; }
            
      function init() {
        map = new esri.Map("map", {logo:false, slider: true, nav: true});
        
        //Creates a BING Maps object layer to add to the map
        veTileLayer = new esri.virtualearth.VETiledLayer({
          bingMapsKey: 'AgnYuBP56hftjLZf07GVhxQrm61_oH1Gkw2F1H5_NSWjyN5s1LKylQ1S3kMDTHb_',
          mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD
        });
                
        //Loads BING map
        map.addLayer(veTileLayer);
        
        //Creates a Natura 2000 layer object based on the site of interest
        var featureLayer = new esri.layers.FeatureLayer(getSitesMapService() + "/0",{
          mode: esri.layers.FeatureLayer.MODE_SNAPSHOT,
          outFields: ["*"],
          opacity:.35
        });
        dojo.connect(featureLayer,"onMouseOver",showTooltip);
        dojo.connect(featureLayer,"onMouseOut",closeDialog);
        featureLayer.setDefinitionExpression("SITECODE='" + sitecode + "'");
        
        //Loads Natura 2000 Site
        map.addLayer(featureLayer);
        loadGeometry(sitecode);
      }

      //Function for zooming into the site of interest
      function loadGeometry(sitecode) {
        var query = new esri.tasks.Query();

        query.where = "SITECODE='" + sitecode + "'"
        query.returnGeometry = true;
        var queryTask = new esri.tasks.QueryTask(getSitesMapService() + "/0");
        queryTask.execute(query);

        // +++++Listen for QueryTask onComplete event+++++
        dojo.connect(queryTask, "onComplete", function(featureSet) {
        polygon = featureSet.features[0].geometry;
        extent = polygon.getExtent();
        map.setExtent(extent.expand(2), true);
        });
      };

      
      //Tooltip functionality to sitename and show spatial area 
      function showTooltip(evt){
      closeDialog();
      var tipContent = "<b>Name of the site</b>: " + evt.graphic.attributes.SITENAME +
      "<br/><b>Area</b>: " + Math.round((evt.graphic.attributes.Shape_Area/1000000)*100/100) + " Square Kilometers";
      var dialog = new dijit.TooltipDialog({
        id: "tooltipDialog",
        content: tipContent,
        style: "position: absolute; padding:2px; background: white; width: 250px; font: normal normal bold 7pt Tahoma;z-index:100"
        });
        dialog.startup();

        dojo.style(dialog.domNode, "opacity", 0.8);
        dijit.placeOnScreen(dialog.domNode, {x: evt.pageX, y: evt.pageY}, ["TL", "BL"], {x: 10, y: 10});
      }
      
      function closeDialog() {
        var widget = dijit.byId("tooltipDialog");
        if (widget) {
            widget.destroy();
        }
      }
      
    dojo.addOnLoad(init);
  </script>

  <h2>
    <%=cm.cmsPhrase("Map of site")%>
  </h2>
  <div id="map" style="position: relative; margin: 1em auto; width:700px; height:500px; border:2px solid #050505;">
  </div>

<%
    }
  // Site pictures
      List listPictures = factsheet.getPicturesForSites();

      if(null != listPictures && listPictures.size() > 0)
      {
%>
  <a href="javascript:openpictures('<%=domainName%>/pictures.jsp?<%=picsURL%>',600,600)"><%=cm.cmsPhrase("View pictures")%></a>
<%
      }
      else if(SessionManager.isAuthenticated() && SessionManager.isUpload_pictures_RIGHT())
      {
%>
      <a href="javascript:openpictures('<%=domainName%>/pictures-upload.jsp?operation=upload&amp;<%=picsURL%>',600,600)"><%=cm.cmsPhrase("Upload pictures")%></a>
<%
      }
%>
