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
%>
  <h2>
    <%=cm.cmsText("site_identification")%>
  </h2>
  <table summary="layout" class="datatable" width="90%">
    <tbody>
      <tr>
        <td width="50%">
          <%-- Code in database --%>
          <strong>
            <%=SitesSearchUtility.translateSourceDB(factsheet.getSiteObject().getSourceDB())%>
          </strong>
          <%=cm.cmsText("code_in_database")%>
        </td>
        <td width="50%">
          <strong>
            <%=factsheet.getIDSite()%>
          </strong>
        </td>
      </tr>
      <tr class="zebraeven">
        <%-- Surface area --%>
        <td>
          <%=cm.cmsText("surface_area_ha")%>
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
          <%=cm.cmsText("sites_factsheet_06")%>
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
          <%=cm.cmsText("complex_name")%>
        </td>
        <td>
          <%=factsheet.getSiteObject().getComplexName()%>
        </td>
      </tr>
      <tr>
        <%-- District name --%>
        <td>
          <%=cm.cmsText("district_name")%>
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
          <%=cm.cmsText("date_form_compilation_date")%> <%=dateformatCompilationDate%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getCompilationDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getCompilationDate(),dateformatCompilationDate2),"MMM yyyy") + (factsheet.getSiteObject().getCompilationDate() == null || factsheet.getSiteObject().getCompilationDate().trim().length()<=0 ? "" :" (" + cm.cmsText("sites_factsheet_170") + " " + factsheet.getSiteObject().getCompilationDate() + ")")%>
        </td>
      </tr>
      <tr>
        <%-- Date form update--%>
        <td>
          <%=cm.cmsText("date_form_update")%> <%=dateformatUpdateDate%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getUpdateDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getUpdateDate(),dateformatUpdateDate2),"MMM yyyy") + (factsheet.getSiteObject().getUpdateDate() == null || factsheet.getSiteObject().getUpdateDate().trim().length()<=0 ? "" : " (" + cm.cmsText("sites_factsheet_170") + " " + factsheet.getSiteObject().getUpdateDate() + ")")%>
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
          <%=cm.cmsText("date_proposed")%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getProposedDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getProposedDate(),"yyyyMM"),"MMM yyyy") + (factsheet.getSiteObject().getProposedDate() == null || factsheet.getSiteObject().getProposedDate().trim().length()<=0 ? "" :" (" + cm.cmsText("sites_factsheet_170") + " " + factsheet.getSiteObject().getProposedDate() + ")")%>
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
          <%=cm.cmsText("date_confirmed")%>
        </td>
        <td>
          <%=SiteFactsheet.TYPE_NATURA2000 != type ? factsheet.getSiteObject().getConfirmedDate() : Utilities.formatDate(Utilities.stringToTimeStamp(factsheet.getSiteObject().getConfirmedDate(),"yyyyMM"),"MMM yyyy") + (factsheet.getSiteObject().getConfirmedDate() == null || factsheet.getSiteObject().getConfirmedDate().trim().length()<=0 ? "" :" (" + cm.cmsText("sites_factsheet_170") + " " + factsheet.getSiteObject().getConfirmedDate() + ")")%>
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
          <%=cm.cmsText("date_first_designation")%>
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
          <%=cm.cmsText("site_designation_date")%>
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
  <br />
