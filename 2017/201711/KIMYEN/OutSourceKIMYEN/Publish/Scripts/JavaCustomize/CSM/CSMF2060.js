$(document).ready(function () {
    CSMF2060.CustomEvent();
});

/**  
* Object CSMF2060
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2060 = new function () {

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.CustomEvent = function () {
        $("#btnImport").unbind('click');
        $("#btnImport").bind('click', CSMF2060.btnImport_Click);
    }

    /**  
    *  Import Click
    *
    * [Kim Vu] Create New [05/02/2018]
    **/
    this.btnImport_Click = function (e) {
        var url = "/Import?type=ConfirmClaimFileID";
        ASOFT.asoftPopup.showIframe(url);
    }
}