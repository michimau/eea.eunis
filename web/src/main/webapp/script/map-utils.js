/**
 * Utilities for maps
 */

var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;

function isDOMAttrModifiedSupported() {
    var p = document.createElement('p');
    var flag = false;

    if (p.addEventListener) p.addEventListener('DOMAttrModified', function() {
        flag = true
    }, false);
    else if (p.attachEvent) p.attachEvent('onDOMAttrModified', function() {
        flag = true
    });
    else return false;

    p.setAttribute('id', 'target');

    return flag;
}

$.fn.attrchange = function(callback) {
    if (MutationObserver) {
        var options = {
            subtree: false,
            attributes: true
        };

        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(e) {
                callback.call(e.target, e.attributeName);
            });
        });

        return this.each(function() {
            observer.observe(this, options);
        });

    } else if (isDOMAttrModifiedSupported()) {
        return this.on('DOMAttrModified', function(e) {
            callback.call(this, e.attrName);
        });
    } else if ('onpropertychange' in document.body) {
        return this.on('propertychange', function(e) {
            callback.call(this, window.event.propertyName);
        });
    }
}



/**
 * Workaround for showing maps in accordion; Firefox does not load the DOM for hidden iframes, so the iframe needs to be reloaded
 * when the accordion section is displayed.
 * The link is set before displaying the iframe for Chrome and IE9+
 * The link is not set until display on IE8, as it displays error popups otherwise
 * @param paneId Accordion pane ID
 * @param mapId Map iframe ID
 * @param link Link to the map
 * @param optionalInitFunction If needed, this function can be triggered instead of the map change.
 */
function addReloadOnDisplay(paneId, mapId, link, optionalInitFunction) {
    var speciesStatusPane = document.getElementById (paneId);
    var loadHandler;

    loadHandler = function loadSpeciesMapWorkaround(event) {
        if (event == "style") {   // Modern browsers
            if (document.getElementById(paneId).style.display == "block" && !document.getElementById(paneId).loaded) {
                document.getElementById(paneId).loaded = true;  // only loaded once
                if (undefined === optionalInitFunction) {
                    document.getElementById(mapId).src = link;
                } else {
                    optionalInitFunction();
                }
            }
        }
        else if (event && event.propertyName == "style.display") {  // IE8
            if (document.getElementById(paneId).style.display == "block") {
                document.getElementById(paneId).loaded = true;  // only loaded once
                if (undefined === optionalInitFunction) {
                    document.getElementById(mapId).src = link;
                } else {
                    optionalInitFunction();
                }
            }
        }
    }

    loadHandler.mapId = mapId;
    loadHandler.paneId = paneId;
    loadHandler.link = link;
    loadHandler.optionalInitFunction = optionalInitFunction;

    if (speciesStatusPane.addEventListener) { // all browsers
        $("#"+paneId).attrchange(loadHandler);
    } else if (speciesStatusPane.attachEvent) {  // IE8
        speciesStatusPane.attachEvent ('onpropertychange', loadHandler);
    }
}