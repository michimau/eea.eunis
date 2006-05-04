<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats general information' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.DescriptionWrapper,
                 ro.finsiel.eunis.factsheet.habitats.HabitatFactsheetRelWrapper,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.jrfTables.Chm62edtHabitatInternationalNamePersist,
                 ro.finsiel.eunis.jrfTables.habitats.factsheet.OtherClassificationPersist,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.List"%>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// INPUT PARAMS: idHabitat
  String idHabitat = request.getParameter("idHabitat");
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse;">
    <tr bgcolor="#CCCCCC" valign="middle">
      <td width="15%">
        <%=cm.cmsText("english_name")%>
      </td>
      <td width="40%">
        <strong>
          <%=factsheet.getHabitatDescription()%>
        </strong>
      </td>
      <%-- Link to key navigation, taxonomic tree and diagram --%>
      <td width="20%" align="center">
<%
  if (factsheet.isEunis() && factsheet.getHabitatLevel().intValue() < 3)
  {
    int realLevel = factsheet.getHabitatLevel().intValue() + 1;
%>
    <%-- Key navigation--%>
    <a title="<%=cm.cms("open_key_navigation")%>" href="habitats-key.jsp?pageCode=<%=factsheet.getEunisHabitatCode()%>&amp;level=<%=realLevel%>"><img alt="Key navigation" src="images/mini/key_in.png" width="20" height="20" title="<%=cm.cms("habitats_factsheet_80")%>" border="0" /></a>
    <%=cm.cmsTitle("open_key_navigation")%><%=cm.cmsTitle("habitats_factsheet_80")%>
    &nbsp;&nbsp;
<%
  }
  if (factsheet.isEunis())
  {
    if (factsheet.getHabitatLevel() != null && factsheet.getHabitatLevel().intValue() > 1)
    {
%>
      <a title="<%=cm.cms("open_code_browser")%>" href="habitats-code-browser.jsp?Code=<%=factsheet.getEunisHabitatCode()%>&amp;habID=<%=factsheet.getIdHabitat()%>&amp;fromFactsheet=yes"><img alt="<%=cm.cms("open_code_browser")%>" src="images/mini/tree.gif" width="20" height="20" border="0" title="<%=cm.cms("habitats_factsheet_06")%>" /></a>
      <%=cm.cmsTitle("open_code_browser")%><%=cm.cmsTitle("habitats_factsheet_06")%>
      &nbsp;&nbsp;
<%
    }
    if (factsheet.getHabitatLevel() != null && factsheet.getHabitatLevel().intValue() == 1)
    {
%>
      <a title="<%=cm.cms("open_tree_navigation")%>" href="habitats-code-browser.jsp"><img alt="<%=cm.cms("open_tree_navigation")%>" src="images/mini/tree.gif" width="20" height="20" border="0" title="<%=cm.cms("habitats_factsheet_06")%>" /></a>
      <%=cm.cmsTitle("open_tree_navigation")%><%=cm.cmsTitle("habitats_factsheet_06")%>
      &nbsp;&nbsp;
<%
    }
%>
      <a title="<%=cm.cms("open_diagram")%>" href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=factsheet.getEunisHabitatCode()%>','','toolbar=yes,scrollbars=yes,resizable=yes')"><img alt="<%=cm.cms("open_diagram")%>" src="images/mini/diagram_out.png" title="<%=cm.cms("habitats_factsheet_07")%>" width="20" height="20" border="0" /></a>
      <%=cm.cmsTitle("open_diagram")%><%=cm.cmsTitle("habitats_factsheet_07")%>
<%
  }
%>
      </td>
    </tr>
  </table>
  <br />
<%-- Habitat code and Level for EUNIS habitats, original code for NATURA --%>
  <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse;">
