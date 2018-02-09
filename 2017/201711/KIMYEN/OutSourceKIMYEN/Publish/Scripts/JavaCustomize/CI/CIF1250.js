var GridCIF1250 = null;
var urldeleteCIF1250 = null;
var action = null;

$(document).ready(function () {
    urldeleteCIF1250 = $('#DeleteCIF1250').val();
    GridCIF1250 = $("#GridOT1301").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });

    var urlPrint = "/CI/CIF1250/";
    ASOFT.partialView.Load(urlPrint, "#contentMaster", 1);

});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCIF1250);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["ID"];
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCIF1250, key, args, deleteSuccess);
    });
}

function PrintClick(e) {
    var dialog = $("#PrintPopup").data("kendoWindow");
    $("#Print").show();
    dialog.wrapper.css({ top: e.sender.wrapper.offset().top + 30, left: e.sender.wrapper.offset().left });

    dialog.open();
}

function print1_Click() {
    action = 1;
    print();
}

function print2_Click() {
    action = 2;
    print();
}

function print3_Click() {
    action = 3;
    PrintClickCIF1250();
}

function PrintClickCIF1250() {
    var key1 = Array();
    var value1 = Array();
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                if (datamaster[key.split('_')[0] + "_Type_Fields"] == 2) {
                    if (value == "Có") {
                        value1.push(1);
                    }
                    else {
                        if (value == "Không") {
                            value1.push(0);
                        }
                        else {
                            if (value == "%") {
                                value1.push("");
                            }
                            else {
                                value1.push(value);
                            }
                        }
                    }
                }
                else {
                    value1.push(value);
                }
                key1.push(key.split('_')[0]);
            }
        }
    })
    ASOFT.helper.postTypeJson1("/CI/CIF1250/DoPrintOrExportCIF1250", key1, value1, ExportSuccess);
}

function print() {
    var records = ASOFT.asoftGrid.selectedRecords(GridCIF1250);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        var data = [];
        data.push(records[i]["ID"]);
        data.push(records[i]["DivisionID"]);
        ASOFT.helper.postTypeJson("/CI/CIF1250/DoPrintOrExport", data, ExportSuccess);
    }
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CI/CIF1250/ReportViewer';
        var urlExcel = '/CI/CIF1250/ExportReport';
        var urlPost = !isMobile ? urlPrint : urlExcel;
        var options = !isMobile ? '&viewer=pdf&actionPrint=' + action : '&actionPrint=' + action;
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (!isMobile)
            window.open(fullPath, "_blank");
        else {
            window.location = fullPath;
        }
    }
}