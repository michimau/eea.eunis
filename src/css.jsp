<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Cascade Style Sheet link - dinamically inserted depending on user preferences.
--%>
<%@ page import="ro.finsiel.eunis.session.SessionManager,
                 ro.finsiel.eunis.jrfTables.users.UserPersist" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  String darkColor = SessionManager.getThemeManager().getDarkColor();
  String mediumColor = SessionManager.getThemeManager().getMediumColor();
  String lightColor = SessionManager.getThemeManager().getLightColor();
  String inputFieldColor = SessionManager.getThemeManager().getInputFieldColor();
  String fontHeader = "10px";
  String fontSmall = "x-small";
  String fontNormal = "small";
  String fontMedium = "medium";
  String fontLarge = "large";
%>
<style type="text/css">
<!--
body {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  background-color: #FFFFFF;
  margin-left: 20px;
}

table {
  font-size: <%=fontNormal%>;
}

form {
  margin: 0px;
}

.fontSmall {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontSmall%>;
}

.fontNormal {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
}

.fontMedium {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontMedium%>;
}

.fontLarge {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontLarge%>;
}

.fontBold {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  font-weight: bold;
}

.textVersion {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontSmall%>;
  color: <%=darkColor%>;
}

.inputTextField {
  font-family: Arial, Helvetica, sans-serif;
  background-color: <%=inputFieldColor%>;
  color: <%=darkColor%>;
  border: 1px solid #000000;
}

.inputTextField200 {
  font-family: Arial, Helvetica, sans-serif;
  background-color: <%=inputFieldColor%>;
  color: <%=darkColor%>;
  border: 1px solid #000000;
  width: 200px;
}

.textInputColorMain {
  font-family: Arial, Helvetica, sans-serif;
  font-size: 10px;
  background-color: white;
  color: <%=darkColor%>;
  border: 1px solid <%=darkColor%>;
  width: 150px;
}

.inputTextFieldCenter {
  font-family: Arial, Helvetica, sans-serif;
  background-color: <%=inputFieldColor%>;
  border: 1px solid #000000;
  text-align: center;
  color: <%=darkColor%>;

}

.bottomCellLine {
  border-bottom-width: 1px;
  border-top-style: none;
  border-right-style: none;
  border-bottom-style: solid;
  border-left-style: none;
  border-bottom-color: #AAAAAA;
}

a:link {
  color: <%=darkColor%>;
  text-decoration: underline;
  font-size: <%=fontNormal%>;
}

a:visited {
  color: <%=darkColor%>;
  text-decoration: underline;
  font-size: <%=fontNormal%>;
}

a:active {
  color: <%=darkColor%>;
  text-decoration: underline;
  font-size: <%=fontNormal%>;
}

a:hover {
  color: #FFFFFF;
  background-color: <%=darkColor%>;
  font-size: <%=fontNormal%>;
}

A.tab:link {
  padding-left: 5px;
  padding-right: 5px;
  color: #FFFFFF;
  text-decoration: none;
  text-align: center;
}

A.tab:visited {
  padding-left: 5px;
  padding-right: 5px;
  color: #FFFFFF;
  text-decoration: none;
  text-align: center;
}

A.tab:active {
  padding-left: 5px;
  padding-right: 5px;
  color: #FFFFFF;
  text-decoration: none;
  text-align: center;
}

A.tab:hover {
  padding-left: 5px;
  padding-right: 5px;
  color: #FFFFFF;
  text-align: center;
}

a.menu_link:link {
  font-family: verdana, helvetica;
  font-size: <%=fontHeader%>;
  font-weight: bold;
  text-decoration: none;
  color: #FFFFFF;
}

a.menu_link:visited {
  font-family: verdana, helvetica;
  font-size: <%=fontHeader%>;
  font-weight: bold;
  text-decoration: none;
  color: #FFFFFF;
}

a.menu_link:active {
  font-family: verdana, helvetica;
  font-size: <%=fontHeader%>;
  font-weight: bold;
  text-decoration: none;
  color: #FFFFFF;
}

a.menu_link:hover {
  font-family: verdana, helvetica;
  font-size: <%=fontHeader%>;
  font-weight: bold;
  color: #FFFFFF;
  background-color: <%=darkColor%>;
  text-decoration: underline;
}

.menu_text {
  font-family: verdana, helvetica;
  font-size: <%=fontHeader%>;
  font-weight: bold;
  color: #FFFFFF;
}

.breadcrumbtrailNormalFont {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  text-decoration: none;
  color: black;
}

a.breadcrumbtrail:link {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  text-decoration: none;
}

a.breadcrumbtrail:visited {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  text-decoration: none;
}

a.breadcrumbtrail:active {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  text-decoration: none;
}

