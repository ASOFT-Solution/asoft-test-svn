$(document).ready(function () {
    $("#BtnInherit").bind('click', LMF1020.LMF1023_Load);
})

var LMF1020 = new function () {

    /**  
    * form load
    *
    * [Kim Vu] Create New [07/12/2017]
    **/
    this.LMF1023_Load = function (e) {

        // url Action
        var url = "/PopupSelectData/Index/LM/LMF1023?type=1";
        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(url, {});
    }
}