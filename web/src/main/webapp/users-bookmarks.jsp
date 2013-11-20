<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Users bookmarks' function - list, edit user's bookmarks.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities,
                 java.util.List,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

  List bookmarks = sqlc.ExecuteSQLReturnList("SELECT BOOKMARK,DESCRIPTION FROM EUNIS_BOOKMARKS WHERE USERNAME = '" + SessionManager.getUsername() + "'", 2);
  int listSize = ( bookmarks == null ? 0 : bookmarks.size() );
%>
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
<%
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,user_bookmarks";
    String typeAction = Utilities.formatString(request.getParameter( "typeAction" ), "" );
    if ( typeAction.equalsIgnoreCase( "edit" ) || typeAction.equalsIgnoreCase( "editSave" ) )
    {
        btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,user_bookmarks#users-bookmarks.jsp,edit_bookmark";
    }
    if ( typeAction.equalsIgnoreCase( "delete" ) )
    {
        btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,user_bookmarks#users-bookmarks.jsp,delete_bookmark";
    }
%>

<c:set var="title" value='<%= application.getInitParameter("PAGE_TITLE") + cm.cms("user_bookmarks") %>'></c:set>

<stripes:layout-render name="/stripes/common/template-legacy.jsp" pageTitle="${title}" btrail="<%= btrail%>">
    <stripes:layout-component name="head">
    <script language="JavaScript" type="text/javascript">
    //<![CDATA[
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
      //]]>
   </script>
    </stripes:layout-component>
    <stripes:layout-component name="contents">
        <a name="documentContent"></a>
        <h1><%=cm.cmsPhrase("EUNIS Database User Bookmarks")%></h1>

<!-- MAIN CONTENT -->
            <%
              if(SessionManager.isAuthenticated())
              {
            %>
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
                    <%=cm.cmsPhrase("Edit bookmark")%>
                    <br />
                    <br />
                    <label for="bookmarkNameEdit">
                    <%=cm.cmsPhrase("Bookmark name")%>:
                    </label>
                    <br />
                    <textarea id="bookmarkNameEdit" title="<%=cm.cms("users_bookmarks_05")%>" name="bookmarkNameEdit" rows="3" cols="100"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmName),"&nbsp;")%></textarea>
                    <%=cm.cmsTitle("users_bookmarks_05")%>
                    <br />
                    <br />
                    <label for="bookmarkDescrptionEdit">
                    <%=cm.cmsPhrase("Bookmark description")%>:
                    </label>
                    <br />
                    <textarea id="bookmarkDescrptionEdit" title="<%=cm.cms("users_bookmarks_06")%>" name="bookmarkDescrptionEdit" rows="3" cols="100"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookmDescription),"&nbsp;")%></textarea>
                    <%=cm.cmsTitle("users_bookmarks_06")%>
                    <br />
                    <input id="input1" type="button" value="<%=cm.cmsPhrase("Save")%>" name="save" onclick="onClickEditSave()" class="saveButton" title="<%=cm.cmsPhrase("Save")%>" />
            <%
                  }
                  else
                  {
            %>
                    <%=cm.cmsPhrase("This bookmark does not exist.")%>
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
                    <div class="system-msg">
                    <%=cm.cmsPhrase("Bookmark has been successfully updated.")%> <a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsPhrase("Back")%></a>
										</div>
                    <%=cm.cmsTitle("users_bookmarks_09")%>
            <%
                  }
                  else
                  {
            %>
                    <div class="error-msg">
                    <%=cm.cmsPhrase("An error occurred while updating the bookmark.")%>
										<a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsPhrase("Back")%></a>
										</div>
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
                    <strong>
                      <%=cm.cmsPhrase("Delete bookmark")%>
                    </strong>
                    <div class="system-msg">
                    <%=cm.cmsPhrase("Bookmark has been successfully deleted.")%> <a title="<%=cm.cms("users_bookmarks_09")%>" href="users-bookmarks.jsp"><%=cm.cmsPhrase("Back")%></a>
										</div>
                    <%=cm.cmsTitle("users_bookmarks_13")%>
            <%
                  }
                  else
                  {
            %>
                    <strong>
                      <%=cm.cmsPhrase("Delete bookmark")%>
                    </strong>
                    <div class="error-msg">
                    <%=cm.cmsPhrase("An error occurred while deleting the bookmark.")%> <a title="<%=cm.cms("users_bookmarks_15")%>" href="users-bookmarks.jsp"><%=cm.cmsPhrase("Bookmarks list")%></a>
										</div>
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
                        <%=cm.cmsPhrase("Bookmark")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Description")%>
                      </td>
                    </tr>
            <%
                    for (int i=0;i<bookmarks.size();i++)
                    {
                      String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
                      TableColumns  bookmark = (TableColumns)bookmarks.get(i);
            %>
                    <tr<%=cssClass%>>
                      <td style="text-align:center;">
                        <input type ="hidden" name="bookmarkName_<%=i%>" value="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>" />
                        <label for="bookmark_<%=i%>" class="noshow"><%=cm.cms("users_bookmarks_18")%></label>
                        <input title="<%=cm.cms("users_bookmarks_18")%>" id="bookmark_<%=i%>" alt="<%=cm.cms("users_bookmarks_18")%>" value="true" type="checkbox" name="bookmark_<%=i%>" />
                        <%=cm.cmsLabel("users_bookmarks_18")%>
                        <%=cm.cmsTitle("users_bookmarks_18")%>
                      </td>
                      <td>
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
                          <a title="<%=cm.cms("bookmark")%>" href="<%=Utilities.treatURLSpecialCharacters((String)bookmark.getColumnsValues().get(0))%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(bookm),"&nbsp;")%></a>
                          <%=cm.cmsTitle("bookmark")%>
                        </span>
            <%
                      }
            %>
                      </td>
                      <td>
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
                  <input id="input2" type="button" value="<%=cm.cms("edit")%>" name="edit" onclick="onClickEdit()" class="standardButton" title="<%=cm.cms("edit")%>" />
                  <%=cm.cmsTitle("edit")%>
                  <%=cm.cmsInput("edit")%>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="input3" type="button" value="<%=cm.cms("delete")%>" name="delete" onclick="onClickDelete()" class="standardButton" title="<%=cm.cms("delete")%>" />
                  <%=cm.cmsTitle("delete")%>
                  <%=cm.cmsInput("delete")%>
            <%
                  }
                  else
                  {
            %>
                   <div class="advice-msg"><%=cm.cmsPhrase("There are no saved bookmarks.")%></div>
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
                <div class="error-msg">
                <%=cm.cmsPhrase("You must be authenticated and have the proper right to access this page.")%>
                </div>
            <%
              }
            %>
                <br />

            <%=cm.br()%>
            <%=cm.cmsMsg("user_bookmarks")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("users_bookmarks_01")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("users_bookmarks_02")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
    </stripes:layout-component>
</stripes:layout-render>