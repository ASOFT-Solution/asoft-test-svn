var value = 1;
var currentChoose = "";
var SelectionType = "";
$(document).ready(function () {
    // Report
    $('#ReportCode001 .block-left .asf-filter-label').append($(".ReportCode").children()[0]);
    $('#ReportCode001 .block-left .asf-filter-input').append($(".ReportCode").children()[0]);
    $('#ReportCode001 .block-right .asf-filter-input').append($(".ReportName").children()[1]);
    $('#ReportCode001 .block-right .asf-filter-input td').css('width', '46%');
    $(".ReportName").css('display', 'none');

    // visiable control
    $(".ReportID").css('display', 'none');
    $(".Filter1IDFrom").css('display', 'none');
    $(".Filter1IDTo").css('display', 'none');
    $(".Filter2IDFrom").css('display', 'none');
    $(".Filter2IDTo").css('display', 'none');
    $(".Filter3IDFrom").css('display', 'none');
    $(".Filter3IDTo").css('display', 'none');
    $(".ReportDate").css('display', 'none');
    $(".IsBefore").css('display', 'none');
    $(".IsType").css('display', 'none');
    $(".FromObjectID").css('display', 'none');
    $(".ToObjectID").css('display', 'none');

    // CurencyID
    $('#CurrencyID001 .block-left .asf-filter-label').append($(".CurrencyID").children()[0]);
    $('#CurrencyID001 .block-left .asf-filter-input').append($(".CurrencyID").children()[0]);

    // AccountID
    $('#FromToAccountID001 .block-left .asf-filter-label').append($(".FromAccountID").children()[0]);
    $('#FromToAccountID001 .block-left .asf-filter-input').append($(".FromAccountID").children()[0]);
    $('#FromToAccountID001 .block-right .asf-filter-label').append($(".ToAccountID").children()[0]);
    $('#FromToAccountID001 .block-right .asf-filter-input').append($(".ToAccountID").children()[0]);

    // ObjectID
    $('#FromToObjectID001 .block-left .asf-filter-label').append($(".FromObjectIDName").children()[0]);
    $('#FromToObjectID001 .block-left .asf-filter-input').append($(".FromObjectIDName").children()[0]);
    $('#FromToObjectID001 .block-right .asf-filter-label').append($(".ToObjectName").children()[0]);
    $('#FromToObjectID001 .block-right .asf-filter-input').append($(".ToObjectName").children()[0]);
    $('#FromToObjectID001 .block-right .asf-filter-input td').css('width', '84%');
    $('#FromToObjectID001 .block-left .asf-filter-input td').css('width', '84%');
    $('#FromToObjectID001 .block-left .asf-filter-input td').css('position', 'relative');
    $('#FromToObjectID001 .block-right .asf-filter-input td').css('position', 'relative');

    // Filter01
    $('#FromToFilter01 .block-left .asf-filter-label').append($(".Filter1IDFromName").children()[0]);
    $('#FromToFilter01 .block-left .asf-filter-input').append($(".Filter1IDFromName").children()[0]);
    $('#FromToFilter01 .block-right .asf-filter-label').append($(".Filter1IDToName").children()[0]);
    $('#FromToFilter01 .block-right .asf-filter-input').append($(".Filter1IDToName").children()[0]);
    $('#FromToFilter01 .block-right .asf-filter-input td').css('width', '84%');
    $('#FromToFilter01 .block-left .asf-filter-input td').css('width', '84%');
    $('#FromToFilter01 .block-left .asf-filter-input td').css('position', 'relative');
    $('#FromToFilter01 .block-right .asf-filter-input td').css('position', 'relative');

    // Filer02
    $('#FromToFilter02 .block-left .asf-filter-label').append($(".Filter2IDFromName").children()[0]);
    $('#FromToFilter02 .block-left .asf-filter-input').append($(".Filter2IDFromName").children()[0]);
    $('#FromToFilter02 .block-right .asf-filter-label').append($(".Filter2IDToName").children()[0]);
    $('#FromToFilter02 .block-right .asf-filter-input').append($(".Filter2IDToName").children()[0]);
    $('#FromToFilter02 .block-right .asf-filter-input td').css('width', '84%');
    $('#FromToFilter02 .block-left .asf-filter-input td').css('width', '84%');
    $('#FromToFilter02 .block-left .asf-filter-input td').css('position', 'relative');
    $('#FromToFilter02 .block-right .asf-filter-input td').css('position', 'relative');

    // Filter03
    $('#FromToFilter03 .block-left .asf-filter-label').append($(".Filter3IDFromName").children()[0]);
    $('#FromToFilter03 .block-left .asf-filter-input').append($(".Filter3IDFromName").children()[0]);
    $('#FromToFilter03 .block-right .asf-filter-label').append($(".Filter3IDToName").children()[0]);
    $('#FromToFilter03 .block-right .asf-filter-input').append($(".Filter3IDToName").children()[0]);
    $('#FromToFilter03 .block-right .asf-filter-input td').css('width', '84%');
    $('#FromToFilter03 .block-left .asf-filter-input td').css('width', '84%');
    $('#FromToFilter03 .block-left .asf-filter-input td').css('position', 'relative');
    $('#FromToFilter03 .block-right .asf-filter-input td').css('position', 'relative');

    var cboReportCode = $("#ReportCode").data("kendoComboBox");
    if (cboReportCode) {
        cboReportCode.select(0);
        var data = cboReportCode.dataItem();
        if (data) {
            $("#ReportName").val(data.ReportName1);
            $("#ReportID").val(data.ReportID);
        }
        cboReportCode.bind('change', function () {
            var data = cboReportCode.dataItem();
            $("#ReportName").val(data.ReportName1);
            $("#ReportID").val(data.ReportID);
        });
    }

    $("input[type='radio']").click(function (e) {
        if ($(this).prop('name') == 'rdoTimeFilter') {
            value = $(this).val();
            $("#ReportDate1").data("kendoDatePicker").enable(value == 1);
            $("#ReportDate2").data("kendoDatePicker").enable(value == 2);
            $("#ReportDate3").data("kendoDatePicker").enable(value == 3);
            date_change(null);
        }
    });

    $("#ReportDate1").data("kendoDatePicker").bind('change', date_change);
    $("#ReportDate2").data("kendoDatePicker").bind('change', date_change);
    $("#ReportDate3").data("kendoDatePicker").bind('change', date_change);
    date_change(null);

    $("#btnFromObjectIDName").bind('click', btnChooseObject_Click);
    $("#btnDeleteFromObjectIDName").bind('click', btnDelete_Click);

    $("#btnToObjectName").bind('click', btnChooseObject_Click);
    $("#btnDeleteToObjectName").bind('click', btnDelete_Click);

    $("#btnFilter1IDFromName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter1IDFromName").bind('click', btnDelete_Click);

    $("#btnFilter1IDToName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter1IDToName").bind('click', btnDelete_Click);

    $("#btnFilter2IDFromName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter2IDFromName").bind('click', btnDelete_Click);

    $("#btnFilter2IDToName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter2IDToName").bind('click', btnDelete_Click);

    $("#btnFilter3IDFromName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter3IDFromName").bind('click', btnDelete_Click);

    $("#btnFilter3IDToName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFilter3IDToName").bind('click', btnDelete_Click);
});


