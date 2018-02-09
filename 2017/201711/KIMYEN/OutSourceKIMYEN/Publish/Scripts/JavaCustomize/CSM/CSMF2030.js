$(document).ready(function () {
    CSMF2030.AddEvent();
});

var CSMF2030 = new function () {

    /**  
    * Add Event control
    *
    * [Kim Vu] Create New [25/01/2018]
    **/ 
    this.AddEvent = function () {
        $("#BtnConfirmAll").unbind('click');
        $("#BtnConfirmAll").bind('click', ShowEditorFrame);
    }

}
