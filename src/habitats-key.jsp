<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2004 European Environment Agency
  - Description : 'Habitats key navigation' function - display and navigate between questions and answers from habitat key navigation.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.key.Chm62edtHabitatKeyNavigationPersist,
                ro.finsiel.eunis.jrfTables.habitats.key.QuestionPersist,
                ro.finsiel.eunis.search.Utilities,
                ro.finsiel.eunis.search.habitats.key.KeyNavigation" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  // Request parameters
  // idQuestionLink
  // level - It defaults to level 1
  // pageCode - see KeyNavigation.findQuestionAnswers for details
  int level = Utilities.checkedStringToInt(request.getParameter("generic_index_07"), 1);
  String pageCode = request.getParameter("pageCode");
  KeyNavigation keyNavigator = new KeyNavigation();
  // List of questions.
  List questions = keyNavigator.findLevelQuestions(level, pageCode);
  String pageName = "habitats-key.jsp";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,habitat_type_key_navigation";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <%-- Note: Include these three files this order. --%>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.HabitatKeyBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_key_title")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  <!--
    function MM_jumpMenu(targ,selObj,restore){ //v3.0
      eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
      if (restore) selObj.selectedIndex=0;
    }
    function MM_openBrWindow(theURL,winName,features) { //v2.0
      window.open(theURL,winName,features);
    }
    function changeColor(nextTable, currentTable)
    {
      try
      {
        if( nextTable != null )
        {
          var tbl1 = document.getElementById(nextTable);
          tbl1.style.backgroundColor="#CCCCCC";
          tbl1.style.borderWidth="1";
        }
        if ( currentTable != null )
        {
          var tbl2 = document.getElementById(currentTable);
          tbl2.style.backgroundColor="#EEEEEE";
          tbl2.style.borderWidth="0";
        }
      }
      catch ( e ) {};
    }
  //-->
  </script>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_HEADER" ) )%>
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
                  <jsp:param name="helpLink" value="habitats-help.jsp" />
                </jsp:include>
                <a name="documentContent"></a>
                <div class="documentActions">
                  <h5 class="hiddenStructure">Document Actions</h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="Print this page"
                            title="Print this page" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="Toggle full screen mode"
                             title="Toggle full screen mode" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsText("habitat_type_key_navigation")%>
                </h1>
                <%=cm.cmsText("habitats_key_help_01")%>
                <ul>
                  <li>
                    <%=cm.cmsText("no")%> ( <img alt="<%=cm.cms("other_question")%>" src="images/mini/navigate.gif" /> <%=cm.cmsText("leading_to_002")%>
                    <%=cm.cmsTitle("other_question")%>
                  </li>
                  <li>
                    <%=cm.cmsText("yes")%> [ <img alt="<%=cm.cms("another_questions")%>" src="images/mini/navigate.gif" /> <%=cm.cmsText("leading_to_G")%>
                    <%=cm.cmsTitle("another_questions")%>
                  </li>
                  <li>
                    <%=cm.cmsText("no")%> <img alt="<%=cm.cms("another_sheet")%>" src="images/mini/sheet.gif" />[ <img alt="Go to factsheet" src="images/mini/navigate.gif" /> <%=cm.cmsText("leading_to_E6")%>
                    <%=cm.cmsTitle("another_sheet")%>
                  </li>
                </ul>
                <%=cm.cmsText("the_diagram_may_be_used_for_references")%>
                <br />
          <%
            if (questions.size() > 0)
            {
              QuestionPersist question = (QuestionPersist) questions.get(0);
          %>
                <br />
                <br />
                <strong>
                  <%=cm.cmsText("category_location")%> : (<%=(null == pageCode) ? cm.cmsText("all") : pageCode%> )<%=question.getPageName()%>
                </strong>
                <br />
                <strong>
                  <%=cm.cmsText("habitats_key_03")%> :
                </strong>
                <a href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=pageCode%>','','toolbar=yes,scrollbars=yes,resizable=yes,width=880,height=640')" title="Open diagram"><img alt="<%=cm.cms("show_habitat_diagram")%>" src="images/mini/diagram_out.png" width="20" height="20" border="0" style="vertical-align:middle" /></a>
                <%=cm.cmsTitle("show_habitat_diagram")%>
                <br />
                <br />
          <%
            }
            String idFirstQuestion = null;
            for (int i = 0; i < questions.size(); i++)
            {
              QuestionPersist question = (QuestionPersist) questions.get(i);
              if (i == 0)
              {
                idFirstQuestion = "DD" + question.getIDQuestion();
              }
          %>
                <%-- Define the name of the anchor to jump to --%>
                <a name="<%=question.getIDQuestion()%>"></a>
                <%-- Define the table for the question --%>
                <br />
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="3" id="DD<%=question.getIDQuestion()%>" style="background-color : #EEEEEE">
                  <tr>
                    <td>
                      <%=cm.cmsText("question")%>
                      <strong>
                        <%=keyNavigator.fixQuestionID(question.getIDQuestion())%>
                      </strong>
                      :
                      &nbsp;
                      <strong>
                        <%=question.getQuestionLabel()%>
                      </strong>
                      <br />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      &nbsp;&nbsp;
          <%
              String correctedExplanation = "";
              correctedExplanation = question.getQuestionExplanation();
              correctedExplanation = correctedExplanation.replaceAll("<I>","###strong###").replaceAll("</I>","###/strong###");
              correctedExplanation = correctedExplanation.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
              correctedExplanation = correctedExplanation.replaceAll("###strong###","<strong>").replaceAll("###/strong###","</strong>");
          %>
                      <%=correctedExplanation%>
                    </td>
                  </tr>
                  <tr>
                    <td bgcolor="#DDDDDD">
                      <%=cm.cmsText("answers")%>
          <%
              // List of question answers.
              List answers = keyNavigator.findQuestionAnswers(level, question.getIDQuestion(), question.getIDPage());
              if (answers.size() > 0)
              {
          %>
                <table summary="layout" width="100%" border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse; background-color : #DDDDDD;">
                <tr align="center">
          <%
                for (int j = 0; j < answers.size(); j++)
                {
                  Chm62edtHabitatKeyNavigationPersist answer = (Chm62edtHabitatKeyNavigationPersist) answers.get(j);
          %>
                          <td>
          <%
                  // If answer is another question.
                  if (keyNavigator.pointsToQuestion(answer))
                  {
                    String additionalInfo = keyNavigator.fixAdditionalInfo(answer.getAdditionalInfo());
          %>
                            <strong>
          <%
                    String correctedAnswer = "";
                    correctedAnswer = answer.getAnswerLabel();
                    correctedAnswer = correctedAnswer.replaceAll("<I>","###strong###").replaceAll("</I>","###/strong###");
                    correctedAnswer = correctedAnswer.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
                    correctedAnswer = correctedAnswer.replaceAll("###strong###","<strong>").replaceAll("###/strong###","</strong>");
          %>
                              <%=correctedAnswer%>
                            </strong>
                            <a title="<%=cm.cms("answer")%>" href="habitats-factsheet.jsp?idHabitat=<%=answer.getIDHabitatLink()%>"><img title="<%=cm.cms("answer")%>" alt="Answer" src="images/mini/sheet.gif" border="0" style="vertical-align:middle" /></a>
                            <%=cm.cmsTitle("answer")%>
          <%
                    if (level > 0 && level < 3)
                    {
                      String str = cm.cms("habitats_key_05");
          %>
                        <%--Ok, we are on the proper level, so we show the link to the next pagelevel (level + 1) --%>
                            [
                            <a href="<%=pageName+"?level=" + (level + 1) + "&amp;idQuestionLink=" + answer.getIDQuestionLink()%>&amp;pageCode=<%=additionalInfo%>"
                               title="<%=str%> <%=answer.getAdditionalInfo()%>"><img alt="<%=str%> <%=answer.getAdditionalInfo()%>" src="images/mini/navigate.gif" border="0" style="vertical-align:middle" /></a>
                            <%=answer.getAdditionalInfo()%>
                            ]
          <%
                    }
                    else
                    {
          %>
                            <%-- If level is greater than 3, then we don't show the link anymore since we don't have diagrams for that level. --%>
                            [ <%=additionalInfo%> ]
          <%
                    }
                  }
                  else
                  {
                    // If answer point to a habitat factsheet.
                    String str = cm.cms("habitats_key_06");
          %>
                            <strong>
          <%
                    String correctedAnswer = "";
                    correctedAnswer = answer.getAnswerLabel();
                    correctedAnswer = correctedAnswer.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;");
          %>
                              <%=correctedAnswer%>
                            </strong>
                            (<a onclick="javascript:changeColor('DD<%=answer.getIDQuestionLink()%>','DD<%=answer.getIDQuestion()%>');"
                              href="#<%=answer.getIDQuestionLink()%>"
                              title="<%=str%><%=keyNavigator.fixQuestionID(answer.getIDQuestionLink())%>"><img alt="<%=cm.cms("question")%>" src="images/mini/navigate.gif" border="0" style="vertical-align:middle" /></a>
                            <%=cm.cmsTitle("question")%>
                            <strong>
                              <%=keyNavigator.fixQuestionID(answer.getIDQuestionLink())%>
                            </strong>)
          <%
                  }
          %>
                          </td>
          <%
                }
          %>
                        </tr>
                      </table>
          <%
              }
          %>
                    </td>
                  </tr>
                </table>
                <br />
          <%
            }
            if (idFirstQuestion != null)
            {
          %>
              <script type="text/javascript" language="javascript">
              <!--
                changeColor( "<%=idFirstQuestion%>", null );
              //-->
              </script>
          <%
            }
          %>
          <%=cm.br()%>
          <%=cm.cmsMsg("habitats_key_title")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("habitats_key_05")%>
          <%=cm.br()%>
          <%=cm.cmsMsg("habitats_key_06")%>
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
                <jsp:param name="page_name" value="habitats-key.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <!-- start of right (by default at least) column -->
        <div id="portal-column-two">
          <div class="visualPadding">
            <jsp:include page="inc_column_right.jsp" />
          </div>
        </div>
        <!-- end of the right (by default at least) column -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <%=cm.readContentFromURL( request.getSession().getServletContext().getInitParameter( "TEMPLATES_FOOTER" ) )%>
    </div>
  </body>
</html>