function date_change(e) {
    if (value == 1) {
        $("#ReportDate").val(kendo.toString($("#ReportDate1").data("kendoDatePicker").value(), 'yyyy-MM-dd'));
        $("#IsBefore").val('1');
        $("#IsType").val('1');
    } else if (value == 2) {
        $("#ReportDate").val(kendo.toString($("#ReportDate2").data("kendoDatePicker").value(), 'yyyy-MM-dd'));
        $("#IsBefore").val('0');
        $("#IsType").val('1');
    } else {
        $("#ReportDate").val(kendo.toString($("#ReportDate3").data("kendoDatePicker").value(), 'yyyy-MM-dd'));
        $("#IsBefore").val('2');
        $("#IsType").val('2');
    }
}

var ListChoose = {
    "btnFromObjectIDName": function (result) {
        $("#FromObjectID").val(result.ObjectID);
        $("#FromObjectIDName").val(result.ObjectName);
    },
    "btnToObjectName": function (result) {
        $("#ToObjectID").val(result.ObjectID);
        $("#ToObjectName").val(result.ObjectName);
    },
    "btnFilter1IDFromName": function (result) {
        $("#Filter1IDFrom").val(result.SelectionID);
        $("#Filter1IDFromName").val(result.SelectionName);
    },
    "btnFilter1IDToName": function (result) {
        $("#Filter1IDTo").val(result.SelectionID);
        $("#Filter1IDToName").val(result.SelectionName);
    },
    "btnFilter2IDFromName": function (result) {
        $("#Filter2IDFrom").val(result.SelectionID);
        $("#Filter2IDFromName").val(result.SelectionName);
    },
    "btnFilter2IDToName": function (result) {
        $("#Filter2IDTo").val(result.SelectionID);
        $("#Filter2IDToName").val(result.SelectionName);
    },
    "btnFilter3IDFromName": function (result) {
        $("#Filter3IDFrom").val(result.SelectionID);
        $("#Filter3IDFromName").val(result.SelectionName);
    },
    "btnFilter3IDToName": function (result) {
        $("#Filter3IDTo").val(result.SelectionID);
        $("#Filter3IDToName").val(result.SelectionName);
    }
};

