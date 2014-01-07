/**
 * Utilities for maps
 */

/**
 * Workaround for showing maps in accordion; Firefox does not load the DOM for hidden iframes, so the iframe needs to be reloaded
 * when the accordion section is displayed.
 * The link is set before displaying the iframe for Chrome and IE9+
 * The link is not set until display on IE8, as it displays error popups otherwise
 * @param paneId Accordion pane ID
 * @param mapId Map iframe ID
 * @param link Link to the map
 */
function addReloadOnDisplay(paneId, mapId, link) {
    var speciesStatusPane = document.getElementById (paneId);
    var loadHandler = function loadSpeciesMapWorkaround(event) {
        if(('attrChange' in event && event.attrName=="style")){
//          alert("DOMAttrModified event! " + event.attrName + " attribute has been changed from " + event.prevValue + " to " + event.newValue);
            if(event.newValue=="display: block;" && !document.getElementById(mapId).loaded)
            {
                document.getElementById(mapId).src=link;
                document.getElementById(mapId).loaded=true;  // only loaded once
            }
        }
        else if ('propertyName' in event && event.propertyName=="style.display"){  // IE8
            if(document.getElementById(paneId).style.display == "block") {
                document.getElementById(mapId).src=link;
                document.getElementById(mapId).loaded=true;  // only loaded once
            }
        }
    }
    loadHandler.mapId = mapId;
    loadHandler.paneId = paneId;
    loadHandler.link = link;

    if (speciesStatusPane.addEventListener) { // all browsers
        speciesStatusPane.addEventListener ('DOMAttrModified', loadHandler, false);
        document.getElementById(mapId).src=link;  // set the link even before display
    }
    if (speciesStatusPane.attachEvent) {  // IE8
        speciesStatusPane.attachEvent ('onpropertychange', loadHandler);
    }
}