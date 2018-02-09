var dateFrom;
var dateTo;
var currentChoose = "";
var SelectionType = "";
$(document).ready(function () {

    // Radio button Isdetail    
    $('#IsDetail001 .block-left .asf-filter-input').append($(".RDO_IsDetail")[0]);
    $('#IsDetail001 .block-right .asf-filter-input').append($(".RDO_IsDetail")[1]);
    

    // Report
    $('#ReportCode001 .block-left .asf-filter-label').append($(".ReportCode").children()[0]);
    $('#ReportCode001 .block-left .asf-filter-input').append($(".ReportCode").children()[0]);
    $('#ReportCode001 .block-right .asf-filter-input').append($(".ReportName").children()[1]);
    $('#ReportCode001 .block-right .asf-filter-input td').css('width', '46%');

    $('#ReportTitle001 .block-left .asf-filter-label').append($(".ReportTitle").children()[0]);
    $('#ReportTitle001 .block-left .asf-filter-input').append($(".ReportTitle").children()[0]);
    $('#ReportTitle001 .block-left .asf-filter-input td').css('width', '26.4%');

    $(".ReportName").css('display', 'none');

    // Time
    // Amount Unit
    $('#AmountUnit001 .block-left .asf-filter-label').append($(".AmountUnit").children()[0]);
    $('#AmountUnit001 .block-left .asf-filter-input').append($(".AmountUnit").children()[0]);
    $("#OORTimeFilter").append($("#PeriodFilter1"));
    $("#OORTimeFilter").append($("#PeriodFilter2"));

    // Tab2
    // Group01
    $('#Group001 .block-left .asf-filter-label').append($(".IsGroup1"));    
    $('#Group001 .block-left .asf-filter-input').append($(".Group1").children()[1]);

    // Group02
    $('#Group002 .block-left .asf-filter-label').append($(".IsGroup2"));
    $('#Group002 .block-left .asf-filter-input').append($(".Group2").children()[1]);

    // Group03
    $('#Group003 .block-left .asf-filter-label').append($(".IsGroup3"));
    $('#Group003 .block-left .asf-filter-input').append($(".Group3").children()[1]);
    
    // Debit
    $('#IsDebit001 .block-left .asf-filter-input').append($(".RDOIsDebit")[0]);
    $('#IsDebit001 .block-right .asf-filter-input').append($(".RDOIsDebit")[1]);

    // Inventory
    // InventoryType
    $('#InventoryType001 .block-left .asf-filter-label').append($(".FromInventoryTypeName").children()[0]);
    $('#InventoryType001 .block-left .asf-filter-input').append($(".FromInventoryTypeName").children()[0]);
    $('#InventoryType001 .block-right .asf-filter-label').append($(".ToInventoryTypeName").children()[0]);
    $('#InventoryType001 .block-right .asf-filter-input').append($(".ToInventoryTypeName").children()[0]);
    $('#InventoryType001 .block-right .asf-filter-input td').css('width', '84%');
    $('#InventoryType001 .block-left .asf-filter-input td').css('width', '84%');
    $('#InventoryType001 .block-left .asf-filter-input td').css('position', 'relative');
    $('#InventoryType001 .block-right .asf-filter-input td').css('position', 'relative');

    // Inventory
    $('#Inventory001 .block-left .asf-filter-label').append($(".FromInventoryName").children()[0]);
    $('#Inventory001 .block-left .asf-filter-input').append($(".FromInventoryName").children()[0]);
    $('#Inventory001 .block-right .asf-filter-label').append($(".ToInventoryName").children()[0]);
    $('#Inventory001 .block-right .asf-filter-input').append($(".ToInventoryName").children()[0]);
    $('#Inventory001 .block-right .asf-filter-input td').css('width', '84%');
    $('#Inventory001 .block-left .asf-filter-input td').css('width', '84%');
    $('#Inventory001 .block-left .asf-filter-input td').css('position', 'relative');
    $('#Inventory001 .block-right .asf-filter-input td').css('position', 'relative');

    // Filter
    // Filter01
    $('#Filter001 .block-left1 .asf-filter-label').append($(".IsFilter1"));
    $('#Filter001 .block-left1 .asf-filter-input').append($(".Filter01").children()[1]);

    $('#Filter001 .block-left .asf-filter-label').append($(".Filter1IDFromName").children()[0]);
    $('#Filter001 .block-left .asf-filter-input').append($(".Filter1IDFromName").children()[0]);
    $('#Filter001 .block-right .asf-filter-label').append($(".Filter1IDToName").children()[0]);
    $('#Filter001 .block-right .asf-filter-input').append($(".Filter1IDToName").children()[0]);
    $('#Filter001 .block-right .asf-filter-input td').css('width', '84%');
    $('#Filter001 .block-left .asf-filter-input td').css('width', '84%');
    $('#Filter001 .block-left .asf-filter-input td').css('position', 'relative');
    $('#Filter001 .block-right .asf-filter-input td').css('position', 'relative');

    // Filer02
    $('#Filter002 .block-left1 .asf-filter-label').append($(".IsFilter2"));
    $('#Filter002 .block-left1 .asf-filter-input').append($(".Filter02").children()[1]);
    $('#Filter002 .block-left .asf-filter-label').append($(".Filter2IDFromName").children()[0]);
    $('#Filter002 .block-left .asf-filter-input').append($(".Filter2IDFromName").children()[0]);
    $('#Filter002 .block-right .asf-filter-label').append($(".Filter2IDToName").children()[0]);
    $('#Filter002 .block-right .asf-filter-input').append($(".Filter2IDToName").children()[0]);
    $('#Filter002 .block-right .asf-filter-input td').css('width', '84%');
    $('#Filter002 .block-left .asf-filter-input td').css('width', '84%');
    $('#Filter002 .block-left .asf-filter-input td').css('position', 'relative');
    $('#Filter002 .block-right .asf-filter-input td').css('position', 'relative');

    // Filter03
    $('#Filter003 .block-left1 .asf-filter-label').append($(".IsFilter3"));
    $('#Filter003 .block-left1 .asf-filter-input').append($(".Filter03").children()[1]);
    $('#Filter003 .block-left .asf-filter-label').append($(".Filter3IDFromName").children()[0]);
    $('#Filter003 .block-left .asf-filter-input').append($(".Filter3IDFromName").children()[0]);
    $('#Filter003 .block-right .asf-filter-label').append($(".Filter3IDToName").children()[0]);
    $('#Filter003 .block-right .asf-filter-input').append($(".Filter3IDToName").children()[0]);
    $('#Filter003 .block-right .asf-filter-input td').css('width', '84%');
    $('#Filter003 .block-left .asf-filter-input td').css('width', '84%');
    $('#Filter003 .block-left .asf-filter-input td').css('position', 'relative');
    $('#Filter003 .block-right .asf-filter-input td').css('position', 'relative');

    // Hidden class
    $(".ToInventoryID").css('display', 'none');
    $(".FromInventoryID").css('display', 'none');
    $(".ToInventoryTypeID").css('display', 'none');
    $(".FromInventoryTypeID").css('display', 'none');
    $(".IsDetail").css('display', 'none');
    $(".IsDebit").css('display', 'none');
    $(".Group1").css('display', 'none');
    $(".Group2").css('display', 'none');
    $(".Group3").css('display', 'none');
    $(".Filter01").css('display', 'none');
    $(".Filter02").css('display', 'none');
    $(".Filter03").css('display', 'none');
    $(".Filter1IDFrom").css('display', 'none');
    $(".Filter1IDTo").css('display', 'none');
    $(".Filter2IDFrom").css('display', 'none');
    $(".Filter2IDTo").css('display', 'none');
    $(".Filter3IDFrom").css('display', 'none');
    $(".Filter3IDTo").css('display', 'none');

    var cboReportCode = $("#ReportCode").data("kendoComboBox");
    if (cboReportCode) {
        cboReportCode.select(0);
        var data = cboReportCode.dataItem();
        $("#ReportName").val(data.ReportName1);
        $("#ReportTitle").val(data.ReportTitle);
        cboReportCode.bind('close', function () {
            var data = cboReportCode.dataItem();
            $("#ReportName").val(data.ReportName1);
            $("#ReportTitle").val(data.ReportTitle);
        });
    }

    $("input[type='radio']").click(function (e) {
        var value = $(this).val();
        if ($(this).prop('name') == 'RDO_IsDetail') {
            $("#ReportCode").data("kendoComboBox").value('');
            $("#ReportName").val('');
            $("#ReportTitle").val('');
            $("#IsDetail").val(value);
        } else if ($(this).prop('name') == 'RDOIsDebit') {
            $("#IsDebit").val(value);
        }
    });

    $("#IsDetail").val('1');
    $("#IsDebit").val('1');
    $("#RDOIsDebit[value='1']").prop('checked', true);
    $("#RDO_IsDetail[value='1']").prop('checked', true);
    $("#IsGroup1").prop('checked', true);
    $("#IsGroup2").prop('checked', true);

    // Bind event click control

    $("#btnFromInventoryTypeName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFromInventoryTypeName").bind('click', btnDelete_Click);

    $("#btnToInventoryTypeName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteToInventoryTypeName").bind('click', btnDelete_Click);

    $("#btnFromInventoryName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteFromInventoryName").bind('click', btnDelete_Click);

    $("#btnToInventoryName").bind('click', btnChooseFilter_Click);
    $("#btnDeleteToInventoryName").bind('click', btnDelete_Click);

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
    dateFrom = $("#FromDate").data("kendoDatePicker");
    dateTo = $("#ToDate").data("kendoDatePicker");
    dateFrom.bind('change', date_change);
    dateTo.bind('change', date_change);
    date_change(null);

    $("input[type='checkbox']").click(function (e) {        
        var id = $(this).prop('id');
        var check = $(this).prop('checked');
        switch (id) {
            case "IsGroup1":
            case "IsGroup2":
                $("#IsGroup1").prop('checked', true);
                $("#IsGroup2").prop('checked', true);
                break;
            case "IsFilter1":
                $("#Filter01").data("kendoComboBox").enable(check);
                $("#btnFilter1IDFromName").data("kendoButton").enable(check);
                $("#btnDeleteFilter1IDFromName").data("kendoButton").enable(check);
                $("#btnFilter1IDToName").data("kendoButton").enable(check);
                $("#btnDeleteFilter1IDToName").data("kendoButton").enable(check);
            case "IsFilter2":
                $("#Filter02").data("kendoComboBox").enable(check);
                $("#btnFilter2IDFromName").data("kendoButton").enable(check);
                $("#btnDeleteFilter2IDFromName").data("kendoButton").enable(check);
                $("#btnFilter2IDToName").data("kendoButton").enable(check);
                $("#btnDeleteFilter2IDToName").data("kendoButton").enable(check);
            case "IsFilter3":
                $("#Filter03").data("kendoComboBox").enable(check);
                $("#btnFilter3IDFromName").data("kendoButton").enable(check);
                $("#btnDeleteFilter3IDFromName").data("kendoButton").enable(check);
                $("#btnFilter3IDToName").data("kendoButton").enable(check);
                $("#btnDeleteFilter3IDToName").data("kendoButton").enable(check);
                break;
            default:
                break;
        }
    });

});

