<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - distribution.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="  ro.finsiel.eunis.search.Utilities,
                   ro.finsiel.eunis.jrfTables.species.factsheet.DistributionWrapper,
                   ro.finsiel.eunis.jrfTables.species.factsheet.ReportsDistributionStatusPersist,
                   java.util.List,
                   ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.ImageProcessing,java.awt.*,
                   java.io.File,java.util.Date"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  try
  {
  // Input parameters
  // expand - if expand into factsheet or work as a standalone popup window
  // idNatureObject - Nature object for the specie
  // name - Name of the species
  WebContentManagement cm = SessionManager.getWebContent();
  Integer idNatureObj = Utilities.checkedStringToInt(request.getParameter("idNatureObject"),new Integer(0));

  DistributionWrapper dist = new DistributionWrapper(idNatureObj);
  // Get species distribution
  List d = dist.getDistribution();
  if (null != d && d.size() > 0)
  {
    String filename = request.getSession().getId() + "_" + new Date().getTime() + "_europe.jpg";
    String inputFilename = application.getInitParameter( "TOMCAT_HOME" ) + "/webapps/eunis/gis/europe-bio.jpg";
    String outputFilename = application.getInitParameter( "TOMCAT_HOME" ) + "/" + application.getInitParameter( "TEMP_DIR" ) + filename;

    System.out.println( "outputFilename = " + outputFilename );
    System.out.println( "inputFilename = " + inputFilename );
    boolean success = false;
    try
    {
      ImageProcessing img = new ImageProcessing( inputFilename, outputFilename );
      img.init();
      String scientificName = request.getParameter("name");
      for (int i = 0; i < d.size(); i += 2)
      {
        ReportsDistributionStatusPersist dis;
        if ( i < d.size() - 1 )
        {
          dis = ( ReportsDistributionStatusPersist ) d.get( i + 1 );
          if(dis.getLatitude() != null && dis.getLongitude() != null && dis.getLatitude().doubleValue() != 0 && dis.getLongitude().doubleValue() != 0)
          {
            double longitude = dis.getLongitude().doubleValue();
            double latitude = dis.getLatitude().doubleValue();
            int x = 0;
            int y = 0;
  //          WEST – 15
  //          EAST +44
  //          NORTH +73
  //          SOUTH +34
  //          PIC SIZE: 616 x 407
            //the map goes from -15 to 44 in longitude
            x = ( int ) ( ( 616 * 15 ) / 59 + ( ( longitude * 616 ) / 59 ) );
            //the map goes from 34 to 73 in latitude
            y = ( int ) ( 407 - ( ( ( ( latitude - 34 ) * 407 ) / 39 ) ) );
            //System.out.println( "longitude:" + longitude  + "=>" + x );
            //System.out.println( "latitude:" + latitude + "=>" + y );
            int radius = 4;
            img.drawPoint( x, y, Color.RED, radius );
          }
        }
      }
      img.save();
      success = true;
    }
    catch( Throwable ex )
    {
      success = false;
      ex.printStackTrace();
    }
%>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet-distribution_10")%></div>
<%
  if ( success )
  {
%>
    <img alt="<%=cm.cms("species_factsheet-distribution_11_Title")%>" name = "mmap" src="temp/<%=filename%>" style="vertical-align:middle" title="<%=cm.cms("species_factsheet-distribution_11_Title")%>" />
    <%=cm.cmsTitle("species_factsheet-distribution_11_Title")%>
    <br />
    <br />
<%
  }
%>
    <table summary="<%=cm.cms("species_factsheet-distribution_12_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="distribution" class="sortable">
      <tr style="vertical-align:middle" title="<%=cm.cms("sort_results_on_this_column")%>">
        <th style="text-align:left">
          <%=cm.cmsText("species_factsheet-distribution_03")%>
          <%=cm.cmsTitle("species_factsheet-distribution_13_Title")%>
        </th>
        <th style="text-align:right" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-distribution_04")%>
          <%=cm.cmsTitle("species_factsheet-distribution_13_Title")%>
        </th>
        <th style="text-align:right" title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-distribution_05")%>
          <%=cm.cmsTitle("species_factsheet-distribution_13_Title")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-distribution_06")%>
          <%=cm.cmsTitle("species_factsheet-distribution_13_Title")%>
        </th>
        <th title="<%=cm.cms("sort_results_on_this_column")%>">
          <%=cm.cmsText("species_factsheet-distribution_07")%>
          <%=cm.cmsTitle("species_factsheet-distribution_13_Title")%>
        </th>
      </tr>
<%
      String GridName="";
      String GridLongitude="";
      String GridLatitude="";
      String GridStatus="";
      String GridIdDc="";
      // Display results.
      for (int i = 0; i < d.size(); i += 2)
      {
        ReportsDistributionStatusPersist dis;
        dis = (ReportsDistributionStatusPersist) d.get(i);
        GridName = dis.getIdLookupGrid();
        GridStatus=dis.getDistributionStatus();
        GridIdDc=dis.getIdDc().toString();
        if (i < d.size() - 1)
        {
          dis = (ReportsDistributionStatusPersist) d.get(i+1);
          GridLongitude=dis.getLongitude().toString();
          GridLatitude=dis.getLatitude().toString();
        }
%>
      <tr style="background-color:<%=(0 == (i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
        <td style="text-align:left">
          <%=Utilities.treatURLSpecialCharacters(GridName)%>
        </td>
        <td style="text-align:right">
          <%=Utilities.formatArea(GridLongitude, 3, 4, "&nbsp;")%>
        </td>
        <td style="text-align:right">
          <%=Utilities.formatArea(GridLatitude, 3, 4, "&nbsp;")%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(GridStatus)%>
        </td>
<%
        if (!Utilities.getAuthorAndUrlByIdDc(GridIdDc).get(1).toString().equalsIgnoreCase(""))
        {
%>
        <td onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(GridIdDc)%>')" onmouseout="hidetooltip()">
          <span class="boldUnderline">
            <a href="<%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(GridIdDc).get(1))%>"><%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(GridIdDc).get(0))%></a>
          </span>
        </td>
<%
        }
        else
        {
%>
        <td onmouseover="return showtooltip('<%=Utilities.getReferencesByIdDc(GridIdDc)%>')" onmouseout="hidetooltip()">
          <span class="boldUnderline">
            <%=Utilities.treatURLSpecialCharacters((String)Utilities.getAuthorAndUrlByIdDc(GridIdDc).get(0))%>&nbsp;
          </span>
        </td>
<%
        }
%>
      </tr>
<%
      }
%>
    </table>
<%
  }
%>

<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-distribution_12_Sum")%>

<br />
<br />
<%
  }catch( Exception ex )
  {
    ex.printStackTrace();
  }
%>