var ListDelte = {
    "btnDeleteFromObjectIDName": function () {
        $("#FromObjectID").val('');
        $("#FromObjectIDName").val('');
    },
    "btnDeleteToObjectName": function () {
        $("#ToObjectID").val('');
        $("#ToObjectName").val('');
    },
    "btnDeleteFilter1IDFromName": function () {
        $("#Filter1IDFrom").val('');
        $("#Filter1IDFromName").val('');
    },
    "btnDeleteFilter1IDToName": function () {
        $("#Filter1IDTo").val('');
        $("#Filter1IDToName").val('');
    },
    "btnDeleteFilter2IDFromName": function () {
        $("#Filter2IDFrom").val('');
        $("#Filter2IDFromName").val('');
    },
    "btnDeleteFilter2IDToName": function () {
        $("#Filter2IDTo").val('');
        $("#Filter2IDToName").val('');
    },
    "btnDeleteFilter3IDFromName": function () {
        $("#Filter3IDFrom").val('');
        $("#Filter3IDFromName").val('');
    },
    "btnDeleteFilter3IDToName": function () {
        $("#Filter3IDTo").val('');
        $("#Filter3IDToName").val('');
    }
};

function btnChooseObject_Click(e) {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + $("#EnvironmentDivisionID").val();
    currentChoose = $(this).context.id;
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
    currentChoose = $(this).context.id;
}

function getSelectionType(id)
{
    var data = $("#ReportCode").data("kendoComboBox").dataItem();
    switch (id) {
        case "btnFilter1IDFromName":
        case "btnFilter1IDToName":
            SelectionType = data.Selection01ID;
            break;
        case "btnFilter2IDFromName":
        case "btnFilter2IDToName":
            SelectionType = data.Selection02ID;
            break;
        case "btnFilter3IDFromName":
        case "btnFilter3IDToName":
            SelectionType = data.Selection03ID;
            break;
    }
}

function btnChooseFilter_Click(e) {
    currentChoose = $(this).context.id;
    getSelectionType(currentChoose);
    var urlChoose = "/PopupSelectData/Index/T/AF1000?SelectionType=" + SelectionType;    
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});    
}

function btnDelete_Click(e) {
    this[ListDelte[$(this).context.id]()];
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};