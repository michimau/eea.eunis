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
                   java.util.Date"%>
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
  
  String kmlUrl = request.getParameter("kmlUrl");

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
    boolean success;
    try
    {
      ImageProcessing img = new ImageProcessing( inputFilename, outputFilename );
      img.init();
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
            int x;
            int y;
  //          WEST � 15
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
  <h2>
    <%=cm.cmsText("grid_distribution")%>
  </h2>
<%
  if ( success )
  {
%>
	<table width="90%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			    <img alt="<%=cm.cms("grid_distribution")%>" name = "mmap" src="temp/<%=filename%>" style="vertical-align:middle" title="<%=cm.cms("grid_distribution")%>" />
			    <%=cm.cmsTitle("grid_distribution")%>
			</td>
			<td align="right" valign="top">
				<a href="<%=kmlUrl%>" title="<%=cm.cms( "header_download_kml_title" )%>"><%=cm.cmsText( "header_download_kml" )%></a>
          		<%=cm.cmsTitle( "header_download_kml_title" )%>
			</td>
    </tr>
    </table>
    <br />
    <br />
<%
  }
%>
  <table summary="<%=cm.cms("table_of_results")%>" class="listing" width="90%">
    <thead>
      <tr>
        <th>
          <%=cm.cmsText("code_cell")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th style="text-align:right">
          <%=cm.cmsText("species_factsheet-distribution_04")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th style="text-align:right">
          <%=cm.cmsText("species_factsheet-distribution_05")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th>
          <%=cm.cmsText("status")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
        <th>
          <%=cm.cmsText("reference")%>
          <%=cm.cmsTitle("sort_by_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
      String GridName;
      String GridLongitude="";
      String GridLatitude="";
      String GridStatus;
      String GridIdDc;
      // Display results.
      for (int i = 0; i < d.size(); i += 2)
      {
        String cssClass = i % 2 == 0 ? "" : " class=\"zebraeven\"";
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
      <tr<%=cssClass%>>
        <td>
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
    </tbody>
  </table>
<%
  }
%>

  <%=cm.br()%>
  <%=cm.cmsMsg("table_of_results")%>

  <br />
  <br />
<%
  }
  catch( Exception ex )
  {
    ex.printStackTrace();
  }
%>
