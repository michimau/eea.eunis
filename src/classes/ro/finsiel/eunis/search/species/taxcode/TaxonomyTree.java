package ro.finsiel.eunis.search.species.taxcode;

import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodeDomain;
import ro.finsiel.eunis.jrfTables.species.taxonomy.Chm62edtTaxcodePersist;
import ro.finsiel.eunis.search.Utilities;

import java.util.*;

/**
 * User: cromanescu
 * Date: Jan 31, 2006
 * Time: 12:26:16 PM
 */
public class TaxonomyTree {

// Arrays for nodes and icons
  ArrayList<String> nodes = null;
  ArrayList<String> openNodes = new ArrayList<String>();
  String[] icons = new String[ 6 ];
  String firstlevelchilds = "";
  String trecut = "f";

  public String[] treeElements;
  public String document = "";


// Loads all icons that are used in the tree

  public void preloadIcons() {
    icons[ 0 ] = "images/tree/plus.gif";
    icons[ 1 ] = "images/tree/plusbottom.gif";
    icons[ 2 ] = "images/tree/minus.gif";
    icons[ 3 ] = "images/tree/minusbottom.gif";
    icons[ 4 ] = "images/tree/folder.gif";
    icons[ 5 ] = "images/tree/folderopen.gif";
  }

// Create the tree

  public void createTree( int nivel, String vName, ArrayList<String> arrName, String startNode, String openNode, String pageURL ) {
    nodes = arrName;
    firstlevelchilds = vName;
    if ( nodes.size() > 0 )
    {
      preloadIcons();
      if ( startNode == null )
      {
        startNode = "0";
      }
      if ( ( openNode != null && openNode.equals( "0" ) ) || openNode != null )
      {
        setOpenNodes( openNode );
      }
      if ( openNode != null && startNode.equals( "0" ) )
      {
        //String[] nodeValues = nodes.get( getArrayId( startNode ) ).split( "|" );
        //document.write("<a title=\""+tree_display_msg+"\" href=\"" + nodeValues[3] + "\"><img alt=\"\" src=\"images/tree/folderopen.gif\" align=\"absbottom\" />" + nodeValues[2] + "</a><br />");
      }
      else
      {
        //document.write("<img src=\"images/tree/base.gif\" alt=\""+tree_habitat_msg+"\" align=\"absbottom\" /><a title=\""+tree_habitat_msg+"\" href=\""+ pageURL +"\">"+tree_habitat_msg+"</a><br />");
      }
      ArrayList recursedNodes = new ArrayList();
      addNode( Utilities.checkedStringToInt( startNode, 0 ), recursedNodes, nivel );
    }
  }

// Create the tree for species taxonomy