<%
  if (factsheet.isEunis())
  {
%>
    <tr bgcolor="#EEEEEE">
      <td width="30%">
        <%=cm.cmsText("eunis_habitat_type_code")%>
      </td>
      <td width="40%">
        &nbsp;
        <strong>
          <%=Utilities.formatString(factsheet.getEunisHabitatCode(), "")%>
        </strong>
      </td>
      <td width="15%" bgcolor="#DDDDDD" align="right">
        <%=cm.cmsText("generic_index_07")%>
      </td>
      <td width="15%" bgcolor="#DDDDDD">
        &nbsp;
        <strong>
          <%=Utilities.formatString(factsheet.getHabitatLevel(), "")%>
        </strong>
      </td>
    </tr>
<%
  }
  else
  {
%>
    <tr bgcolor="#EEEEEE">
      <td width="30%">
        <%=cm.cmsText("habitats_factsheet_12")%>
      </td>
      <td width="40%">
        &nbsp;
        <strong>
          <%=factsheet.getCode2000()%>
        </strong>
      </td>
      <td width="15%" bgcolor="#DDDDDD" align="right">&nbsp;</td>
      <td width="15%" bgcolor="#DDDDDD">&nbsp;</td>
    </tr>
    <tr bgcolor="#EEEEEE">
      <td>
        <%=cm.cmsText("originally _published_code")%>
      </td>
      <td>
        <strong>
          &nbsp;
          <%=(factsheet.isAnnexI() ? Utilities.formatString(factsheet.getHabitat().getCodeAnnex1()) : Utilities.formatString(factsheet.getHabitat().getOriginallyPublishedCode()))%>
        </strong>
      </td>
      <td bgcolor="#DDDDDD" align="right">
        <%=cm.cmsText("priority")%>
        &nbsp;
      </td>
      <td bgcolor="#DDDDDD">
        <strong>
          &nbsp;
          <%=(factsheet.getPriority() != null && 1 == factsheet.getPriority().shortValue() ? cm.cmsText("yes") :  cm.cmsText("no"))%>
          &nbsp;
        </strong>
      </td>
    </tr>
<%
  }
%>
  </table>