function date_change(e) {
    $("#FromDate1").val(kendo.toString(dateFrom.value(), 'yyyy-MM-dd'));
    $("#ToDate1").val(kendo.toString(dateTo.value(), 'yyyy-MM-dd'));
}

function getSelectionType(id) {    
    switch (id) {
        case "btnFilter1IDFromName":
        case "btnFilter1IDToName":
            SelectionType = $("#Filter01").data("kendoComboBox").value();
            break;
        case "btnFilter2IDFromName":
        case "btnFilter2IDToName":
            SelectionType = $("#Filter02").data("kendoComboBox").value();
            break;
        case "btnFilter3IDFromName":
        case "btnFilter3IDToName":
            SelectionType = $("#Filter03").data("kendoComboBox").value();
            break;
        case "btnFromInventoryTypeName":
        case "btnToInventoryTypeName":
            SelectionType = 'INT';
            break;
        case "btnFromInventoryName":
        case "btnToInventoryName":
            SelectionType = 'IN';
            break;

    }
}

function btnChooseFilter_Click(e) {    
    currentChoose = $(this).context.id;
    getSelectionType(currentChoose);
    var urlChoose = "/PopupSelectData/Index/T/AF1000?SelectionType=" + SelectionType + "&Key01ID=" + $("#FromInventoryTypeID").val() + "&Key02ID=" + $("#ToInventoryTypeID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDelete_Click(e) {
    this[ListDelte[$(this).context.id]()];
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

var ListChoose = {
    "btnFromInventoryTypeName": function (result) {
        $("#FromInventoryTypeID").val(result.SelectionID);
        $("#FromInventoryTypeName").val(result.SelectionName);
    },
    "btnToInventoryTypeName": function (result) {
        $("#ToInventoryTypeID").val(result.SelectionID);
        $("#ToInventoryTypeName").val(result.SelectionName);
    },
    "btnFromInventoryName": function (result) {
        $("#FromInventoryID").val(result.SelectionID);
        $("#FromInventoryName").val(result.SelectionName);
    },
    "btnToInventoryName": function (result) {
        $("#ToInventoryID").val(result.SelectionID);
        $("#ToInventoryName").val(result.SelectionName);
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
    },
    "btnDeleteFromInventoryTypeName": function () {
        $("#FromInventoryTypeName").val('');
        $("#FromInventoryTypeID").val('');
    },
    "btnDeleteToInventoryTypeName": function () {
        $("#ToInventoryTypeID").val('');
        $("#ToInventoryTypeName").val('');
    },
    "btnDeleteFromInventoryName": function () {
        $("#FromInventoryName").val('');
        $("#FromInventoryID").val('');
    },
    "btnDeleteToInventoryName": function () {
        $("#ToInventoryName").val('');
        $("#ToInventoryID").val('');
    }
};