  public String generateTree( int expandedNodeID )
  {
    System.out.println( "expandedNodeID = " + expandedNodeID );
    String ret = "";
    int[] ident = new int[ treeElements.length ];
    int[] nodeIDs = new int[ treeElements.length ];
    int[] parentIDs = new int[ treeElements.length ];
    boolean[] hasChilds = new boolean[ treeElements.length ];

    String[] names = new String[ treeElements.length ];
    String[] links = new String[ treeElements.length ];

    for( int c = 0; c < treeElements.length; c++ )
    {
      ident[ c ] = 0;
      nodeIDs[ c ] = 0;
      parentIDs[ c ] = 0;
      links[ c ] = "";
    }
    for( int c = 0; c < treeElements.length; c++ )
    {
      String element = treeElements[ c ];
      String[] tmp = element.split( "\\|" );
      nodeIDs[ c ] = Utilities.checkedStringToInt( tmp[ 0 ], 0 );
      parentIDs[ c ] = Utilities.checkedStringToInt( tmp[ 1 ], 0 );
      names[ c ] = tmp[ 2 ];
      links[ c ] = tmp[ 3 ];
      hasChilds[ c ] = Utilities.checkedStringToBoolean( tmp[ 4 ], false );
    }

    ident[ 0 ] = 0;

    for( int i = 0; i < ident.length - 1; i++ )
    {
      for( int j = 0; j < ident.length - 1; j++ )
      {
        if( nodeIDs[ j ] == parentIDs[ i ] )
        {
          ident[ i ] = ident[ j ] + 1;
          break;
        }
      }
    }

//    String img = "";
//    for( int i = 0; i < ident.length; i++ )
//    {
//      ret += nbsp( ident[ i ] );
//      if( hasChilds[ i ] )
//      {
//        img = "folder.gif";
//        ret += "<a href=\"" + links[ i ] + "\"><img src=\"images/tree/" + img + "\" border=\"0\" /></a>" + names[ i ] + "<br />\n";
//      }
//      else
//      {
//        img = "page.gif";
//        ret += "<img src=\"images/tree/" + img + "\"/><a href=\"" + links[ i ] + "\">" + names[ i ] + "</a><br />\n";
//      }
//    }

    int expandedNodeIdent = -1;
    int expandedNodePosition = -1;
    for( int i = ident.length - 1; i >= 0; i-- )
    {
      if( nodeIDs[ i ] == expandedNodeID )
      {
        expandedNodeIdent = ident[ i ];
        expandedNodePosition = i;
        break;
      }
    }

    ArrayList<String> treeLines = new ArrayList<String>();
    int prevIdent = -1;
    for( int i = ident.length - 1; i >= 0; i-- )
    {
      if( i <= expandedNodePosition )
      {
        if( ident[ i ] <= expandedNodeIdent )
        {
          if( nodeIDs[ i ] == expandedNodeID )
          {
            System.out.println( "i = " + i );
            treeLines.add( nbsp( ident[ i ] ) + names[ i ] + "<br />\n" );
            prevIdent = ident[ i ];
          }
          else
          {
            if( prevIdent >= 0 )
            {
              treeLines.add( nbsp( ident[ i ] ) + names[ i ] + "<br />\n" );
              prevIdent = ident[ i ];
            }
            else
            {
              treeLines.add( names[ i ] + "<br />\n" );
              prevIdent = -1;
            }
          }
        }
        else
        {
          treeLines.add( "" );
        }
      }
      else
      {
        if( ident[ i ] > 0 && ident[ i ] < expandedNodeIdent )
          treeLines.add( "" );
        else
          treeLines.add( "xx" );
      }
    }

    System.out.println( "expandedNodeIdent = " + expandedNodeIdent );
    System.out.println( "expandedNodePosition = " + expandedNodePosition );
    System.out.println( "ident[ 4 ] = " + ident[ 4 ] );
    System.out.println( "ident[ 5 ] = " + ident[ 5 ] );
    for( int i = 0; i < treeLines.size(); i++ )
    {
      if( i > expandedNodePosition )
      {
        if( ident[ i ] == expandedNodeIdent && treeLines.get( i ).length() > 0 )
        {
          System.out.println( expandedNodeIdent + ":" + i + ":" + treeLines.get( i ) );
          treeLines.set( i , nbsp( ident[ i ] ) + treeLines.get( i ) );
        }
        else
        {
          break;
        }
      }
    }

    for( int i = treeLines.size() - 1; i >= 0; i-- )
    {
      ret += treeLines.get( i );
    }

    return ret;
  }

  private String nbsp( int nr )
  {
    String ret = "";
    for( int i = 0; i < nr; i++ )
      ret += "--";
    return ret;
  }

  public void createTreeSpeciesTaxonomy( String taxLevel,
                                         String taxName,
                                         int nivel,
                                         String vName,
                                         String startNode,
                                         String openNode,
                                         String pageURL )
  {
    nodes = new ArrayList<String>();
    for( String element : treeElements )
    {
      nodes.add( element );
    }
    firstlevelchilds = vName;
    if (nodes.size()> 0)
    {
      preloadIcons();
      if (startNode == null) startNode = "0";
      if ( Utilities.checkedStringToInt( openNode, 0 ) != 0 || openNode != null)
        setOpenNodes(openNode);
      if ( Utilities.checkedStringToInt( startNode, 0 ) !=0 )
      {
        String[] nodeValues = nodes.get( getArrayId(startNode) ).split("\\|");
        document += "<a href=\"" + nodeValues[3] + "\">" + nodeValues[2] + "</a><br />";
      } else
      {
        document += "<img src=\"images/tree/base.gif\" align=\"absbottom\"><a href=\"" + pageURL + "\" />" + taxLevel + " - "+taxName+"</a><br />";
      }
      ArrayList recursedNodes = new ArrayList();
      addNode(Utilities.checkedStringToInt( startNode, 0 ), recursedNodes,nivel);
    }
  }

// Returns the position of a node in the array

  public int getArrayId( String node ) {
    int idx = Utilities.checkedStringToInt( node, -1 );
    if ( node != null )
    {
      return idx - 1;
    }
    return 0;
  }

// Puts in array nodes that will be open

  public void setOpenNodes( String openNode ) {
    int idx = Utilities.checkedStringToInt( openNode, -1 );
    if ( idx > 0 )
    {
      String[] nodeValues = nodes.get( idx - 1 ).split( "\\|" );
      openNodes.add( nodeValues[ 0 ] );
      setOpenNodes( nodeValues[ 1 ] );
    }
  }

// Checks if a node is open

  public boolean isNodeOpen( String node ) {
    for ( Object openNode : openNodes )
    {
      if ( openNode.toString().equals( node ) )
      {
        return true;
      }
    }
    return false;
  }

// Checks if a node has any children

