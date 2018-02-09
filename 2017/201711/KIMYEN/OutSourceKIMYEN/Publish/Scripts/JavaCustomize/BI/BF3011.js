$(document).ready(function () {
    BF3011.LayoutControl();
})

BF3011 = new function () {

    this.OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    this.tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    this.filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";

    /**  
    * Layout control
    *
    * [Kim Vu] Create new [25/12/2017]
    **/
    this.LayoutControl = function () {
        $("#FormReportFilter").prepend(this.filter);
        $("#FormReportFilter").prepend(this.OrtherInfo);
        $("#OOR").prepend($(".ReportID").parent().parent());
        $("#OORfilter").prepend(this.tableOO1);
        $("#ReportTitle").val($("#ReportName").val().toUpperCase());        

        $("#TableOO1").append($(".TranYear"));
        $("#TableOO1").append($(".CurrencyID"));
        $("#TableOO1").append($(".FromObjectName"));        
        $(".FromObjectID").css('display', 'none');
        $(".FromObjectName .asf-td-field").css('position', 'relative');
        $("#btnFromObjectName").bind("click", BF3011.btnFromObjectName_Click);
        $("#btnDeleteFromObjectName").bind("click", BF3011.btnDeleteFromObjectName_Click);
    }

    /**  
    * FromObjectName click
    *
    * [Kim Vu] Create new [25/12/2017]
    **/
    this.btnFromObjectName_Click = function (e) {
        currentChoose = "btnFromObjectIDName";
        var url = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + $("#EnvironmentDivisionID").val();
        ASOFT.asoftPopup.showIframe(url, {});
    };

    /**  
    * delete FromObjectName click
    *
    * [Kim Vu] Create new [25/12/2017]
    **/
    this.btnDeleteFromObjectName_Click = function () {
        $("#FromObjectID").val('');
        $("#FromObjectName").val('');
    };

};

/**  
* ReceiveResult from pop child
*
* [Kim Vu] Create new [25/12/2017]
**/
function receiveResult(result) {
    $("#FromObjectID").val(result.ObjectID);
    $("#FromObjectName").val(result.ObjectName);
};
