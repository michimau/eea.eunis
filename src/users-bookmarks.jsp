<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Users bookmarks' function - list, edit user's bookmarks.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.List,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement cm = SessionManager.getWebContent();

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  List bookmarks = sqlc.ExecuteSQLReturnList("SELECT BOOKMARK,DESCRIPTION FROM EUNIS_BOOKMARKS WHERE USERNAME = '" + SessionManager.getUsername() + "'", 2);
  int listSize = ( bookmarks == null ? 0 : bookmarks.size() );
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
        <%=application.getInitParameter("PAGE_TITLE")%>
        <%=cm.cms("users_bookmarks_title")%>
    </title>
    <script language="JavaScript" type="text/javascript">
    <!--
        function onClickEdit() {
           var listSize = <%=listSize%>;
           var isSomethinkChecked = false;
           var isTwoChecked = false;
           for (i=0;i<listSize;i++)
           {
               if(document.eunis.elements["bookmark_"+i].checked == true)
               {
                 if(isSomethinkChecked) {isTwoChecked = true;document.eunis.bookmarkNameHidden.value = '';break;}
                 isSomethinkChecked = true;
                 document.eunis.bookmarkNameHidden.value = document.eunis.elements["bookmarkName_"+i].value;
               }
           }

          if(!isSomethinkChecked) alert('<%=cm.cms("users_bookmarks_01")%>');
          else
          if(isTwoChecked) alert('<%=cm.cms("users_bookmarks_02")%>');
          else
          {
             document.eunis.typeAction.value = 'edit';
             document.eunis.submit();
          }

        }

        function onClickEditSave() {
          document.eunis.typeAction.value = 'editSave';
             document.eunis.submit();
        }

          function onClickDelete() {

          var listSize = <%=listSize%>;
          var isSomethinkChecked = false;

          for (i=0;i<listSize;i++)
           {
               if(document.eunis.elements["bookmark_"+i].checked == true)
               {
                 isSomethinkChecked = true;
                 document.eunis.elements["bookmark_"+i].value = true;
               } else
               document.eunis.elements["bookmark_"+i].value = false;
           }


          if(!isSomethinkChecked) alert('<%=cm.cms("users_bookmarks_01")%>');
          else
          {
            document.eunis.typeAction.value = 'delete';
            document.eunis.submit();
          }
        }
      //-->

   </script>
  </head>
<%
  String breadcrumbtrail = "home_location#index.jsp,services_location#services.jsp,user_bookmarks_location";
  String typeAction = Utilities.formatString(request.getParameter( "typeAction" ), "" );
  if ( typeAction.equalsIgnoreCase( "edit" ) || typeAction.equalsIgnoreCase( "editSave" ) )
  {
    breadcrumbtrail = "home_location#index.jsp,services_location#services.jsp,user_bookmarks_location#users-bookmarks.jsp,user_bookmarks_location_edit";
  }
  if ( typeAction.equalsIgnoreCase( "delete" ) )
  {
    breadcrumbtrail = "home_location#index.jsp,services_location#services.jsp,user_bookmarks_location#users-bookmarks.jsp,user_bookmarks_location_delete";
  }
%>
  <body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="<%=breadcrumbtrail%>"/>
    </jsp:include>
<%
  if(SessionManager.isAuthenticated())
  {
%>
    <h1><%=cm.cmsText("users_bookmarks_03")%></h1>
    <form name="eunis" method="post" action="users-bookmarks.jsp">
      <input type ="hidden" name="typeAction" value="<%=request.getParameter("typeAction")%>" />
      <input type ="hidden" name="bookmarkNameHidden" value="<%=request.getParameter("bookmarkNameHidden")%>" />
      <br />
      <br />
<%
    if( typeAction.equalsIgnoreCase( "edit" ) )
    {
      String bookm = (request.getParameter("bookmarkNameHidden") == null ? "" : request.getParameter("bookmarkNameHidden"));
      bookm = bookm.replaceAll("'","''");
      List bookmarksEdit = sqlc.ExecuteSQLReturnList("SELECT BOOKMARK,DESCRIPTION FROM EUNIS_BOOKMARKS WHERE USERNAME = '" + SessionManager.getUsername() + "' and BOOKMARK='"+bookm+"'", 2);
      if( bookmarksEdit != null && bookmarksEdit.size() > 0 )
      {
        String bookmName = (String)((TableColumns)bookmarksEdit.get(0)).getColumnsValues().get(0);
        String bookmDescription = (String)((TableColumns)bookmarksEdit.get(0)).getColumnsValues().get(1);
%>
        <strong class="fontNormal">
          <%=cm.cmsText("users_bookmarks_04")%>
        </strong>
        <br />
        <br />
        <label for="bookmarkNameEdit">
        <%=cm.cmsText("users_bookmarks_05")%>:
        </label>
        <br />
        <textarea id="bookmarkNameEdit" title="<%=cm.cms("users_bookmarks_05")%>" name="bookmarkNameEdit" rows="3" cols="100" class="inputTextField"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmName),"&nbsp;")%></textarea>
        <%=cm.cmsTitle("users_bookmarks_05")%>
        <br />
        <br />
        <label for="bookmarkDescrptionEdit">
        <%=cm.cmsText("users_bookmarks_06")%>:
        </label>
        <br />
        <textarea id="bookmarkDescrptionEdit" title="<%=cm.cms("users_bookmarks_06")%>" name="bookmarkDescrptionEdit" rows="3" cols="100" class="inputTextField"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmDescription),"&nbsp;")%></textarea>
        <%=cm.cmsTitle("users_bookmarks_06")%>
        <br />
        <label for="input1" class="noshow"><%=cm.cms("save")%></label>
        <input id="input1" type="button" value="<%=cm.cms("save_btn")%>" name="save" onclick="onClickEditSave()" class="inputTextField" title="<%=cm.cms("save")%>" />
        <%=cm.cmsLabel("save")%>
        <%=cm.cmsTitle("save")%>
        <%=cm.cmsInput("save_btn")%>