  public boolean hasChildNode( String parentNode ) {
    int idx = Utilities.checkedStringToInt( parentNode, -1 );
    if ( idx >= 0 )
    {
      String[] nodeValues = nodes.get( idx - 1 ).split( "\\|" );
      return nodeValues[ 4 ].equalsIgnoreCase( "true" );
    }
    return false;
  }

// Checks if a node is the last sibling

  public boolean lastSibling( String node, String parentNode ) {
    int idx = Utilities.checkedStringToInt( node, -1 );
    if ( idx >= 0 )
    {
      String[] nodeValues = nodes.get( idx - 1 ).split( "\\|" );
      return nodeValues[ 5 ].equalsIgnoreCase( "true" );
    }
    return true;
  }



  public void addNode( int parentNode, ArrayList recursedNodes, int nivel ) {
    String[] nodeValues2;
    String[] childs = null;
    String Buffer= "";

    if(parentNode >0 ){
      nodeValues2 = nodes.get( parentNode-1 ).split("\\|");
      childs = nodeValues2[6].split(",");
    } else{
      childs = firstlevelchilds.split(",");
    }

    if(childs.length == 1 && childs[0].equalsIgnoreCase( "null" ) ) {
    } else {
      for( int j = 0; j < childs.length; j++) {
        int i = Utilities.checkedStringToInt( childs[j], 1 ) - 1;
        String[] nodeValues = nodes.get( i ).split("\\|");
        boolean ls	= lastSibling(nodeValues[0], nodeValues[1]);
        boolean hcn	= hasChildNode(nodeValues[0]);
        boolean ino = isNodeOpen(nodeValues[0]);
        boolean branch = Utilities.checkedStringToInt( nodeValues[7], 0 ) < nivel;

        // Write out line & empty icons
        for(int g=0; g<recursedNodes.size(); g++) {
          if( Utilities.checkedStringToInt( recursedNodes.get( g ).toString(), 0 ) == 1) {
            Buffer+="<img src=\"images/tree/line.gif\" align=\"absbottom\" />";
          } else {
            Buffer+="<img src=\"images/tree/empty.gif\" align=\"absbottom\" />";
          }
        }
        // put in array line & empty icons
        if(ls)
          recursedNodes.add(0);
        else
          recursedNodes.add(1);

        if(hcn) {
          if(ls) {
            Buffer+="<a href=\"javascript:oc(" + nodeValues[0] + ", 1);\"><img id=\"join" + nodeValues[0] + "\" src=\"images/tree/";
            if(branch) {
              if(!ino)
                Buffer+="minusbottom.gif\" align=\"absbottom\"></a>";
              else
                Buffer+="plusbottom.gif\" align=\"absbottom\"></a>";
            } else {
               if(ino)
                 Buffer+="minusbottom.gif\" align=\"absbottom\"></a>";
              else
                Buffer+="plusbottom.gif\" align=\"absbottom\"></a>";
            }
          } else {
            Buffer+="<a href=\"javascript:oc(" + nodeValues[0] + ", 0);\"><img id=\"join" + nodeValues[0] + "\" src=\"images/tree/";
            if(branch) {
              if(!ino)
                Buffer+="minus.gif\" align=\"absbottom\" /></a>";
              else
                Buffer+="plus.gif\" align=\"absbottom\" /></a>";
            } else {
              if(ino)
                Buffer+="minus.gif\" align=\"absbottom\" /></a>";
              else
                Buffer+="plus.gif\" align=\"absbottom\" /></a>";
            }
          }
        } else {
          if(ls)
            Buffer+="<img src=\"images/tree/join.gif\" align=\"absbottom\" />";
          else
            Buffer+="<img src=\"images/tree/joinbottom.gif\" align=\"absbottom\" />";
        }
        // Start link
        Buffer+="<a href=\"" + nodeValues[3] + "#factsheet\">";
        // Write out folder & page icons
        if(hcn) {
          Buffer+="<img id=\"icon" + nodeValues[0] + "\" src=\"images/tree/folder";
          if(branch) {
            if(!ino) {
              Buffer+="open";
            }
          } else {
            if(ino) {
              Buffer+="open";
            }
          }
          Buffer+=".gif\" align=\"absbottom\" />";
        } else {
          Buffer+="<img id=\"icon" + nodeValues[0] + "\" src=\"images/tree/page.gif\" align=\"absbottom\" />";
        }
        // Write out node name
        Buffer+=nodeValues[2];
        // End link
        Buffer+="</a><br />";
        // If node has children write out divs and go deeper
        if(hcn) {
          Buffer+="<div id=\"div" + nodeValues[0] + "\"";
          if(!ino) {
            if(branch)
              Buffer+=" style=\"display:\"\";\"";
            else
              Buffer+=" style=\"display:none;\"";
          }
          Buffer+=">";

          document += Buffer;

          Buffer = "";
          addNode( Utilities.checkedStringToInt( nodeValues[0], 0 ), recursedNodes,nivel);
          Buffer+="</div>";
        }
        // remove last line or empty icon
        recursedNodes.remove( recursedNodes.size() - 1 );
      }
    }
    document += Buffer;
  }

///////////////////////////////////////////////////////////////////////////////
  private int nodeID;
  /**
   * Javascript tree.
   */
  public StringBuffer tree;
  /**
   * Whole tree.
   */
  public StringBuffer treeAll;
  /**
   * Maximum level.
   */
  public int maxlevel;
  /**
   * Level.
   */
  public String level1;
  List coduriL1;


