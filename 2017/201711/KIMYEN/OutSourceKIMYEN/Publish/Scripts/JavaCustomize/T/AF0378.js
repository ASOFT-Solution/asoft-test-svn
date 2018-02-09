$(document).ready(function () {
    var DivTag = "<div class='asf-filter-main' id='{0}'></div>";
    var DivTagblock = "<div class='block-{0}'> <div class='asf-filter-label'></div><div class='asf-filter-input'></div></div>";

    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").prepend(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#TableOO1").append($("#PeriodFilter1"));
    $("#TableOO1").append($("#PeriodFilter2"));

    $('#TableOO1').append(kendo.format(DivTag, "FromToInventoryID"));
    $('#FromToInventoryID').append(kendo.format(DivTagblock, "left"));
    $('#FromToInventoryID .block-left .asf-filter-label').append($(".FromInventoryID_AF0378").children()[0]);
    $('#FromToInventoryID .block-left .asf-filter-input').append($($(".FromInventoryID_AF0378").children()[0]).children());

    $('#FromToInventoryID').append(kendo.format(DivTagblock, "right"));
    $('#FromToInventoryID .block-right .asf-filter-label').append($(".ToInventoryID_AF0378").children()[0]);
    $('#FromToInventoryID .block-right .asf-filter-input').append($($(".ToInventoryID_AF0378").children()[0]).children());

    $('#FromToInventoryID .block-left').css('position', 'relative');
    $('#FromToInventoryID .block-right').css('position', 'relative');

    $($(".ToInventoryID_AF0378").parent().parent().parent()).css('display', 'none');

    // bind event click
    $("#btnFromInventoryID_AF0378").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFromInventoryID_AF0378").bind('click', btnDelete_Click);

    $("#btnToInventoryID_AF0378").bind('click', btnChooseFilter_Click);
    $("#btnDeleteToInventoryID_AF0378").bind('click', btnDelete_Click);
});

var ListChoose = {
    "btnFromInventoryID_AF0378": function (result) {
        $("#FromInventoryID_AF0378").val(result.SelectionName);
        $("#FromInventoryID").val(result.SelectionID);
    },
    "btnToInventoryID_AF0378": function (result) {
        $("#ToInventoryID_AF0378").val(result.SelectionName);
        $("#ToInventoryID").val(result.SelectionID);
    }
};

var ListDelte = {
    "btnDeleteFromInventoryID_AF0378": function () {
        $("#FromInventoryID_AF0378").val('');
        $("#FromInventoryID").val('');
    },
    "btnDeleteToInventoryID_AF0378": function () {
        $("#ToInventoryID_AF0378").val('');
        $("#ToInventoryID").val('');
    }
};
var currentChoose = "";

function btnChooseFilter_Click(e) {
    currentChoose = $(this).context.id;    
    var urlChoose = "/PopupSelectData/Index/T/AF1000?SelectionType=IN";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
};

function btnDelete_Click(e) {
    this[ListDelte[$(this).context.id]()];
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};
