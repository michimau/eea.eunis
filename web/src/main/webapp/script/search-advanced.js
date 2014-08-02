
function selectDefaultOnFocus(input) {
    input.each(function (index, elem) {
        var jelem = $(elem);
        var ignoreNextMouseUp = false;

        jelem.mousedown(function () {
            if (document.activeElement !== elem) {
                ignoreNextMouseUp = true;
            }
        });
        jelem.mouseup(function (ev) {
            if (ignoreNextMouseUp) {
                ev.preventDefault();
                ignoreNextMouseUp = false;
            }
        });
        jelem.focus(function () {
            if(jelem.val().toUpperCase() === "enter value here...".toUpperCase()) {
                jelem.select();
            }
        });
    });
}