  public TaxonomyTree() {
    coduriL1 = new Chm62edtTaxcodeDomain().findWhereOrderBy( "ID_TAXONOMY=ID_TAXONOMY_PARENT", "NAME" );
  }

  public List getFirstLevelClassifications() {
    return coduriL1;
  }

  public void getTree( int level, String parentCode )
  {
    tree = new StringBuffer();
    nodeID = 0;
    level1 = getTree( level, 0, parentCode );

    String[] elements = tree.toString().split( "#" );

    System.out.println( elements.length );

//    for( String element : elements )
//    {
//      System.out.println( element );
//    }
    treeElements = new String[ elements.length ];
    for( String element : elements )
    {
      int idx = Utilities.checkedStringToInt( element.substring( 0, element.indexOf( "==" ) ), 0 );
//      System.out.println( "idx = " + idx );
      treeElements[ idx ] = element.substring( element.indexOf( "==" ) + 2 );
    }

    int x = 0;
//    for( String treeElement : treeElements )
//    {
//      System.out.println( "treeElement[" + x++ + "] = " + treeElement );
//    }
  }


  public String getTree( int level, int parentNodID, String parentCode ) {
    String r = null;
    StringBuffer localTree = new StringBuffer();
    StringBuffer childs = null;
    if (level <= maxlevel) {
      List lTaxcodes = null;

      if (level == 1)
        lTaxcodes = new Chm62edtTaxcodeDomain().findWhereOrderBy("ID_TAXONOMY=ID_TAXONOMY_PARENT", "NAME");
      else
        lTaxcodes = getChildrenForThisParent(parentCode);

      Iterator it = lTaxcodes.iterator();
      if (it.hasNext()) childs = new StringBuffer();
      while (it.hasNext())
      {
        Chm62edtTaxcodePersist h = (Chm62edtTaxcodePersist) it.next();
        localTree.append(nodeID++); //elementId
        localTree.append("==");
        localTree.append(nodeID); //nodeId
        childs.append(nodeID);
        if (it.hasNext()) childs.append(",");
        localTree.append("|");
        localTree.append(parentNodID);
        localTree.append("|");
        String sn = h.getTaxonomicName();
        while (sn.indexOf("\"") != -1) {
          String aux = sn.substring(0, sn.indexOf("\"")) + "\\$";
          sn = aux + sn.substring(sn.indexOf("\"") + 1);
        }
        localTree.append(h.getTaxonomicLevel() + " - " + sn.replace('$', '\"'));
        localTree.append("|");
        localTree.append("species-taxonomic-browser.jsp?idTaxExpanded=" + h.getIdTaxcode() + "&openNode=" + nodeID);
        localTree.append("|");
        String nextlevel = this.getTree( level + 1, nodeID, h.getIdTaxcode());
        localTree.append(nextlevel != null);
        localTree.append("|");
        localTree.append(!it.hasNext());
        localTree.append("|");
        localTree.append(nextlevel);
        localTree.append("|");
        localTree.append(findLevel(h));
        localTree.append("#");
      }
      tree.append(localTree);
    }
    if (childs != null) r = childs.toString();
    return r;
  }


  private int findLevel( Chm62edtTaxcodePersist tax ) {
    List list;
    int result = 0;
    try
    {
      list = new Chm62edtTaxcodeDomain().findWhere( "ID_TAXONOMY = '" + tax.getIdTaxcode() + "'" );
      if ( list != null && list.size() > 0 )
      {
        Chm62edtTaxcodePersist t = ( Chm62edtTaxcodePersist ) list.get( 0 );
        String str = t.getTaxonomyTree();
        StringTokenizer st = new StringTokenizer( str, "," );
        while ( st.hasMoreTokens() )
        {
          st.nextToken();
          result ++;
        }
        result ++;
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace();
      result = 0;
    }
    return result;
  }

  private List getChildrenForThisParent( String parent ) {
    List l2 = new Chm62edtTaxcodeDomain().findWhere( "ID_TAXONOMY != ID_TAXONOMY_PARENT AND ID_TAXONOMY_PARENT ='" + parent + "'" );
    if ( l2 != null && l2.size() > 0 )
    {
      return l2;
    }
    else
    {
      return new Vector();
    }
  }

}