/*

This class may be used to simulate the rubberbanding behavior used by many windows based applications to capture a portion of the screen and the corresponding device coordinates.  It provides rubberband feedback through drawing a box of the specified color, width, and style between the point at which the mouse is depressed and to which the mouse has moved.  The developer must follow the requirements listed below to make successful use of the class.

1.  This class has only been tested with the Internet Explorer browser version 6.0.  Use of any other browser is not supported.

2.  Include the RubberRectangle.js source file in the target HTML page header.

3.  Include a DIV element in the document to serve as the container that will respond to and be responsible for dispatching mouse events to the event handler of the instance of the RubberRectangle class.  This container element should contain an input of type image to serve as the backdrop and an additional DIV that will serve as the visual representation of the envelope.

4.  The additional DIV should have the visibility style preset to hidden at design time.  It should also contain another invisible DIV element of type with no children and visibility of hidden as well.  These settings are all necessary for creating a DIV that can range from 1 X 1 pixels to any size area.  Without these settings the DIV rectangle will never allow a box smaller than the height of a para element.

5.  Create an instance of the class and initialize it with the event object and the DIV element for drawing the bounding box.  This should typically be done in the mousedown event of the top most container DIV element.

6.  Forward the event object to the processEvent method of the class on mousemove and mouseup events of the topmost container DIV.  This methodology relies on the persistience of the rubber bander beyond mouse events.  Thus, the instance of RubberRectangle should be scoped at the document or page level.

Example - The following HTML meets all requirements and may be inserted into any container such as another DIV or a table cell
------------------------------------------------------------------------------------------------------------------------------
<div id='map" name="map' onmousedown='document.rubberbander = new RubberRectangle(event, box, "red"); document.rubberbander.processEvent(event);' onmousemove='if (document.rubberbander){document.rubberbander.processEvent(event);}' onmouseup='if (document.rubberbander){document.rubberbander.processEvent(event);}">
   <input type="image' src='' height='100%' width='100%">
   <div id='box" name="box' style='visibility:hidden">
      <div style='visibility:hidden"></div>
   </div>
</div>

*/
function RubberRectangle(box, borderColor, borderStyle, borderWidth)
{
   //if box is undefined then the constructor was called only for creating
   //the class prototype object to assign instance functions
   if (box)
   {
      //the visual component for the class is an absolutely positioned div
      //the use of the conditional operand is for allowing default style parameters
      this.box = box;

      //initialize the styles for the rubberbanding box
      this.box.style.borderColor = borderColor ? borderColor : "black";
      this.box.style.borderStyle = borderStyle ? borderStyle : "solid";
      this.box.style.borderWidth = borderWidth ? borderWidth : "1px";
      this.box.style.position = "absolute";

      //preset the rubberbanding flag
      this.rubberbanding = false;
   }
}

//main event handler function, this function handles all drawing based on events
function RubberRectangle_processEvent(e)
{
   switch (e.type)
   {
      case "mousedown":

	 //only respond to left mouse clicks
	 if (!this.rubberbanding && e.button == 1)
	 {
            //envelope coordinates in pixels
            //Absolute for dynamically locating the div in the browser
            //Relative for converting to map coordinates on the server
            this.absOrigX = e.clientX;
            this.absOrigY = e.clientY;
            this.absDestX = e.clientX;
            this.absDestY = e.clientY;
            this.relOrigX = e.offsetX;
            this.relOrigY = e.offsetY;
            this.relDestX = e.offsetX;
            this.relDestY = e.offsetY;

            //switch the rubberbanding flag so it will be rendered dynamically
            this.rubberbanding = true;

            //locate the div and initialize its dimensions
            this.box.style.left = this.absOrigX;
            this.box.style.top = this.absOrigY;
            this.box.style.height = "0";
            this.box.style.width = "0";
            this.box.style.visibility = "visible";
	 }

         break;

      case "mousemove":

         if (this.rubberbanding && e.button == 1)
         {
            //store the current cursor coordinates
            this.absDestX = e.clientX;
            this.absDestY = e.clientY;

            //height and width will always be the absolute value of the difference in client coordinates
	    var height = Math.abs(this.absOrigY - this.absDestY);
	    var width = Math.abs(this.absOrigX - this.absDestX);
            this.box.style.height = height;
            this.box.style.width  = width;

            //branch on the cartesian coordinate system quadrants relative to origin
            if (this.absDestX > this.absOrigX && this.absDestY < this.absOrigY) // I
            {
               this.box.style.left = this.absOrigX;
               this.box.style.top  = this.absDestY;

	       this.relDestX = this.relOrigX + width;
	       this.relDestY = this.relOrigY - height;
            }
            else if (this.absDestX < this.absOrigX && this.absDestY < this.absOrigY) // II
            {
               this.box.style.left = this.absDestX;
               this.box.style.top  = this.absDestY;

	       this.relDestX = this.relOrigX - width;
	       this.relDestY = this.relOrigY - height;
            }
            else if (this.absDestX < this.absOrigX && this.absDestY > this.absOrigY) // III
            {
               this.box.style.left = this.absDestX;
               this.box.style.top  = this.absOrigY;

	       this.relDestX = this.relOrigX - width;
	       this.relDestY = this.relOrigY + height;
            }
            else if (this.absDestX > this.absOrigX && this.absDestY > this.absOrigY) // IV
            {
               this.box.style.left = this.absOrigX;
               this.box.style.top  = this.absOrigY;

	       this.relDestX = this.relOrigX + width;
	       this.relDestY = this.relOrigY + height;
            }
            else if (this.absDestX > this.absOrigX && this.absDestY == this.absOrigY) // 0 degrees
            {
               this.box.style.left = this.absOrigX;
               this.box.style.top  = this.absOrigY;

	       this.relDestX = this.relOrigX + width;
	       this.relDestY = this.relOrigY;
            }
            else if (this.absDestX == this.absOrigX && this.absDestY < this.absOrigY) // 90 degrees
            {
               this.box.style.left = this.absOrigX;
               this.box.style.top  = this.absDestY;

	       this.relDestX = this.relOrigX;
	       this.relDestY = this.relOrigY - height;
            }
            else if (this.absDestX < this.absOrigX && this.absDestY == this.absOrigY) // 180 degrees
            {
               this.box.style.left = this.absDestX;
               this.box.style.top  = this.absOrigY;

	       this.relDestX = this.relOrigX - width;
	       this.relDestY = this.relOrigY;
            }
            else if (this.absDestX == this.absOrigX && this.absDestY > this.absOrigY) // 270 degrees
            {
               this.box.style.left = this.absOrigX;
               this.box.style.top  = this.absOrigY;

	       this.relDestX = this.relOrigX;
	       this.relDestY = this.relOrigY + height;
            }
         }

         break;

      case "mouseup":

	 if (this.rubberbanding && e.button == 1)
	 {
            this.rubberbanding = false;
            this.box.style.visibility = "hidden";
	 }

         break;
   }
}

//force the creation of a prototype object for assigning instance methods
new RubberRectangle();
RubberRectangle.prototype.processEvent = RubberRectangle_processEvent;
