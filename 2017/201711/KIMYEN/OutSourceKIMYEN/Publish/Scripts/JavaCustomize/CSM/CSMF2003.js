
$(document).ready(function () {
    CSMF2003.setAPK;
});

var CSMF2003 = new function () {
    this.setAPK = new function () {
        $("#APKMaster").val(window.parent.getAPK);
    }
}

