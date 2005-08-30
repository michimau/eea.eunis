<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats general information' function - display links to all habitat searches.
--%>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
  <table summary="layout" width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse;">
    <tr bgcolor="#CCCCCC" valign="middle">
      <td width="15%" align="left">
        <%=contentManagement.getContent("habitats_factsheet_04")%>
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
    <a title="Open key navigation page" href="habitats-key.jsp?pageCode=<%=factsheet.getEunisHabitatCode()%>&amp;level=<%=realLevel%>"><img alt="Key navigation" src="images/mini/key_in.png" width="20" height="20" title="<%=contentManagement.getContent("habitats_factsheet_80", false )%>" border="0" /></a>
    &nbsp;&nbsp;
<%
  }
  if (factsheet.isEunis())
  {
    if (factsheet.getHabitatLevel() != null && factsheet.getHabitatLevel().intValue() > 1)
    {
%>
      <a title="Open code browser" href="habitats-code-browser.jsp?Code=<%=factsheet.getEunisHabitatCode()%>&amp;habID=<%=factsheet.getIdHabitat()%>&amp;fromFactsheet=yes"><img alt="Tree navigation" src="images/mini/tree.gif" width="20" height="20" border="0" title="<%=contentManagement.getContent("habitats_factsheet_06", false )%>" /></a>
      &nbsp;&nbsp;
<%
    }
    if (factsheet.getHabitatLevel() != null && factsheet.getHabitatLevel().intValue() == 1)
    {
%>
      <a title="Tree navigation" href="habitats-code-browser.jsp"><img alt="Tree navigation" src="images/mini/tree.gif" width="20" height="20" border="0" title="<%=contentManagement.getContent("habitats_factsheet_06", false )%>" /></a>
      &nbsp;&nbsp;
<%
    }
%>
      <a title="Open diagram" href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=factsheet.getEunisHabitatCode()%>','','toolbar=yes,scrollbars=yes,resizable=yes')"><img alt="Diagram" src="images/mini/diagram_out.png" title="<%=contentManagement.getContent("habitats_factsheet_07", false )%>" width="20" height="20" border="0" /></a>
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
        <%=contentManagement.getContent("habitats_factsheet_10")%>
      </td>
      <td width="40%">
        &nbsp;
        <strong>
          <%=Utilities.formatString(factsheet.getEunisHabitatCode(), "")%>
        </strong>
      </td>
      <td width="15%" bgcolor="#DDDDDD" align="right">
        <%=contentManagement.getContent("habitats_factsheet_11")%>
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
        <%=contentManagement.getContent("habitats_factsheet_12")%>
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
        <%=contentManagement.getContent("habitats_factsheet_13")%>
      </td>
      <td>
        <strong>
          &nbsp;
          <%=(factsheet.isAnnexI() ? Utilities.formatString(factsheet.getHabitat().getCodeAnnex1()) : Utilities.formatString(factsheet.getHabitat().getOriginallyPublishedCode()))%>
        </strong>
      </td>
      <td bgcolor="#DDDDDD" align="right">
        <%=contentManagement.getContent("habitats_factsheet_14")%>
        &nbsp;
      </td>
      <td bgcolor="#DDDDDD">
        <strong>
          &nbsp;
          <%=(factsheet.getPriority() != null && 1 == factsheet.getPriority().shortValue() ? contentManagement.getContent("habitats_factsheet_81") :  contentManagement.getContent("habitats_factsheet_82"))%>
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
          <%=contentManagement.getContent("habitats_factsheet_15")%>
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
          <%=contentManagement.getContent("habitats_factsheet_16")%>
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
                <%=contentManagement.getContent("habitats_factsheet_17")%>:
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
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;">Name in other languages</div>
    <table summary="Name in other languages" border="0" width="100%" cellspacing="0" cellpadding="0" style="border-collapse : collapse">
      <tr bgcolor="#DDDDDD">
        <th class="resultHeader">
          <strong>
            <%=contentManagement.getContent("habitats_factsheet-intern_02")%>
          </strong>
        </th>
        <th class="resultHeader">
          <strong>
            <%=contentManagement.getContent("habitats_factsheet-intern_03")%>
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
    <div style="width : 740px; background-color : #CCCCCC; font-weight : bold;"><%=contentManagement.getContent("habitats_factsheet_22")%></div>
    <table width="100%" border="0" summary="Relation with other classifications" cellspacing="0" cellpadding="0" style="border-collapse: collapse;" id="relations">
      <tr bgcolor="#DDDDDD">
        <th class="resultHeader" width="30%">
          <a title="Sort by this column" href="javascript:sortTable(4, 0, 'relations', false);"><strong><%=contentManagement.getContent("habitats_factsheet_23")%></strong></a>
        </th>
        <th class="resultHeader" width="15%">
          <a title="Sort by this column" href="javascript:sortTable(4, 1, 'relations', false);"><strong><%=contentManagement.getContent("habitats_factsheet_24")%></strong></a>
        </th>
        <th class="resultHeader" width="40%">
          <a title="Sort by this column" href="javascript:sortTable(4, 2, 'relations', false);"><strong><%=contentManagement.getContent("habitats_factsheet_25")%></strong></a>
        </th>
        <th class="resultHeader" width="15%">
          <a title="Sort by this column" href="javascript:sortTable(4, 3, 'relations', false);"><strong><%=contentManagement.getContent("habitats_factsheet_26")%></strong></a>
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
        <td width="15%" align="left"><%=otherHab.getEunisCode()%></td>
<%
        if (!otherHab.getIdHabitat().equalsIgnoreCase("10000")) {
%>
        <td width="40%"><a title="Open habitat type factsheet" href="habitats-factsheet.jsp?idHabitat=<%=otherHab.getIdHabitat()%>"><%=otherHab.getScientificName()%></a></td>
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
            <a href="habitats-key.jsp?pageCode=<%=otherHab.getEunisCode()%>&amp;level=<%=realLevel%>"><img src="images/mini/key_out.png" alt="Go to key navigator, starting with this habitat." border="0" /></a>
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