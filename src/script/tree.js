// Arrays for nodes and icons
var nodes		= new Array();
var openNodes	= new Array();
var icons		= new Array(6);
var firstlevelchilds = "";
var trecut="f";

// Loads all icons that are used in the tree
function preloadIcons() {
	icons[0] = new Image();
	icons[0].src = "images/tree/plus.gif";
	icons[1] = new Image();
	icons[1].src = "images/tree/plusbottom.gif";
	icons[2] = new Image();
	icons[2].src = "images/tree/minus.gif";
	icons[3] = new Image();
	icons[3].src = "images/tree/minusbottom.gif";
	icons[4] = new Image();
	icons[4].src = "images/tree/folder.gif";
	icons[5] = new Image();
	icons[5].src = "images/tree/folderopen.gif";
}

// Create the tree
function createTree(nivel,vName, arrName, startNode, openNode, pageURL) {
	nodes = arrName;
  firstlevelchilds = vName;
	if(nodes.length > 0) {
		preloadIcons();
		if(startNode == null) startNode = 0;
		if(openNode != 0 || openNode != null) setOpenNodes(openNode);
		if(startNode !=0) {
			var nodeValues = nodes[getArrayId(startNode)].split("|");
			document.write("<a title=\"Display data for this node\" href=\"" + nodeValues[3] + "\"><img alt=\"\" src=\"images/tree/folderopen.gif\" align=\"absbottom\" />" + nodeValues[2] + "</a><br />");
		} else
		  document.write("<img src=\"images/tree/base.gif\" alt=\"Habitat Classification Categories\" align=\"absbottom\" /><a title=\"Habitat Classification Categories\" href=\""+ pageURL +"\">Habitat Classification Categories</a><br />");
		var recursedNodes = new Array();
		addNode(startNode, recursedNodes,nivel);
	}
}

// Create the tree for species taxonomy
function createTreeSpeciesTaxonomy(taxLevel, taxName, nivel, vName, arrName, startNode, openNode, pageURL) {
	nodes = arrName;
  firstlevelchilds = vName;
  if (nodes.length > 0) {
		preloadIcons();
		if (startNode == null) startNode = 0;
		if (openNode != 0 || openNode != null) setOpenNodes(openNode);
		if (startNode !=0) {
			var nodeValues = nodes[getArrayId(startNode)].split("|");
			document.write("<a title=\"Display data for this node\" href=\"" + nodeValues[3] + "\">" + nodeValues[2] + "</a><br />");
		} else document.write("<img src=\"images/tree/base.gif\" alt=\"Taxonomic Classification\" align=\"absbottom\"><a title=\"Taxonomic Classification\" href=\"" + pageURL + "\" />Taxonomic Classification for " + taxLevel + " - "+taxName+"</a><br />");
		var recursedNodes = new Array();
		addNode(startNode, recursedNodes,nivel);
	}
}



// Returns the position of a node in the array
function getArrayId(node) {
	return node-1;
}


// Puts in array nodes that will be open
function setOpenNodes(openNode) {
  if(openNode != null && openNode > 0) {
    var nodeValues = nodes[openNode-1].split("|");
    openNodes.push(nodeValues[0]);
    setOpenNodes(nodeValues[1]);
  }
}


// Checks if a node is open
function isNodeOpen(node) {
	for(i=0; i<openNodes.length; i++)
		if(openNodes[i]==node) return true;
	return false;
}


// Checks if a node has any children
function hasChildNode(parentNode) {
  var nodeValues = nodes[parentNode-1].split("|");
  return (nodeValues[4] == "true");
}



// Checks if a node is the last sibling
function lastSibling (node, parentNode) {
  var nodeValues = nodes[node-1].split("|");
  return (nodeValues[5] == "true");
}

// Opens or closes a node
function oc(node, bottom) {
  var theDiv = document.getElementById("div" + node);
	var theJoin	= document.getElementById("join" + node);
	var theIcon = document.getElementById("icon" + node);
	if(theDiv.style.display == "none") {
    if(bottom==1)
      theJoin.src = icons[3].src;
		else
		  theJoin.src = icons[2].src;
		theIcon.src = icons[5].src;
    theDiv.style.display = "";
  } else {
    if(bottom==1)
      theJoin.src = icons[1].src;
		else theJoin.src = icons[0].src;
		  theIcon.src = icons[4].src;
    theDiv.style.display = "none";
  }
}