<%
      // Site designations
      List designations = SitesSearchUtility.findDesignationsForSitesFactsheet(factsheet.getSiteObject().getIdSite());
      if (designations != null && designations.size()>0)
      {
%>
  <%-- Designation information --%>
  <h2>
    <%=cm.cmsText("designation_information")%>
  </h2>
  <table summary="<%=cm.cms("designation_information")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("source_data_set")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("designation_code")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("designation_name_original")%>
        </th>
        <th style="text-transform: capitalize; text-align: left;">
          <%=cm.cmsText("designation_name_english")%>
        </th>
<%
        if (SiteFactsheet.TYPE_CORINE != type)
        {
%>
        <th>
          <%=cm.cmsText("designation_name_french")%>
        </th>
<%
        }
%>
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
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=original&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=designation.getDescription()%></a>
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
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=designation.getDescriptionEn()%></a>
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
<%
          if (SiteFactsheet.TYPE_CORINE != type)
          {
%>
        <td>
<%
            if(designation.getDescriptionFr() != null && designation.getDescriptionFr().trim().length() > 0)
            {
%>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=fr&amp;idDesign=<%=designation.getIdDesignation()%>&amp;geoscope=<%=designation.getIdGeoscope()%>"><%=designation.getDescriptionFr()%></a>
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
<%
          }
%>
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
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=original&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescription()%></a>
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
            <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=en&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescriptionEn()%></a>
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
          if(desig.getDescriptionFr() != null && desig.getDescriptionFr().trim().length() > 0)
          {
%>
          <a title="<%=cm.cms("open_designation_factsheet")%>" href="designations-factsheet.jsp?fromWhere=fr&amp;idDesign=<%=desig.getIdDesignation()%>&amp;geoscope=<%=desig.getIdGeoscope()%>"><%=desig.getDescriptionFr()%></a>
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
  <br />
  <table summary="layout" class="datatable" width="90%">
    <tr class="zebraeven">
      <%-- Project ID --%>
      <td width="15%">
        <%=cm.cmsText("project_id")%>
      </td>
      <td>
        &nbsp;
      </td>
    </tr>
    <tr class="zebraeven">
      <%-- Project title --%>
      <td>
        <%=cm.cmsText("project_title")%>
      </td>
      <td>
        &nbsp;
      </td>
    </tr>
  </table>
  <br />
  <a name="monitoring"></a>
  <h2>
    <%=cm.cmsText("sites_factsheet_24")%>
  </h2>
  <br />
  <%-- Monitoring activities --%>
  <textarea rows="1" cols="80"></textarea>
  <br />
  <br />
  <table summary="Link to other providers" width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="50%">
        <a title="<%=cm.cms("google_pictures")%>" href="javascript:openGooglePics('http://images.google.com/images?q=<%=factsheet.getSiteObject().getName()%>')"><%=cm.cmsText("pictures_on_google")%></a>
      </td>
      <td width="50%" align="right">
<%
      if ( SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type || SiteFactsheet.TYPE_CDDA_NATIONAL == type )
      {
        String level = "nat";
        if ( SiteFactsheet.TYPE_CDDA_INTERNATIONAL == type )
        {
          level = "int";
        }
%>
        <a title="<%=cm.cms("wcmc_link")%>" href="javascript:openunepwcmc('http://sea.unep-wcmc.org/wdbpa/sitedetails.cfm?siteid=<%=factsheet.getSiteObject().getIdSite()%>&amp;level=<%=level%>')"><%=cm.cmsText("unep_link")%></a>
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
  </table>
  <br />
<%
      String country = Utilities.formatString(factsheet.getCountry()).trim();
      String parentCountry = Utilities.formatString(factsheet.getParentCountry()).trim();
%>
  <%-- Location information --%>
  <h2>
    <%=cm.cmsText("location_information")%>
  </h2>
  <table summary="<%=cm.cms("location_information")%>" class="datatable" width="90%">
    <tr>
      <td colspan="2">
        <%=cm.cmsText("country")%>
      </td>
<%--              <td><a href="sites-statistical-result.jsp?country=<%=country%>&amp;DB_NATURA2000=true&amp;DB_CDDA_NATIONAL=true&amp;DB_NATURE_NET=true&amp;DB_DIPLOMA=true&amp;DB_CDDA_INTERNATIONAL=true&amp;DB_CORINE=true&amp;DB_BIOGENETIC=true&amp;DB_EMERALD=true" title="Open the statistical data for <%=country%>"><%=country%></a></td>--%>
      <td>
<%
      if(Utilities.isCountry(country))
      {
%>
        <a href="javascript:goToCountryStatistics('<%=country%>')" title="<%=cm.cms("open_the_statistical_data_for")%> <%=country%>"><%=Utilities.formatString(country,"")%></a>
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
        <%=cm.cmsText("parent_country")%>
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
    <tr class="zebraeven">
      <td colspan="2">
        <%=cm.cmsText("sites_factsheet_30")%>
      </td>
      <td colspan="4">
<%
            if(regionCodes.size()>0)
            {
              for (int i = 0;  i < regionCodes.size(); i++)
              {
                RegionsCodesPersist region = (RegionsCodesPersist)regionCodes.get(i);
%>
        NUTS code <%=Utilities.formatString(region.getRegionCode())%>, <%=Utilities.formatString(region.getRegionName())%>, cover:<%=Utilities.formatString(region.getRegionCover())%>%
<%
                  if (regionCodes.size() > 1 && i < regionCodes.size() - 1)
                  {
                    out.print("<br />");
                  }
              }
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
          boolean anatol = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ANATOL"), false);
          boolean arctic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ARCTIC"), false);
          boolean atlantic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("ATLANTIC"), false);
          boolean boreal = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("BOREAL"), false);
          boolean continent = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("CONTINENT"), false);
          boolean macarones = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MACARONES"), false);
          boolean mediterranean = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("MEDITERRANIAN"), false);
          boolean pannonic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PANNONIC"), false);
          boolean pontic = Utilities.checkedStringToBoolean(factsheet.findSiteAttribute("PONTIC"), false);
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
              <%=cm.cmsText("sites_factsheet_149")%>
            </td>
          </tr>
          <tr>
            <td>
              <%=cm.cmsText("biogeographic_region")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_152")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_153")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_154")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_155")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_156")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_157")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_158")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_159")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_160")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_161")%>
            </td>
            <td>
              <%=cm.cmsText("sites_factsheet_162")%>
            </td>
          </tr>
          <tr bgcolor="#EEEEEE">
            <td>
              <%=cm.cmsText("sites_factsheet_151")%>
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
    <tr class="zebraeven">
      <td>
        <%=cm.cmsText("minimum_altitude")%>
      </td>
      <td>
      <%=Utilities.formatString(altMin)%>
      </td>
      <td>
        <%=cm.cmsText("mean_altitude_m")%>
      </td>
      <td>
        <%=Utilities.formatString(altMean)%>
      </td>
      <td>
        <%=cm.cmsText("maximum_altitude_m")%>
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
        <%=cm.cmsText("longitude")%>
      </td>
      <td>
        <%=longitude%>
      </td>
      <td>
        <%=cm.cmsText("latitude")%>
      </td>
      <td colspan="3">
        <%=latitude%>
      </td>
    </tr>
    <tr class="zebraeven">
      <td>
        <%=cm.cmsText("sites_factsheet_36")%>
      </td>
      <td colspan="2">
        <%=Utilities.formatArea(factsheet.getSiteObject().getLongitude(), 0, 6, null)%>
      </td>
      <td>
        <%=cm.cmsText("sites_factsheet_37")%>
      </td>
      <td colspan="2">
        <%=Utilities.formatArea(factsheet.getSiteObject().getLatitude(), 0, 6, null)%>
      </td>
    </tr>
