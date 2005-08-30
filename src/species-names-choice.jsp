<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup for list of values on second form from 'Species names' function.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page import="java.util.List, java.util.Iterator,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                ro.finsiel.eunis.search.species.names.NameSearchCriteria,
                net.sf.jrf.domain.PersistentObject,
                ro.finsiel.eunis.jrfTables.*,
                ro.finsiel.eunis.jrfTables.species.VernacularNamesPersist,
                ro.finsiel.eunis.WebContentManagement"%><%@ page import="java.util.ArrayList"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.names.NameBean" scope="page">
    <jsp:setProperty name="formBean" property="*"/>
</jsp:useBean>
  <head>
    <jsp:include page="header-page.jsp" />
    <%
      WebContentManagement contentManagement = SessionManager.getWebContent();
      Integer typeForm = Utilities.checkedStringToInt(formBean.getTypeForm(), NameSearchCriteria.CRITERIA_SCIENTIFIC);
    %>
    <title>
      <%=contentManagement.getContent("species_names-choice_pageTitle", false )%>
    </title>
      <script language="JavaScript" type="text/javascript">
      <!--
           function setLine(val) {
          <%if (typeForm.intValue() == SpeciesSearchUtility.CRITERIA_SCIENTIFIC_NAME.intValue()) {%>window.opener.document.eunis1.scientificName.value=val;<%}%>
          <%if (typeForm.intValue() == SpeciesSearchUtility.CRITERIA_VERNACULAR_NAME.intValue()) {%>window.opener.document.eunis2.vernacularName.value=val;<%}%>
              window.close();
           }
           function editContent( idPage )
           {
             var url = 'web-content-inline-editor.jsp?idPage=' + idPage;
             window.open( url ,'', 'width=540,height=500,status=0,scrollbars=0,toolbar=0,resizable=1,location=0');
           }
      // -->
      </script>
  </head>
  <%// Get form parameters here%>
<%
  boolean expandFullNames = Utilities.checkedStringToBoolean(request.getParameter("showAll"), false);
  Integer oper = Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS);
  boolean showNonValidatedSpecies = SessionManager.getShowEUNISInvalidatedSpecies();
  // List of species vernacular names
  List species = SpeciesSearchUtility.findSpeciesWithCriteria(SpeciesSearchUtility.CRITERIA_VERNACULAR_NAME,
                                                          formBean.getVernacularName(),
                                                          oper,
                                                          formBean.getLanguage(),
                                                          showNonValidatedSpecies,
                                                          expandFullNames);
  if ( species == null ) species = new ArrayList();
%>
  <body style="background-color:#FFFFFF">
<%
  if ( species.size() > 0 )
  {
    out.print(Utilities.getTextMaxLimitForPopup( contentManagement,( species.size() ) ) );
  }
  if ( species.isEmpty() )
  {
%>
          <strong>
            <%=contentManagement.getContent("species_names-choice_notResults")%>.
          </strong>
          <br />
<%
  }
  else
  {
%>    <h6>List of values for:</h6>
      <u>
        <%=contentManagement.getContent("species_names-choice_criteria")%>
      </u>
      <em><%=Utilities.ReturnStringRelatioOp(oper)%></em>
      <strong><%=formBean.getVernacularName()%></strong>
      <br />
      <br />
      <div id="tab">
      <table summary="List of values" border="1" cellpadding="2" cellspacing="0" style="border-collapse: collapse" width="100%">
<%
    Iterator it = species.iterator();
    int i = 0;
    int cnt = 0;
    // Display results.
    while (it.hasNext())
    {  cnt ++;
      String bgColor = (0 == (i++ % 2)) ? "#EEEEEE" : "#FFFFFF";
      if (0 == typeForm.compareTo(SpeciesSearchUtility.CRITERIA_VERNACULAR_NAME))
      {
        PersistentObject specie = (PersistentObject)it.next();
        if (null == formBean.getLanguage() || (null != formBean.getLanguage() && formBean.getLanguage().equalsIgnoreCase("any")))
        {
%>
              <tr style="background-color:<%=bgColor%>">
                <td>
                  <a title="Choose this value" href="javascript:setLine('<%=((Chm62edtReportAttributesPersist)specie).getValue()%>');"><%=((Chm62edtReportAttributesPersist)specie).getValue()%></a>
                </td>
              </tr>
<%
        }
        else
        {
%>
              <tr style="background-color:<%=bgColor%>">
                  <td>
                      <a title="Choose this value" href="javascript:setLine('<%=((VernacularNamesPersist)specie).getValue()%>');"><%=((VernacularNamesPersist)specie).getValue()%></a>
                  </td>
              </tr>
<%
        }
      }
    }
%>
      </table>
      </div>
<%
      out.print(Utilities.getTextWarningForPopup(cnt));
  }
%>
    <br />
    <form action="">
       <label for="button" class="noshow"><%=contentManagement.getContent("species_names-choice_btnClose", false)%></label> 
       <input title="Close window" id="button" type="button" value="<%=contentManagement.getContent("species_names-choice_btnClose", false)%>" onclick="javascript:window.close()" name="button" class="inputTextField" />
    </form>
  </body>
</html>