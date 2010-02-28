<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.0">
<Document>
<%@ page contentType="application/vnd.google-earth.kml+xml; charset=UTF-8" %>
<%
  request.setCharacterEncoding( "UTF-8");
  response.setHeader("Content-Disposition", "attachment; filename=griddistribution.kml");
%>
<%@page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet, 
				ro.finsiel.eunis.jrfTables.SpeciesNatureObjectPersist, 
				ro.finsiel.eunis.jrfTables.species.factsheet.DistributionWrapper,
				ro.finsiel.eunis.jrfTables.species.factsheet.ReportsDistributionStatusPersist,
				java.util.List,
				ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  	Integer idSpecies = Utilities.checkedStringToInt( request.getParameter( "idSpecies" ), new Integer( 0 ) );
  	Integer idSpeciesLink = Utilities.checkedStringToInt( request.getParameter( "idSpeciesLink" ), new Integer( 0 ) );
  	
  	SpeciesFactsheet factsheet = new SpeciesFactsheet(idSpecies, idSpeciesLink);
  	if ( factsheet.exists() ){
	  	SpeciesNatureObjectPersist specie = factsheet.getSpeciesNatureObject();
        String scientificName = specie.getScientificName();
        String description = factsheet.getSpeciesDescription();
        %>
<name><%=scientificName%></name>
<description><%=description%></description>
<Style id="presence">
	<IconStyle>
		<scale>1.0</scale>
		<Icon>
			<href>http://eunis.eea.europa.eu/images/ge_icon.png</href>
			<x>32</x>
			<y>128</y>
			<w>32</w>
			<h>32</h>
		</Icon>
	</IconStyle>
	<LabelStyle>
		<scale>1.0</scale>
		<color>00ffffff</color>
	</LabelStyle>
</Style>
        <%
        DistributionWrapper dist = new DistributionWrapper(specie.getIdNatureObject());
        List d = dist.getDistribution();
        if (null != d && d.size() > 0)
        {
            String GridName;
            String GridLongitude="";
            String GridLatitude="";
            String GridStatus;
            String GridIdDc;
            for (int i = 0; i < d.size(); i += 2){
                ReportsDistributionStatusPersist dis;
                dis = (ReportsDistributionStatusPersist) d.get(i);
                GridName = dis.getIdLookupGrid();
                GridStatus=dis.getDistributionStatus();
                GridIdDc=dis.getIdDc().toString();
                String refDc = Utilities.getReferencesByIdDc(GridIdDc);
                if (i < d.size() - 1)
                {
                  dis = (ReportsDistributionStatusPersist) d.get(i+1);
                  GridLongitude=dis.getLongitude().toString();
                  GridLatitude=dis.getLatitude().toString();
                } %>
<Placemark>
	<name><%=GridName%></name>
	<description>
		<%=refDc%>
	</description>
	<open>0</open>
	<styleUrl>#presence</styleUrl>
	<Point>
		<coordinates><%=GridLongitude%>,<%=GridLatitude%></coordinates>
	</Point>
</Placemark>
            <% 
            }
        }
    }
            
%>
</Document>
</kml>

