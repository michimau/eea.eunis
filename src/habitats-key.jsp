<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2004 European Environment Agency
  - Description : 'Habitats key navigation' function - display and navigate between questions and answers from habitat key navigation.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html" %>
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
  WebContentManagement contentManagement = SessionManager.getWebContent();
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <%-- Note: Include these three files this order. --%>
    <jsp:include page="header-page.jsp" />
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.HabitatKeyBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=contentManagement.getContent("habitats_key_title", false)%>
  </title>
  <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
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
          tbl1.style.backgroundColor="#AAAAAA";
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
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="Home#index.jsp,Habitat types#habitats.jsp,Habitat types key navigation" />
        <jsp:param name="helpLink" value="habitats-help.jsp" />
      </jsp:include>
      <h5>
        <%=contentManagement.getContent("habitats_key_01")%>
      </h5>
      You may use 'key navigation' function to identify a specific habitat by answering a set of questions. Starting from
      first question to next questions you select one of the possible answers. Here are samples of possible answers:
      <ul>
        <li>
          No ( <img alt="Leading to other question" src="images/mini/navigate.gif" /> 002 ) - Leading to question named '002'
        </li>
        <li>
          Yes [ <img alt="Leading to another questions subset" src="images/mini/navigate.gif" /> G ] - Leading to another questions subset of level G
        </li>
        <li>
          No <img alt="Leading to another sheet" src="images/mini/sheet.gif" />[ <img alt="Go to factsheet" src="images/mini/navigate.gif" /> E6 ] - Links directly to factsheet for E6
        </li>
      </ul>
      Additionally the diagram may be used for reference.
      <br />
<%
  if (questions.size() > 0)
  {
    QuestionPersist question = (QuestionPersist) questions.get(0);
%>
      <br />
      <br />
      <strong>
        <%=contentManagement.getContent("habitats_key_02")%> : (<%=(null == pageCode) ? "All" : pageCode%> )<%=question.getPageName()%>
      </strong>
      <br />
      <strong>
        <%=contentManagement.getContent("habitats_key_03")%> :
      </strong>
      <a href="javascript:openDiagram('habitats-diagram.jsp?habCode=<%=pageCode%>','','toolbar=yes,scrollbars=yes,resizable=yes,width=880,height=640')" title="Open diagram"><img alt="Show habitat type diagram in a new window" src="images/mini/diagram_out.png" width="20" height="20" border="0" align="middle" /></a>
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
            <%=contentManagement.getContent("habitats_key_04")%>
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
            Answers:
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
                  <a title="Answer" href="habitats-factsheet.jsp?idHabitat=<%=answer.getIDHabitatLink()%>"><img title="Answer" alt="Answer" src="images/mini/sheet.gif" border="0" align="middle" /></a>
<%
          if (level > 0 && level < 3)
          {
            String str = contentManagement.getContent("habitats_key_05", false);
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
          String str = contentManagement.getContent("habitats_key_06", false);
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
                    title="<%=str%><%=keyNavigator.fixQuestionID(answer.getIDQuestionLink())%>"><img alt="Question" src="images/mini/navigate.gif" border="0" align="middle" /></a>
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
    <noscript>
      Your browser does not support JavaScript!
    </noscript>
<%
  }
%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-key.jsp" />
</jsp:include>
    </div>
  </body>
</html>