<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Fuzzy search help
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html"%>
<%@page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    // Web content manager used in this page.
    WebContentManagement contentManagement = SessionManager.getWebContent();
  %>
  <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("sites_help_title", false )%></title>
</head>
<body>
  <div id="content">
  <jsp:include page="header-dynamic.jsp">
    <jsp:param name="location" value="Home#index.jsp, Help on fuzzy search"/>
    <jsp:param name="mapLink" value="show"/>
  </jsp:include>
  <%
    /*
    String paragraph01 = contentManagement.getContent("sites_help_01");
    if (null != paragraph01) out.print(paragraph01);
    */
  %>
  <h5>Help on fuzzy search</h5>
  <br />
  <a href="javascript:history.go(-1);" title="Return to previous page">Back</a>
  <br />
  <br />
  <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td>
      <strong>Overview of the fuzzy search algorithm used in quick search by name functions</strong>
      <br />
      <br />
      Terms that are often misspelled can be a problem for the users of the application.
      Names, for example, are variable length, can have strange spellings, and they are not unique.
      Words can be misspelled or have multiple spellings, especially across different cultures or national sources.

      <br />
      To solve this problem, we need phonetic algorithms which can find similar sounding terms and names. Just such a family of algorithms exist and are called
      <strong>SoundExes</strong>, after the first patented version.

      A Soundex search algorithm takes a word, such as a person's name, as input and produces a character string which identifies a set of words that are (roughly) phonetically alike. It is very handy for searching large databases when the user has incomplete data.

      <br />
      The original Soundex algorithm was patented by Margaret O'Dell and Robert C. Russell in 1918. The method is based on the six phonetic classifications of human speech sounds (bilabial, labiodental,
      dental, alveolar, velar, and glottal), which in turn are based on where you put
      your lips and tongue to make the sounds. The algorithm is fairly straight
      forward to code and requires no backtracking or multiple passes over the input
      word.<strong><br />
      <br />
      The Algorithm</strong>
      <br />
      <br />
      1. Capitalize all letters in the word and drop all punctuation marks. Pad the word with rightmost blanks as needed during each procedure step.
      <br />
      2. Retain the first letter of the word.
      <br />
      3. Change all occurrence of the following letters to '0' (zero):<br />
        'A', E', 'I', 'O', 'U', 'H', 'W', 'Y'.
      <br />
      4. Change letters from the following sets into the digit given:<br />
        1 = 'B', 'F', 'P', 'V'
        2 = 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z'
        3 = 'D','T'
        4 = 'L'
        5 = 'M','N'
        6 = 'R'
      <br />
      5. Remove all pairs of digits which occur beside each other from the string that resulted after step (4).
      <br />
      6. Remove all zeros from the string that results from step 5.0 (placed there in step 3)
      <br />
      7. Pad the string that resulted from step (6) with trailing zeros and return only the first four positions, which will be of the form [uppercase letter] [digit] [digit] [digit].
      <p><strong>EUNIS Database approach</strong>
      <br />
      <br />
      In EUNIS Database application we implemented a variation of the Soundex algorithm for the '<strong>Quick
      search by name</strong>' feature. It is based on the implementation of the SOUNDEX
      function in MySQL and a custom developed function which takes a step-by-step
      intelligent approach in matching the string(s) used in search with a database of
      pre-validated terms. If the initial query does not return any results., EUNIS Database
      will try to to find 'similar' terms in the database and, as Google does, will
      suggest the one that is closest, using the SOUNDEX variation implemented by the EUNIS team.</p>
    </td>
  </tr>
 </table>
  <br />
  <a href="javascript:history.go(-1);" title="Return to previous page">Back</a>
  <br />
  <jsp:include page="footer.jsp">
    <jsp:param name="page_name" value="sites-help.jsp" />
  </jsp:include>
    </div>
  </body>
</html>