a.breadcrumbtrail:hover {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  text-decoration: underline;
}

.footer_text {
  font-size: small;
}

a.footerLink:link {
  font-family: Arial, Helvetica, sans-serif;
  text-decoration: none;
  font-weight: normal;
  font-size: <%=fontNormal%>;
}

a.footerLink:visited {
  font-family: Arial, Helvetica, sans-serif;
  text-decoration: none;
  font-weight: normal;
  font-size: <%=fontNormal%>;
}

a.footerLink:active {
  font-family: Arial, Helvetica, sans-serif;
  text-decoration: none;
  font-weight: normal;
  font-size: <%=fontNormal%>;
}

a.footerLink:hover {
  font-family: Arial, Helvetica, sans-serif;
  text-decoration: underline;
  font-weight: normal;
  font-size: <%=fontNormal%>;
}

.dynamic_content {
  font-family: Arial, Helvetica, sans-serif;
  color: red;
  display: block;
}

.horizontal_line {
  width: 740px;
  height: 1px;
  background-color: <%=darkColor%>
}

h2 {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontMedium%>;
  font-weight: bold;
  padding: 0px;
}

.title, h4 {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontLarge%>;
  font-weight: bold;
  margin: 0px;
}

h5 {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontMedium%>;
  font-weight: bold;
  background-color: white;
  width: 740px;
  margin-top: 0px;
  margin-bottom: 0px;
}

h6 {
  font-family: Arial, Helvetica, sans-serif;
  font-size: <%=fontNormal%>;
  font-weight: bold;
  background-color: white;
  width: 740px;
  font-style: normal;
  font-variant: normal;
  margin-top: 0px;
  margin-bottom: 0px;
}

.grey_rectangle_bold {
  background-color: #EEEEEE;
  font-weight: bold;
  width: 740px;
}

.grey_rectangle {
  background-color: #EEEEEE;
  width: 740px;
}

.resultHeader {
  color: white;
  background-color: <%=darkColor%>;
  padding-left: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
}

.resultHeaderForFactsheet {
  color: white;
  background-color: #DDDDDD;
  padding-left: 5px;
  padding-top: 1px;
  padding-bottom: 1px;
}

.resultHeader a:link {
  color: white;
  text-decoration: none;
}

.resultHeader a:visited {
  color: white;
  text-decoration: none;
}

.resultHeader a:active {
  color: white;
  text-decoration: none;
}

.resultHeader a:hover {
  color: white;
  text-decoration: underline;
}

.resultCell {
  padding-left: 5px;
  padding-top: 1px;
  padding-bottom: 1px;
  padding-right: 2px;
}

a.announcement:link {
  font-size: <%=fontMedium%>;
  color: #339900;
  background-color: white;
  text-decoration: none;
  font-weight: bold;
}

a.announcement:active {
  font-size: <%=fontMedium%>;
  color: #339900;
  background-color: white;
  text-decoration: none;
  font-weight: bold;
}

a.announcement:visited {
  font-size: <%=fontMedium%>;
  color: #339900;
  background-color: white;
  text-decoration: none;
  font-weight: bold;
}

a.announcement:hover {
  font-size: <%=fontMedium%>;
  color: #339900;
  background-color: white;
  text-decoration: underline;
  font-weight: bold;
}

th {
  text-align: left;
  color: white;
  background-color: <%=darkColor%>;
}

.editContent {
  border: 1px solid red;
}

.mainHeader180 {
  background-color: <%=darkColor%>;
  color: white;
  padding-left: 5px;
  width: 180px;
}

.mainHeader300 {
  background-color: <%=darkColor%>;
  color: white;
  padding-left: 5px;
  width: 300px;
}

/* Tabbed menus  */
#tabbedmenu {
  float: left;
  width: 740px;
  border-bottom: thin solid #E3E2D3;
  font-size: <%=fontSmall%>;
  line-height: normal;
}

#tabbedmenu ul {
  margin: 0;
  padding: 2px 2px 0;
  list-style: none;
  list-style-image: none;
}

#tabbedmenu li {
  float: left;
  background: url( "images/mini/tableft.gif" ) no-repeat left top;
  margin: 0;
  padding: 0 0 0 9px;
  white-space: nowrap;
}

#tabbedmenu a {
  display: block;
  text-decoration: none;
  font-weight: normal;
  color: black;
  background: url( "images/mini/tabright.gif" ) no-repeat right top;
  padding: 5px 15px 2px 3px;
}

#tabbedmenu #currenttab {
  background-image: url( "images/mini/tableft_on.gif" );
}

#tabbedmenu #currenttab a {
  text-decoration: none;
  font-weight: bold;
  background-image: url( "images/mini/tabright_on.gif" );
  padding-bottom: 2px;
}

