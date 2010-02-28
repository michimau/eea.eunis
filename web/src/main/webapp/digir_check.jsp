<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Display DiGIR Provider status
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.net.HttpURLConnection,
                 java.net.URL"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<%
  WebContentManagement cms = SessionManager.getWebContent();
  //Check if digir provider is running
  if( !SessionManager.isDigirProviderRunChecked() )
  {
    URL addressurl;
    String proxyurl = application.getInitParameter( "PROXY_URL" );
    String url = application.getInitParameter( "DIGIR_SERVICE");
    if (proxyurl != null)
    {
      int proxyport = Utilities.checkedStringToInt( application.getInitParameter( "PROXY_PORT" ), 0 );
      addressurl = new URL( "http", proxyurl, proxyport, url );
    }
    else
    {
      addressurl = new URL( url );
    }
    InputStream is = null;
    HttpURLConnection conn = null;
    try
    {
      SessionManager.setDigirProviderRunChecked( true );
      conn = ( HttpURLConnection ) addressurl.openConnection();
      conn.setConnectTimeout( 5000 );
      conn.setDoInput( true );
      conn.connect();
      is = conn.getInputStream();
      byte[] b = new byte [ 5 ];
      is.read( b );
      String s = new String( b );
      // It's not enought to .connect() to provider. When passing through proxy server, .connect() successfully connects
      // to proxy and reports that DiGIR is running while not. Reading response reflects the real state of the provider.
      if( s.equalsIgnoreCase( "<?xml") )
      {
        SessionManager.setDigirProviderRunning( true );
      }
    }
    catch ( Exception ex )
    {
      SessionManager.setDigirProviderRunning( false );
    }
    finally
    {
      if ( is != null )
      {
        try { is.close(); } catch( Exception ex ) {}
      }
      if ( conn != null )
      {
        try { conn.disconnect(); } catch( Exception ex ) {}
      }
    }
  }
%>
<script language="javascript" type="text/javascript">
  var ctrl_digir_url_link = document.getElementById( "digir_url_link" );
  var digirUp = <%=SessionManager.isDigirProviderRunning()%>;
  if ( !digirUp )
  {
    ctrl_digir_url_link.style.color = "#FF6A6A";
  }
</script>
