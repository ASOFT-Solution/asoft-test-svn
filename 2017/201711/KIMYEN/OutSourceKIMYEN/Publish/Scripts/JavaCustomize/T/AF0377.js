var currentChoose = "";
var SelectionType = "";
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

    $('#TableOO1').append(kendo.format(DivTag, "FromToAnaID"));
    $('#FromToAnaID').append(kendo.format(DivTagblock, "left"));
    $('#FromToAnaID .block-left .asf-filter-label').append($(".FromAna01ID_AF0377").children()[0]);
    $('#FromToAnaID .block-left .asf-filter-input').append($($(".FromAna01ID_AF0377").children()[0]).children());

    $('#FromToAnaID').append(kendo.format(DivTagblock, "right"));
    $('#FromToAnaID .block-right .asf-filter-label').append($(".ToAna01ID_AF0377").children()[0]);
    $('#FromToAnaID .block-right .asf-filter-input').append($($(".ToAna01ID_AF0377").children()[0]).children());

    $('#FromToAnaID .block-left').css('position', 'relative');
    $('#FromToAnaID .block-right').css('position', 'relative');

    $($(".ToInventoryID_AF0378").parent().parent().parent()).css('display', 'none');

    $('#TableOO1').append(kendo.format(DivTag, "FromToDepartmentID"));
    $('#FromToDepartmentID').append(kendo.format(DivTagblock, "left"));
    $('#FromToDepartmentID .block-left .asf-filter-label').append($(".FromDepartmentID_AF0377").children()[0]);
    $('#FromToDepartmentID .block-left .asf-filter-input').append($($(".FromDepartmentID_AF0377").children()[0]).children());

    $('#FromToDepartmentID').append(kendo.format(DivTagblock, "right"));
    $('#FromToDepartmentID .block-right .asf-filter-label').append($(".ToDepartmentID_AF0377").children()[0]);
    $('#FromToDepartmentID .block-right .asf-filter-input').append($($(".ToDepartmentID_AF0377").children()[0]).children());

    $('#FromToDepartmentID .block-left').css('position', 'relative');
    $('#FromToDepartmentID .block-right').css('position', 'relative');

    $($(".FromDepartmentID_AF0377").parent().parent().parent()).css('display', 'none');

    // bind event click
    $("#btnFromDepartmentID_AF0377").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFromDepartmentID_AF0377").bind('click', btnDelete_Click);

    $("#btnToDepartmentID_AF0377").bind('click', btnChooseFilter_Click);
    $("#btnDeleteToDepartmentID_AF0377").bind('click', btnDelete_Click);

    $("#btnToAna01ID_AF0377").bind('click', btnChooseFilter_Click);
    $("#btnDeleteToAna01ID_AF0377").bind('click', btnDelete_Click);

    $("#btnFromAna01ID_AF0377").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFromAna01ID_AF0377").bind('click', btnDelete_Click);
});

var ListChoose = {
    "btnFromAna01ID_AF0377": function (result) {
        $("#FromAna01ID_AF0377").val(result.SelectionName);
        $("#FromAna01ID").val(result.SelectionID);
    },
    "btnToAna01ID_AF0377": function (result) {
        $("#ToAna01ID").val(result.SelectionID);
        $("#ToAna01ID_AF0377").val(result.SelectionName);
    },
    "btnFromDepartmentID_AF0377": function (result) {
        $("#FromDepartmentID").val(result.SelectionID);
        $("#FromDepartmentID_AF0377").val(result.SelectionName);
    },
    "btnToDepartmentID_AF0377": function (result) {
        $("#ToDepartmentID").val(result.SelectionID);
        $("#ToDepartmentID_AF0377").val(result.SelectionName);
    }
};

var ListDelte = {
    "btnDeleteFromAna01ID_AF0377": function () {
        $("#FromAna01ID_AF0377").val('');
        $("#FromAna01ID").val('');
    },
    "btnDeleteToAna01ID_AF0377": function () {
        $("#ToAna01ID_AF0377").val('');
        $("#ToAna01ID").val('');
    },
    "btnDeleteFromDepartmentID_AF0377": function () {
        $("#FromDepartmentID_AF0377").val('');
        $("#FromDepartmentID").val('');
    },
    "btnDeleteToDepartmentID_AF0377": function () {
        $("#ToDepartmentID_AF0377").val('');
        $("#ToDepartmentID").val('');
    }
};

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

function btnChooseFilter_Click(e) {
    currentChoose = $(this).context.id;
    getSelectionType(currentChoose);
    var urlChoose = "/PopupSelectData/Index/T/AF1000?SelectionType=" + SelectionType;
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
};

function getSelectionType(id) {
    switch (id) {
        case "btnFromAna01ID_AF0377":
        case "btnToAna01ID_AF0377":
            SelectionType = 'A01';
            break;
        case "btnFromDepartmentID_AF0377":
        case "btnToDepartmentID_AF0377":
            SelectionType = 'A02';
            break;
    }
};

function btnDelete_Click(e) {
    this[ListDelte[$(this).context.id]()];
}