#tabbedmenu #currenttab span {
  display: block;
  text-decoration: none;
  font-weight: normal;
  background: url( "images/mini/tabright_on.gif" ) no-repeat right top;
  padding: 5px 15px 2px 3px;
}

.indexQS {
  font-family: Arial, Helvetica, sans-serif;
  font-size: 11px;
  background-color: <%=inputFieldColor%>;
  color: <%=darkColor%>;
  border: 1px solid #000000;
}

#tab {
  width: 350px;
  height: 300px;
  overflow: auto;
}

.hidden {
  position: absolute;
  left: 0px;
  top: 0px;
  width: 1px;
  height: 1px;
  overflow: hidden;
  display : none;
}

#container {
  width: 740px;
  margin: 0px;
  background-color: white;
  color: #000000;
  line-height: 100%;
}

#leftnav
{
  float: left;
  width: 175px;
  margin-right: 20px;
  background-color: #F3F8F9;
  margin-bottom: 10px;
}

#rightnav {
  position: relative;
  float: left;
  width: 215px;
  margin-bottom: 10px;
}

#content {
  width : 740px;
  text-align : left;
}

#content_index {
  float: left;
  width: 305px;
  margin-right: 20px;
  margin-bottom: 10px;
}

#leftnav p, #rightnav p {
  margin: 0 0 1em 0;
}

.mainlabel180_1 {
	background-color: #006CAD;
	color: white;
	height: 20px;
	padding-top:5px;
	vertical-align:middle;
	background-image: url(images/top_list.jpg);
	background-repeat: no-repeat;
	background-position: left top;
	text-indent: 10px;
}

#mainlabel180_2 {
  background-color: #006CAD;
  color: white;
  padding-left: 5px;
  height: 20px;
  padding-top:5px;
  vertical-align:middle;
}

#mainlabel250 {
  /*background-color: #006CAD; color: white;*/
 	font-size: <%=fontNormal%>;
	color: #006CAD;
	font-weight: bold;
	padding: 7px 0px 23px 0px;
  /*padding-left: 5px;*/
}

.mainHeader180 {
  background-color: #006CAD;
  color: white;
  padding-left: 5px;
  width: 180px;
}

.mainHeader300 {
  background-color: #006CAD;
  color: white;
  padding-left: 5px;
  width: 300px;
}

.separator {
  display: block;
  height: 10px;
  border: 0 0 0 0;
}

.brClear
{
  clear : both;
}

#overDiv
{
  z-index:1000;
  visibility: hidden;
  position: absolute;
}

.submit_buttons
{
  background-color : #EEEEEE;
  width : 740px;
  text-align : right;
}

.coordinates
{
  font-family : courier;
  font-size : 10px;
}

#header
{
  width : 740px;
  height : 60px;
  background-image : url(images/banner_blue.jpg);
  text-align : right;
}

.main_menu
{
  border-collapse: collapse;
  border-color : #6DABD0;
  background-color : #006CAD;
  color : white;
}

.languageTextField {
  font-family: arial, sans-serif;
  background-color: #FFFFFF;
  color: black;
  border: 1px solid black;
  position :relative;
  top : 38px;
}

#bodydiv
{
  width: 100%;
  text-align: center;
}

#bodydiv2
{
  width: 740px;
  text-align: left;
}

/* */
.between {
	width: 100%;
	background-color: white;
	height: 15px;
	background-image: url(images/round_box_bottom.gif);
	background-repeat: no-repeat;
	background-position: left top;
}

#leftnav ul {
	width: 100%;
	margin:0;
	padding: 10px 0;
	list-style:none;
	border-top: 2px solid white;
	background-image: url(images/round_box_top.gif);
	background-position: left top;
	background-repeat: no-repeat;
}
#leftnav li {
	margin-left: 15px;
	margin-bottom: 5px;
	margin-top: 10px;
	line-height: 1.3em;
}

.search_style {
	float: right;
	text-align: right;
	vertical-align: middle;
}

.search_details {
	font-family: Arial, Helvetica, sans-serif;
	clear: both;
	width: 100%;
	margin-top: 3px;
	margin-bottom: 7px;
	font-size: 95%;
}

#content a {
line-height: 1.4em;
/*padding-top: 15px;*/
display: block;
color: #006CAD;
}

#content a:hover
{
color: white;
}

#footer ul {
	display: inline;
	margin:0;
	padding: 0;
	list-style: none;
	text-align: center;

}

#footer li {
	display: inline;
	margin:0;
	padding: 0 4px;
	list-style: none;


}

.footer_line {
	height: 21px;
	text-align:center;
}

-->
</style>