<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.0">
<Folder>    
	<name>Network Links</name>    
	<visibility>0</visibility>    
	<open>1</open>    
<%@ page contentType="application/vnd.google-earth.kml+xml; charset=UTF-8" %>
<%
  request.setCharacterEncoding( "UTF-8");
  response.setHeader("Content-Disposition", "attachment; filename=networklinks.kml");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.species.names.HasGridDistTabDomain,
				ro.finsiel.eunis.jrfTables.species.names.HasGridDistTabPersist,
				java.util.List,
				java.util.Iterator"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
	<jsp:include page="kml/bioregions.kml" />
    <%
  	List species = new HasGridDistTabDomain().findAll();
  	Iterator it = species.iterator(); %>
  	<%
	  while (it.hasNext()) 
	    { 
	    HasGridDistTabPersist part = (HasGridDistTabPersist)it.next(); 
	    Integer idSpecies = part.getIdSpecies();
  		Integer idSpeciesLink = part.getIdSpeciesLink();
	    %>
	    <NetworkLink>
	    	<name><%=part.getScientificName()%></name>
	    	<open>0</open>
	    	<visibility>0</visibility>
	    	<Url>
				<href>http://eunis.eea.europa.eu/species-factsheet-distribution-kml.jsp?idSpecies=<%=idSpecies%>&amp;idSpeciesLink=<%=idSpeciesLink%></href>
			</Url>
	    </NetworkLink>
	    <%
	    } 
    %>
</Folder>
</kml>