<%
      if ( SiteFactsheet.TYPE_DIPLOMA == type || SiteFactsheet.TYPE_BIOGENETIC == type || SiteFactsheet.TYPE_CORINE == type )
      {
        List results = factsheet.getBiogeoregion();
%>
    <tr class="zebraeven">
      <td colspan="2"><%=cm.cmsText("biogeographic_regions")%></td>
      <td colspan="4">
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
      String longitudeURL = factsheet.getSiteObject().getLongitude();
      String latitudeURL = factsheet.getSiteObject().getLatitude();
      if (null != longitudeURL && null != latitudeURL)
      {
%>
  <br />
<%
        String sitesCoordinates = "";
        Chm62edtSitesPersist site = factsheet.getSiteObject();
        if(site.getLatitude()!=null && site.getLongitude()!=null && !site.getLongitude().substring(0,5).equalsIgnoreCase("0.000") && !site.getLatitude().substring(0,5).equalsIgnoreCase("0.000"))
        {

          sitesCoordinates = site.getLongitude().substring(0,5)+":"+ site.getLatitude().substring(0,5) + ":-2:" + Utilities.cleanString( site.getName() );
        }

        String extension=application.getInitParameter("EEA_MAP_SERVER_EXTENSION"); //default image type for maps
        String urlPic = application.getInitParameter("EEA_MAP_SERVER") + "/getmap.asp";
        String parameters = "p=";
        String mapType="World_B";
        if( request.getParameter( "mapType" ) != null )
        {
          mapType = request.getParameter("mapType");
        }
        String zoom="0";
        if( request.getParameter("Zoom") != null )
        {
          zoom=request.getParameter("Zoom");
        }
        parameters += sitesCoordinates;
        parameters += "&amp;Color=HEEEEEE";
        parameters += "&amp;Coordsys=LL";
        parameters += "&amp;Size=W345H300";
        parameters += "&amp;ImageQuality=100";
        parameters += "&amp;Outline=1";
        parameters += "&amp;Scalebar=1";
        parameters += "&amp;MapType=" + mapType;
        parameters += "&amp;Zoom=" + zoom;
        String proxy = application.getInitParameter("PROXY_URL");
        int port = ro.finsiel.eunis.search.Utilities.checkedStringToInt(application.getInitParameter("PROXY_PORT"),0);
        String filename = urlPic + "?" + parameters;
%>
  <table summary="layout" border="0" cellpadding="0" cellspacing="0" width="90%" style="border-collapse:collapse">
    <tr>
      <td width="50%">
        <a name="map"></a>
        <img name="mmap" alt="<%=cm.cms("site_location_on_map")%>" title="<%=cm.cms("site_location_on_map")%>" src="<%=filename%>" width="345" height="300" style="vertical-align:middle" />
        <%=cm.cmsAlt("site_location_on_map")%>
        <%=cm.cmsTitle("site_location_on_map")%>
        <br />
      </td>
      <td width="50%" style="padding-left : 20px;">
        <strong>
          <%=cm.cmsText("change_map_type")%>
        </strong>
        <br />
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Standard#map" title="<%=cm.cms("change_map_to_standard")%>"><%=cm.cmsText("standard_europe" )%></a>
        <%=cm.cmsTitle("change_map_to_standard")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Standard_B#map" title="<%=cm.cms("change_map_to_standard_boundaries")%>"><%=cm.cmsText("standard_europe_boundaries" )%></a>
        <%=cm.cmsTitle("change_map_to_standard_boundaries")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Europe#map" title="<%=cm.cms("change_map_to_europe")%>"><%=cm.cmsText("europe" )%></a>
        <%=cm.cmsTitle("change_map_to_europe")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Europe_B#map" title="<%=cm.cms("change_map_to_europe_boundaries")%>"><%=cm.cmsText("europe_boundaries" )%></a>
        <%=cm.cmsTitle("change_map_to_europe_boundaries")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=World#map" title="<%=cm.cms("change_map_to_world")%>"><%=cm.cmsText("world" )%></a>
        <%=cm.cmsTitle("change_map_to_world")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=World_B#map" title="<%=cm.cms("change_map_to_world_boundaries")%>"><%=cm.cmsText("world_boundaries" )%></a>
        <%=cm.cmsTitle("change_map_to_world_boundaries")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Biogeographic#map" title="<%=cm.cms("change_map_to_biogeographic")%>"><%=cm.cmsText("biogeographic" )%></a>
        <%=cm.cmsTitle("change_map_to_biogeographic")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=Biogeographic_B#map" title="<%=cm.cms("change_map_to_biogeographic_boundaries")%>"><%=cm.cmsText("biogeographic_boundaries" )%></a>
        <%=cm.cmsTitle("change_map_to_biogeographic_boundaries")%>
        <br />
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=<%=mapType%>&amp;Zoom=2#map" title="<%=cm.cms("zoom_in_map")%>"><%=cm.cmsText("zoom_in" )%></a>
        <%=cm.cmsTitle("zoom_in_map")%>
        <br />
        <a href="sites-factsheet.jsp?tab=<%=tab%>&amp;idsite=<%=siteid%>&amp;mapType=<%=mapType%>&amp;Zoom=0#map" title="<%=cm.cms("zoom_out_map")%>"><%=cm.cmsText("zoom_out" )%></a>
        <%=cm.cmsTitle("zoom_out_map")%>
        <br />
      </td>
    </tr>
  </table>
  <br />
  <form name="gis" action="sites-gis-tool.jsp" target="_blank" method="post">
    <input type="hidden" name="sites" value="'<%=site.getIdSite()%>'" />
    <input id="showMap" type="submit" title="<%=cm.cms("show_map")%>" name="Show map" value="<%=cm.cms("show_map")%>" class="standardButton" />
    <%=cm.cmsTitle("show_map")%>
    <%=cm.cmsInput("show_map")%>
  </form>
<%
    }
%>
