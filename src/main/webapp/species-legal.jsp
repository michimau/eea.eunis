<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species Legal instruments' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="ro.finsiel.eunis.search.species.legal.LegalSearchCriteria,
                ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                ro.finsiel.eunis.jrfTables.species.legal.ScientificLegalPersist,
                ro.finsiel.eunis.jrfTables.species.legal.LegalReportsPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.WebContentManagement,
                java.util.Vector"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesPersist"%>
<%@page import="java.util.List, java.util.Iterator"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
    <script language="JavaScript" src="script/species-legal.js" type="text/javascript"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,legal_instruments";
%>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        function setGroupName(selObj)
        {
          document.eunis.grName.value=selObj.options[selObj.selectedIndex].name;
        }

        function setGroupName2(selObj)
        {
          document.eunis2.grName.value=selObj.options[selObj.selectedIndex].name;
        }

        function legalText1OnChange()
        {
          var frm = document.eunis2;
          var legalText1 = document.eunis2.legalText1.options[document.eunis2.legalText1.selectedIndex].value;
          var arr = legalText1.split( "##" );

          var grName = document.createElement("input");
          grName.type= "hidden";
          grName.name = "grName";
          grName.value = arr[ 0 ];
          frm.appendChild( grName );

          var groupName = document.createElement("input");
          groupName.type= "hidden";
          groupName.name = "groupName";
          groupName.value = arr[ 1 ];
          frm.appendChild( groupName );

          var annex = document.createElement("input");
          annex.type= "hidden";
          annex.name = "annex";
          annex.value = arr[ 2 ];
          frm.appendChild( annex );

          var legalText = document.createElement("input");
          legalText.type= "hidden";
          legalText.name = "legalText";
          legalText.value = arr[ 3 ];
          frm.appendChild( legalText );

          frm.submit();
        }


        function groupNameChanged()
        {
          var groupID = document.eunis2.groupName.options[document.eunis2.groupName.selectedIndex].value;
          var groupName = document.eunis2.groupName.options[document.eunis2.groupName.selectedIndex].text;
          var frm = document.createElement( "FORM" );
          document.getElementById("main").appendChild( frm );
          frm.method = "get";
          frm.action="species-legal.jsp";

          var ctrl_h1 = document.createElement("input");
          ctrl_h1.type= "hidden";
          ctrl_h1.name = "groupID";
          ctrl_h1.value = groupID;
          frm.appendChild( ctrl_h1 );

          var isPostBack = document.createElement("input");
          isPostBack.type= "hidden";
          isPostBack.name = "postBack";
          isPostBack.value = "true";
          frm.appendChild( isPostBack );

          var ctrl_h2 = document.createElement("input");
          ctrl_h2.type= "hidden";
          ctrl_h2.name = "groupName";
          ctrl_h2.value = groupName;
          frm.appendChild( ctrl_h2 );

          //var showScientificName = document.eunis2.showScientificName;
          var ctrl_h3 = document.createElement("input");
          ctrl_h3.type= "hidden";
          ctrl_h3.name = "showScientificName";
          //ctrl_h3.value = showScientificName.checked;
          ctrl_h3.value = "true";
          frm.appendChild( ctrl_h3 );

          var showGroup = document.eunis2.showGroup;
          var ctrl_h4 = document.createElement("input");
          ctrl_h4.type= "hidden";
          ctrl_h4.name = "showGroup";
          ctrl_h4.value = showGroup.checked;
          frm.appendChild( ctrl_h4 );

          var showLegalText = document.eunis2.showLegalText;
          var ctrl_h5 = document.createElement("input");
          ctrl_h5.type= "hidden";
          ctrl_h5.name = "showLegalText";
          ctrl_h5.value = showLegalText.checked;
          frm.appendChild( ctrl_h5 );

          var showAbbreviation = document.eunis2.showAbbreviation;
          var ctrl_h6 = document.createElement("input");
          ctrl_h6.type= "hidden";
          ctrl_h6.name = "showAbbreviation";
          ctrl_h6.value = showAbbreviation.checked;
          frm.appendChild( ctrl_h6 );

          var showComment = document.eunis2.showComment;
          var ctrl_h7 = document.createElement("input");
          ctrl_h7.type= "hidden";
          ctrl_h7.name = "showComment";
          ctrl_h7.value = showComment.checked;
          frm.appendChild( ctrl_h7 );

          var showURL = document.eunis2.showURL;
          var ctrl_h8 = document.createElement("input");
          ctrl_h8.type= "hidden";
          ctrl_h8.name = "showURL";
          ctrl_h8.value = showURL.checked;
          frm.appendChild( ctrl_h8 );

          var typeForm = document.eunis2.typeForm;
          var ctrl_h9 = document.createElement("input");
          ctrl_h9.type= "hidden";
          ctrl_h9.name = "typeForm";
          ctrl_h9.value = typeForm.value;
          frm.appendChild( ctrl_h9 );

          frm.submit();
        }

        function onLoadFunction() {
            <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
            %>
                 document.eunis.saveCriteria.style.display = 'none';
                 document.eunis2.saveCriteria.style.display = 'none';
            <%
              }
            %>

        document.eunis.action = 'species-legal-result.jsp';
        document.eunis2.action = 'species-legal-result.jsp';
     }

     <%
              if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
              {
      %>
        function checkSaveCriteria(fromWhere) {
        if((fromWhere == '2' && validateForm()) || (fromWhere == '1' && trim(document.eunis2.groupName.value) != ''))
        {
            if(fromWhere == '2')
            {
               document.eunis.saveCriteria.checked=true;
               document.eunis.action = 'species-legal.jsp';
               alert('<%=cm.cms("save_alert")%>');
               document.eunis.submit();
            }
            if(fromWhere == '1')
            {
               document.eunis2.saveCriteria.checked=true;
               document.eunis2.action = 'species-legal.jsp';
               alert('<%=cm.cms("save_alert")%>');
               document.eunis2.submit();
            }
        } else
        {
            if(fromWhere == '2')
            {
              document.eunis.action = 'species-legal.jsp';
              document.eunis.submit();
            }
            if(fromWhere == '1')
            {
              if(trim(document.eunis2.groupName.value) == '') alert('<%=cm.cms("please_select_a_group")%>');
              document.eunis2.action = 'species-legal.jsp';
              document.eunis2.submit();
            }
        }
        }
            <%
            }
            %>

      //]]>
    </script>
