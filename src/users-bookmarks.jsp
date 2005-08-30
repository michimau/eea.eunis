<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Users bookmarks' function - list, edit user's bookmarks.
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.List,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<%@page contentType="text/html"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  // Web content manager used in this page.
  WebContentManagement contentManagement = SessionManager.getWebContent();

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
    <script language="JavaScript" src="script/utils.js" type="text/javascript"></script>
    <title><%=application.getInitParameter("PAGE_TITLE")%><%=contentManagement.getContent("users_bookmarks_title", false )%></title>
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

          if(!isSomethinkChecked) alert('Please select a bookmark.');
          else
          if(isTwoChecked) alert('Warning! Please select only one bookmark for edit.');
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


          if(!isSomethinkChecked) alert('Please select a bookmark.');
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
  String breadcrumbtrail = "Home#index.jsp,Services#services.jsp,User Bookmarks";
  String typeAction = Utilities.formatString(request.getParameter( "typeAction" ), "" );
  if ( typeAction.equalsIgnoreCase( "edit" ) || typeAction.equalsIgnoreCase( "editSave" ) )
  {
    breadcrumbtrail = "Home#index.jsp,Services#services.jsp,User Bookmarks#users-bookmarks.jsp,Edit bookmark";
  }
  if ( typeAction.equalsIgnoreCase( "delete" ) )
  {
    breadcrumbtrail = "Home#index.jsp,Services#services.jsp,User Bookmarks#users-bookmarks.jsp,Delete bookmark";
  }
%>
  <body style="background-color:#ffffff">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="<%=breadcrumbtrail%>"/>
    </jsp:include>
<%
  if(SessionManager.isAuthenticated())
  {
%>
    <h5>EUNIS Database User Bookmarks</h5>
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
          Edit bookmark
        </strong>
        <br />
        <br />
        <label for="bookmarkNameEdit">
        Bookmark name:
        </label>
        <br />
        <textarea id="bookmarkNameEdit" title="Bookmark name" name="bookmarkNameEdit" rows="3" cols="100" class="inputTextField"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmName),"&nbsp;")%></textarea>
        <br />
        <br />
        <label for="bookmarkDescrptionEdit">
        Bookmark description:
        </label>
        <br />
        <textarea id="bookmarkDescrptionEdit" title="Bookmark description" name="bookmarkDescrptionEdit" rows="3" cols="100" class="inputTextField"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmDescription),"&nbsp;")%></textarea>
        <br />
        <label for="input1" class="noshow">Save</label>
        <input id="input1" type="button" value="Save" name="save" onclick="onClickEditSave()" class="inputTextField" title="Save this bookmark" />
<%
      }
      else
      {
%>
        This bookmark does not exist.
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
        Bookmark has been successfully updated. <a title="Go back" href="users-bookmarks.jsp">Back</a>
<%
      }
      else
      {
%>
        <br />
        <br />
        An error occurred while updating the bookmark. <a title="Go back" href="users-bookmarks.jsp">Back</a>
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
        <strong class="fontNormal">Delete bookmark</strong>
        <br />
        <br />
        Bookmark has been successfully deleted. <a title="Go back" href="users-bookmarks.jsp">Back</a>
<%
      }
      else
      {
%>
        <br />
        <strong class="fontNormal">Delete bookmark</strong>
        <br />
        <br />
        An error occurred while deleting the bookmark. <a title="Bookmarks list" href="users-bookmarks.jsp">Bookmarks list</a>
<%
      }
    }
    else
    {
      if( bookmarks != null && bookmarks.size() > 0 )
      {
%>
      <table summary="Bookmarks list" width="100%" border="1" cellspacing="0" cellpadding="0" style="border-collapse : collapse">
        <tr style="background-color:#DDDDDD">
          <td style="text-align:center">
            Sel.
          </td>
          <td>
            Bookmark
          </td>
          <td>
            Description
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
            <label for="bookmark_<%=i%>" class="noshow">Choose a bookmark</label>
            <input title="Choose a bookmark" id="bookmark_<%=i%>" alt="Choose a bookmark" value="true" type="checkbox" name="bookmark_<%=i%>" />
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
              <a title="Bookmark" href="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookm),"&nbsp;")%></a>
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
      <label for="input2" class="noshow">Edit</label>
      <input id="input2" type="button" value="Edit" name="edit" onclick="onClickEdit()" class="inputTextField" title="Edit bookmark" />
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <label for="input3" class="noshow">Delete</label>
      <input id="input3" type="button" value="Delete" name="delete" onclick="onClickDelete()" class="inputTextField" title="Delete bookmark" />
<%
      }
      else
      {
%>
       <span style="color:red">There are no saved bookmarks.</span>
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
    <span style="color : red">You must be authenticated and have the proper right to access this page.</span>
<%
  }
%>
    <br />
    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="users-bookmarks.jsp" />
    </jsp:include>
  </div>
  </body>
</html>