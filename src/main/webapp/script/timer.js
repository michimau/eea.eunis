// please keep these lines on when you copy the source
// made by: Nicolas - http://www.javascript-page.com

var timerID = 0;
var tStart  = null;

function UpdateTimer() {
   if(timerID) {
      clearTimeout(timerID);
      clockID  = 0;
   }
   if(!tStart) tStart   = new Date();
   var   tDate = new Date();
   var   tDiff = tDate.getTime() - tStart.getTime();
   tDate.setTime(tDiff);
   document.theTimer.theTime.value = "" + tDate.getMinutes() + ":" + tDate.getSeconds();
   timerID = setTimeout("UpdateTimer()", 1000);
}

function Start() {
   tStart   = new Date();
   document.theTimer.theTime.value = "00:00";
   timerID  = setTimeout("UpdateTimer()", 1000);
}

function Stop() {
   if(timerID) {
      clearTimeout(timerID);
      timerID  = 0;
   }
   tStart = null;
}

function Reset() {
   tStart = null;
   document.theTimer.theTime.value = "00:00";
}
