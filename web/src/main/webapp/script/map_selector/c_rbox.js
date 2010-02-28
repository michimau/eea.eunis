//this function assigns the javascript functions to the map's event handlers
function initMap()
{
   map.onmousedown = Map_onMouseDown;
   map.onmousemove = Map_onMouseMove;
   map.onmouseup = Map_onMouseUp;
}

function killBox()
{
   document.map.onmousedown = null;
   document.map.onmousemove = null;
   document.map.onmouseup = null;
}


function Map_onMouseDown()
{
   rubberbander = new RubberRectangle(box, 'red', 'solid', 1);
   rubberbander.processEvent(event);
}

function Map_onMouseMove()
{
   if (rubberbander)
   {
      rubberbander.processEvent(event);
   }
}

function Map_onMouseUp()
{
   if (rubberbander)
   {
      rubberbander.processEvent(event);
	  boxprocess(rubberbander.relOrigX,rubberbander.relOrigY,rubberbander.relDestX,rubberbander.relDestY);
   }
}

//on load map the event handlers
//window.onload = initMap;

//create a variable to hold the rubberbander
var rubberbander = new RubberRectangle();