<%
  // Habitat description.
  Vector descriptions = null;
  try {
    descriptions = factsheet.getDescrOwner();
  } catch(InitializationException e) {
  e.printStackTrace();
  }
  for (int i = 0; i < descriptions.size(); i++)
  {
    DescriptionWrapper description = (DescriptionWrapper)descriptions.get(i);
    if(description.getLanguage().equalsIgnoreCase("english"))
    {
%>
  <br />
  <table summary="layout"  width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
    <tr>
      <td bgcolor="#DDDDDD">
        <strong>
          <%=cm.cmsText("description")%>
          (
            <%=description.getLanguage()%>
          )
        </strong>
      </td>
    </tr>
    <tr>
      <td bgcolor="#EEEEEE">
        <%=description.getDescription()%>
      </td>
    </tr>
<%
      if (!description.getOwnerText().equalsIgnoreCase("n/a") && !description.getOwnerText().equalsIgnoreCase(""))
      {
%>
    <tr>
      <td bgcolor="#DDDDDD">
        <strong>
          <%=cm.cmsText("habitats_factsheet_16")%>
        </strong>
      </td>
    </tr>
    <tr>
      <td bgcolor="#EEEEEE">
        <%=description.getOwnerText()%>
      </td>
    </tr>
<%
      }
      if (null != description.getIdDc())
      {
        String textSource = Utilities.formatString(SpeciesFactsheet.getBookAuthorDate(description.getIdDc()), "");
        if (!textSource.equalsIgnoreCase(""))
        {
%>
          <tr>
            <td bgcolor="#DDDDDD">
              <strong>
                <%=cm.cmsText("source")%>:
              </strong>
            </td>
          </tr>
          <tr>
            <td bgcolor="#EEEEEE">
              <%
                String _source = textSource;
                _source = _source.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
              %>
              <%=_source%>
            </td>
          </tr>
<%
        }
      }
%>
  </table>

<%
    }
  }

  // List of habitats inernationals names.
  List names = factsheet.getInternationalNames();
  if ( names.size() > 0 )
  {
%>
    <br />
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("habitats_name_in_other_languages")%></div>
    <table summary="<%=cm.cms("habitats_name_in_other_languages")%>" border="0" width="100%" cellspacing="0" cellpadding="0" style="border-collapse : collapse">
      <tr bgcolor="#DDDDDD">
        <th class="resultHeader">
          <strong>
            <%=cm.cmsText("language")%>
          </strong>
        </th>
        <th class="resultHeader">
          <strong>
            <%=cm.cmsText("name")%>
          </strong>
        </th>
      </tr>
<%
        // List habitats internationals names.
        for ( int i = 0; i < names.size(); i++ )
        {
          Chm62edtHabitatInternationalNamePersist name = (Chm62edtHabitatInternationalNamePersist)names.get(i);
%>
      <tr bgcolor="<%=(0 == (i % 2) ?  "#EEEEEE" : "#FFFFFF")%>">
        <td>
          <%=name.getNameEn()%>
        </td>
        <td>
          <%=name.getName()%>
        </td>
      </tr>
<%
        }
%>
    </table>
<%
  }
  // Habitat codes in other classifications.
  List otherClassifHabitats = factsheet.getOtherClassifications();
   // Relation with other habitats
  Vector otherHabitats = factsheet.getOtherHabitatsRelations();

  if (otherClassifHabitats.size() > 0 || otherHabitats.size() > 0)
  {
    int ii = 0;
%>
    <br />
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("habitats_factsheet_22")%></div>
    <table width="100%" border="0" summary="<%=cm.cms("habitats_factsheet_22")%>" cellspacing="0" cellpadding="0" id="relations" class="sortable">
      <tr bgcolor="#DDDDDD">
        <th width="30%" title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("classification")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
        <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("code_column")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
        <th width="40%" title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("title")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
        <th width="15%" title="<%=cm.cms("sort_results_on_this_column")%>">
          <strong>
            <%=cm.cmsText("relation_type")%>
            <%=cm.cmsTitle("sort_results_on_this_column")%>
          </strong>
        </th>
      </tr>
<%
    if (otherClassifHabitats.size() > 0)
    {
      for (int j = 0; j < otherClassifHabitats.size(); j++)
      {
        OtherClassificationPersist otherClassifHabitat = (OtherClassificationPersist)otherClassifHabitats.get(j);
  %>
        <tr bgcolor="<%=(0 == (ii++ % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <%
            String _name = otherClassifHabitat.getName();
            _name = _name.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
          %>
          <td width="30%"><%=_name%>&nbsp;</td>
          <td width="15%">&nbsp;<%=otherClassifHabitat.getCode()%></td>
          <td width="40%"><%=otherClassifHabitat.getTitle()%></td>
          <td width="15%">&nbsp;<%=HabitatsFactsheet.mapHabitatsRelations(otherClassifHabitat.getRelationType())%></td>
        </tr>
  <%
      }
      ii++;
    }
  if (otherHabitats.size() > 0)
  {
    ii++;
    for (int i = 0; i < otherHabitats.size(); i++)
    {
      HabitatFactsheetRelWrapper otherHab = (HabitatFactsheetRelWrapper)otherHabitats.get(i);
      String relation = otherHab.getRelation();
%>
      <tr bgcolor="<%=(0 == (ii++ % 2) ?  "#EEEEEE" : "#FFFFFF")%>">
        <td width="30%">&nbsp;</td>
        <td width="15%"><%=otherHab.getEunisCode()%></td>
<%
        if (!otherHab.getIdHabitat().equalsIgnoreCase("10000")) {
%>
          <td width="40%">
            <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=otherHab.getIdHabitat()%>"><%=otherHab.getScientificName()%></a>
            <%=cm.cmsTitle("open_habitat_factsheet")%>
          </td>
<%
        } else {
%>  
          <td width="40%"><%=otherHab.getScientificName()%></td>
<%
        }
%>
        <td width="15%">
<%
          if (otherHab.getLevel().intValue() < 3 && HabitatsFactsheet.isEunis( otherHab.getIdHabitat() ) )
          {
            int realLevel = otherHab.getLevel().intValue() + 1;
%>
            <a title="<%=cm.cms("go_to_key_navigator")%>" href="habitats-key.jsp?pageCode=<%=otherHab.getEunisCode()%>&amp;level=<%=realLevel%>"><img src="images/mini/key_out.png" alt="<%=cm.cms("go_to_key_navigator")%>" border="0" /></a>
            <%=cm.cmsTitle("go_to_key_navigator")%>
<%
          }
%>
        &nbsp;&nbsp;&nbsp;<%=relation%>
        </td>
      </tr>
<%
    }
  }
%>
    </table>
<%
  }
%>