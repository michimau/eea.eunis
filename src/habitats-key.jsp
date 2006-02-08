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
  int level = Utilities.checkedStringToInt(request.getParameter("level"), 1);
  String pageCode = request.getParameter("pageCode");
  KeyNavigation keyNavigator = new KeyNavigation();
  // List of questions.
  List questions = keyNavigator.findLevelQuestions(level, pageCode);
  String pageName = "habitats-key.jsp";
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
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_key_navigation_location" />
        <jsp:param name="helpLink" value="habitats-help.jsp" />
      </jsp:include>
      <h1>
        <%=cm.cmsText("habitats_key_01")%>
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
        <%=cm.cmsText("habitats_key_02")%> : (<%=(null == pageCode) ? cm.cmsText("all") : pageCode%> )<%=question.getPageName()%>
      </strong>
      <br />
      <strong>
        <%=cm.cmsText("habitats_key_03")%> :
      </strong>
      <a href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=pageCode%>','','toolbar=yes,scrollbars=yes,resizable=yes,width=880,height=640')" title="Open diagram"><img alt="<%=cm.cms("show_habitat_diagram")%>" src="images/mini/diagram_out.png" width="20" height="20" border="0" align="middle" /></a>
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
            <%=cm.cmsText("habitats_key_04")%>
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
                  <a title="<%=cm.cms("answer")%>" href="habitats-factsheet.jsp?idHabitat=<%=answer.getIDHabitatLink()%>"><img title="<%=cm.cms("answer")%>" alt="Answer" src="images/mini/sheet.gif" border="0" align="middle" /></a>
                  <%=cm.cmsTitle("answer")%>
<%
          if (level > 0 && level < 3)
          {
            String str = cm.cms("habitats_key_05");
%>
              <%--Ok, we are on the proper level, so we show the link to the next pagelevel (level + 1) --%>
                  [
                  <a href="<%=pageName+"?level=" + (level + 1) + "&amp;idQuestionLink=" + answer.getIDQuestionLink()%>&amp;pageCode=<%=additionalInfo%>"
                     title="<%=str%> <%=answer.getAdditionalInfo()%>"><img alt="<%=str%> <%=answer.getAdditionalInfo()%>" src="images/mini/navigate.gif" border="0" align="middle" /></a>
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
                    title="<%=str%><%=keyNavigator.fixQuestionID(answer.getIDQuestionLink())%>"><img alt="<%=cm.cms("question")%>" src="images/mini/navigate.gif" border="0" align="middle" /></a>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-key.jsp" />
</jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>