<%
      }
      else
      {
%>
        <%=cm.cmsText("users_bookmarks_07")%>
<%
      }
    }
    else if(typeAction.equalsIgnoreCase("editSave"))
    {
      String bookmOld = (request.getParameter("bookmarkNameHidden") == null ? "" : request.getParameter("bookmarkNameHidden"));
      String bookmNew = (request.getParameter("bookmarkNameEdit") == null ? "" : request.getParameter("bookmarkNameEdit"));
      String bookmDescr = (request.getParameter("bookmarkDescrptionEdit") == null ? "" : request.getParameter("bookmarkDescrptionEdit"));
      boolean editOk1 = sqlc.ExecuteUpdate("eunis_bookmarks", "DESCRIPTION", bookmDescr.replaceAll("'","''"), " USERNAME = '" + SessionManager.getUsername() + "' and BOOKMARK='"+bookmOld.replaceAll("'","''")+"'");
      boolean editOk2 = sqlc.ExecuteUpdate("eunis_bookmarks", "BOOKMARK", bookmNew.replaceAll("'","''"), " USERNAME = '" + SessionManager.getUsername() + "' and BOOKMARK='"+bookmOld.replaceAll("'","''")+"'");
      if(editOk1 && editOk2)
      {
 %>
        <br />
        <br />
        <%=cm.cmsText("users_bookmarks_08")%> <a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsText("users_bookmarks_10")%></a>
        <%=cm.cmsTitle("users_bookmarks_09")%>
<%
      }
      else
      {
%>
        <br />
        <br />
        <%=cm.cmsText("users_bookmarks_11")%> <a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsText("users_bookmarks_10")%></a>
        <%=cm.cmsTitle("users_bookmarks_09")%>
<%
      }
    }
    else if(typeAction.equalsIgnoreCase("delete"))
    {
      String whereCondition = " USERNAME = '" + SessionManager.getUsername() + "'";
      String whereCondition1 = "";
      for (int i=0;i<listSize;i++)
      {
        if(request.getParameter("bookmark_"+i) != null && request.getParameter("bookmark_"+i).equalsIgnoreCase("true"))
          if (request.getParameter("bookmarkName_"+i) != null )
           whereCondition1 += (whereCondition1.trim().length()<=0 ? " AND (" : " OR ") + " BOOKMARK = '" + request.getParameter("bookmarkName_"+i).replaceAll("'","''")  + "' ";
      }
      boolean deleteOk = sqlc.ExecuteDelete("eunis_bookmarks", whereCondition + whereCondition1 + (whereCondition1.trim().length()<=0 ? "" : ")"));
      if(deleteOk)
      {
 %>
        <br />
        <strong class="fontNormal"><%=cm.cmsText("users_bookmarks_12")%></strong>
        <br />
        <br />
        <%=cm.cmsText("users_bookmarks_13")%> <a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsText("users_bookmarks_10")%></a>
        <%=cm.cmsTitle("users_bookmarks_13")%>
<%
      }
      else
      {
%>
        <br />
        <strong class="fontNormal"><%=cm.cmsText("users_bookmarks_12")%></strong>
        <br />
        <br />
        <%=cm.cmsText("users_bookmarks_14")%> <a title="<%=cm.cms("users_bookmarks_15")%>" href="users-bookmarks.jsp"><%=cm.cmsText("users_bookmarks_15")%></a>
        <%=cm.cmsTitle("users_bookmarks_15")%>
<%
      }
    }
    else
    {
      if( bookmarks != null && bookmarks.size() > 0 )
      {
%>
      <table summary="<%=cm.cms("users_bookmarks_15")%>" width="100%" border="1" cellspacing="0" cellpadding="0" style="border-collapse : collapse">
        <tr style="background-color:#DDDDDD">
          <td style="text-align:center">
            Sel.
          </td>
          <td>
            <%=cm.cmsText("users_bookmarks_16")%>
          </td>
          <td>
            <%=cm.cmsText("users_bookmarks_17")%>
          </td>
        </tr>
<%
        for (int i=0;i<bookmarks.size();i++)
        {
          String bgColor = (0 == (i % 2)) ? "#EEEEEE" : "#FFFFFF";
          TableColumns  bookmark = (TableColumns)bookmarks.get(i);
%>
        <tr>
          <td style="text-align:center;background-color:<%=bgColor%>">
            <input type ="hidden" name="bookmarkName_<%=i%>" value="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>" />
            <label for="bookmark_<%=i%>" class="noshow"><%=cm.cms("users_bookmarks_18")%></label>
            <input title="<%=cm.cms("users_bookmarks_18")%>" id="bookmark_<%=i%>" alt="<%=cm.cms("users_bookmarks_18")%>" value="true" type="checkbox" name="bookmark_<%=i%>" />
            <%=cm.cmsLabel("users_bookmarks_18")%>
            <%=cm.cmsTitle("users_bookmarks_18")%>
          </td>
          <td style="text-align:left;background-color:<%=bgColor%>">
<%
          String bookm = (String)bookmark.getColumnsValues().get(0);
          boolean withTooltip = (bookm == null || bookm.trim().length() <=0 ? false : (bookm.indexOf("?") >= 0 ? true : (bookm.length() < 50 ? false : true)));
          bookm = (bookm == null || bookm.trim().length() <=0 ? "" : (bookm.indexOf("?") >= 0 ? bookm.substring(0,bookm.indexOf("?")) + " ... ": (bookm.length() < 50 ? bookm : bookm.substring(0,50) + " ... ")));
          String msg = (bookmark.getColumnsValues().get(0) == null ? null : ((String)bookmark.getColumnsValues().get(0)).replaceAll("'"," ").replaceAll("\""," "));
          // eliminate all line terminators
          msg = msg.replaceAll("\\r\\n"," ");
          msg = msg.replaceAll("\\n"," ");
          msg = msg.replaceAll("\\r"," ");
          msg = msg.replaceAll("\\u0085"," ");
          msg = msg.replaceAll("\\u2028"," ");
          msg = msg.replaceAll("\\u2029"," ");
          if( withTooltip )
          {
%>
            <span title="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>">
              <a href="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookm),"&nbsp;")%></a>
            </span>
<%
          }
          else
          {
%>
            <span>
              <a title="<%=cm.cms("users_bookmarks_16")%>" href="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookm),"&nbsp;")%></a>
              <%=cm.cmsTitle("users_bookmarks_16")%>
            </span>
<%
          }
%>
          </td>
          <td style="text-align:left;background-color:<%=bgColor%>">
<%
          String descr = (String)bookmark.getColumnsValues().get(1);
          withTooltip = (descr == null || descr.trim().length() <=0 ? false : (descr.length() < 50 ? false : true));
          descr = (descr == null || descr.trim().length() <=0 ? "" : (descr.length() < 50 ? descr : descr.substring(0,50) + " ... "));
          msg = (bookmark.getColumnsValues().get(1) == null ? null : ((String)bookmark.getColumnsValues().get(1)).replaceAll("'"," ").replaceAll("\""," "));
          //System.out.println("msg =>>" + msg + "<<");
          // eliminate all line terminators
          msg = msg.replaceAll("\\r\\n"," ");
          msg = msg.replaceAll("\\n"," ");
          msg = msg.replaceAll("\\r"," ");
          msg = msg.replaceAll("\\u0085"," ");
          msg = msg.replaceAll("\\u2028"," ");
          msg = msg.replaceAll("\\u2029"," ");
          if(withTooltip)
          {
%>
            <span title="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(1))%>">
              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(descr),"&nbsp;")%>
            </span>
<%
          }
          else
          {
%>
            <span>
              <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(descr),"&nbsp;")%>
            </span>
<%
          }
%>
          </td>
        </tr>
<%
        }