if(!Array.prototype.push) {
	function array_push() {
		for(var i=0;i<arguments.length;i++)
			this[this.length]=arguments[i];
		return this.length;
	}
	Array.prototype.push = array_push;
}
if(!Array.prototype.pop) {
	function array_pop(){
		lastElement = this[this.length-1];
		this.length = Math.max(this.length-1,0);
		return lastElement;
	}
	Array.prototype.pop = array_pop;
}

function addNode(parentNode, recursedNodes,nivel) {
  var nodeValues2;
  var childs= new Array();
  var Buffer= "";

  if(parentNode >0 ){
    nodeValues2 = nodes[parentNode-1].split("|");
    childs = nodeValues2[6].split(",");
  } else{
    childs = firstlevelchilds.split(",");
  }

  if(childs.length == 1 && childs[0]=="null") {
  } else {
	  for(var j = 0; j < childs.length; j++) {
      i=childs[j]-1;
  		var nodeValues = nodes[i].split("|");
      var ls	= lastSibling(nodeValues[0], nodeValues[1]);
      var hcn	= hasChildNode(nodeValues[0]);
      var ino = isNodeOpen(nodeValues[0]);
      var branch = nodeValues[7] < nivel;

      // Write out line & empty icons
      for(g=0; g<recursedNodes.length; g++) {
        if(recursedNodes[g] == 1) {
          Buffer+="<img src=\"images/tree/line.gif\" align=\"absbottom\" />";
        } else {
          Buffer+="<img src=\"images/tree/empty.gif\" align=\"absbottom\" />";
        }
      }
      // put in array line & empty icons
      if(ls)
        recursedNodes.push(0);
      else
        recursedNodes.push(1);

      if(hcn) {
        if(ls) {
          Buffer+="<a title=\"Display data for this node\" href=\"javascript:oc(" + nodeValues[0] + ", 1);\"><img id=\"join" + nodeValues[0] + "\" src=\"images/tree/";
          if(branch) {
            if(!ino)
              Buffer+="minusbottom.gif\" align=\"absbottom\" alt=\"Open/Close node\"></a>";
            else
              Buffer+="plusbottom.gif\" align=\"absbottom\" alt=\"Open/Close node\"></a>";
          } else {
					 	if(ino)
					 	  Buffer+="minusbottom.gif\" align=\"absbottom\" alt=\"Open/Close node\"></a>";
						else
						  Buffer+="plusbottom.gif\" align=\"absbottom\" alt=\"Open/Close node\"></a>";
          }
        } else {
          Buffer+="<a title=\"Display data for this node\" href=\"javascript:oc(" + nodeValues[0] + ", 0);\"><img id=\"join" + nodeValues[0] + "\" src=\"images/tree/";
          if(branch) {
            if(!ino)
              Buffer+="minus.gif\" align=\"absbottom\" alt=\"Open/Close node\" /></a>";
            else
              Buffer+="plus.gif\" align=\"absbottom\" alt=\"Open/Close node\" /></a>";
          } else {
						if(ino)
						  Buffer+="minus.gif\" align=\"absbottom\" alt=\"Open/Close node\" /></a>";
						else
						  Buffer+="plus.gif\" align=\"absbottom\" alt=\"Open/Close node\" /></a>";
          }
        }
      } else {
        if(ls)
          Buffer+="<img src=\"images/tree/join.gif\" align=\"absbottom\" />";
        else
          Buffer+="<img src=\"images/tree/joinbottom.gif\" align=\"absbottom\" />";
      }
      // Start link
      Buffer+="<a title=\"Display data for this node\" href=\"" + nodeValues[3] + "#factsheet\">";
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
        Buffer+=".gif\" align=\"absbottom\" alt=\"Folder\" />";
      } else {
        Buffer+="<img id=\"icon" + nodeValues[0] + "\" src=\"images/tree/page.gif\" align=\"absbottom\" alt=\"Page\" />";
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

        document.write(Buffer);
        Buffer = "";
        addNode(nodeValues[0], recursedNodes,nivel);
        Buffer+="</div>";
      }
      // remove last line or empty icon
      recursedNodes.pop();
    }
  }
  document.write(Buffer);
}

