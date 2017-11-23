var GridCIF1310 = null;
var urldeleteCIF1310 = null;

var isGroupID = null;
$(document).ready(function () {
    isGroupID = 4;
    urldeleteCIF1310 = $('#DeleteCIF1310').val();
    GridCIF1310 = $("#GridAT1011").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
    $("#BtnShow").unbind();
    $("#BtnShow").kendoButton({
        "click": CustomShow_Click
    });
    $("#BtnHide").unbind();
    $("#BtnHide").kendoButton({
        "click": CustomHide_Click
    });
    $("#BtnFilter").bind("click", function () {
        if ($("#GroupID_CIF1310").val() == "")
            isGroupID = 4;
        else
            isGroupID = $("#GroupID_CIF1310").val();
    });
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCIF1310);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["AnaTypeID"] + ",";
        valuepk = valuepk + records[i]["AnaID"] + ",";
        valuepk = valuepk + isGroupID;
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCIF1310, key, args, deleteSuccess);
    });
}

function CustomShow_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCIF1310);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i]["AnaTypeID"] + "," + records[i]["AnaID"] + "," + isGroupID);
    }
    key.push(tablecontent, pk);
    ASOFT.helper.postTypeJson1("/GridCommon/Enable/CI/CIF1310", key, args, function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, "FormFilter", function () {
            var urlcontent = $('ContentCIF1310').val();
            //Chuyển hướng hoặc refresh data
            if (urlcontent) {
                window.location.href = urlcontent; // redirect index
            }
        }, null, null, true, false, "FormFilter");
        if (GridCIF1310) {
            GridCIF1310.dataSource.page(1); // Refresh grid 
        }
    });
}

function CustomHide_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCIF1310);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i]["AnaTypeID"] + "," + records[i]["AnaID"] + "," + isGroupID);
    }
    key.push(tablecontent, pk);
    ASOFT.helper.postTypeJson1("/GridCommon/Disable/CI/CIF1310", key, args, function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, "FormFilter", function () {
            var urlcontent = $('ContentCIF1310').val();
            //Chuyển hướng hoặc refresh data
            if (urlcontent) {
                window.location.href = urlcontent; // redirect index
            }
        }, null, null, true, false, "FormFilter");
        if (GridCIF1310) {
            GridCIF1310.dataSource.page(1); // Refresh grid 
        }
    });
}


function PrintClick() {
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
    ASOFT.helper.postTypeJson1("/CI/CIF1310/DoPrintOrExport", key1, value1, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CI/CIF1310/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}