%>
      </table>
      <br />
      <label for="input2" class="noshow"><%=cm.cms("edit")%></label>
      <input id="input2" type="button" value="<%=cm.cms("edit_btn")%>" name="edit" onclick="onClickEdit()" class="inputTextField" title="<%=cm.cms("edit")%>" />
      <%=cm.cmsLabel("edit")%>
      <%=cm.cmsTitle("edit")%>
      <%=cm.cmsInput("edit_btn")%>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label for="input3" class="noshow"><%=cm.cms("delete")%></label>
      <input id="input3" type="button" value="<%=cm.cms("delete_btn")%>" name="delete" onclick="onClickDelete()" class="inputTextField" title="<%=cm.cms("delete")%>" />
      <%=cm.cmsLabel("delete")%>
      <%=cm.cmsTitle("delete")%>
      <%=cm.cmsInput("delete_btn")%>
<%
      }
      else
      {
%>
       <span style="color:red"><%=cm.cmsText("users_bookmarks_19")%></span>
<%
      }
    }
%>
    </form>
<%
  }
  else
  {
%>
    <span style="color : red"><%=cm.cmsText("users_bookmarks_20")%></span>
<%
  }
%>
    <br />

<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_01")%>
<%=cm.br()%>
<%=cm.cmsMsg("users_bookmarks_02")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="users-bookmarks.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>