<%
  // REQUEST PARAMETERS (facultative)
  // groupID - ID associated with groupName
  String groupID = null;
  if(request.getParameter( "groupID" ) == null && request.getParameter( "groupName" ) != null)
     groupID = Utilities.formatString( request.getParameter( "groupName" ), "" );
  else  groupID = Utilities.formatString( request.getParameter( "groupID" ), "" );
  String sv = (request.getParameter("saveCriteria") == null ?
                "false" :
                request.getParameter("saveCriteria")).equalsIgnoreCase("true") ? "checked=\"checked\"" : "";
%>
    <jsp:useBean id="GroupspeciesDomain" class="ro.finsiel.eunis.jrfTables.Chm62edtGroupspeciesDomain" scope="page" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_legal_title")%>
    </title>
  </head>
  <body onload="onLoadFunction()" id="main">
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cms("Document Actions")%></h5><%=cm.cmsTitle( "Document Actions" )%>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cms("Print this page")%>"
                            title="<%=cm.cms("Print this page")%>" /></a><%=cm.cmsTitle( "Print this page" )%>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cms("Toggle full screen mode")%>"
                             title="<%=cm.cms("Toggle full screen mode")%>" /></a><%=cm.cmsTitle( "Toggle full screen mode" )%>
                    </li>
                    <li>
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cms( "header_help_title" )%>"
                             title="<%=cm.cms( "header_help_title" )%>" /></a>
            				<%=cm.cmsTitle( "header_help_title" )%>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <table summary="layout" width="100%" border="0">
                  <tr>
                    <td>
                    <h1>
                      <%=cm.cmsPhrase("Species referenced by international legal instruments")%>
                    </h1>
                    <br />
                    <%=cm.cmsPhrase("(ex.: search <strong>Mammals</strong> referenced by the <strong>ANNEX II - Bern Convention legal text</strong>)")%>
                    <br />
                    <br />
                    <form name="eunis2" action="species-legal-result.jsp" method="get">
                      <input type="hidden" name="typeForm" value="<%=LegalSearchCriteria.CRITERIA_LEGAL%>" />
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                        <tr>
                          <td>
                            <strong>
                              <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td>
            <%
              boolean ckShowScientificName = true;
              boolean ckShowGroup = true;
              boolean ckShowLegalText = true;
              boolean ckShowAbbreviation = true;
              boolean ckShowComment = true;
              boolean ckShowURL = true;
              //Utilities.dumpRequestParams( request );
              boolean isPostBack = Utilities.checkedStringToBoolean( request.getParameter( "postBack"), false );
              if ( isPostBack )
              {
                ckShowScientificName = Utilities.checkedStringToBoolean( request.getParameter( "showScientificName" ), true);
                ckShowGroup = Utilities.checkedStringToBoolean( request.getParameter( "showGroup" ), true );
                ckShowLegalText = Utilities.checkedStringToBoolean( request.getParameter( "showLegalText" ), true );
                ckShowAbbreviation = Utilities.checkedStringToBoolean( request.getParameter( "showAbbreviation" ), true );
                ckShowComment = Utilities.checkedStringToBoolean( request.getParameter( "showComment" ), true );
                ckShowURL = Utilities.checkedStringToBoolean( request.getParameter( "showURL" ), true );
              }
            %>
                            <input title="<%=cm.cms("scientific_name")%>" id="checkbox1" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                              <label for="checkbox1"><%=cm.cmsPhrase("Scientific name")%></label>
                              <%=cm.cmsTitle("scientific_name")%>
                            <input title="<%=cm.cms("group")%>" id="checkbox2" type="checkbox" name="showGroup" value="true" <%=ckShowGroup ? "checked=\"checked\"" : ""%> />
                              <label for="checkbox2"><%=cm.cmsPhrase("Group")%></label>
                              <%=cm.cmsTitle("group")%>
                            <input title="<%=cm.cms("legal_text")%>" id="checkbox3" type="checkbox" name="showLegalText" value="true" <%=ckShowLegalText ? "checked=\"checked\"" : ""%> />
                              <label for="checkbox3"><%=cm.cmsPhrase("legal text")%></label>
                              <%=cm.cmsTitle("legal_text")%>
                            <input title="<%=cm.cms("abbreviation")%>" id="checkbox4" type="checkbox" name="showAbbreviation" value="true" <%=ckShowAbbreviation ? "checked=\"checked\"" : ""%> />
                              <label for="checkbox4"><%=cm.cmsPhrase("Abbreviation")%></label>
                              <%=cm.cmsTitle("abbreviation")%>
                            <input title="<%=cm.cms("comment")%>" id="checkbox5" type="checkbox" name="showComment" value="true" <%=ckShowComment ? "checked=\"checked\"" : ""%> />
                              <label for="checkbox5"><%=cm.cmsPhrase("Comment")%></label>
                              <%=cm.cmsTitle("comment")%>
                            <input title="<%=cm.cms("url")%>" id="checkbox6" type="checkbox" name="showURL" value="true" <%=ckShowURL ? "checked=\"checked\"" : ""%> />
                              <label for="checkbox6"><%=cm.cmsPhrase("Url")%></label>
                              <%=cm.cmsTitle("url")%>
                          </td>
                        </tr>
                      </table>
                      <table summary="layout" cellspacing="2" cellpadding="0" border="0" width="100%" style="text-align:left">
                        <tr>
                          <td style="vertical-align:bottom" colspan="2">
                            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                            <%=cm.cmsAlt("field_mandatory")%>
                            <strong>
                              <%=cm.cmsPhrase("Group")%>
                            </strong>
                          </td>
                          <td style="vertical-align:bottom" colspan="2">
                            <label for="select1" class="noshow"><%=cm.cms("group_name")%></label>
                            <select id="select1" title="<%=cm.cms("group_name")%>" name="groupName" onchange="groupNameChanged();">
                              <option value="" <%if (LegalSearchCriteria.CRITERIA_LEGAL.toString().equals(request.getParameter("typeForm")) && null == groupID) {%>selected="selected"<%}%>><%=cm.cms("please_select_a_group")%></option>
                              <option value="any" <%if (LegalSearchCriteria.CRITERIA_LEGAL.toString().equals(request.getParameter("typeForm")) && null != groupID && groupID.equalsIgnoreCase("any")){%>selected="selected"<%}%>><%=cm.cms("any_group")%></option>
                              <% // Find all groups
                              List speciesNames2 = GroupspeciesDomain.findOrderBy("ID_GROUP_SPECIES");
                              Iterator it2 = speciesNames2.iterator();
                              while (it2.hasNext())
                              {
                                Chm62edtGroupspeciesPersist group = (Chm62edtGroupspeciesPersist)it2.next();%>
                                <option value="<%=group.getIdGroupspecies()%>" <%if (LegalSearchCriteria.CRITERIA_LEGAL.toString().equals(request.getParameter("typeForm")) && null != groupID && groupID.equalsIgnoreCase(group.getIdGroupspecies().toString())) {%>selected="selected"<%}%>><%=(group.getCommonName() != null ? group.getCommonName().replaceAll("&","&amp;") : "")%></option>
                            <%
                              }
                            %>
                            </select>
                            <%=cm.cmsLabel("group_name")%>
                            <%=cm.cmsTitle("group_name")%>
                          </td>
                          <%
                               if ( !groupID.equalsIgnoreCase( "" ) )
                               {
                          %>
                          <td style="vertical-align:bottom">&nbsp;&nbsp;<strong><%=cm.cmsPhrase("and")%></strong></td>
                          <%
                              } else
                              {
                          %>
                                <td>
                                  &nbsp;
                                </td>
                          <%
                              }
                          %>
                        </tr>
                        <tr>
                          <%
                              if ( !groupID.equalsIgnoreCase( "" ) )
                              {
                          %>
                          <td style="vertical-align:bottom" colspan="2">
                            <br />
                            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                            <%=cm.cmsAlt("field_mandatory")%>
                            <strong><%=cm.cmsPhrase("legal text")%></strong>
                          </td>
                          <%
                          } else
                          {
                          %>
                            <td colspan="2">
                              &nbsp;
                            </td>
                          <%
                          }
                            if ( !groupID.equalsIgnoreCase( "" ) )
                            {
                          %>
                              <td style="vertical-align:bottom" colspan="3">
                                <label for="legalText1" class="noshow"><%=cm.cms("species_legal_instrument")%></label>
                                <select name="legalText1" id="legalText1" onchange="legalText1OnChange();" title="<%=cm.cms("species_legal_instrument")%>">
                                  <option value="" selected="selected"><%=cm.cms("species_legal_28")%></option>
                                  <option value="any##any##any##any"><%=cm.cms("any_legal_text")%></option>
                                  <%// Legal texts within selected group
                                  List results = SpeciesSearchUtility.findLegalTextsForGroup(groupID);
                                  Iterator resIt = results.iterator();
                                  // if we don't have any group
                                  if (!groupID.equalsIgnoreCase("any"))
                                  {
                                    while (resIt.hasNext())
                                    {
                                      ScientificLegalPersist item = (ScientificLegalPersist)resIt.next();%>
                                      <option value="<%=(item.getCommonName() != null ? item.getCommonName().replaceAll("&","&amp;") : "")%>##<%=item.getIdGroupspecies()%>##<%=item.getAnnex()%>##<%=item.getAlternative()%>">ANNEX <%=item.getAnnex()%> - <%=item.getAlternative()%></option>
                                <%
                                    }
                                  } else {
                                  // if we have any group
                                    while (resIt.hasNext())
                                    {
                                      LegalReportsPersist item = (LegalReportsPersist)resIt.next();%>
                                      <option value="any##any##<%=item.getAnnex()%>##<%=item.getAlternative()%>">ANNEX <%=item.getAnnex()%> - <%=item.getAlternative()%></option>
                                <%
                                    }
                                  }
                                %>
                                </select>
                                <%=cm.cmsLabel("species_legal_instrument")%>
                                <%=cm.cmsTitle("species_legal_instrument")%>
                              </td>
                          <%
                            } else {
                          %>
                              <td style="vertical-align:bottom" colspan="3">&nbsp;</td>
                          <%
                            }
                          %>
                        </tr>
                        <%
                            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                            {
                        %>
                              <tr>
                                <td colspan="5">&nbsp;
                                 <br />
                                  <input title="<%=cm.cms("save_criteria")%>" id="saveCriteria1" type="checkbox" name="saveCriteria" value="true" <%=sv%> />
                                  <label for="saveCriteria1"><%=cm.cmsPhrase("Save your criteria:")%></label>
                                  <%=cm.cmsTitle("save_criteria")%>
                                  <a title="<%=cm.cms("save_open_link")%>" href="javascript:checkSaveCriteria(1)"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                                  <%=cm.cmsTitle("save_open_link")%>
                                </td>
                              </tr>
                        <%
                            }
                        %>

                        <tr>
                            <td colspan="5">
                                <br />
                                <hr class="horizontal_line" />
                            </td>
                        </tr>
                      </table>
                    </form>
                      <br />
                      <h1>
                        <%=cm.cmsPhrase("International Legal Instruments")%>
                      </h1>
                      <br />
                      <%=cm.cmsPhrase("Legal texts by selected species<br />(ex.: search legal information mentioning <strong>Alopex lagopus</strong> from <strong>Mammals</strong> group)")%>
                      <br />
                      <br />
                      <form onsubmit="javascript:return validateForm();" name="eunis" action="species-legal-result.jsp" method="get">
                        <input type="hidden" name="showScientificName" value="true" />
                        <input type="hidden" name="grName" value="" />
                        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                          <tr>
                            <td>
                              <strong>
                                <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed)")%>:
                              </strong>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <input title="<%=cm.cms("scientific_name")%>" id="checkbox11" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                                <label for="checkbox11"><%=cm.cmsPhrase("Scientific name")%></label>
                                <%=cm.cmsTitle("scientific_name")%>
                              <input title="<%=cm.cms("group")%>" id="checkbox12" type="checkbox" name="showGroup" value="true" checked="checked" />
                                <label for="checkbox12"><%=cm.cmsPhrase("Group")%></label>
                                <%=cm.cmsTitle("group")%>
                              <input title="<%=cm.cms("legal_text")%>" id="checkbox13" type="checkbox" name="showLegalText" value="true" checked="checked" />
                                <label for="checkbox13"><%=cm.cmsPhrase("legal text")%></label>
                                <%=cm.cmsTitle("legal_text")%>
                              <input title="<%=cm.cms("abbreviation")%>" id="checkbox14" type="checkbox" name="showAbbreviation" value="true" checked="checked" />
                                <label for="checkbox14"><%=cm.cmsPhrase("Abbreviation")%></label>
                                <%=cm.cmsTitle("abbreviation")%>
                              <input title="<%=cm.cms("comment")%>" id="checkbox15" type="checkbox" name="showComment" value="true" checked="checked" />
                                <label for="checkbox15"><%=cm.cmsPhrase("Comment")%></label>
                                <%=cm.cmsTitle("comment")%>
                              <input title="<%=cm.cms("url")%>" id="checkbox16" type="checkbox" name="showURL" value="true" checked="checked" />
                                <label for="checkbox16"><%=cm.cmsPhrase("Url")%></label>
                                <%=cm.cmsTitle("url")%>
                            </td>
                          </tr>
                      </table>
                      <input type="hidden" name="typeForm" value="<%=LegalSearchCriteria.CRITERIA_SPECIES%>" />
                      <table summary="layout" cellspacing="2" cellpadding="0" border="0" style="text-align:left" width="100%">
                        <tr>
                          <td style="vertical-align:bottom" colspan="2">
                            <br />
                            <br />
                            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_included.gif" />
                            <%=cm.cmsTitle("field_optional")%>
                            <strong>
                                <%=cm.cmsPhrase("Group")%>
                            </strong>
                          </td>
                          <td style="vertical-align:bottom" colspan="2">
                            <label for="select2" class="noshow"><%=cm.cms("group_name")%></label>
                            <select id="select2" title="<%=cm.cms("group_name")%>" name="groupName" onchange="setGroupName(this)">
                              <option value="any" <%=(LegalSearchCriteria.CRITERIA_SPECIES.toString().equals(request.getParameter("typeForm")) && request.getParameter("groupName") == null ? "selected=\"selected\"" : "")%>><%=cm.cms("any_group")%></option>
                              <%
                                // List of species group names
                                List speciesNames = GroupspeciesDomain.findOrderBy("ID_GROUP_SPECIES");
                                Iterator it = speciesNames.iterator();
                                while (it.hasNext())
                                {
                                  Chm62edtGroupspeciesPersist specieName = (Chm62edtGroupspeciesPersist)it.next();%>
                                  <option value="<%=specieName.getIdGroupspecies()%>" <%=(LegalSearchCriteria.CRITERIA_SPECIES.toString().equals(request.getParameter("typeForm")) && specieName.getIdGroupspecies() != null && specieName.getIdGroupspecies().toString().equalsIgnoreCase(request.getParameter("groupName")) ? "selected=\"selected\"" : "")%>><%=(specieName.getCommonName() != null ? specieName.getCommonName().replaceAll("&","&amp;") : "")%></option>
                              <%
                                }
                              %>
                            </select>
                              <%=cm.cmsLabel("group_name")%>
                              <%=cm.cmsTitle("group_name")%>
                          </td>
                          <td>
                            &nbsp;
                            <strong>
                              <%=cm.cmsPhrase("and")%>
                            </strong>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <br />
                            <img alt="<%=cm.cms("field_mandatory")%>" width="11" height="12" style="vertical-align:middle" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" />
                            <%=cm.cmsAlt("field_mandatory")%>
                              <label for ="scientificName"><%=cm.cmsPhrase("Scientific name")%></label>
                          </td>
                          <td style="vertical-align:bottom" colspan="3">
                            <input id="scientificName" alt="<%=cm.cms("scientific_name")%>" size="43" name="scientificName" title="<%=cm.cms("scientific_name")%>" value="<%=(request.getParameter("scientificName") == null ? "" : request.getParameter("scientificName"))%>" /><%=cm.cmsTitle("scientific_name")%>&nbsp;
                            <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-legal-choice.jsp')"><img alt="<%=cm.cms("species_legal_13")%>" style="vertical-align:middle" height="18" title="<%=cm.cms("species_legal_13")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                            <%=cm.cmsTitle("list_values_link")%>
                            <%=cm.cmsAlt("species_legal_13")%>
                          </td>
                        </tr>
                           <%
                          if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                          {
                        %>
                            <tr>
                              <td colspan="5">
                                <br/>
                                <input title="<%=cm.cms("save_criteria")%>" id="saveCriteria2" type="checkbox" name="saveCriteria" value="true" <%=sv%> />
                                <%=cm.cmsTitle("save_criteria")%>
                                  <label for="saveCriteria2">
                                      <%=cm.cmsPhrase("Save your criteria:")%>
                                  </label>
                                <a title="<%=cm.cms("save_open_link")%>" href="javascript:checkSaveCriteria(2)"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                                <%=cm.cmsTitle("save_open_link")%>
                                <%=cm.cmsAlt("save_open_link")%>
                              </td>
                            </tr>
                        <%
                          }
                        %>
                        <tr>
                          <td style="text-align:right" colspan="5">
                            <input id="Reset" type="reset" value="<%=cm.cms("reset")%>" name="Reset" class="standardButton" title="<%=cm.cms("reset")%>" />
                            <%=cm.cmsTitle("reset")%>
                            <%=cm.cmsInput("reset")%>
                            <input id="Search" type="submit" value="<%=cm.cms("search")%>" name="submit2" class="submitSearchButton" title="<%=cm.cms("search")%>" />
                            <%=cm.cmsTitle("search")%>
                            <%=cm.cmsInput("search")%>
                          </td>
                        </tr>
                      </table>
                    </form>
                </td>
              </tr>
            </table>
                        <%
                          // Expand saved searches list for this jsp page
                          if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
                          {
                            // Set Vector for URL string
                            Vector show = new Vector();
                            show.addElement("showScientificName");
                            show.addElement("showGroup");
                            show.addElement("showLegalText");
                            show.addElement("showAbbreviation");
                            show.addElement("showURL");
                            show.addElement("showComment");

                            String pageName = "species-legal.jsp";
                            String pageNameResult = "species-legal-result.jsp?"+Utilities.writeURLCriteriaSave(show) + "&amp;expand=true";
                            // Expand or not save criterias list
                            String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
                        %>
                    <hr class="horizontal_line" />
                    <br />
                            <jsp:include page="show-criteria-search.jsp">
                              <jsp:param name="pageName" value="<%=pageName%>" />
                              <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                              <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                            </jsp:include>
                        <%
                          }
                        %>

            <%=cm.br()%>
            <%=cm.cmsMsg("save_alert")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_legal_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("please_select_a_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any_group")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_legal_28")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any_legal_text")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any_group")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-legal.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
